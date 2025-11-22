#include <open.mp>
#include <core>
#include <float>
#include <zcmd>

#pragma tabsize 0

new GAME_MODE_TEXT[] = "SySafarila Script";

main()
{
	print("\n----------------------------------");
	print("  Bare Script\n");
	print("----------------------------------\n");
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

CMD:addmoney(playerid, params[])
{
    new amount = strval(params);

    if(!amount)
        return SendClientMessage(playerid, -1, "Usage: /addmoney <amount>");

    GivePlayerMoney(playerid, amount);
    new currentMoney = GetPlayerMoney(playerid);

    new msg[64];
    format(msg, sizeof msg, "You have received $%d. New balance: $%d", amount, currentMoney);
    SendClientMessage(playerid, -1, msg);

    return 1;
}

CMD:setname(playerid, params[])
{
    if(!strlen(params))
        return SendClientMessage(playerid, -1, "Usage: /setname <new_name>");

    // Cek panjang name (aturan SA-MP)
    if(strlen(params) < 3 || strlen(params) > 24)
        return SendClientMessage(playerid, -1, "Name must be 3-24 characters.");

    // Coba ganti nama
    if(!SetPlayerName(playerid, params))
        return SendClientMessage(playerid, -1, "Name change failed. Name might be taken or invalid.");

    new msg[64];
    format(msg, sizeof msg, "Your name has been changed to %s", params);
    SendClientMessage(playerid, -1, msg);

    return 1;
}

CMD:veh(playerid, params[])
{
    new vehicleId = strval(params);

    if(!vehicleId)
        return SendClientMessage(playerid, -1, "Usage: /veh <VEHICLE ID>");

    if(vehicleId < 400 || vehicleId > 611)
        return SendClientMessage(playerid, -1, "Invalid VEHICLE ID (400 - 611).");

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

    // PutPlayerInVehicle(playerid, vid, 0);
    return 1;
}

public OnPlayerConnect(playerid)
{
	GameTextForPlayer(playerid,"~w~SA-MP: ~r~Bare Script",5000,5);
	return 1;
}

public OnPlayerSpawn(playerid)
{
	SetPlayerInterior(playerid,false);
	TogglePlayerClock(playerid,false);
	return 1;
}

public OnPlayerDeath(playerid, killerid, WEAPON:reason)
{
   	return 1;
}

public OnPlayerRequestClass(playerid, classid)
{
    // Set the player's spawn information (skin, weapons, location, etc.)
    // This example uses default info set with AddPlayerClass earlier in the script.
    SetSpawnInfo(playerid, NO_TEAM, 2, 1958.33, 1343.12, 15.36, 269.15, WEAPON_SAWEDOFF, 36, WEAPON_UZI, 150, WEAPON_BAT, 0);

    // set player name
    SetPlayerName(playerid, "syahrul_safarila");

    // set player score
    SetPlayerScore(playerid, 10);

    // Force the player to spawn instantly
    SpawnPlayer(playerid);
    return 1;
}

public OnPlayerDisconnect(playerid, reason)
{
	new Float:LastX[MAX_PLAYERS], Float:LastY[MAX_PLAYERS], Float:LastZ[MAX_PLAYERS];
    GetPlayerPos(playerid, LastX[playerid], LastY[playerid], LastZ[playerid]);
    printf("Saved last pos for player %d: %f, %f, %f", playerid, LastX[playerid], LastY[playerid], LastZ[playerid]);
    return 1;
}


public OnGameModeInit()
{
	SetGameModeText(GAME_MODE_TEXT);
	ShowPlayerMarkers(PLAYER_MARKERS_MODE_GLOBAL);
	ShowNameTags(true);
	// AllowAdminTeleport(1);

	// AddPlayerClass(265,1958.3783,1343.1572,15.3746,270.1425,0,0,0,0,-1,-1);

    DisableInteriorEnterExits()

	return 1;
}
