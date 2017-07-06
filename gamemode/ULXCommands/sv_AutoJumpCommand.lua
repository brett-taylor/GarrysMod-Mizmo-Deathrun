/*function ulx.ToggleAutoJump(callingPlayer)
	local currentSetting = callingPlayer:GetSetting(PlayerSettings.Enums.AUTO_JUMP.Name);
	if (tonumber(currentSetting) >= 1) then
		callingPlayer:SetSetting(PlayerSettings.Enums.AUTO_JUMP.Name, 0);
	else
		callingPlayer:SetSetting(PlayerSettings.Enums.AUTO_JUMP.Name, 1);
	end
end

local toggleAJ = ulx.command("toggleautojump", "ulx toggleautojump", ulx.ToggleAutoJump, {"!autojump", "!autoj", "!auto"});
toggleAJ:defaultAccess(ULib.ACCESS_ALL);
toggleAJ:help("Toggles autojump on or off.");*/