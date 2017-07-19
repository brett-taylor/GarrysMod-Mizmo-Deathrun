local PANEL = {};

function PANEL:Init()
	self.SortingType = "name";
	self.ShopCatName = "";
	self.InventoryCatName = "";
	self.LastCloseAttempt = CurTime() + 0.2;
	self.ClosedPressed = true;
	self.LastItemDataOpened = nil;
	self.Alerts = {
		"Welcome To The www.Mizmo-Gaming.co.uk Store. Click me to make me disappear!"
	}

	self:SetSize(ScrW(), ScrH());
	self:Center();

	self.Background = vgui.Create("DPanel", self);
	self.Background.Paint = function(self, w, h)
		surface.SetDrawColor(0, 0, 0, 150);
		surface.DrawRect(0, 0, w, h);

		surface.SetDrawColor(ColorAlpha(Colours.Grey, 255));
		surface.DrawRect(0, 0, w, 100);

		Util.DrawRotatedText("WIP!!!", 50, 20, Colours.White, "MizmoGaming-Button-Medium", -25);
	end

	self.Header = vgui.Create("DIconLayout", self.Background);
	self.Header.Paint = function(self, w, h)
	end

	self.CloseButton = vgui.Create("DMizmoButton", self.Background);
	self.CloseButton:SetTextSmall();
	self.CloseButton:SetText("Close");
	self.CloseButton:DisableOutline();
	self.CloseButton:DisableTextOutline();
	self.CloseButton.OnClicked = function()
		PS:ToggleMenu();
	end

	self.InfoHeader = vgui.Create("DMizmoShopHeaderInfo", self.Header);
	self.InfoHeader.Paint = function(self, w, h)
	end

	self.AlertPanel = vgui.Create("DPanel", self.Background);
	self.AlertPanel.Paint = function(self, w, h)
	end

	self.MainContentHolder = vgui.Create("DPanel", self.Background)
	self.MainContentHolder.Paint = function(self, w, h)
	end

	self.Shop = vgui.Create("DMizmoShopCatButton", self.Header);
	self.Shop:SetText("Shop");
	self.Shop.OnClicked = function()
		self:OpenShop();
		self:ResetCatButtons("shop");
	end
	
	self.Inventory = vgui.Create("DMizmoShopCatButton", self.Header);
	self.Inventory:SetText("Inventory");
	self.Inventory.OnClicked = function()
		self:OpenInventory();
		self:ResetCatButtons("inventory");
	end

	self.Crates = vgui.Create("DMizmoShopCatButton", self.Header);
	self.Crates:SetText("Crates");
	self.Crates.OnClicked = function()
		self:OpenCrates();
		self:ResetCatButtons("crates");
	end

	self.ModelBackground = vgui.Create("DPanel", self.MainContentHolder);
	self.ModelBackground.Paint = function(self, w, h)
		surface.SetDrawColor(Colours.Grey);
		surface.DrawRect(0, 0, w, h);
	end

	self.AdminButton = vgui.Create("DMizmoButton", self.ModelBackground);
	self.AdminButton:SetText("Administration");
	self.AdminButton:SetTextSmall()
	self.AdminButton:DisableTextOutline()
	self.AdminButton:SetOutlineColour(Colours.GreyDark);
	self.AdminButton:SetOutlineColouredHovered(Colours.Gold);
	self.AdminButton:SetColour(Colours.GreyDark);
	self.AdminButton:SetColourHovered(Colours.GreyDark);

	self.ModelViewer = vgui.Create("DMizmoShopModelViewer", self.ModelBackground);	

	self.MainTab = vgui.Create("DPanel", self.MainContentHolder);
	self.MainTab.Paint = function(self, w, h)
		surface.SetDrawColor(Colours.Grey);
		surface.DrawRect(0, 0, w, h);
	end

	self:InvalidateLayout();
	--self:OpenInventoryTab("trails");
	--self:OpenShopTab("playermodels");
	self:OpenLoadingTab();
	--self:OpenShop();
	self:MakePopup();
end

function PANEL:InvalidateLayout()
	self:RequestFocus();

	if (self.Background ~= nil) then
		self.Background:SetSize(ScrW(), ScrH());
		self.Background:Center();
	end

	if (self.Header ~= nil) then
		self.Header:SetSize(900, 100);
		self.Header:CenterHorizontal();
	end

	if (self.CloseButton ~= nil) then
		self.CloseButton:SetSize(70, 30);
		self.CloseButton:SetPos(self.Background:GetWide() - 90, self.Header:GetTall() - 30);
	end

	if (self.InfoHeader ~= nil) then
		self.InfoHeader:SetSize(300, 100);
	end

	if (self.AlertPanel ~= nil) then
		self.AlertPanel:SetSize(self.Background:GetWide(), 30);
		self.AlertPanel:SetPos(0, self.Header:GetTall());
	end

	if (self.MainContentHolder ~= nil) then
		self.MainContentHolder:SetSize(400 + (math.floor((ScrW() - 500) / 160) * 160 + 20), ScrH() - 130);
		self.MainContentHolder:SetPos((ScrW() / 2) - (self.MainContentHolder:GetWide() / 2), 130);
	end

	if (self.ModelBackground ~= nil) then
		self.ModelBackground:SetSize(400, ScrH() - 250);
		self.ModelBackground:SetPos(self.MainContentHolder:GetWide() - 400, 50);
	end

	if (self.AdminButton ~= nil) then
		self.AdminButton:SetSize(20, 30);
		self.AdminButton:Dock(BOTTOM);
		self.AdminButton:DockMargin(5, 5, 5, 5);
	end

	if (self.ModelViewer ~= nil) then
		self.ModelViewer:Dock(FILL);
	end

	if (self.MainTab ~= nil) then
		self.MainTab:SetSize(math.floor((ScrW() - 500) / 160) * 160 + 20, ScrH() - 250);		
		self.MainTab:SetPos(0, 50);
	end
