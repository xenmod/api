#include <xf_api/base/key>

#define XFKEY_VERSION   1000010

methodmap XFKey __nullable__
{
    /**
     * Creates an object.
     * 
     * @param key   XenForo API key.
     */
    public native XFKey(const char[] key);

    /**
     * Checks if a key has been loaded.
     */
    property bool loaded
    {
        public native get();
    }

    /**
     * Returns key type (see XFKeyType enum)
     */
    property XFKeyType type
    {
        public native get();
    }

    /**
     * Key owner.
     */
    property int user_id
    {
        public native get();
    }

    /**
     * Checks if the key has access to all scopes.
     */
    property bool allow_all_scopes
    {
        public native get();
    }

    /**
     * Gets a key.
     * 
     * @param buffer    Buffer to store.
     * @param size      Size of buffer.
     */
    public native void GetKey(char[] buffer, int size);

    /**
     * Requests the load of a key.
     * 
     * @param base      Base url to api.
     * @param callback  Called when the key has been loaded.
     * @param value     Any value to pass.
     * 
     * @error           Invalid url. (or any other error, for example, key not found in XenForo database)
     */
    public native void RequestLoad(const char[] base, XFKeyLoadCallback callback, any value = 0);

    /**
     * Checks if the key has api scope.
     * 
     * @param scope     API scope.
     * 
     * @error           Key not loaded.
     */
    public native bool HasScope(const char[] scope);

    /**
     * Removes object from memory.
     */
    public native void Delete();
}