int __xfresponse_increment = 0;
ArrayList __XFResponseList;

XFResponse XFResponse_ById(int id)
{
    if (!__XFResponseList || __XFResponseList.FindValue(id) == -1)
    {
        ThrowNativeError(SP_ERROR_INDEX, "Invalid Object(XFResponse) (%i)", id);
    }

    return view_as<XFResponse>(id);
}

enum struct XFResponseData
{
    int index;

    JSON json;
    JSONArray errors;
    XFRequest request;
    HTTPStatus status;

    void free()
    {
        if (this.json)
        {
            delete this.json;
        }

        if (this.errors)
        {
            delete this.errors;
        }
    }
}

methodmap XFResponse __nullable__
{
    public XFResponse(XFRequest request)
    {
        XFResponseData data;

        if (__xfresponse_increment == 0)
        {
            __XFResponseList = new ArrayList(sizeof data);
        }

        __xfresponse_increment++;

        data.index = __xfresponse_increment;
        data.request = request;

        __XFResponseList.PushArray(data);

        return view_as<XFResponse>(__xfresponse_increment);
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

    property JSON json
    {
        public get()
        {
            XFResponseData data;
            this.GetData(data);

            if (!data.json)
            {
                return null;
            }

            return data.json;
        }
    }

    property XFRequest request
    {
        public get()
        {
            XFResponseData data;
            this.GetData(data);

            return data.request;
        }
    }

    property HTTPStatus status
    {
        public get()
        {
            XFResponseData data;
            this.GetData(data);

            return data.status;
        }
    }

    /**
     * Functions
     */
    public void GetData(XFResponseData data)
    {
        __XFResponseList.GetArray(__XFResponseList.FindValue(this.index), data);
    }

    public void SetData(XFResponseData data)
    {
        __XFResponseList.SetArray(__XFResponseList.FindValue(this.index), data);
    }

    public void GetError(int idx, char[] code, int code_size, char[] message, int message_size, char[] params = "", int params_size = 0)
    {
        XFResponseData data;
        this.GetData(data);

        if (!data.errors || (idx < 0 && idx < data.errors.Length))
        {
            return;
        }

        JSONObject error = view_as<JSONObject>(data.errors.Get(idx));

        error.GetString("code", code, code_size);
        error.GetString("message", message, message_size);

        if (params_size)
        {
            JSON json_params = error.Get("params");
            
            json_params.ToString(params, params_size);

            delete json_params;
        }

        delete error;
    }

    public void AddError(const char[] code, const char[] message)
    {
        XFResponseData data;
        this.GetData(data);

        if (!data.errors)
        {
            data.errors = new JSONArray();
        }

        this.SetData(data);

        JSONObject error = new JSONObject();

        error.SetString("code", code);
        error.SetString("message", message);

        JSONArray params = new JSONArray();

        error.Set("params", params);

        data.errors.Push(error);

        delete error;
        delete params;
    }

    public void Delete()
    {
        XFResponseData data;
        this.GetData(data);

        data.free();

        __XFResponseList.Erase(__XFResponseList.FindValue(this.index));
    }
}