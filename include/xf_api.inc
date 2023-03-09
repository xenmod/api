#if defined _xf_api_included
    #endinput
#endif
#define _xf_api_included

#if !defined _ripext_included_
    #include <ripext>
#endif

#include <xf_api/key>
#include <xf_api/request>
#include <xf_api/response>

public SharedPlugin __pl_xf_api= 
{
	name = "xf_api",
	file = "xf_api.smx",
#if defined REQUIRE_PLUGIN
	required = 1
#else
	required = 0
#endif
};

#if !defined REQUIRE_PLUGIN
public void __pl_xf_api_SetNTVOptional()
{
    /**
     * XFKey
     */
	MarkNativeAsOptional("XFKey.XFKey");

    MarkNativeAsOptional("XFKey.type.get");
    MarkNativeAsOptional("XFKey.loaded.get");
    MarkNativeAsOptional("XFKey.user_id.get");
    MarkNativeAsOptional("XFKey.allow_all_scopes.get");

    MarkNativeAsOptional("XFKey.GetKey");
    MarkNativeAsOptional("XFKey.RequestLoad");
    MarkNativeAsOptional("XFKey.HasScope");
    MarkNativeAsOptional("XFKey.Delete");


    /**
     * XFRequest
     */
    MarkNativeAsOptional("XFRequest.XFRequest");

    MarkNativeAsOptional("XFRequest.key.get");
    MarkNativeAsOptional("XFRequest.key.set");
    MarkNativeAsOptional("XFRequest.method.get");
    MarkNativeAsOptional("XFRequest.method.set");

    MarkNativeAsOptional("XFRequest.GetBase");
    MarkNativeAsOptional("XFRequest.SetBase");
    MarkNativeAsOptional("XFRequest.GetEndpoint");
    MarkNativeAsOptional("XFRequest.SetEndpoint");
    MarkNativeAsOptional("XFRequest.GetRequestParams");
    MarkNativeAsOptional("XFRequest.SetRequestParam");
    MarkNativeAsOptional("XFRequest.RemoveRequestParam");
    MarkNativeAsOptional("XFRequest.RemoveRequestParams");
    MarkNativeAsOptional("XFRequest.Send");
    MarkNativeAsOptional("XFRequest.Delete");


    /**
     * XFResponse
     */
    MarkNativeAsOptional("XFResponse.json.get");
    MarkNativeAsOptional("XFResponse.request.get");
    MarkNativeAsOptional("XFResponse.http_status.get");
    
    MarkNativeAsOptional("XFResponse.GetError");
}
#endif