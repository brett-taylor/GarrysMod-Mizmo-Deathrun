function ulx.ToggleThirdPerson(callingPlayer)
	local currentSetting = callingPlayer:GetSetting(PlayerSettings.Enums.THIRD_PERSON.Name);
	print(currentSetting);
	if (tonumber(currentSetting) >= 1) then
		callingPlayer:SetSetting(PlayerSettings.Enums.THIRD_PERSON.Name, 0);
		callingPlayer:Notify("You are now in first person.", 5);
	else
		callingPlayer:SetSetting(PlayerSettings.Enums.THIRD_PERSON.Name, 1);
		callingPlayer:Notify("You are now in third person.", 5);
	end
end

local toggleTP = ulx.command("togglethirdperson", "ulx togglethirdperson", ulx.ToggleThirdPerson, {"!thirdperson", "!tp", "!thirdp",  "!thirdpersonview", "!third", "!firstperson", "!fp", "!firstp",  "!firstpersonview", "!first"});
toggleTP:defaultAccess(ULib.ACCESS_ALL);
toggleTP:help("Toggles your view point between third person and first person.");