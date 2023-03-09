#pragma semicolon 1

#include <sourcemod>
#include <ripext>

#pragma newdecls required

#include "xf_api/entity/key.sp"
#include "xf_api/entity/request.sp"
#include "xf_api/entity/response.sp"

#include "xf_api/natives.sp"

public Plugin myinfo =
{
	name    = "[XF] API",
	author	= "github.com/xenmod",
	version = "1.0.0 Alpha b_"...SOURCEMOD_VERSION
};

public void OnNotifyPluginUnloaded(Handle plugin)
{
	XFKey_OnOwnerUnloaded(plugin);
	XFRequest_OnOwnerUnloaded(plugin);
}