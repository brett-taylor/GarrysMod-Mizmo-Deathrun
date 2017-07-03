PlayerSettings.PlayerMetaTable = FindMetaTable("Player");

function PlayerSettings.DoesConvarExist(convarName)
	if (PlayerSettings.Enums == nil) then
		return false;
	end

	if (PlayerSettings.Enums[convarName] == nil) then
		return false;
	else
		return true;
	end
end

function PlayerSettings.SetConvar(ply, setting, value)
	PlayerSettings.Data.SetValue(ply:SteamID(), setting, value);
end

function PlayerSettings.GetConvar(ply, setting)
	return PlayerSettings.Data.GetValue("test", setting);
end

function PlayerSettings.PlayerMetaTable:SetConvar(setting, value)
	PlayerSettings.SetConvar(self, setting, value);
end

function PlayerSettings.PlayerMetaTable:GetConvar(setting)
	PlayerSettings.GetConvar(self, setting);
end

print(player.GetAll()[1]:GetConvar("IS_DEBUGGING"));