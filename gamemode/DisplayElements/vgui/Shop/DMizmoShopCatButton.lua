local PANEL = {}

function PANEL:Init()
	self:SetSize(200, 100);
	self:DisableOutline();
	self:DisableTextOutline();
	self:SetColourHovered(Colours.GreyDark);

	self.Bar = vgui.Create("DPanel", self);
	self.Bar.Paint = function(self, w, h)
		if (self.IsClicked == true || self.Blah == true) then
			surface.SetDrawColor(Colours.Gold);
			surface.DrawRect(0, 0, w, h);
		end
	end

	self:InvalidateLayout();
end

function PANEL:InvalidateLayout()
	if (self.Bar ~= nil) then
		self.Bar:SetSize(self:GetWide(), 5);
		self.Bar:SetPos(0, self:GetTall() - 5);
	end
end

vgui.Register("DMizmoShopCatButton", PANEL, "DMizmoButton");