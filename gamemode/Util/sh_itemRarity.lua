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

function Util.GetItemColour(grade)
	local result = Util.ItemRarity[grade];
	
	if (result == nil) then
		result = Util.ItemRarity["Consumer"];
	end

	return result;
end