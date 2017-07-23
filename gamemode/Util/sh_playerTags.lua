if (Util == nil) then
	Util = {};
end

function Util.PlayerHasTag(ply)
	return ply:GetNWString(PlayerSettings.Enums.TAG_NAME.Name) ~= "NIL";
end

function Util.GetTagColour(ply)
	local colourString = ply:GetNWString(PlayerSettings.Enums.TAG_COLOUR.Name);
	colourString = string.Split(colourString, "-");
	if (#colourString == 3) then
		if (isnumber(tonumber(colourString[1])) && isnumber(tonumber(colourString[2])) && isnumber(tonumber(colourString[3]))) then
			return Color(tonumber(colourString[1]), tonumber(colourString[2]), tonumber(colourString[3]));
		else
			return Color(255, 255, 255);
		end
	else
		return Color(255, 255, 255);
	end
end