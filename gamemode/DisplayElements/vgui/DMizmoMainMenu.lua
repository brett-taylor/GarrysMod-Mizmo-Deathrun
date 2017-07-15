local PANEL = {}

function PANEL:Init()
	self.Background = vgui.Create("DMizmoFrame");
	self.Background:SetText("Menu");
	self.Background:ShouldShowCloseButton(true);
	self.Background:SetOnClose(function()
		self:Remove(); 
		EscapeMenu.Panel = nil;
	end);

	self.ButtonPanel = vgui.Create("DPanel", self.Background.Container);
	self.ButtonPanel.Paint = function(self, w, h)
	end

	self.ButtonGrid = vgui.Create("DIconLayout", self.ButtonPanel);
	self.ButtonGrid:SetSpaceY(5);
	for i = 1, 2 do 
		local ListItem = self.ButtonGrid:Add("DMizmoButton");
		ListItem:SetSize(255, 40);
	end

	self:InvalidateLayout();
end

function PANEL:InvalidateLayout()
	if (self.Background ~= nil) then
		self.Background:SetSize(300, 170);
		self.Background:Center();
		self.Background:InvalidateLayout();
	end

	if (self.ButtonPanel ~= nil) then
		self.ButtonPanel:SetSize(self.ButtonPanel:GetParent():GetWide() - 10, self.ButtonPanel:GetParent():GetTall() - 5);
		self.ButtonPanel:SetPos(5, 0);
	end

	if (self.ButtonGrid ~= nil) then
		self.ButtonGrid:Dock(FILL);
	end
end

function PANEL:Remove()
	self.Background:Remove();
end

vgui.Register("DMizmoMainMenu", PANEL);