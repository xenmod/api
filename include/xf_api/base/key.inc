typedef XFKeyLoadCallback = function void(bool valid, any data);

enum XFKeyType
{
    XFKey_INVALID,
    XFKey_GUEST,
    XFKey_USER,
    XFKey_SUPERUSER
}