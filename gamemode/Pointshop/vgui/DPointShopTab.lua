local PANEL = {};

function PANEL:Init()
	self.CategoriesHolder = vgui.Create("DPanel", self);
	self.CategoriesHolder.Paint = function(self, w, h)
		surface.SetDrawColor(Colours.Gold);
		surface.DrawRect(0, 0, w, h);

		surface.SetDrawColor(Colours.Grey);
		surface.DrawRect(2, 2, w - 4, h - 4);
	end

	self.ItemHolder = vgui.Create("DPanel", self);
	self.ItemHolder.Paint = function(self, w, h)
		surface.SetDrawColor(Colours.Gold);
		surface.DrawRect(0, 0, w, h);

		surface.SetDrawColor(Colours.Grey);
		surface.DrawRect(2, 2, w - 4, h - 4);
	end

	self.PreviewHolder = vgui.Create("DPanel", self);
	self.PreviewHolder.Paint = function(self, w, h)
		surface.SetDrawColor(Colours.Gold);
		surface.DrawRect(0, 0, w, h);

		surface.SetDrawColor(Colours.Grey);
		surface.DrawRect(2, 2, w - 4, h - 4);
	end

	self.PreviewModel = vgui.Create('DPointShopPreview', self.PreviewHolder);
	self.PreviewModel.Angles = Angle( 0, 0, 0 )
	function self.PreviewModel:DragMousePress()
		self.PressX, self.PressY = gui.MousePos()
		self.Pressed = true
	end

	function self.PreviewModel:DragMouseRelease()
		self.Pressed = false
		self.lastPressed = RealTime()
	end
	
	function self.PreviewModel:LayoutEntity( thisEntity )
		if ( self.bAnimated ) then self:RunAnimation() end
		
		if ( self.Pressed ) then
			local mx, my = gui.MousePos()
			self.Angles = self.Angles - Angle( 0, ( self.PressX or mx ) - mx, 0 )
			self.PressX, self.PressY = gui.MousePos()
		end
		
		if ( RealTime() - ( self.lastPressed or 0 ) ) < 4 or self.Pressed then
			thisEntity:SetAngles( self.Angles )
		else	
			self.Angles.y = math.NormalizeAngle(self.Angles.y + (RealFrameTime() * 21))
			thisEntity:SetAngles( Angle( 0, self.Angles.y ,  0) )
		end
	end

	self.CategoryScroll = vgui.Create("DScrollPanel", self.CategoriesHolder);
	self.CategoryGrid = vgui.Create("DIconLayout", self.CategoryScroll);
	self.CategoryGrid:SetSpaceY(5);

	self.categoryButtons = {};
	for category_id, CATEGORY in pairs(PS.Categories) do
		if (CATEGORY.Name ~= "Weapons") then
			self.categoryButtons[#self.categoryButtons + 1] = self:AddButton(self.CategoryGrid);
			self.categoryButtons[#self.categoryButtons]:SetText(CATEGORY.Name);
			self.categoryButtons[#self.categoryButtons].DoClick = function()
				self:LoadItemTab(CATEGORY.Name);
			end
		end
	end
	
	self:InvalidateLayout();
	self:LoadItemTab("Trails");
end

function PANEL:LoadItemTab(catName)
	if (self.ItemScroll ~= nil) then
		self.ItemScroll:Remove();
		self.ItemScroll = nil;
	end

	self.ItemScroll = vgui.Create("DScrollPanel", self.ItemHolder);
	self.ItemScroll:GetVBar().Paint = function(self, w, h)
		draw.RoundedBox(0, 0, 0, w, h, Colours.Gold);
	end

	self.CategoryGrid = vgui.Create("DIconLayout", self.ItemScroll);
	self.CategoryGrid:SetSpaceY(5);
	self.CategoryGrid:SetBorder(8);
	self.CategoryGrid:SetSpaceX(8);
	self.CategoryGrid:SetSpaceY(8);
	
	for _, ITEM in pairs(PS.Items) do
		if ITEM.Category == catName then
			local model = vgui.Create('DPointShopItem')
			model:SetData(ITEM)
			model:SetSize(128, 128)
			
			self.CategoryGrid:Add(model);
		end
	end

	self:InvalidateLayout();
end

function PANEL:InvalidateLayout()
	if (self.CategoriesHolder ~= nil) then
		self.CategoriesHolder:SetSize(250, 0);
		self.CategoriesHolder:Dock(LEFT);
		self.CategoriesHolder:DockMargin(0, 0, 5, 0);
	end

	if (self.ItemHolder ~= nil) then
		self.ItemHolder:Dock(FILL);
	end

	if (self.PreviewHolder ~= nil) then
		self.PreviewHolder:SetSize(250, 0);
		self.PreviewHolder:Dock(RIGHT);
		self.PreviewHolder:DockMargin(5, 0, 0, 0);
	end

	if (self.PreviewModel ~= nil) then
		self.PreviewModel:Dock(FILL);
	end

	if (self.CategoryScroll ~= nil) then
		self.CategoryScroll:Dock(FILL);
	end

	if (self.CategoryGrid ~= nil) then
		self.CategoryGrid:Dock(FILL);
		self.CategoryGrid:DockMargin(4, 0, 4, 0);
	end

	if (self.categoryButtons ~= nil) then
		for i = 1, #self.categoryButtons do
			if (self.categoryButtons[i] ~= nil) then
				self.categoryButtons[i]:SetSize(self.categoryButtons[i]:GetParent():GetParent():GetParent():GetParent():GetWide(), 50);
			end
		end
	end

	if (self.ItemScroll ~= nil) then
		self.ItemScroll:Dock(FILL);
	end

	if (self.CategoryGrid ~= nil) then
		self.CategoryGrid:Dock(FILL);
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

vgui.Register('DPointShopTab', PANEL);