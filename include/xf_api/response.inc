#define XFRESPONSE_VERSION   1000010

methodmap XFResponse __nullable__
{
    /**
     * Returns json data.
     * 
     * @error   Unable to fetch json data.
     */
    property JSON json
    {
        public native get();
    }

    /**
     * Return XFRequest object.
     */
    property XFRequest request
    {
        public native get();
    }

    /**
     * Returns HTTPStatus.
     */
    property HTTPStatus status
    {
        public native get();
    }

    /**
     * Return error (if exists).
     * 
     * @param idx           Error index.
     * @param code          Buffer to store error code.
     * @param code_size     Size of code buffer.
     * @param message       Buffer to store error message.
     * @param message_size  Size of message buffer.
     * @param params        Buffer to store params field.
     * @param params_size   Size of params buffer.
     * 
     * @error               Invalid error index.
     */
    public native void GetError(int idx, char[] code, int code_size, char[] message, int message_size, char[] params = "", int params_size = 0);
}