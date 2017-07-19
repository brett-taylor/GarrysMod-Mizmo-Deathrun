local PANEL = {};

function PANEL:Init()
	self.PickedCat = false;
	self.CatPicked = "";
	self.ButtonsMaxAlpha = 255;
	self.Timer = 1;
	self.IsInventory = false;

	self.ButtonContainer = vgui.Create("DPanel", self);
	self.ButtonContainer.Paint = function(self, w, h)
	end

	self.ButtonHolder = vgui.Create("DIconLayout", self.ButtonContainer)
	self.ButtonHolder:SetSpaceX(5);
	self.ButtonHolder:SetSpaceY(5);

	self:InvalidateLayout();
	self:DoCategories();
end

function PANEL:InvalidateLayout()
	self:Dock(FILL);

	if (self.ButtonContainer ~= nil) then
		self.ButtonContainer:SetSize(610, 405);
		self.ButtonContainer:SetPos(self:GetParent():GetWide() / 2 - self.ButtonContainer:GetWide() / 2, self:GetParent():GetTall() / 2 - self.ButtonContainer:GetTall() / 2);
	end

	if (self.ButtonHolder ~= nil) then
		self.ButtonHolder:Dock(FILL);
	end
end

function PANEL:DoCategories()
	self.ButtonHolder:Clear();

	for category_id, CATEGORY in pairs(PS.Categories) do
		local catButton = self.ButtonHolder:Add("DMizmoShopType");
 		catButton:SetInfo(self, category_id, CATEGORY.Name, CATEGORY.Colour, CATEGORY.Icon);
	end
end

function PANEL:Think()
	if (self.ButtonsMaxAlpha == 0) then
		self.Timer = self.Timer - FrameTime();
		if (self.Timer < 0) then
			if (self.IsInventory == true) then
				PS.ShopMenu.InventoryCatName = self.CatPicked;
				PS.ShopMenu:OpenInventoryTab(self.CatPicked);
			else
				PS.ShopMenu.ShopCatName = self.CatPicked;
				PS.ShopMenu:OpenShopTab(self.CatPicked);
			end
		end
	end	
end

function PANEL:DoInventory()
	self.IsInventory = true;
	self:InvalidateLayout();
	self:DoCategories();
end

vgui.Register("DMizmoShopTypePick", PANEL);