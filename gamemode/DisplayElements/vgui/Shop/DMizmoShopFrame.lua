local PANEL = {};

function PANEL:Init()
	self.Background = vgui.Create("DPanel");
	self.Background.Paint = function(self, w, h)
		surface.SetDrawColor(0, 0, 0, 150);
		surface.DrawRect(0, 0, w, h);

		surface.SetDrawColor(ColorAlpha(Colours.Grey, 255));
		surface.DrawRect(0, 0, w, 100);
	end

	self.Header = vgui.Create("DIconLayout", self.Background);
	self.Header.Paint = function(self, w, h)
	end

	self.InfoHeader = vgui.Create("DMizmoShopHeaderInfo", self.Header);
	self.InfoHeader.Paint = function(self, w, h)
	end

	self.Shop = vgui.Create("DMizmoShopCatButton", self.Header);
	self.Shop:SetText("Shop");
	
	self.Inventory = vgui.Create("DMizmoShopCatButton", self.Header);
	self.Inventory:SetText("Inventory");
	
	self.Crates = vgui.Create("DMizmoShopCatButton", self.Header);
	self.Crates:SetText("Crates");

	self.ModelBackground = vgui.Create("DPanel", self.Background);
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
	self.ModelViewer.Angles = Angle( 0, 0, 0 )
	function self.ModelViewer:DragMousePress()
		self.PressX, self.PressY = gui.MousePos()
		self.Pressed = true
	end

	function self.ModelViewer:DragMouseRelease()
		self.Pressed = false
		self.lastPressed = RealTime()
	end
	
	function self.ModelViewer:LayoutEntity( thisEntity )
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

	self.MainTab = vgui.Create("DPanel", self.Background);
	self.MainTab.Paint = function(self, w, h)
		surface.SetDrawColor(Colours.Grey);
		surface.DrawRect(0, 0, w, h);
	end

	self.ShopTab = vgui.Create("DMizmoShopTab", self.MainTab);

	self:InvalidateLayout();
end

function PANEL:InvalidateLayout()		
	if (self.Background ~= nil) then
		self.Background:SetSize(ScrW(), ScrH());
		self.Background:Center();
	end

	if (self.Header ~= nil) then
		self.Header:SetSize(900, 100);
		self.Header:CenterHorizontal();
	end

	if (self.InfoHeader ~= nil) then
		self.InfoHeader:SetSize(300, 100);
	end

	if (self.ModelBackground ~= nil) then
		self.ModelBackground:SetSize(400, ScrH() - 150);
		self.ModelBackground:SetPos(ScrW() - 400, 150);
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
		self.MainTab:SetSize(math.floor((ScrW() - 500) / 160) * 160 + 20, ScrH() - 150);		
		self.MainTab:SetPos(0, 150);	
	end

	if (self.ShopTab ~= nil) then
		self.ShopTab:Dock(FILL);
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