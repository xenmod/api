typedef XFRequestCallback = function void(XFResponse response, int err_c, any data);

enum XFRequestMethod
{
    XFRequest_GET,
    XFRequest_PUT,
    XFRequest_POST,
    XFRequest_DELETE
}