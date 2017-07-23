Util = Util or {};
Util.ChatColours = {};

Util.ChatColours["red"] = Color(204, 68, 44);
Util.ChatColours["green"] = Color(43, 204, 99);
Util.ChatColours["orange"] = Color(204, 126, 43);
Util.ChatColours["blue"] = Color(66, 134, 244);
Util.ChatColours["mizmogold"] = Color(223, 163, 0);
Util.ChatColours["gold"] = Util.ChatColours["mizmogold"];
Util.ChatColours["yellow"] = Color(244, 235, 66);
Util.ChatColours["pink"] = Color(244, 66, 167);

function Util.GetChatColour(ply)
	local colourString = ply:GetNWString(PlayerSettings.Enums.CHAT_COLOUR.Name);
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