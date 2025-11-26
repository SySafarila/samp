#include <open.mp>
#include <core>
#include <float>
#include <zcmd>
#include <sscanf2>

#pragma tabsize 0

new GAME_MODE_TEXT[] = "SySafarila Script";
new Float:selectedMap[MAX_PLAYERS][3];

main()
{
    print("\n----------------------------------");
    print("  Bare Script\n");
    print("----------------------------------\n");
}

CMD:me(playerid, params[])
{
    if (!strlen(params))
        return SendClientMessage(playerid, -1, "Usage: /me <action>");

    new name[MAX_PLAYER_NAME], msg[128];
    GetPlayerName(playerid, name, sizeof(name));

    format(msg, sizeof(msg), "* %s %s", name, params);
    SendClientMessageToAll(0xC2A2DAFF, msg);
    return 1;
}

CMD:setmoney(playerid, params[])
{
    new integer:amount, integer:targetPlayerId;
    sscanf(params, "ii", targetPlayerId, amount);

    if (!amount)
    {
        return SendClientMessage(playerid, -1, "Usage: /setmoney <playerid> <amount>");
    }

    if (!IsPlayerConnected(targetPlayerId))
    {
        return SendClientMessage(playerid, -1, "Target player is not online.");
    }

    GivePlayerMoney(targetPlayerId, amount);
    new currentMoney = GetPlayerMoney(targetPlayerId);

    new msg[64];
    format(msg, sizeof msg, "You have received $%d. New balance: $%d", amount, currentMoney);
    SendClientMessage(targetPlayerId, -1, msg);

    return 1;
}

CMD:setname(playerid, params[])
{
    if (!strlen(params))
        return SendClientMessage(playerid, -1, "Usage: /setname <new_name>");

    // Cek panjang name (aturan SA-MP)
    if (strlen(params) < 3 || strlen(params) > 24)
        return SendClientMessage(playerid, -1, "Name must be 3-24 characters.");

    // Coba ganti nama
    if (!SetPlayerName(playerid, params))
        return SendClientMessage(playerid, -1, "Name change failed. Name might be taken or invalid.");

    new msg[64];
    format(msg, sizeof msg, "Your name has been changed to %s", params);
    SendClientMessage(playerid, -1, msg);

    return 1;
}

CMD:currentlocation(playerId, params[])
{
    new Float:LastX[MAX_PLAYERS], Float:LastY[MAX_PLAYERS], Float:LastZ[MAX_PLAYERS];
    GetPlayerPos(playerId, LastX[playerId], LastY[playerId], LastZ[playerId]);
    printf("Current pos for player %d: %f, %f, %f", playerId, LastX[playerId], LastY[playerId], LastZ[playerId]);
}

CMD:getvehicleposition(playerId, params[])
{
    new vehicleId = GetPlayerVehicleID(playerId);

    if (vehicleId == 0)
    {
        return SendClientMessage(playerId, -1, "You are not in a vehicle.");
    }

    new Float:vehX, Float:vehY, Float:vehZ, Float:vehA, string[128], string2[128];

    GetVehiclePos(vehicleId, vehX, vehY, vehZ);
    GetVehicleZAngle(vehicleId, vehA);

    format(string, sizeof(string), "The current vehicle positions are: %f, %f, %f", vehX, vehY, vehZ);
    format(string2, sizeof(string), "and current angle is: %f", vehA);
    SendClientMessage(playerId, 0xFFFFFFFF, string);
    SendClientMessage(playerId, 0xFFFFFFFF, string2);
    print(string);
    print(string2);
    return 1;
}

CMD:teleport(playerId, params[])
{
    new Float:x = selectedMap[playerId][0];
    new Float:y = selectedMap[playerId][1];
    new Float:z = selectedMap[playerId][2];

    new bool:playerInVeh = IsPlayerInAnyVehicle(playerId);
    if (playerInVeh == true)
    {
        new vehicleid = GetPlayerVehicleID(playerId);
        new seatid = GetPlayerVehicleSeat(playerId);
        SetPlayerPos(playerId, x, y, z);
        SetVehiclePos(vehicleid, x, y, z)
        PutPlayerInVehicle(playerId, vehicleid, seatid)
        return 1;
    }

    SetPlayerPos(playerId, x, y, z);

    new msg[128];
    format(msg, sizeof msg, "Teleported to X: %f, Y: %f, Z: %f", x, y, z);
    SendClientMessage(playerId, -1, msg);

    return 1;
}

CMD:clear(playerId, params[])
{
    SendClientMessage(playerId, -1, "Clearing chat...");
    for (new i = 0; i < 20; i++)
    {
        SendClientMessage(playerId, -1, " ");
    }

    return 1;
}

CMD:fixvehicleengine(playerId, params[])
{
    new vehicleId = GetPlayerVehicleID(playerId);
    SetVehicleHealth(vehicleId, 1000.0);
    SendClientMessage(playerId, -1, "Vehicle engine repaired.");
    return 1;
}

CMD:fixvehiclebody(playerId, params[])
{
    new vehicleId = GetPlayerVehicleID(playerId);
    RepairVehicle(vehicleId);
    SendClientMessage(playerId, -1, "Vehicle body repaired.");
    return 1;
}

CMD:veh(playerid, params[])
{
    new vehicleId = strval(params);

    if (!vehicleId)
        return SendClientMessage(playerid, -1, "Usage: /veh <VEHICLE ID>");

    if (vehicleId < 400 || vehicleId > 611)
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

CMD:setvehicleplate(playerId, params[])
{
    new vehicleId;
    new plate[16];

    sscanf(params, "is[16]", vehicleId, plate)

    if (strlen(plate) == 0)
    {
        return SendClientMessage(playerId, -1, "Usage: /setvehicleplate <vehicleid> <plate>");
    }

    if (!IsValidVehicle(vehicleId))
        return SendClientMessage(playerId, -1, "Invalid vehicle ID.");

    SetVehicleNumberPlate(vehicleId, plate);

    new msg[64];
    format(msg, sizeof(msg), "Vehicle %d plate set to %s", vehicleId, plate);
    SendClientMessage(playerId, -1, msg);

    return 1;
}

public OnPlayerConnect(playerid)
{
    GameTextForPlayer(playerid, "~w~SA-MP: ~r~Bare Script", 5000, 5);
    return 1;
}

public OnPlayerSpawn(playerid)
{
    SetPlayerInterior(playerid, false);
    TogglePlayerClock(playerid, false);
    return 1;
}

public OnPlayerDeath(playerid, killerid, WEAPON:reason)
{
    return 1;
}

public OnPlayerClickMap(playerid, Float:fX, Float:fY, Float:fZ)
{
    selectedMap[playerid][0] = fX;
    selectedMap[playerid][1] = fY;
    selectedMap[playerid][2] = fZ;

    new msg[128];
    format(msg, sizeof(msg), "You selected map coordinates: X: %f, Y: %f, Z: %f", fX, fY, fZ);
    SendClientMessage(playerid, -1, msg);
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

    new Float:car1x = 2039.055786;
    new Float:car1y = 1342.085693;
    new Float:car1z = 10.471857;
    new Float:car1a = 179.931472;

    new vid = CreateVehicle(409, car1x, car1y, car1z, car1a, 1, 1, 60000);

    // Plate perlu titik koma
    SetVehicleNumberPlate(vid, "TESTDRIVE");

    return 1;
}
