local PANEL = {};

function PANEL:Init()
	self.CategoryScroll = vgui.Create("DMizmoScroll", self);
	self.CategoryGrid = vgui.Create("DIconLayout", self.CategoryScroll);
	self.CategoryGrid:SetSpaceX(10);
	self.CategoryGrid:SetSpaceY(10);

	for _, ITEM in pairs(PS.Items) do
		--if (string.StartWith(_, "csgo_")) then
			self.Item = self.CategoryGrid:Add("DMizmoShopItem");
			self.Item:SetData(ITEM);
		--end
	end

	self:InvalidateLayout();
end

function PANEL:InvalidateLayout()
	if (self.CategoryScroll ~= nil) then
		self.CategoryScroll:Dock(FILL);
		self.CategoryScroll:DockMargin(5, 5, 5, 5);
	end

	if (self.CategoryGrid ~= nil) then
		self.CategoryGrid:Dock(FILL);
	end
end

function PANEL:Paint(w, h)
end

vgui.Register("DMizmoShopTab", PANEL);