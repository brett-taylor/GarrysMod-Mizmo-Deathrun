PlayerSettings.PlayerMetaTable = FindMetaTable("Player");

function PlayerSettings.DoesSettingExist(setting)
	if (PlayerSettings.Enums == nil) then
		return false;
	end

	if (PlayerSettings.Enums[setting] == nil) then
		return false;
	else
		return true;
	end
end

function PlayerSettings.CheckPlayerExists(ply)
	PlayerSettings.Data.CheckPlayerRow(ply:SteamID());
	PlayerSettings.CreateNetworkedStrings(ply);
end
hook.Add("PlayerInitialSpawn", "MizmoSetUpSettings", PlayerSettings.CheckPlayerExists);

function PlayerSettings.CreateNetworkedStrings(ply)
	for i = 1, #PlayerSettings.Enums do
		if (PlayerSettings.Enums[i].IsNetworked == true) then
			ply:SetNWString(PlayerSettings.Enums[i].Name, PlayerSettings.GetSetting(ply, PlayerSettings.Enums[i].Name));
		end
	end
end

function PlayerSettings.GetSetting(ply, setting)
	if (PlayerSettings.DoesSettingExist(setting) == false) then
		return nil;
	end

	local networkResult = "";
	if (PlayerSettings.Enums[setting].IsNetworked == true) then
		networkResult = ply:GetNWString(PlayerSettings.Enums[setting].Name, "NULL");
	end

	if (PlayerSettings.Enums[setting].IsNetworked == false || networkResult == "NULL") then
		PlayerSettings.Data.CheckPlayerRow(ply:SteamID());
		PlayerSettings.Data.CheckValue(ply:SteamID(), setting);
		return PlayerSettings.Data.GetValue(ply:SteamID(), setting);
	end

	return networkResult;
end

function PlayerSettings.SetSetting(ply, setting, newValue)
	if (PlayerSettings.DoesSettingExist(setting) == false) then
		return;
	end

	if (PlayerSettings.Enums[setting].IsNetworked == true) then
		ply:SetNWString(PlayerSettings.Enums[setting].Name, newValue);
	end

	PlayerSettings.Data.CheckPlayerRow(ply:SteamID());
	PlayerSettings.Data.SetValue(ply:SteamID(), setting, newValue);
	hook.Run("MizmoSettingChanged", ply, setting, newValue);
end

function PlayerSettings.PlayerMetaTable:SetSetting(setting, value)
	PlayerSettings.SetSetting(self, setting, value);
end

function PlayerSettings.PlayerMetaTable:GetSetting(setting)
	return PlayerSettings.GetSetting(self, setting);
end

function ulx.ChangePlayerSetting(callingPlayer, targetPlayer, setting, value)
	ulx.fancyLogAdmin(callingPlayer, "#A changed #T's setting #s to #s.", targetPlayer, setting, value);
	targetPlayer:SetSetting(setting, value);
end

local changePlayerSetting = ulx.command("User Management", "ulx changeplayersetting", ulx.ChangePlayerSetting, "!playersettingchange");
changePlayerSetting:defaultAccess(ULib.ACCESS_ADMIN);
changePlayerSetting:addParam{ type=ULib.cmds.PlayerArg };
changePlayerSetting:addParam{ type=ULib.cmds.StringArg };
changePlayerSetting:addParam{ type=ULib.cmds.StringArg };
changePlayerSetting:help("Changes a player setting");

function ulx.GetPlayerSetting(callingPlayer, targetPlayer, setting)
	ulx.fancyLogAdmin(callingPlayer, "#T's setting #s is #s (Called by #A)", targetPlayer, setting, targetPlayer:GetSetting(setting));
end

local getPlayerSetting = ulx.command("User Management", "ulx getplayersetting", ulx.GetPlayerSetting, "!playersetting");
getPlayerSetting:defaultAccess(ULib.ACCESS_ADMIN);
getPlayerSetting:addParam{ type=ULib.cmds.PlayerArg };
getPlayerSetting:addParam{ type=ULib.cmds.StringArg };
getPlayerSetting:help("Gets a player setting");