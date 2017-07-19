local PANEL = {};

function PANEL:Init()
	surface.PlaySound("UI/buttonclick.wav");
	self.TotalTime = 10;
	self.Timer = self.TotalTime;
	self:SetTextColor(Colours.Grey);
	self:SetFont("MizmoGaming-Shop-ItemIcon-Text");

	self:InvalidateLayout();
end

function PANEL:InvalidateLayout()
	self:Dock(FILL);
end

function PANEL:Paint(w, h)
	surface.SetDrawColor(Colours.GreyDark);
	surface.DrawRect(0, 0, w, h);

	surface.SetDrawColor(Colours.GoldDark);
	surface.DrawRect(2, 2, w - 4, h - 4);

	surface.SetDrawColor(Colours.Gold);
	surface.DrawRect(2, 2, ((self.Timer / self.TotalTime) * w), h - 4);
end

function PANEL:DoClick()
	self:Remove();
	PS.ShopMenu.Alert = nil;
end

function PANEL:Think()
	self.Timer = self.Timer - FrameTime();

	if (self.Timer < 0) then
		self:Remove();
		PS.ShopMenu.Alert = nil;
	end
end

vgui.Register("DMizmoShopAlert", PANEL, "DButton");