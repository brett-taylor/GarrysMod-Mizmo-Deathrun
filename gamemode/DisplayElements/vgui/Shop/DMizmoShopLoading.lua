 local PANEL = {};

function PANEL:Init()
	self.Stage = 1;
	self.Items = {};
	self.Current = 0;
	self.TotalItems = 0;

	for v, k in pairs(PS.Items) do
		table.insert(self.Items, v);
	end

	self.TotalItems = table.Count(PS.Items);

	self:Dock(FILL);
end

function PANEL:Paint(w, h)
	if (self.Stage == 2) then
		draw.SimpleText("Done Loading!", "MizmoGaming-Pointshop-Title", w / 2, h / 2 - 20, Colours.White, TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM);
		draw.SimpleText("Enjoy the www.Mizmo-Gaming.co.uk shop!", "MizmoGaming-Button-Small", w / 2, h / 2 - 15, Colours.White, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP);
	else
		draw.SimpleText("Loading The Mizmo Shop", "MizmoGaming-Pointshop-Title", w / 2, h / 2 - 120, Colours.White, TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM);
		draw.SimpleText("Loaded "..self.Current.." out of "..table.Count(PS.Items).. " items.", "MizmoGaming-Button-Small", w / 2, h / 2 - 115, Colours.White, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP);

		surface.SetDrawColor(Colours.GreyDark);
		surface.DrawRect(10, h / 2 - 90, self:GetWide() - 20, 30);

		surface.SetDrawColor(Colours.GoldDark);
		surface.DrawRect(12, h / 2 - 88, self:GetWide() - 24, 26);

		surface.SetDrawColor(Colours.Gold);
		surface.DrawRect(12, h / 2 - 88, (self.Current / table.Count(PS.Items)) * (self:GetWide() - 24), 26);
		
		draw.SimpleText("Loading "..PS.Items[self.Items[self.Current]].Name..".", "MizmoGaming-Button-Small", w / 2, h / 2 - 83, Colours.White, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP);
	end
end

function PANEL:Think()
	if (self.Current + 1 > #self.Items && self.Stage == 1) then
		self.Stage = 2;
		timer.Simple(1, function()
			if (PS.ShopMenu ~= nil) then
				PS.ShopMenu:OpenShopCatTab();
			end
		end)
		return;
	elseif (self.Stage == 1) then
		self.Current = self.Current + 1;
		local item = vgui.Create("DMizmoItem", self);
		item:SetPos(self:GetWide() / 2 - item:GetWide() / 2, self:GetTall() / 2 + 50);
		item:SetData(PS.Items[self.Items[self.Current]]);
		item:Remove();
	end
end

function PANEL:InvalidateLayout()
	self:Dock(FILL);
end	

vgui.Register("DMizmoShopLoading", PANEL, "DPanel");