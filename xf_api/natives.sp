public APLRes AskPluginLoad2(Handle myself, bool late, char[] error, int err_max)
{
    RegPluginLibrary("xf_api");

    /**
     * XFKey
     */
    CreateNative("XFKey.XFKey",                     Native_XFKey_XFKey);

    CreateNative("XFKey.type.get",                  Native_XFKey_Type_Get);
    CreateNative("XFKey.loaded.get",                Native_XFKey_Loaded_Get);
    CreateNative("XFKey.user_id.get",               Native_XFKey_UserId_Get);
    CreateNative("XFKey.allow_all_scopes.get",      Native_XFKey_AllowAllScopes_Get);

    CreateNative("XFKey.GetKey",                    Native_XFKey_GetKey);
    CreateNative("XFKey.RequestLoad",               Native_XFKey_RequestLoad);
    CreateNative("XFKey.HasScope",                  Native_XFKey_HasScope);
    CreateNative("XFKey.Delete",                    Native_XFKey_Delete);


    /**
     * XFRequest
     */
    CreateNative("XFRequest.XFRequest",             Native_XFRequest_XFRequest);

    CreateNative("XFRequest.key.get",               Native_XFRequest_Key_Get);
    CreateNative("XFRequest.key.set",               Native_XFRequest_Key_Set);
    CreateNative("XFRequest.method.get",            Native_XFRequest_Method_Get);
    CreateNative("XFRequest.method.set",            Native_XFRequest_Method_Set);

    CreateNative("XFRequest.GetBase",               Native_XFRequest_GetBase);
    CreateNative("XFRequest.SetBase",               Native_XFRequest_SetBase);
    CreateNative("XFRequest.GetEndpoint",           Native_XFRequest_GetEndpoint);
    CreateNative("XFRequest.SetEndpoint",           Native_XFRequest_SetEndpoint);
    CreateNative("XFRequest.GetRequestParams",      Native_XFRequest_GetRequestParams);
    CreateNative("XFRequest.SetRequestParam",       Native_XFRequest_SetRequestParam);
    CreateNative("XFRequest.RemoveRequestParam",    Native_XFRequest_RemoveRequestParam);
    CreateNative("XFRequest.RemoveRequestParams",   Native_XFRequest_RemoveRequestParams);
    CreateNative("XFRequest.Send",                  Native_XFRequest_Send);
    CreateNative("XFRequest.Delete",                Native_XFRequest_Delete);

    /**
     * XFResponse
     */
    CreateNative("XFResponse.json.get",             Native_XFResponse_Json_Get);
    CreateNative("XFResponse.request.get",          Native_XFResponse_Request_Get);
    CreateNative("XFResponse.http_status.get",      Native_XFResponse_HttpStatus_Get);
    
    CreateNative("XFResponse.GetError",             Native_XFResponse_GetError);

    return APLRes_Success;
}


/**
 * XFKey
 */
any Native_XFKey_XFKey(Handle plugin, int num_params)
{
    char key[64];
    GetNativeString(1, key, sizeof key);
    return new XFKey(key, plugin);
}

any Native_XFKey_Type_Get(Handle plugin, int num_params)
{
    XFKey key = XFKey_ById(GetNativeCell(1), plugin);
    return key.type;
}

any Native_XFKey_Loaded_Get(Handle plugin, int num_params)
{
    XFKey key = XFKey_ById(GetNativeCell(1), plugin);
    return key.loaded;
}

any Native_XFKey_UserId_Get(Handle plugin, int num_params)
{
    XFKey key = XFKey_ById(GetNativeCell(1), plugin);
    return key.user_id;
}

any Native_XFKey_AllowAllScopes_Get(Handle plugin, int num_params)
{
    XFKey key = XFKey_ById(GetNativeCell(1), plugin);
    return key.allow_all_scopes;
}

any Native_XFKey_GetKey(Handle plugin, int num_params)
{
    XFKey key = XFKey_ById(GetNativeCell(1), plugin);

    char key_c[64];
    key.GetKey(key_c, sizeof key_c);
    SetNativeString(2, key_c, GetNativeCell(3));

    return 0;
}

any Native_XFKey_RequestLoad(Handle plugin, int num_params)
{
    XFKey key = XFKey_ById(GetNativeCell(1), plugin);

    char base[64];
    GetNativeString(2, base, sizeof base);

    key.RequestLoad(base, GetNativeFunction(3), GetNativeCell(4), plugin);

    return 0;
}

any Native_XFKey_HasScope(Handle plugin, int num_params)
{
    XFKey key = XFKey_ById(GetNativeCell(1), plugin);

    char scope[32];
    GetNativeString(2, scope, sizeof scope);

    return key.HasScope(scope);
}

any Native_XFKey_Delete(Handle plugin, int num_params)
{
    XFKey key = XFKey_ById(GetNativeCell(1), plugin);

    key.Delete();

    return 0;
}


/**
 * XFRequest
 */
any Native_XFRequest_XFRequest(Handle plugin, int num_params)
{
    return new XFRequest(plugin);
}

