if (Util == nil) then
	Util = {};
end

Util.ItemRarity = {};
Util.ItemRarity["Consumer"] = Colours.Items.Common;
Util.ItemRarity["Industrial"] = Colours.Items.Industrial;
Util.ItemRarity["Mil-spec"] = Colours.Items.MilSpec;
Util.ItemRarity["Restricted"] = Colours.Items.Restricted;
Util.ItemRarity["Classified"] = Colours.Items.Classified;
Util.ItemRarity["Covert"] = Colours.Items.Covert;
Util.ItemRarity["Exceedingly Rare"] = Colours.Items.ExceedinglyRare;

Util.ItemRarityNumbers = {};
Util.ItemRarityNumbers["Consumer"] = 1;
Util.ItemRarityNumbers["Industrial"] = 2;
Util.ItemRarityNumbers["Mil-spec"] = 3;
Util.ItemRarityNumbers["Classified"] = 4;
Util.ItemRarityNumbers["Restricted"] = 5;
Util.ItemRarityNumbers["Covert"] = 6;
Util.ItemRarityNumbers["Exceedingly Rare"] = 7;

function Util.GetItemColour(grade)
	local result = Util.ItemRarity[grade];
	
	if (result == nil) then
		result = Util.ItemRarity["Consumer"];
	end

	return result;
end

function Util.GetItemGradeInt(grade)
	local result = Util.ItemRarityNumbers[grade];
	
	if (result == nil) then
		result = Util.ItemRarityNumbers["Consumer"];
	end

	return result;
end