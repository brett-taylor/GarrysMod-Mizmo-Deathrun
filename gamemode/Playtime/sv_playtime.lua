local meta = FindMetaTable("Player");
PlaytimeServer = {};

function PlaytimeServer.GetPlaytime(ply)
	return ply:GetNWString(PlayerSettings.Enums.PLAY_TIME.Name);
end

function PlaytimeServer.SetPlaytime(ply, value)
	ply:SetNWString(PlayerSettings.Enums.PLAY_TIME.Name, tostring(value));
end

function PlaytimeServer.GetPlaytimeHours(ply)
	local minutesPlayed = tonumber(PlaytimeServer.GetPlaytime(ply));
	return minutesPlayed / 60;
end

function meta:SetPlaytime(value)
	PlaytimeServer.SetPlaytime(self, value);
end

function meta:GetPlaytime()
	return PlaytimeServer.GetPlaytime(self);
end

function meta:GetPlaytimeHours()
	return PlaytimeServer.GetPlaytimeHours(self);
end

function PlaytimeServer.UpdatePlayers()
	for _, ply in ipairs(player.GetAll()) do
		if (ply and ply:IsConnected()) then
			ply:SetPlaytime(ply:GetPlaytime() + 1);
			ply:SetSetting(PlayerSettings.Enums.PLAY_TIME.Name, ply:GetPlaytime())
		end
	end
end
timer.Create("MizmoPlayTimeIncrement", 60, 0, PlaytimeServer.UpdatePlayers);