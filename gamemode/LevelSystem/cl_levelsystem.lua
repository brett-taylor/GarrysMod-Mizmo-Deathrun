local meta = FindMetaTable("Player");
Experience = {};

function Experience.GetCurrentExp(ply)
	return ply:GetNWString(PlayerSettings.Enums.EXPERIENCE.Name)
end

function Experience.GetCurrentLevel(ply)
	local exp = ply:GetNWString(PlayerSettings.Enums.EXPERIENCE.Name)
	local level = math.floor((((exp)^(1/2))/5) + 1)
	return level;
end

function Experience.GetExpRequired(ply)
	local exp = ply:GetNWString(PlayerSettings.Enums.EXPERIENCE.Name)
	local level = math.floor((((exp)^(1/2))/5) + 1)
	local nextlevelexp = ((level * 5)^2)
	local exprequired = nextlevelexp - exp
	return exprequired
end

function meta:GetCurrentExp()
	return Experience.GetCurrentExp(self);
end

function meta:GetCurrentLevel()
	return Experience.GetCurrentLevel(self);
end

function meta:GetExpRequired()
	return Experience.GetExpRequired(self);
end
