local PANEL = {};

local function DrawCircle( x, y, radius, seg )
	local cir = {}
	table.insert( cir, { x = x, y = y } )
	for i = 0, seg do
		local a = math.rad( ( i / seg ) * -360 )
		table.insert( cir, { x = x + math.sin( a ) * radius, y = y + math.cos( a ) * radius } )
	end
	local a = math.rad( 0 )
	table.insert( cir, { x = x + math.sin( a ) * radius, y = y + math.cos( a ) * radius } )
	surface.DrawPoly( cir )
end

function PANEL:Init()
	self.HoveredOver = false;
	self.Percentage = 0;
	self.LastPercentage = 0;
	self.IsGold = 0;
	self.Data = PS.Items["turtlehat"];
	self.BackgroundColour = Colours.Gold;

	self:SetText("");
	self:InvalidateLayout();
end

function PANEL:InvalidateLayout()
	self:SetSize(150, 150);
end

function PANEL:OnCursorEntered()
	self.HoveredOver = true;
	surface.PlaySound("UI/buttonrollover.wav");
end

function PANEL:OnCursorExited()
	self.HoveredOver = false;
	surface.PlaySound("UI/buttonrollover.wav");
end

function PANEL:Paint(w, h)
	self.CurrentBGColour = self.CurrentBGColour or self.BackgroundColour;
	self.TextColour = self.TextColour or ColorAlpha(Colours.White, 0);

	if (self.HoveredOver == true) then
		self.CurrentBGColour = Util.LerpColour(FrameTime() * 5, self.CurrentBGColour, Colours.GreyDark);
		self.TextColour = Util.LerpColour(FrameTime() * 5, self.TextColour, Colours.White);
	else
		self.CurrentBGColour = Util.LerpColour(FrameTime() * 5, self.CurrentBGColour, self.BackgroundColour);
		self.TextColour = Util.LerpColour(FrameTime() * 5, self.TextColour, ColorAlpha(Colours.White, 0));
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
	draw.NoTexture()
	surface.SetDrawColor( Color( 0, 0, 0, 255 ) )
		DrawCircle(w / 2, h / 2, h / 2, math.max(w, h) / 2);
	render.SetStencilFailOperation( STENCILOPERATION_ZERO )
	render.SetStencilPassOperation( STENCILOPERATION_REPLACE )
	render.SetStencilZFailOperation( STENCILOPERATION_ZERO )
	render.SetStencilCompareFunction( STENCILCOMPARISONFUNCTION_EQUAL )
	render.SetStencilReferenceValue( 1 )
		surface.SetDrawColor(self.CurrentBGColour);
		DrawCircle(10, 10, 300, math.max(w, h) / 2);

		draw.SimpleText(self.Data.Name or "", "MizmoGaming-Shop-ItemIcon-Name", w / 2, 40, self.TextColour, TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM);
		draw.SimpleText("Mizmos: ", "MizmoGaming-Shop-ItemIcon-Name", w / 2, 55, self.TextColour, TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER);
		draw.SimpleText("Level: ", "MizmoGaming-Shop-ItemIcon-Name", w / 2, 75, self.TextColour, TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER);
		draw.SimpleText("Rarity: ", "MizmoGaming-Shop-ItemIcon-Name", w / 2, 95, self.TextColour, TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER);
		draw.SimpleText(self.Data.Price or "$$$", "MizmoGaming-Shop-ItemIcon-Text", w / 2, 55, ColorAlpha(Colours.Gold, self.TextColour.a), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER);
		draw.SimpleText(self.Data.Level or "1", "MizmoGaming-Shop-ItemIcon-Text", w / 2, 75, ColorAlpha(Colours.Gold, self.TextColour.a), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER);
		draw.SimpleText(self.Data.Grade or "Consumer", "MizmoGaming-Shop-ItemIcon-Text", w / 2, 95, ColorAlpha(self.BackgroundColour, self.TextColour.a), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER);
	render.SetStencilEnable( false )
	render.ClearStencil()
end

function PANEL:SetData(data)
	self.Data = data;
	self.BackgroundColour = Util.GetItemColour(self.Data.Grade or "Consumer");

	if (self.Data.Model) then
		local modelVariant = vgui.Create('DMizmoItemModelVariant', self);
		modelVariant:SetData(data);
	end

	if (self.Data.Level == 0) then
		self.Data.Level = 1;
	end
end

vgui.Register("DMizmoShopItem", PANEL, "DButton");