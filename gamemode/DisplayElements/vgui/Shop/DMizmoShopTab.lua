local PANEL = {}

function PANEL:SetCategory(category, frame, inventory)
	if (PS.Categories[category] == nil) then
		return;
	end

	self.Frame = frame;
	self.Category = PS.Categories[category];
	self.ButtonsMaxAlpha = 255;
	self.PanelAlpha = 255;
	self.Back = false;
	self.FoundItems = false;
	self.IsInventory = inventory;

	self.CatIcon = vgui.Create("DMizmoShopType", self);
	self.CatIcon:SetInfo(self, self.Category.category_id, self.Category.Name, self.Category.Colour, self.Category.Icon);
	self.CatIcon:IsShopTab();

	self.Title = vgui.Create("DLabel", self)
	self.Title:SetText(self.Category.Name);
	self.Title:SetTextColor(self.Category.Colour);
	self.Title:SetFont("MizmoGaming-Button-Large");

	self.Scroll = vgui.Create("DMizmoScroll", self);
	self.Scroll:SetColour(self.Category.Colour);

	self.CategoryLayout = vgui.Create("DIconLayout", self.Scroll);
	self.CategoryLayout:SetSpaceX(5);
	self.CategoryLayout:SetSpaceY(5);

	self.Search = vgui.Create("DMizmoTextEntry", self)
	self.Search:SetColour(self.Category.Colour);
	self.Search.OnUpdate = function()
		self:DoItems();
	end
	
	self.SearchButtonContainer = vgui.Create("DPanel", self);
	self.SearchButtonContainer.Paint = function(self, w, h)
	end

	self.NameSearch = vgui.Create("DMizmoButton", self.SearchButtonContainer);
	self.NameSearch:SetText("Name");
	self.NameSearch:SetTextSmall();
	self.NameSearch:DisableTextOutline();
	self.NameSearch:SetColourHovered(Colours.Grey);
	self.NameSearch.OnClicked = function()
		self:ResetSortingButtons("");
	end

	self.PriceSearch = vgui.Create("DMizmoButton", self.SearchButtonContainer);
	self.PriceSearch:SetText("Price");
	self.PriceSearch:SetTextSmall();
	self.PriceSearch:DisableTextOutline();
	self.PriceSearch:SetColourHovered(Colours.Grey);
	self.PriceSearch.OnClicked = function()
		self:ResetSortingButtons("price");
	end

	self.LevelSearch = vgui.Create("DMizmoButton", self.SearchButtonContainer);
	self.LevelSearch:SetText("Level");
	self.LevelSearch:SetTextSmall();
	self.LevelSearch:DisableTextOutline();
	self.LevelSearch:SetColourHovered(Colours.Grey);
	self.LevelSearch.OnClicked = function()
		self:ResetSortingButtons("level");
	end

	self.RaritySearch = vgui.Create("DMizmoButton", self.SearchButtonContainer);
	self.RaritySearch:SetText("Rarity");
	self.RaritySearch:SetTextSmall();
	self.RaritySearch:DisableTextOutline();
	self.RaritySearch:SetColourHovered(Colours.Grey);
	self.RaritySearch.OnClicked = function()
		self:ResetSortingButtons("rarity");
	end

	self:ResetSortingButtons(self.Frame.SortingType);
	self:InvalidateLayout()
end

