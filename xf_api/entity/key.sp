#include <xf_api/base/key>

int __xfkey_increment = 0;
ArrayList __XFKeyList;

XFKey XFKey_ById(int id, Handle plugin)
{
    int pos;
    if (!__XFKeyList || (pos = __XFKeyList.FindValue(id)) == -1 || __XFKeyList.Get(pos, 1) != plugin)
    {
        ThrowNativeError(SP_ERROR_INDEX, "Invalid Object(XFKey) (%i)", id);
    }

    return view_as<XFKey>(id);
}

void XFKey_OnOwnerUnloaded(Handle owner)
{
    if (__XFKeyList)
    {
        int pos;
        while ((pos = __XFKeyList.FindValue(owner, 1)) != -1)
        {
            view_as<XFKey>(__XFKeyList.Get(pos)).Delete();
        }
    }
}

enum struct XFKeyData
{
    int index;
    Handle owner;

    int user_id;
    bool loaded;
    bool allow_all_scopes;
    char key[64];

    XFKeyType type;
    JSONObject scopes;

    void free()
    {
        if (this.scopes)
        {
            delete this.scopes;
        }
    }
}

methodmap XFKey __nullable__
{
    public XFKey(const char[] key, Handle owner = INVALID_HANDLE)
    {
        XFKeyData data;

        if (__xfkey_increment == 0)
        {
            __XFKeyList = new ArrayList(sizeof data);
        }

        __xfkey_increment++;

        data.index = __xfkey_increment;
        data.owner = owner;

        strcopy(data.key, sizeof XFKeyData::key, key);

        __XFKeyList.PushArray(data);

        return view_as<XFKey>(__xfkey_increment);
    }

    /**
     * Propeties
     */
    property int index
    {
        public get()
        {
            return view_as<int>(this);
        }
    }

    property bool loaded
    {
        public get()
        {
            XFKeyData data;
            this.GetData(data);
            return data.loaded;
        }
    }

    property XFKeyType type
    {
        public get()
        {
            XFKeyData data;
            this.GetData(data);
            return data.type;
        }
    }

    property int user_id
    {
        public get()
        {
            XFKeyData data;
            this.GetData(data);
            return data.user_id;
        }
    }

    property bool allow_all_scopes
    {
        public get()
        {
            XFKeyData data;
            this.GetData(data);
            return data.allow_all_scopes;
        }
    }

    /**
     * Functions
     */
    public void GetData(XFKeyData data)
    {
        __XFKeyList.GetArray(__XFKeyList.FindValue(this.index), data);
    }

    public void SetData(XFKeyData data)
    {
        __XFKeyList.SetArray(__XFKeyList.FindValue(this.index), data);
    }

    public void GetKey(char[] buffer, int size)
    {
        XFKeyData data;
        this.GetData(data);
        strcopy(buffer, size, data.key);
    }

    public void RequestLoad(const char[] base, Function callback, any value = 0, Handle plugin = INVALID_HANDLE)
    {
        XFKeyData data;
        this.GetData(data);

        data.user_id = 0;
        data.loaded = false;
        data.allow_all_scopes = false;
        data.type = XFKey_INVALID;
        data.free();

        this.SetData(data);

        DataPack pack = new DataPack();

        pack.WriteCell(plugin);
        pack.WriteFunction(callback);
        pack.WriteCell(value);

        XFRequest request = new XFRequest();

        request.key = this;
        request.SetBase(base);

        request.Send(__OnKeyLoad, _, pack);
    }

    public bool HasScope(const char[] scope)
    {
        XFKeyData data;
        this.GetData(data);

        if (!data.loaded)
        {
            return false;
        }

        return data.allow_all_scopes || (data.scopes && data.scopes.HasKey(scope));
    }

    public void Delete()
    {
        XFKeyData data;
        this.GetData(data);

        data.free();

        __XFKeyList.Erase(__XFKeyList.FindValue(this.index));
    }
}

void __OnKeyLoad(XFResponse response, int err_c, DataPack pack)
{
    // Checking whether the object was not deleted
    if (__XFKeyList.FindValue(response.request.key.index) == -1)
    {
        delete pack;
        return;
    }

    XFRequest request = response.request;

    XFKeyData data;
    request.key.GetData(data);

    if (!err_c)
    {
        JSONObject json = view_as<JSONObject>(view_as<JSONObject>(response.json).Get("key"));

        data.loaded = true;
        
        data.user_id = json.GetInt("user_id");
        data.allow_all_scopes = json.GetBool("allow_all_scopes");
        data.scopes = view_as<JSONObject>(json.Get("scopes"));

        char type[2];
        json.GetString("type", type, sizeof type);

        switch (type[0])
        {
            case 'g': data.type = XFKey_GUEST;
            case 'u': data.type = XFKey_USER;
            case 's': data.type = XFKey_SUPERUSER;
        }

        request.key.SetData(data);

        delete json;
    }
    else
    {
        char error_code[32], error_message[64];
        for (int i = 0; i < err_c; i++)
        {
            response.GetError(i, error_code, sizeof error_code, error_message, sizeof error_message);
            LogError("%s - %s", error_code, error_message);
        }
    }

    pack.Reset();
    request.Delete();

    Handle plugin = pack.ReadCell();
    Call_StartFunction(plugin, pack.ReadFunction());

    Call_PushCell(!err_c);
    Call_PushCell(pack.ReadCell());

    Call_Finish();

    delete pack;
}