any Native_XFRequest_Key_Get(Handle plugin, int num_params)
{
    XFRequest request = XFRequest_ById(GetNativeCell(1), plugin);
    return request.key;
}

any Native_XFRequest_Key_Set(Handle plugin, int num_params)
{
    XFRequest request = XFRequest_ById(GetNativeCell(1), plugin);

    XFKey key = XFKey_ById(GetNativeCell(2), plugin);

    request.key = key;

    return 0;
}

any Native_XFRequest_Method_Get(Handle plugin, int num_params)
{
    XFRequest request = XFRequest_ById(GetNativeCell(1), plugin);
    return request.method;
}

any Native_XFRequest_Method_Set(Handle plugin, int num_params)
{
    XFRequest request = XFRequest_ById(GetNativeCell(1), plugin);

    request.method = GetNativeCell(2);

    return 0;
}

any Native_XFRequest_GetBase(Handle plugin, int num_params)
{
    XFRequest request = XFRequest_ById(GetNativeCell(1), plugin);

    char base[64];
    request.GetBase(base, sizeof base);

    SetNativeString(2, base, GetNativeCell(3));

    return 0;
}

any Native_XFRequest_SetBase(Handle plugin, int num_params)
{
    XFRequest request = XFRequest_ById(GetNativeCell(1), plugin);

    char base[64];
    GetNativeString(2, base, sizeof base);

    request.SetBase(base);

    return 0;
}

any Native_XFRequest_GetEndpoint(Handle plugin, int num_params)
{
    XFRequest request = XFRequest_ById(GetNativeCell(1), plugin);

    char endpoint[128];
    request.GetEndpoint(endpoint, sizeof endpoint);

    SetNativeString(2, endpoint, GetNativeCell(3));

    return 0;
}

any Native_XFRequest_SetEndpoint(Handle plugin, int num_params)
{
    XFRequest request = XFRequest_ById(GetNativeCell(1), plugin);

    char endpoint[128];
    GetNativeString(2, endpoint, sizeof endpoint);

    request.SetEndpoint(endpoint);

    return 0;
}

any Native_XFRequest_GetRequestParams(Handle plugin, int num_params)
{
    XFRequest request = XFRequest_ById(GetNativeCell(1), plugin);

    int size = GetNativeCell(3);

    char[] params = new char[size];
    request.GetRequestParams(params, size);

    SetNativeString(2, params, size);

    return 0;
}

any Native_XFRequest_SetRequestParam(Handle plugin, int num_params)
{
    XFRequest request = XFRequest_ById(GetNativeCell(1), plugin);

    char param[32], value[64];
    GetNativeString(2, param, sizeof param);
    GetNativeString(3, value, sizeof value);

    request.SetRequestParam(param, value);

    return 0;
}

any Native_XFRequest_RemoveRequestParam(Handle plugin, int num_params)
{
    XFRequest request = XFRequest_ById(GetNativeCell(1), plugin);

    char param[32];
    GetNativeString(2, param, sizeof param);

    request.RemoveRequestParam(param);

    return 0;
}

any Native_XFRequest_RemoveRequestParams(Handle plugin, int num_params)
{
    XFRequest request = XFRequest_ById(GetNativeCell(1), plugin);

    request.RemoveRequestParams();

    return 0;
}

any Native_XFRequest_Send(Handle plugin, int num_params)
{
    XFRequest request = XFRequest_ById(GetNativeCell(1), plugin);

    request.Send(GetNativeFunction(2), GetNativeCell(3), GetNativeCell(4), GetNativeCell(5), plugin);

    return 0;
}

any Native_XFRequest_Delete(Handle plugin, int num_params)
{
    XFRequest request = XFRequest_ById(GetNativeCell(1), plugin);

    request.Delete();

    return 0;
}


/**
 * XFResponse
 */
any Native_XFResponse_Json_Get(Handle plugin, int num_params)
{
    XFResponse response = XFResponse_ById(GetNativeCell(1));

    return response.json;
}

any Native_XFResponse_Request_Get(Handle plugin, int num_params)
{
    XFResponse response = XFResponse_ById(GetNativeCell(1));

    return response.request;
}

any Native_XFResponse_HttpStatus_Get(Handle plugin, int num_params)
{
    XFResponse response = XFResponse_ById(GetNativeCell(1));

    return response.status;
}

any Native_XFResponse_GetError(Handle plugin, int num_params)
{
    XFResponse response = XFResponse_ById(GetNativeCell(1));

    int
        code_size = GetNativeCell(4),
        message_size = GetNativeCell(6),
        params_size = GetNativeCell(8);

    char[] code = new char[code_size];
    char[] message = new char[message_size];
    char[] params = new char[params_size];

    response.GetError(GetNativeCell(2), code, code_size, message, message_size, params, params_size);

    SetNativeString(3, code, code_size);
    SetNativeString(5, message, message_size);
    SetNativeString(7, params, params_size);

    return 0;
}