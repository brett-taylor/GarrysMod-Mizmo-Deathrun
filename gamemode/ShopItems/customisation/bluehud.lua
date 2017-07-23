ITEM.Name = 'Blue HUD'
ITEM.Price = 1000
ITEM.Text = "HUD";
ITEM.TextColour = Color(66, 185, 244);
ITEM.Buyable = true;
ITEM.Desc = 'Ever wanted a bright blue HUD?'
ITEM.Grade = 'Restricted'
ITEM.Level = 10;
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