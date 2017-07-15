local PANEL = {};

function PANEL:Init()
	self.TitlePanel = vgui.Create("DPanel", self);
	self.TitlePanel.Paint = function(self, w, h)
		surface.SetDrawColor(Colours.Gold);
		surface.DrawRect(0, 0, w, h - 15);

		surface.SetDrawColor(ColorAlpha(Colours.Grey, 255));
		surface.DrawRect(15, h - 15, w - 30, 15);

		local leftArrow =
		{
			{ x = 0, y = h - 15 },
			{ x = 15, y = h - 15 },
			{ x = 15, y = h }
		}
		surface.SetDrawColor(Colours.GoldDark);
		surface.DrawPoly(leftArrow);

		local rightArrow =
		{
			{ x = w, y = h - 15 },
			{ x = w - 15, y = h - 15 },
			{ x = w - 15, y = h }
		}
		surface.SetDrawColor(Colours.GoldDark);
		surface.DrawPoly(rightArrow);
	end

	self.Container = vgui.Create("DPanel", self);
	self.Container.Paint = function(self, w, h)		
		surface.SetDrawColor(Colours.Grey);
		surface.DrawRect(0, 0, w, h);
	end

	self.Title = vgui.Create("DLabel", self.TitlePanel);
	self.Title:SetFont("MizmoGaming-Pointshop-Title");
	self.Title:SetColor(Colours.Grey);

	self.ShowTheCloseButton = false;

	self:MakePopup();
end

function PANEL:InvalidateLayout()
	self:Center();

	if (self.TitlePanel ~= nil) then
		self.TitlePanel:SetSize(self.TitlePanel:GetParent():GetWide(), 55);
		self.TitlePanel:SetPos(0, 0);
	end

	if (self.Container ~= nil) then
		self.Container:SetSize(self.TitlePanel:GetParent():GetWide() - 30, self.TitlePanel:GetParent():GetTall() - 55);
		self.Container:SetPos(15, 55);
	end

	if (self.Title ~= nil) then
		self.Title:SetContentAlignment(8);
		self.Title:Dock(FILL);
		self.Title:DockMargin(0, 5, 0, 5);
	end

	if (self.ShowTheCloseButton == true && self.CloseButton == nil) then
		self:CreateCloseButton();
	end

	if (self.ShowTheCloseButton == false && self.CloseButton ~= nil) then
		self.CloseButton:Remove();
	end

	if (self.CloseButton ~= nil) then
		self.CloseButton:SetSize(25, 25);
		self.CloseButton:SetPos(self.CloseButton:GetParent():GetWide() - 40, 7);
	end
end

function PANEL:SetOnClose(f)
	self.OnCloseFunction = f;
end

function PANEL:SetText(text)
	if (self.Title ~= nil) then
		self.Title:SetText(text);
	end
end

function PANEL:CreateCloseButton()
	self.CloseButton = vgui.Create("DMizmoButton", self.TitlePanel);
	self.CloseButton:SetText("X");
	self.CloseButton:SetTextSmall();

	self.CloseButton.OnClicked = function()
		if (self.OnCloseFunction ~= nil) then
			self.OnCloseFunction();
		end
	end
end

function PANEL:ShouldShowCloseButton(b)
	self.ShowTheCloseButton = b;
end

vgui.Register("DMizmoFrame", PANEL)
