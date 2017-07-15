local PANEL = {};

function PANEL:Init()
	self.Background = vgui.Create("DMizmoFrame");
	self.Background:SetText("The Mizmo-Gaming Shop");
	self.Background:ShouldShowCloseButton(true);
	self.Background:SetOnClose(function()
		PS:ToggleMenu();
	end);

	self.buttonContainer = vgui.Create("DPanel", self.Background.Container);
	self.buttonContainer.Paint = function(self, w, h)
	end

	self.shopButton = vgui.Create("DMizmoButton", self.buttonContainer);
	self.shopButton:SetText("Shop");
	self.shopButton:SetColour(Colours.Gold);
	self.shopButton.OnClicked = function()
		self.mainContentShop:Show();
		self.mainContentInventory:Hide();
		self.mainContentCrates:Hide();
	end

	/*self.crateButton = vgui.Create("DMizmoButton", self.buttonContainer);
	self.crateButton:SetText("Crates");
	self.crateButton:SetColour(Colours.Gold);
	self.crateButton.OnClicked = function()
		self.mainContentShop:Hide();
		self.mainContentInventory:Hide();
		self.mainContentCrates:Show();
	end*/

	self.inventorybutton = vgui.Create("DMizmoButton", self.buttonContainer);
	self.inventorybutton:SetText("Inventory");
	self.inventorybutton:SetColour(Colours.Gold);
	self.inventorybutton.OnClicked = function()
		self.mainContentShop:Hide();
		self.mainContentInventory:Show();
		self.mainContentCrates:Hide();
	end

	self.mainContent = vgui.Create("DPanel", self.Background.Container);
	self.mainContent.Paint = function(self, w, h)
	end

	self.mainContentShop = vgui.Create("DMizmoShopTab", self.mainContent);
	self.mainContentInventory = vgui.Create("DMizmoShopInventory", self.mainContent);
	self.mainContentCrates = vgui.Create("DMizmoShopTab", self.mainContent);
	self.mainContentShop:Show();
	self.mainContentInventory:Hide();
	self.mainContentCrates:Hide();

	self.Background:MakePopup();
	self:InvalidateLayout();
end

function PANEL:InvalidateLayout()		
	if (self.Background ~= nil) then
		self.Background:SetSize((ScrW() / 100) * 80, (ScrH() / 100) * 80);
		self.Background:InvalidateLayout();
	end

	if (self.buttonContainer ~= nil) then
		self.buttonContainer:SetSize(self.buttonContainer:GetParent():GetWide() - 10, 50);
		self.buttonContainer:SetPos(5, 0);
	end

	if (self.shopButton ~= nil) then
		self.shopButton:SetSize(self.shopButton:GetParent():GetWide() / 3, 0);
		self.shopButton:Dock(LEFT);
		self.shopButton:DockMargin(0, 0, 2, 0);
	end

	/*if (self.crateButton ~= nil) then
		self.crateButton:SetSize(self.crateButton:GetParent():GetWide() / 3, 0);
		self.crateButton:Dock(RIGHT);
		self.crateButton:DockMargin(2, 0, 2, 0);
	end*/

	if (self.inventorybutton ~= nil) then
		self.inventorybutton:SetSize(self.inventorybutton:GetParent():GetWide() / 3 , 0);
		self.inventorybutton:Dock(FILL);
		self.inventorybutton:DockMargin(2, 0, 2, 0);
	end

	if (self.mainContent ~= nil) then
		self.mainContent:SetPos(5, 55);
		self.mainContent:SetSize(self.mainContent:GetParent():GetWide() - 10, self.mainContent:GetParent():GetTall() - 65);
	end

	if (self.mainContentShop ~= nil) then
		self.mainContentShop:Dock(FILL);
	end

	if (self.mainContentInventory ~= nil) then
		self.mainContentInventory:Dock(FILL);
	end

	if (self.mainContentCrates ~= nil) then
		self.mainContentCrates:Dock(FILL);
	end
end

function PANEL:Show()
	self.Background:Show();
end

function PANEL:Hide()
	self.Background:Hide();
end

function PANEL:Remove()
	self.Background:Remove();
end

function PANEL:Paint(w, h)
end

vgui.Register("DMizmoShopFrame", PANEL);