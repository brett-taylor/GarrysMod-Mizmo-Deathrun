local PANEL = {};

function PANEL:Init()
	self.titlePanel = vgui.Create("DPanel", self);
	self.titlePanel.Paint = function(self, w, h)
		surface.SetDrawColor(Colours.Gold);
		surface.DrawRect(0, 0, w, h - 15);

		surface.SetDrawColor(Colours.Grey);
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

	self.container = vgui.Create("DPanel", self);
	self.container.Paint = function(self, w, h)
		surface.SetDrawColor(Colours.Grey);
		surface.DrawRect(0, 0, w, h);
	end

	self.title = vgui.Create("DLabel", self.titlePanel);
	self.title:SetText("The Mizmo-Gaming Shop");
	self.title:SetFont("MizmoGaming-Pointshop-Title");
	self.title:SetColor(Colours.Grey);

	self.closeButton = vgui.Create("DButton", self.titlePanel);
	self.closeButton:SetText("X");
	self.closeButton:SetTextColor(Colours.Grey);
	self.closeButton.Paint = function(self, w, h)
		surface.SetDrawColor(Colours.Grey);
		surface.DrawRect(0, 0, w, h);

		surface.SetDrawColor(Colours.Gold);
		surface.DrawRect(2, 2, w - 4, h - 4);
	end
	self.closeButton.DoClick = function()
		PS:ToggleMenu();
	end

	self.buttonContainer = vgui.Create("DPanel", self.container);
	self.buttonContainer.Paint = function(self, w, h)
	end

	self.shopButton = self:AddButton(self.buttonContainer);
	self.shopButton:SetText("Shop");

	self.crateButton = self:AddButton(self.buttonContainer);
	self.crateButton:SetText("Crates");

	self.inventorybutton = self:AddButton(self.buttonContainer);
	self.inventorybutton:SetText("Inventory");

	self.mainContent = vgui.Create("DPanel", self.container);
	self.mainContent.Paint = function(self, w, h)
	end

	self.mainContentShop = vgui.Create("DPointShopTab", self.mainContent);
	self.mainContentInventory = vgui.Create("DPointShopTab", self.mainContent);
	self.mainContentCrates = vgui.Create("DPointShopTab", self.mainContent);
	self.mainContentShop:Show();
	self.mainContentInventory:Hide();
	self.mainContentCrates:Hide();

	self.shopButton.DoClick = function()
		if (self.mainContentShop ~= nil) then
			self.mainContentShop:Show();
		end 

		if (self.mainContentInventory ~= nil) then
			self.mainContentInventory:Hide();
		end 
		
		if (self.mainContentCrates ~= nil) then
			self.mainContentCrates:Hide();
		end 
	end

	self.crateButton.DoClick = function()
		if (self.mainContentShop ~= nil) then
			self.mainContentShop:Hide();
		end 

		if (self.mainContentInventory ~= nil) then
			self.mainContentInventory:Hide();
		end 
		
		if (self.mainContentCrates ~= nil) then
			self.mainContentCrates:Show();
		end 
	end

	self.inventorybutton.DoClick = function()
		if (self.mainContentShop ~= nil) then
			self.mainContentShop:Hide();
		end 

		if (self.mainContentInventory ~= nil) then
			self.mainContentInventory:Show();
		end 
		
		if (self.mainContentCrates ~= nil) then
			self.mainContentCrates:Hide();
		end 
	end

	self:InvalidateLayout();
end

function PANEL:InvalidateLayout()
	self:SetSize((ScrW() / 100) * 80, (ScrH() / 100) * 80);
	self:Center();

	if (self.titlePanel ~= nil) then
		self.titlePanel:SetSize(self.titlePanel:GetParent():GetWide(), 55);
		self.titlePanel:SetPos(0, 0);
	end

	if (self.container ~= nil) then
		self.container:SetSize(self.titlePanel:GetParent():GetWide() - 30, self.titlePanel:GetParent():GetTall() - 55);
		self.container:SetPos(15, 55);
	end

	if (self.title ~= nil) then
		self.title:SetContentAlignment(8);
		self.title:Dock(FILL);
		self.title:DockMargin(0, 5, 0, 5);
	end

	if (self.closeButton ~= nil) then
		self.closeButton:SetSize(25, 25);
		self.closeButton:SetPos(self.closeButton:GetParent():GetWide() - 40, 7);
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

	if (self.crateButton ~= nil) then
		self.crateButton:SetSize(self.crateButton:GetParent():GetWide() / 3, 0);
		self.crateButton:Dock(RIGHT);
		self.crateButton:DockMargin(2, 0, 2, 0);
	end

	if (self.inventorybutton ~= nil) then
		self.inventorybutton:SetSize(self.crateButton:GetParent():GetWide() / 3 , 0);
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

function PANEL:Paint(w, h)
end

function PANEL:AddButton(parent)
	local button = vgui.Create("DButton", parent);
 	button:SetText("test");
 	button:SetFont("MizmoGaming-Pointshop-BigButton");
 	button:SetTextColor(Colours.WhiteText);
 	button.Paint = function(self, w, h)
		surface.SetDrawColor(ColorAlpha(Colours.Gold, 255));
		surface.DrawRect(0, 0, w, h);
	end

 	return button;
end

vgui.Register('DPointShopMenu', PANEL)