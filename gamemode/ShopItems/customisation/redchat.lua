ITEM.Name = 'Red Chat Colour'
ITEM.Price = 1000
ITEM.Text = "Chat Colour";
ITEM.TextColour = Color(209, 59, 46);
ITEM.Buyable = true;
ITEM.Desc = 'Ever wanted your chat colour to be bright red by default?'
ITEM.Grade = 'Restricted'
ITEM.Level = 10;
ITEM.Type = "ChatColour";

function ITEM:OnEquip(ply)
    ply:SetSetting(PlayerSettings.Enums.CHAT_COLOUR.Name, string.format("%s-%s-%s", self.TextColour.r, self.TextColour.g, self.TextColour.b));
end

function ITEM:OnHolster(ply)
    ply:SetSetting(PlayerSettings.Enums.CHAT_COLOUR.Name, "255-255-255");
end

function ITEM:CanPlayerEquip(ply)
    for name, Item in pairs(PS.Items) do
		if (Item.CategoryID == self.CategoryID) then
            if (Item.Type == self.Type) then
                if (ply:PS_HasItemEquipped(name) == true) then
                    return false;
                end
            end
		end
	end

    return true;
end