end

function PANEL:Paint(w, h)
end

function PANEL:Think()
	if (input.IsKeyDown(KEY_F3) == false) then
		self.ClosedPressed = false;
	end
	
	if (input.IsKeyDown(KEY_F3) && self.ClosedPressed == false) then
		if (self.LastCloseAttempt == nil || CurTime() > self.LastCloseAttempt) then
			self:RequestFocus();
			self.LastCloseAttempt = CurTime() + 0.1;
			self.ClosedPressed = true;
			PS:ToggleMenu();
		end
	end

	if (#self.Alerts > 0 && self.Alert == nil) then
		self.Alert = vgui.Create("DMizmoShopAlert", self.AlertPanel);
		self.Alert:SetText(self.Alerts[1]);
		table.remove(self.Alerts, 1);
	end
end

function PANEL:Show()
	self:SetVisible(true);
	self.Background:SetVisible(true);
	self.isVisible = true;
	self.LastCloseAttempt = CurTime() + 0.1;
end

function PANEL:Hide()
	self:SetVisible(false);
	self.Background:SetVisible(false);
	self.isVisible = false;
	self.LastCloseAttempt = CurTime() + 0.1;
end

function PANEL:ResetCatButtons(but)
	self.Shop:SetColour(Colours.Grey);
	self.Shop:SetColourHovered(Colours.GreyDark);
		
	self.Inventory:SetColour(Colours.Grey);
	self.Inventory:SetColourHovered(Colours.GreyDark);

	self.Crates:SetColour(Colours.Grey);
	self.Crates:SetColourHovered(Colours.GreyDark);

	if (but == "crates") then
		self.Crates:SetColour(Colours.GreyDark);
		self.Crates:SetColourHovered(Colours.Gold);
	elseif (but == "inventory") then
		self.Inventory:SetColour(Colours.GreyDark);
		self.Inventory:SetColourHovered(Colours.Gold);
	else
		self.Shop:SetColour(Colours.GreyDark);
		self.Shop:SetColourHovered(Colours.Gold);
	end
end

function PANEL:ClearMainTab()
	if (IsValid(self.Loading)) then
		self.Loading:Remove();
	end

	if (IsValid(self.ShopCatTab)) then
		self.ShopCatTab:Remove();
	end

	if (IsValid(self.ShopTab)) then
		self.ShopTab:Remove();
	end

	if (IsValid(self.InventoryCatTab)) then
		self.InventoryCatTab:Remove();
	end

	if (IsValid(self.InventoryTab)) then
		self.InventoryTab:Remove();
	end
end

function PANEL:OpenLoadingTab()
	self:ClearMainTab();
	self.Loading = vgui.Create("DMizmoShopLoading", self.MainTab);
end

function PANEL:OpenShop()
	self:ClearMainTab();
	if (self.ShopCatName ~= "") then
		self:OpenShopTab(self.ShopCatName);
		return;
	end
	self:OpenShopCatTab();
	self:ResetCatButtons("shop");
end

function PANEL:OpenInventory()
	self:ClearMainTab();
	if (self.InventoryCatName ~= "") then
		self:OpenInventoryTab(self.InventoryCatName);
		return;
	end
	self:OpenInventoryCatTab();
	self:ResetCatButtons("inventory");
end

function PANEL:OpenCrates()
	self:ClearMainTab();
	self:ResetCatButtons("crates");
end

function PANEL:OpenShopCatTab()
	self:ClearMainTab();
	self.ShopCatTab = vgui.Create("DMizmoShopTypePick", self.MainTab);
	self:ResetCatButtons("shop");
end

function PANEL:OpenShopTab(category)
	self:ClearMainTab();
	self.ShopTab = vgui.Create("DMizmoShopTab", self.MainTab);
	self.ShopTab:SetCategory(category, self, false);
	self:ResetCatButtons("shop");
end

function PANEL:OpenInventoryCatTab()
	self:ClearMainTab();
	self.InventoryCatTab = vgui.Create("DMizmoShopTypePick", self.MainTab);
	self.InventoryCatTab:DoInventory();
	self:ResetCatButtons("inventory");
end

function PANEL:OpenInventoryTab(category)	
	self:ClearMainTab();
	self.InventoryTab = vgui.Create("DMizmoShopTab", self.MainTab);
	self.InventoryTab:SetCategory(category, self, true);
	self:ResetCatButtons("inventory");
end

vgui.Register("DMizmoShopFrame", PANEL, "DFrame");