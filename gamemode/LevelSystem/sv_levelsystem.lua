local meta = FindMetaTable("Player");
Experience = {};

function Experience.GetCurrentExp(ply)
	local exp = ply:GetSetting(PlayerSettings.Enums.EXPERIENCE.Name)
	return exp;
end

function Experience.GetCurrentLevel(ply)
	local exp = tonumber(Experience.GetCurrentExp(ply))
	local level = math.floor((((exp)^(1/2))/5) + 1)
	return level;
end

function Experience.SetCurrentExp(ply, expToAdd)
	ply:SetSetting(PlayerSettings.Enums.EXPERIENCE.Name, ply:GetSetting(PlayerSettings.Enums.EXPERIENCE.Name) + expToAdd)
end

function meta:AddExp(expToAdd) 
	Experience.SetCurrentExp(self, expToAdd) 
end
