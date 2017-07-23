ITEM.Name = 'Pink Chat Colour'
ITEM.Price = 2000
ITEM.Text = "Chat Colour";
ITEM.TextColour = Color(244, 66, 179);
ITEM.Buyable = true;
ITEM.Desc = 'Ever wanted your chat colour to be bright pink by default?'
ITEM.Grade = 'Covert'
ITEM.Level = 15;
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