function PANEL:DoItems()
	self.CategoryLayout:Clear();
	local Items = {};

	for _, Item in pairs(PS.Items) do
		if (Item.Category == self.Category.Name) then
			if ((self.IsInventory == true && LocalPlayer():PS_HasItem(Item.ID)) || (self.IsInventory == false && !LocalPlayer():PS_HasItem(Item.ID))) then
				if (string.find(string.lower(Item.Name), string.lower(self.Search:GetValue()))) then
					table.insert(Items, Item);
				end
			end
		end
	end

	if (self.Frame.SortingType == "rarity") then
		table.sort(Items, function(a, b) 
			return (Util.GetItemGradeInt(a.Grade) < Util.GetItemGradeInt(b.Grade));
		end)
	elseif (self.Frame.SortingType == "level") then
		table.sort(Items, function(a, b) 
			return (a.Level < b.Level);
		end)

	elseif (self.Frame.SortingType == "price") then
		table.sort(Items, function(a, b) 
			return (a.Price < b.Price);
		end)

	else // Name
		table.sort(Items, function(a, b) 
			return (a.Name < b.Name);
		end)
	end

	for v, Item in pairs(Items) do
		local itemButton = vgui.Create("DMizmoItem");
		itemButton:SetData(Item);
		itemButton:SetInventory(self.IsInventory);
		self.CategoryLayout:Add(itemButton);
	end 

	self.Scroll:InvalidateLayout();

	if ((#self.CategoryLayout:GetChildren() or 0 ) > 0) then
		self.FoundItems = true;
	else
		self.FoundItems = false;
	end
end

function PANEL:InvalidateLayout()
	self:Dock(FILL);

	if (self.CatIcon ~= nil) then
		self.CatIcon:SetSize(64, 64);
		self.CatIcon:SetPos(5, 5);
	end

	if (self.Title ~= nil) then
		self.Title:SizeToContents();
		self.Title:SetPos(80, 12);
	end

	if (self.Scroll ~= nil) then
		self.Scroll:SetSize(self:GetParent():GetWide() - 10, self:GetParent():GetTall() - 85);
		self.Scroll:SetPos(5, 85);
	end

	if (self.CategoryLayout ~= nil) then
		self.CategoryLayout:Dock(FILL);
	end

	if (self.Search ~= nil) then
		self.Search:SetSize(315, 30);
		self.Search:SetPos(self:GetParent():GetWide() - 320, 40);
	end

	if (self.SearchButtonContainer ~= nil) then
		self.SearchButtonContainer:SetSize(315, 30);
		self.SearchButtonContainer:SetPos(self:GetParent():GetWide() - 320, 5);
	end

	if (self.NameSearch ~= nil) then
		self.NameSearch:SetSize(75, 30);
		self.NameSearch:SetPos(0, 0);
	end

	if (self.PriceSearch ~= nil) then
		self.PriceSearch:SetSize(75, 30);
		self.PriceSearch:SetPos(80, 0);
	end

	if (self.LevelSearch ~= nil) then
		self.LevelSearch:SetSize(75, 30);
		self.LevelSearch:SetPos(160, 0);
	end

	if (self.RaritySearch ~= nil) then
		self.RaritySearch:SetSize(75, 30);
		self.RaritySearch:SetPos(240, 0);
	end
end

function PANEL:Paint(w, h)
	self.CurrentAlpha = self.CurrentAlpha or self.PanelAlpha;
	self.CurrentAlpha = Lerp(FrameTime() * 5, self.CurrentAlpha, self.PanelAlpha);

	surface.SetDrawColor(self.Category.Colour, self.CurrentAlpha);
	surface.DrawRect(4, 75, w - 8, 2);

	if (self.FoundItems == false) then
		draw.SimpleText("Uh Oh!", "MizmoGaming-Button-Large", w / 2, h / 2, Colours.White, TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM);
		draw.SimpleText("There Appears To Be No Items Here.", "MizmoGaming-Button-Medium", w / 2, h / 2, Colours.White, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP);
	end
end

function PANEL:Clicked()
	self.PanelAlpha = 0;
	self.Back = true;
	if (self.IsInventory == true) then
		PS.ShopMenu.InventoryCatName = "";
		PS.ShopMenu:OpenInventoryCatTab();
	else
		PS.ShopMenu.ShopCatName = "";
		PS.ShopMenu:OpenShopCatTab();
	end
end

function PANEL:Show()
	self:SetVisible(true);
	self.isVisible = true;
end

function PANEL:Hide()
	self:SetVisible(false);
	self.isVisible = false;
end

function PANEL:ResetSortingButtons(sorting)
	self.NameSearch:SetOutlineColour(self.Category.Colour);
	self.NameSearch:SetOutlineColouredHovered(Colours.Gold);

	self.PriceSearch:SetOutlineColour(self.Category.Colour);
	self.PriceSearch:SetOutlineColouredHovered(Colours.Gold);

	self.LevelSearch:SetOutlineColour(self.Category.Colour);
	self.LevelSearch:SetOutlineColouredHovered(Colours.Gold);

	self.RaritySearch:SetOutlineColour(self.Category.Colour);
	self.RaritySearch:SetOutlineColouredHovered(Colours.Gold);

	if (sorting == "rarity") then
		self.RaritySearch:SetOutlineColour(Colours.Gold);
		self.RaritySearch:SetOutlineColouredHovered(self.Category.Colour);
	elseif (sorting == "level") then
		self.LevelSearch:SetOutlineColour(Colours.Gold);
		self.LevelSearch:SetOutlineColouredHovered(self.Category.Colour);
	elseif (sorting == "price") then
		self.PriceSearch:SetOutlineColour(Colours.Gold);
		self.PriceSearch:SetOutlineColouredHovered(self.Category.Colour);
	else // Name
		self.NameSearch:SetOutlineColour(Colours.Gold);
		self.NameSearch:SetOutlineColouredHovered(self.Category.Colour);
	end

	self.Frame.SortingType = sorting;
	self:DoItems();
end

vgui.Register("DMizmoShopTab", PANEL, "DPanel");