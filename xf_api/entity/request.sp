#include <xf_api/base/request>

int __xfrequest_increment = 0;
ArrayList __XFRequestList;

XFRequest XFRequest_ById(int id, Handle plugin)
{
    int pos;
    if (!__XFRequestList || (pos = __XFRequestList.FindValue(id)) == -1 || __XFRequestList.Get(pos, 1) != plugin)
    {
        ThrowNativeError(SP_ERROR_INDEX, "Invalid Object(XFRequest) (%i)", id);
    }

    return view_as<XFRequest>(id);
}

void XFRequest_OnOwnerUnloaded(Handle owner)
{
    if (__XFRequestList)
    {
        int pos;
        while ((pos = __XFRequestList.FindValue(owner, 1)) != -1)
        {
            view_as<XFRequest>(__XFRequestList.Get(pos)).Delete();
        }
    }
}

enum struct XFRequestData
{
    int index;
    Handle owner;

    char base[64];
    char endpoint[128];

    XFKey key;
    XFRequestMethod method;
    JSONObject params;

    void free()
    {
        if (this.params)
        {
            delete this.params;
        }
    }
}

methodmap XFRequest __nullable__
{
    public XFRequest(Handle owner = INVALID_HANDLE)
    {
        XFRequestData data;

        if (__xfrequest_increment == 0)
        {
            __XFRequestList = new ArrayList(sizeof data);
        }

        __xfrequest_increment++;

        data.index = __xfrequest_increment;
        data.owner = owner;

        __XFRequestList.PushArray(data);

        return view_as<XFRequest>(__xfrequest_increment);
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

    property XFKey key
    {
        public get()
        {
            XFRequestData data;
            this.GetData(data);
            return data.key;
        }
        public set(XFKey key)
        {
            XFRequestData data;
            this.GetData(data);

            data.key = key;

            this.SetData(data);
        }
    }

    property XFRequestMethod method
    {
        public get()
        {
            XFRequestData data;
            this.GetData(data);
            return data.method;
        }
        public set(XFRequestMethod method)
        {
            XFRequestData data;
            this.GetData(data);

            data.method = method;

            this.SetData(data);
        }
    }

    /**
     * Functions
     */
    public void GetData(XFRequestData data)
    {
        __XFRequestList.GetArray(__XFRequestList.FindValue(this.index), data);
    }

    public void SetData(XFRequestData data)
    {
        __XFRequestList.SetArray(__XFRequestList.FindValue(this.index), data);
    }

    public void GetBase(char[] buffer, int size)
    {
        XFRequestData data;
        this.GetData(data);
        strcopy(buffer, size, data.base);
    }

    public void SetBase(const char[] base)
    {
        XFRequestData data;
        this.GetData(data);

        strcopy(data.base, sizeof XFRequestData::base, base);

        this.SetData(data);
    }

    public void GetEndpoint(char[] buffer, int size)
    {
        XFRequestData data;
        this.GetData(data);
        strcopy(buffer, size, data.endpoint);
    }

    public void SetEndpoint(const char[] endpoint)
    {
        XFRequestData data;
        this.GetData(data);

        strcopy(data.endpoint, sizeof XFRequestData::endpoint, endpoint);

        this.SetData(data);
    }

    public void GetRequestParams(char[] buffer, int size)
    {
        XFRequestData data;
        this.GetData(data);

        if (data.params)
        {
            data.params.ToString(buffer, size);
        }
    }

    public void SetRequestParam(const char[] param, const char[] value)
    {
        XFRequestData data;
        this.GetData(data);

        if (!data.params)
        {
            data.params = new JSONObject();
        }

        data.params.SetString(param, value);

        this.SetData(data);
    }

    public void RemoveRequestParam(const char[] param)
    {
        XFRequestData data;
        this.GetData(data);

        if (data.params && data.params.HasKey(param))
        {
            data.params.Remove(param);
        }
    }

    public void RemoveRequestParams()
    {
        XFRequestData data;
        this.GetData(data);

        if (data.params)
        {
            data.params.Clear();
        }
    }

    public void Send(Function callback, JSON json = null, any value = 0, int timeout = 3, Handle plugin = INVALID_HANDLE)
    {
        XFRequestData data;
        this.GetData(data);

        char key[64];
        data.key.GetKey(key, sizeof key);

        char url[256];
        FormatEx(url, sizeof url, "%s/%s", data.base, data.endpoint);

        HTTPRequest request = new HTTPRequest(url);

        request.SetHeader("Content-Type", "application/json");
        request.SetHeader("XF-Api-Key", key);

        request.Timeout = timeout;

        if (data.params)
        {
            JSONObjectKeys keys = data.params.Keys();

            char qparam[32], qvalue[64];
            while (keys.ReadKey(qparam, sizeof qparam))
            {
                data.params.GetString(qparam, qvalue, sizeof qvalue);
                request.AppendQueryParam(qparam, qvalue);
            }

            delete keys;
        }

        DataPack pack = new DataPack();

        pack.WriteCell(this);
        pack.WriteCell(plugin);
        pack.WriteFunction(callback);
        pack.WriteCell(value);

        switch (data.method)
        {
            case XFRequest_GET:
            {
                request.Get(__XFRequestCallback, pack);
            }
            case XFRequest_PUT:
            {
                request.Put(json, __XFRequestCallback, pack);
            }
            case XFRequest_POST:
            {
                request.Post(json, __XFRequestCallback, pack);
            }
            case XFRequest_DELETE:
            {
                request.Delete(__XFRequestCallback, pack);
            }
        }
    }

    public void Delete()
    {
        XFRequestData data;
        this.GetData(data);

        data.free();

        __XFRequestList.Erase(__XFRequestList.FindValue(this.index));
    }
}

void __XFRequestCallback(HTTPResponse http_response, DataPack pack, const char[] internal_error)
{
    pack.Reset();

    XFRequest request = pack.ReadCell();

    // Checking whether the object was not deleted
    if (__XFRequestList.FindValue(request.index) == -1)
    {
        delete pack;
        return;
    }

    int err_c = 0;
    XFResponse response = new XFResponse(request);

    if (internal_error[0])
    {
        err_c++;
        response.AddError("internal_error", internal_error);
    }
    else
    {
        XFResponseData data;
        response.GetData(data);

        data.status = http_response.Status;

        if (data.status != HTTPStatus_OK)
        {
            if (view_as<int>(data.status) / 100 == 4)
            {
                JSONObject json_response = view_as<JSONObject>(http_response.Data);

                data.errors = view_as<JSONArray>(json_response.Get("errors"));
                err_c = data.errors.Length;

                delete json_response;
            }
            else
            {
                err_c++;
                response.AddError("internal_server_error", "Unable to process the request.");
            }
        }
        else
        {
            data.json = http_response.Data;
        }

        response.SetData(data);
    }

    Handle plugin = pack.ReadCell();
    Call_StartFunction(plugin, pack.ReadFunction());

    Call_PushCell(response);
    Call_PushCell(err_c);
    Call_PushCell(pack.ReadCell());

    Call_Finish();

    delete pack;

    response.Delete();
}