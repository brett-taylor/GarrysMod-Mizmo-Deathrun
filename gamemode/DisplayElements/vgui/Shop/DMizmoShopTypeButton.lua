local PANEL = {};

function PANEL:SetInfo(pickMenu, cat, catName, catColour, catIcon)
	self.PickMenu = nil;
	self.Name = "Undefined";
	self.Cat = "Undefined";
	self.Icon = "Undefined";
	self.Colour = Colours.Gold;
	self.HoverColour = Colours.GreyDark;
	self.HoveredOver = false;
	self.MaxAlpha = 255;
	self.OnShopTab = false;

	self.PickMenu = pickMenu;
	self.Name = catName;
	self.Cat = cat;
	self.Colour = catColour;
	self.Icon = catIcon;

	self:SetText("");
	self.Material = Material("Mizmo-Gaming-Downloads/shop/"..self.Icon..".png");
	self:InvalidateLayout();
end

function PANEL:IsShopTab()
	self.OnShopTab = true;
end

function PANEL:InvalidateLayout()
	if (self.OnShopTab == false) then
		self:SetSize(200, 200);
	end
end

function PANEL:OnCursorExited()
	self.HoveredOver = false;
	surface.PlaySound("UI/buttonrollover.wav");
end

function PANEL:OnCursorEntered()
	self.HoveredOver = true;
	surface.PlaySound("UI/buttonrollover.wav");
end

function PANEL:DoClick()
	surface.PlaySound("UI/buttonclick.wav");
	if (self.OnShopTab == true) then
		if (self.PickMenu.Back == false) then
			self.PickMenu:Clicked();
		end
	else
		if (self.PickMenu.PickedCat == false) then
			self.PickMenu.PickedCat = true;
			self.PickMenu.CatPicked = self.Cat;
			self.PickMenu.ButtonsMaxAlpha = 0;
		end
	end
end

function PANEL:Paint(w, h)
	self.CurrentBGColour = self.CurrentBGColour or self.Colour;
	self.ImageAlpha = self.ImageAlpha or 255;
	self.TextAlpha = self.TextAlpha or 0;

	if (self.HoveredOver == true) then
		self.CurrentBGColour = Util.LerpColour(FrameTime() * 5, self.CurrentBGColour, ColorAlpha(self.HoverColour, self.PickMenu.ButtonsMaxAlpha));
		self.ImageAlpha = Lerp(FrameTime() * 5, self.ImageAlpha, 0);
		self.TextAlpha = Lerp(FrameTime() * 5, self.TextAlpha, self.PickMenu.ButtonsMaxAlpha);
	else
		self.CurrentBGColour = Util.LerpColour(FrameTime() * 5, self.CurrentBGColour, ColorAlpha(self.Colour, self.PickMenu.ButtonsMaxAlpha));
		self.ImageAlpha = Lerp(FrameTime() * 5, self.ImageAlpha, self.PickMenu.ButtonsMaxAlpha);
		self.TextAlpha = Lerp(FrameTime() * 5, self.TextAlpha, 0);
	end

	if (self.OnShopTab == true) then
		Util.DrawCircle(w / 2, h / 2, 32, math.max(w, h) / 2, ColorAlpha(Colours.GreyDark, self.PickMenu.ButtonsMaxAlpha));
	else
		Util.DrawCircle(w / 2, h / 2, 100, math.max(w, h) / 2, ColorAlpha(Colours.GreyDark, self.PickMenu.ButtonsMaxAlpha));
	end
	render.ClearStencil()
	render.SetStencilEnable( true )
	render.SetStencilWriteMask( 1 )
	render.SetStencilTestMask( 1 )
	render.SetStencilFailOperation( STENCILOPERATION_REPLACE )
	render.SetStencilPassOperation( STENCILOPERATION_ZERO )
	render.SetStencilZFailOperation( STENCILOPERATION_ZERO )
	render.SetStencilCompareFunction( STENCILCOMPARISONFUNCTION_NEVER )
	render.SetStencilReferenceValue( 1 )
	if (self.OnShopTab == true) then
		Util.DrawCircle(w / 2, h / 2, 29, math.max(w, h) / 2, Color(0, 0, 0, 255))
	else
		Util.DrawCircle(w / 2, h / 2, 95, math.max(w, h) / 2, Color(0, 0, 0, 255))
	end
	render.SetStencilFailOperation( STENCILOPERATION_ZERO )
	render.SetStencilPassOperation( STENCILOPERATION_REPLACE )
	render.SetStencilZFailOperation( STENCILOPERATION_ZERO )
	render.SetStencilCompareFunction( STENCILCOMPARISONFUNCTION_EQUAL )
	render.SetStencilReferenceValue(1)
		surface.SetDrawColor(self.CurrentBGColour);
		surface.DrawRect(0, 0, w, h);

		if (self.Material ~= nil) then
			surface.SetDrawColor(0, 0, 0, self.ImageAlpha);
			surface.SetMaterial(self.Material);
			surface.DrawTexturedRect(0, 0, w, h);
		end

		if (self.OnShopTab == true) then
			draw.SimpleText(self.Name or "Undefined", "MizmoGaming-Button-Small", w / 2, h / 2, ColorAlpha(self.Colour, self.TextAlpha), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER);
		else	
			draw.SimpleText(self.Name or "Undefined", "MizmoGaming-Button-Medium", w / 2, h / 2, ColorAlpha(self.Colour, self.TextAlpha), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER);
		end
	render.SetStencilEnable( false )
	render.ClearStencil()
end

vgui.Register("DMizmoShopType", PANEL, "DButton");