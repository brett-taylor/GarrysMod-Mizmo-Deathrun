local PANEL = {};

function PANEL:Init()
	self.Text = "";
	self.HoveredOver = false;
	self.AccentColour = Colours.Gold;
	self.Material = nil;
	self.InitialTimer = 4;
	self.Timer = self.InitialTimer;
	self.IsPressed = false;
	self.OnClicked = nil;
	self.Execute = nil;

	self:SetText("");
	self:InvalidateLayout();
end

function PANEL:InvalidateLayout()
	self:SetSize(60, 60);
end

function PANEL:Settext(text)
	self.Text = text;
end

function PANEL:SetAccentColour(colour)
	self.AccentColour = colour;
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

	if (self.IsPressed == true) then
		self:CancelClick();
		return;
	end

	self.IsPressed = true;
	if (self.OnClicked ~= nil) then
		self.OnClicked();
	end
end

function PANEL:SetMaterial(material)
	self.Material = Material("Mizmo-Gaming-Downloads/shop/"..material..".png");
end

function PANEL:Think()
	 if (self.IsPressed == true) then
		self.Timer = self.Timer - FrameTime();
		
		if (self.Timer < 1) then
			self:CancelClick();
			self:OnExecute();
		end
	 end
end

function PANEL:OnExecute()
	if (self.Execute ~= nil) then
		self.Execute();
	end
end

function PANEL:CancelClick()
	self.IsPressed = false;
	self.Timer = self.InitialTimer;
end

function PANEL:NoWait()
	self.InitialTimer = 1;
	self.Timer = self.InitialTimer;
end

function PANEL:Paint(w, h)
	self.CurrentOutlineColour = self.CurrentOutlineColour or self.AccentColour;
	self.CurrentBGColour = self.CurrentBGColour or Colours.GreyDark;
	self.ImageAlpha = self.ImageAlpha or 255;
	self.TextAlpha = self.TextAlpha or 0;

	if (self.HoveredOver == true) then
		self.CurrentOutlineColour = Util.LerpColour(FrameTime() * 5, self.CurrentOutlineColour, self.AccentColour);
		self.CurrentBGColour = Util.LerpColour(FrameTime() * 3, self.CurrentBGColour, Colours.Grey);
		self.ImageAlpha = Lerp(FrameTime() * 7, self.ImageAlpha, 0);
		self.TextAlpha = Lerp(FrameTime() * 5, self.TextAlpha, 255);
	else
		self.CurrentOutlineColour = Util.LerpColour(FrameTime() * 5, self.CurrentOutlineColour, self.AccentColour);
		self.CurrentBGColour = Util.LerpColour(FrameTime() * 5, self.CurrentBGColour, Colours.GreyDark);
		self.ImageAlpha = Lerp(FrameTime() * 5, self.ImageAlpha, 255);
		self.TextAlpha = Lerp(FrameTime() * 5, self.TextAlpha, 0);
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
		Util.DrawCircle(w / 2, h / 2, 29, math.max(w, h) / 2, Color(0, 0, 0, 255));
	render.SetStencilFailOperation( STENCILOPERATION_ZERO )
	render.SetStencilPassOperation( STENCILOPERATION_REPLACE )
	render.SetStencilZFailOperation( STENCILOPERATION_ZERO )
	render.SetStencilCompareFunction( STENCILCOMPARISONFUNCTION_EQUAL )
	render.SetStencilReferenceValue(1)
		surface.SetDrawColor(self.CurrentOutlineColour);
		surface.DrawRect(0, 0, w, h);
		Util.DrawCircle(w / 2, h / 2, 27, math.max(w, h) / 2, self.CurrentBGColour);

		if (self.IsPressed == false) then
			draw.SimpleText(self.Text or "Undefined", "MizmoGaming-Button-Small", w / 2, h / 2, ColorAlpha(self.AccentColour, self.TextAlpha), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER);
		else
			self.TextAlpha = 255;
			draw.SimpleText(string.sub(self.Timer, 1, 1), "MizmoGaming-Button-Medium", w / 2, h / 2, ColorAlpha(self.AccentColour, self.TextAlpha), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER);
		end
	render.SetStencilEnable( false )
	render.ClearStencil()

	render.ClearStencil()
	render.SetStencilEnable( true )
	render.SetStencilWriteMask( 1 )
	render.SetStencilTestMask( 1 )
	render.SetStencilFailOperation( STENCILOPERATION_REPLACE )
	render.SetStencilPassOperation( STENCILOPERATION_ZERO )
	render.SetStencilZFailOperation( STENCILOPERATION_ZERO )
	render.SetStencilCompareFunction( STENCILCOMPARISONFUNCTION_NEVER )
	render.SetStencilReferenceValue( 1 )
		Util.DrawCircle(w / 2, h / 2, 26, math.max(w, h) / 2, Color(0, 0, 0, 255));
	render.SetStencilFailOperation( STENCILOPERATION_ZERO )
	render.SetStencilPassOperation( STENCILOPERATION_REPLACE )
	render.SetStencilZFailOperation( STENCILOPERATION_ZERO )
	render.SetStencilCompareFunction( STENCILCOMPARISONFUNCTION_EQUAL )
	render.SetStencilReferenceValue(1)
		if (self.Material ~= nil && self.IsPressed == false) then
			surface.SetDrawColor(255, 255, 255, self.ImageAlpha);
			surface.SetMaterial(self.Material);
			surface.DrawTexturedRect(0, 0, w, h);
		end
	render.SetStencilEnable( false )
	render.ClearStencil()
end

vgui.Register("DMizmoShopFunctionButton", PANEL, "DButton");