#include <xf_api/base/request>

#define XFKEY_VERSION   1000010

methodmap XFRequest __nullable__
{
    /**
     * Creates an object.
     */
    public native XFRequest();

    /**
     * Gets/Sets XFKey object
     */
    property XFKey key
    {
        public native get();
        public native set(XFKey key);
    }

    /**
     * Gets/Sets request method. (Default: GET)
     */
    property XFRequestMethod method
    {
        public native get();
        public native set(XFRequestMethod method);
    }

    /**
     * Gets a base url.
     * 
     * @param buffer    Buffer to store.
     * @param size      Size of buffer.
     */
    public native void GetBase(char[] buffer, int size);

    /**
     * Sets a base url.
     * 
     * @param base  Base url.
     */
    public native void SetBase(const char[] base);

    /**
     * Gets a endpoint.
     * 
     * @param buffer    Buffer to store.
     * @param size      Size of buffer.
     */
    public native void GetEndpoint(char[] buffer, int size);

    /**
     * Sets a endpoint.
     * 
     * @param endpoint  Endpoint.
     */
    public native void SetEndpoint(const char[] endpoint);

    /**
     * Gets a request params.
     * 
     * @param buffer    Buffer to store.
     * @param size      Size of buffer.
     */
    public native void GetRequestParams(char[] buffer, int size)

    /**
     * Sets a query parameter to the URL.
     * 
     * @param param     Parameter name.
     * @param format    Formatting rules.
     * @param ...       Variables for formatting.
     */
    public native void SetRequestParam(const char[] param, const char[] format, any ...);

    /**
     * Removes a query parameter.
     * 
     * @param param     Parameter name.
     */
    public native void RemoveRequestParam(const char[] param);

    /**
     * Removes a query parameters.
     */
    public native void RemoveRequestParams();

    /**
     * Sends a request.
     * 
     * @param callback  Request callback. (Always called)
     * @param json      JSON data. (Not used for GET and DELETE requests)
     * 
     * @error           XFKey not provided.
     */
    public native void Send(XFRequestCallback callback, JSON json = null, any value = 0, int timeout = 3);

    /**
     * Removes object from memory.
     */
    public native void Delete();
}