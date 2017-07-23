ITEM.Name = 'Pink HUD'
ITEM.Price = 2000
ITEM.Text = "HUD";
ITEM.TextColour = Color(244, 66, 179);
ITEM.Buyable = true;
ITEM.Desc = 'Ever wanted a bright pink HUD?'
ITEM.Grade = 'Covert'
ITEM.Level = 15;
ITEM.Type = "HUD";

function ITEM:OnEquip(ply)
    ply:SetSetting(PlayerSettings.Enums.HUD_COLOUR.Name, string.format("%s-%s-%s", self.TextColour.r, self.TextColour.g, self.TextColour.b));
end

function ITEM:OnHolster(ply)
    ply:SetSetting(PlayerSettings.Enums.HUD_COLOUR.Name, string.format("%s-%s-%s", Colours.Gold.r, Colours.Gold.g, Colours.Gold.b));
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