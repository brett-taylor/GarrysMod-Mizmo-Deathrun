local meta = FindMetaTable("Player");
PlaytimeClient = {};

function PlaytimeClient.GetPlaytime(ply)
	return ply:GetNWInt(PlayerSettings.Enums.PLAY_TIME.Name);
end

function PlaytimeClient.GetPlaytimeHours(ply)
	return math.floor((ply:GetNWInt(PlayerSettings.Enums.PLAY_TIME.Name) / 60));
end

function meta:GetPlaytime()
	return PlaytimeClient.GetPlaytime(self);
end

function meta:GetPlaytimeHours()
	return PlaytimeClient.GetPlaytimeHours(self);
end