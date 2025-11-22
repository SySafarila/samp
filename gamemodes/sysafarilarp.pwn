#include <a_samp>
#include <core>
#include <float>
#include <zcmd>

#pragma tabsize 0

main()
{
	print("\n----------------------------------");
	print("  Bare Script\n");
	print("----------------------------------\n");
}

public OnPlayerConnect(playerid)
{
	GameTextForPlayer(playerid,"~w~SA-MP: ~r~Bare Script",5000,5);
	return 1;
}

CMD:me(playerid, params[])
{
    if(!strlen(params))
        return SendClientMessage(playerid, -1, "Usage: /me <action>");

    new name[MAX_PLAYER_NAME], msg[128];
    GetPlayerName(playerid, name, sizeof(name));

    format(msg, sizeof(msg), "* %s %s", name, params);
    SendClientMessageToAll(0xC2A2DAFF, msg);
    return 1;
}

CMD:veh(playerid, params[])
{
    if(!strlen(params))
        return SendClientMessage(playerid, -1, "Usage: /veh <vehicleid>");

    new vehicleId = strval(params);

    if(vehicleId < 400 || vehicleId > 611)
        return SendClientMessage(playerid, -1, "Invalid ID (400–611).");

    new Float:x, Float:y, Float:z;
    GetPlayerPos(playerid, x, y, z);

    // PENTING: warna jangan -1,-1
    // PENTING: spawn offset sedikit biar ga numpuk di atas kendaraan lama
    new vid = CreateVehicle(vehicleId, x + 1.5, y, z, 0.0, 1, 1, 60000);

    // Plate perlu titik koma
    SetVehicleNumberPlate(vid, "TESTDRIVE");

    new msg[128];
    format(msg, sizeof msg, "Spawned vehicle %d", vehicleId);
    SendClientMessage(playerid, -1, msg);

    PutPlayerInVehicle(playerid, vid, 0);
    return 1;
}

public OnPlayerCommandText(playerid, cmdtext[])
{
	new idx;
	new cmd[256];
	
	cmd = strtok(cmdtext, idx);

	if(strcmp(cmd, "/yadayada", true) == 0) {
    	return 1;
	}

	return 0;
}

public OnPlayerSpawn(playerid)
{
	SetPlayerInterior(playerid,0);
	TogglePlayerClock(playerid,0);
	return 1;
}

public OnPlayerDeath(playerid, killerid, reason)
{
   	return 1;
}

SetupPlayerForClassSelection(playerid)
{
 	SetPlayerInterior(playerid,14);
	SetPlayerPos(playerid,258.4893,-41.4008,1002.0234);
	SetPlayerFacingAngle(playerid, 270.0);
	SetPlayerCameraPos(playerid,256.0815,-43.0475,1004.0234);
	SetPlayerCameraLookAt(playerid,258.4893,-41.4008,1002.0234);
}

public OnPlayerRequestClass(playerid, classid)
{
	SetupPlayerForClassSelection(playerid);
	return 1;
}

public OnGameModeInit()
{
	SetGameModeText("Bare Script");
	ShowPlayerMarkers(1);
	ShowNameTags(1);
	AllowAdminTeleport(1);

	AddPlayerClass(265,1958.3783,1343.1572,15.3746,270.1425,0,0,0,0,-1,-1);

    DisableInteriorEnterExits()

	return 1;
}

strtok(const string[], &index)
{
	new length = strlen(string);
	while ((index < length) && (string[index] <= ' '))
	{
		index++;
	}

	new offset = index;
	new result[20];
	while ((index < length) && (string[index] > ' ') && ((index - offset) < (sizeof(result) - 1)))
	{
		result[index - offset] = string[index];
		index++;
	}
	result[index - offset] = EOS;
	return result;
}
