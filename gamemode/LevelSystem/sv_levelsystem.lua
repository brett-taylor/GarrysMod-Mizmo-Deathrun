local meta = FindMetaTable("Player");
Experience = {};

function Experience.GetCurrentExp(ply)
	return (ply:GetSetting(PlayerSettings.Enums.EXPERIENCE.Name) or 1);
end

function Experience.GetCurrentLevel(ply)
	local exp = tonumber(Experience.GetCurrentExp(ply));
	local level = math.floor((((exp)^(1/2))/5) + 1);
	return level;
end

function Experience.AddExp(ply, expToAdd)
	ply:SetSetting(PlayerSettings.Enums.EXPERIENCE.Name, ply:GetSetting(PlayerSettings.Enums.EXPERIENCE.Name) + expToAdd);
end

function Experience.SetExp(ply, expToSetTo)
	ply:SetSetting(PlayerSettings.Enums.EXPERIENCE.Name, expToSetTo);
end

function Experience.RemoveExp(ply, expToAdd)
	ply:SetSetting(PlayerSettings.Enums.EXPERIENCE.Name, ply:GetSetting(PlayerSettings.Enums.EXPERIENCE.Name) - expToAdd);
	if (ply:GetExp() < 1) then
		ply:SetExp(1);
	end
end

function meta:AddExp(expToAdd) 
	Experience.AddExp(self, expToAdd);
end

function meta:SetExp(expToSetTo) 
	Experience.SetExp(self, expToSetTo);
end

function meta:RemoveExp(exptoRemove) 
	Experience.RemoveExp(self, exptoRemove);
end

function meta:GetExp() 
	return Experience.GetCurrentExp(self);
end

