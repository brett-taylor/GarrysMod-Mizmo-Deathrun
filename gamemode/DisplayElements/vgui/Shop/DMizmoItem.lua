local PANEL = {};

function PANEL:Init()
	self.HoveredOver = false;
	self.Percentage = 0;
	self.LastPercentage = 0;
	self.IsGold = 0;
	self.Data = PS.Items["turtlehat"];
	self.BackgroundColour = Colours.Gold;
	self.IsInventory = false;
	self.IsInItemPopup = false;
	self.Radius = 72;
	self.CanBuy = true;
	self.IsEquipped = true;
	self.PadLock = Material("Mizmo-Gaming-Downloads/shop/padlock.png");
	self.EquippedIcon = Material("Mizmo-Gaming-Downloads/shop/equipped.png");
	self.UpdateTimer = 1;

	local i = math.random(1, 2);
	if (i == 1) then
		self.TopRight = true;
	else
		self.TopRight = false;
	end

	self:SetText("");
	self:InvalidateLayout();
end

function PANEL:SetInventory(b)
	self.IsInventory = b;
end

function PANEL:DoItemPopup()
	self.IsInItemPopup = true;
	if (self.ModelVariant) then
		self.ModelVariant:DoItemPopup();
	end
	if (self.MaterialVariant) then
		self.MaterialVariant:DoItemPopup();
	end

	if (self.TextVariant) then
		self.TextVariant:DoItemPopup();
	end
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

function PANEL:DoClick()
	if (self.IsInItemPopup == false && self.CanBuy == true) then
		local itemPopup = vgui.Create("DMizmoShopItemData", PS.ShopMenu);
		itemPopup:SetData(self.Data);
	end
end

function PANEL:Paint(w, h)
	self.CurrentBGColour = self.CurrentBGColour or self.BackgroundColour;
	self.CurrentMizmoColour = self.CurrentMizmoColour or Colours.Gold;
	self.TextColour = self.TextColour or ColorAlpha(Colours.White, 0);
	self.PadLockAlpha = self.PadLockAlpha or 255;

	if (self.IsInItemPopup == false) then
		if (self.HoveredOver == true) then
			self.CurrentBGColour = Util.LerpColour(FrameTime() * 5, self.CurrentBGColour, Colours.GreyDark);
			self.CurrentMizmoColour = Util.LerpColour(FrameTime() * 5, self.CurrentMizmoColour, Colours.GreyDark);
			self.TextColour = Util.LerpColour(FrameTime() * 5, self.TextColour, Colours.White);
			self.PadLockAlpha = Lerp(FrameTime() * 10, self.PadLockAlpha, 0);
		else
			self.CurrentBGColour = Util.LerpColour(FrameTime() * 5, self.CurrentBGColour, self.BackgroundColour);
			self.CurrentMizmoColour = Util.LerpColour(FrameTime() * 5, self.CurrentMizmoColour, Colours.Gold);
			self.TextColour = Util.LerpColour(FrameTime() * 5, self.TextColour, ColorAlpha(Colours.White, 0));
			self.PadLockAlpha = Lerp(FrameTime() * 10, self.PadLockAlpha, 255);
		end
	end

	/*render.ClearStencil()
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
		DrawCircle(w / 2, h / 2, 75, math.max(w, h) / 2);
	render.SetStencilFailOperation( STENCILOPERATION_ZERO )
	render.SetStencilPassOperation( STENCILOPERATION_REPLACE )
	render.SetStencilZFailOperation( STENCILOPERATION_ZERO )
	render.SetStencilCompareFunction( STENCILCOMPARISONFUNCTION_EQUAL )
	render.SetStencilReferenceValue( 1 )
		surface.SetDrawColor(self.CurrentBGColour);
		draw.NoTexture()
		DrawCircle(w / 2, h / 2, 75, math.max(w, h) / 2);

		surface.SetDrawColor(Colours.GreyDark);
		draw.NoTexture()
		DrawCircle(w / 2, h / 2, 72, math.max(w, h) / 2);

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
		draw.NoTexture()
		surface.SetDrawColor( Color(255, 0, 0, 255));
		
		if (self.TopRight) then
			local rightTopCorner = {
				{ x = w - 60, y = 0 },
				{ x = w, y = 0 },
				{ x = w, y = 60 },
				{ x = w / 2, y = h / 2 },
			}
			draw.NoTexture()
			surface.SetDrawColor(Color(255, 255, 0, 255));
			surface.DrawPoly(rightTopCorner);

			local leftBottomCorner = {
				{ x = 0, y = h - 60 },
				{ x = w / 2, y = h / 2 },
				{ x = 60, y = h },
				{ x = 0, y = h }
			}
			draw.NoTexture()
			surface.SetDrawColor(Color(255, 255, 0, 255));
			surface.DrawPoly(leftBottomCorner);
		else
			local leftTopCorner = {
				{ x = 0, y = 0 },
				{ x = 60, y = 0 },
				{ x = w / 2, y = h / 2 },
				{ x = 0, y = 60 },
			}
			draw.NoTexture()
			surface.SetDrawColor(Color(255, 255, 0, 255));
			surface.DrawPoly(leftTopCorner);

			local rightBottomCorner = {
				{ x = w, y = h },
				{ x = w - 60, y = h },
				{ x = w / 2, y = h / 2 },
				{ x = w, y = h - 60 },
			}
			draw.NoTexture()
			surface.SetDrawColor(Color(255, 255, 0, 255));
			surface.DrawPoly(rightBottomCorner);
		end
	render.SetStencilFailOperation( STENCILOPERATION_ZERO )
	render.SetStencilPassOperation( STENCILOPERATION_REPLACE )
	render.SetStencilZFailOperation( STENCILOPERATION_ZERO )
	render.SetStencilCompareFunction( STENCILCOMPARISONFUNCTION_EQUAL )
	render.SetStencilReferenceValue( 1 )
		surface.SetDrawColor(self.CurrentBGColour);
		draw.NoTexture()
		DrawCircle(w / 2, h / 2, 75, math.max(w, h) / 2);

		surface.SetDrawColor(self.CurrentMizmoColour);
		draw.NoTexture()
		DrawCircle(w / 2, h / 2, 72, math.max(w, h) / 2);
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
		draw.NoTexture()
		surface.SetDrawColor( Color( 0, 0, 0, 255 ) )
		DrawCircle(w / 2, h / 2, 75, math.max(w, h) / 2);
	render.SetStencilFailOperation( STENCILOPERATION_ZERO )
	render.SetStencilPassOperation( STENCILOPERATION_REPLACE )
	render.SetStencilZFailOperation( STENCILOPERATION_ZERO )
	render.SetStencilCompareFunction( STENCILCOMPARISONFUNCTION_EQUAL )
	render.SetStencilReferenceValue( 1 )
		draw.SimpleText(self.Data.Name or "", "MizmoGaming-Shop-ItemIcon-Name", w / 2, 40, self.TextColour, TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM);
		draw.SimpleText("Mizmos: ", "MizmoGaming-Shop-ItemIcon-Name", w / 2, 55, self.TextColour, TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER);
		draw.SimpleText("Level: ", "MizmoGaming-Shop-ItemIcon-Name", w / 2, 75, self.TextColour, TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER);
		draw.SimpleText("Rarity: ", "MizmoGaming-Shop-ItemIcon-Name", w / 2, 95, self.TextColour, TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER);
		draw.SimpleText(self.Data.Price or "$$$", "MizmoGaming-Shop-ItemIcon-Text", w / 2, 55, ColorAlpha(Colours.Gold, self.TextColour.a), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER);
		draw.SimpleText(self.Data.Level or "1", "MizmoGaming-Shop-ItemIcon-Text", w / 2, 75, ColorAlpha(Colours.Gold, self.TextColour.a), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER);
		draw.SimpleText(self.Data.Grade or "Consumer", "MizmoGaming-Shop-ItemIcon-Text", w / 2, 95, ColorAlpha(self.BackgroundColour, self.TextColour.a), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER);
	render.SetStencilEnable( false )
	render.ClearStencil()*/

	render.ClearStencil()
	render.SetStencilEnable( true )
	render.SetStencilWriteMask( 1 )
	render.SetStencilTestMask( 1 )
	render.SetStencilFailOperation( STENCILOPERATION_REPLACE )
	render.SetStencilPassOperation( STENCILOPERATION_ZERO )
	render.SetStencilZFailOperation( STENCILOPERATION_ZERO )
	render.SetStencilCompareFunction( STENCILCOMPARISONFUNCTION_NEVER )
	render.SetStencilReferenceValue( 1 )
	 	Util.DrawCircle(w / 2, h / 2, h / 2, math.max(w, h) / 2, Color(0, 0, 0, 255));
	render.SetStencilFailOperation( STENCILOPERATION_ZERO )
	render.SetStencilPassOperation( STENCILOPERATION_REPLACE )
	render.SetStencilZFailOperation( STENCILOPERATION_ZERO )
	render.SetStencilCompareFunction( STENCILCOMPARISONFUNCTION_EQUAL )
	render.SetStencilReferenceValue( 1 )
 		surface.SetDrawColor(self.CurrentBGColour);
 		surface.DrawRect(0, 0, w, h);
	 	Util.DrawCircle(w / 2, h / 2, self.Radius, math.max(w, h) / 2, Colours.GreyDark)

	 	if (self.Data.Subname ~= nil) then
			draw.SimpleText(self.Data.Name or "", "MizmoGaming-Shop-ItemIcon-Name", w / 2, 40, self.TextColour, TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM);
			draw.SimpleText(self.Data.Subname or "", "MizmoGaming-Shop-ItemIcon-Name", w / 2, 42, ColorAlpha(self.BackgroundColour, self.TextColour.a), TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP);
	 	else
			draw.SimpleText(self.Data.Name or "", "MizmoGaming-Shop-ItemIcon-Name", w / 2, 40, self.TextColour, TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM);
	 	end

	 	if (self.IsInventory == true) then
			draw.SimpleText("Sell For: ", "MizmoGaming-Shop-ItemIcon-Name", w / 2, 65, self.TextColour, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER);
			draw.SimpleText(PS.Config.CalculateSellPrice(LocalPlayer(), self.Data) or "$$$", "MizmoGaming-Shop-ItemIcon-Text", w / 2 - 5, 85, ColorAlpha(Colours.Gold, self.TextColour.a), TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER);
			draw.SimpleText("Mizmos", "MizmoGaming-Shop-ItemIcon-Name", w / 2, 85, self.TextColour, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER);
	 	else
	 		if (self.Data.Buyable == true) then
				draw.SimpleText("Mizmos: ", "MizmoGaming-Shop-ItemIcon-Name", w / 2, 55, self.TextColour, TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER);
				draw.SimpleText("Level: ", "MizmoGaming-Shop-ItemIcon-Name", w / 2, 75, self.TextColour, TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER);
				draw.SimpleText("Rarity: ", "MizmoGaming-Shop-ItemIcon-Name", w / 2, 95, self.TextColour, TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER);
				draw.SimpleText(PS.Config.CalculateBuyPrice(LocalPlayer(), self.Data) or "$$$", "MizmoGaming-Shop-ItemIcon-Text", w / 2, 55, ColorAlpha(Colours.Gold, self.TextColour.a), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER);
				draw.SimpleText(self.Data.Level or "1", "MizmoGaming-Shop-ItemIcon-Text", w / 2, 75, ColorAlpha(Colours.Gold, self.TextColour.a), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER);
				draw.SimpleText(self.Data.Grade or "Consumer", "MizmoGaming-Shop-ItemIcon-Text", w / 2, 95, ColorAlpha(self.BackgroundColour, self.TextColour.a), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER);
	 		else
			 	Util.DrawRotatedText("UNBUYABLE!", w /2 , h / 2, self.TextColour, "MizmoGaming-Button-Small", 0);
	 		end
	 	end
	render.SetStencilEnable( false )
	render.ClearStencil()
end

function PANEL:SetRadius(radius)
	self.Radius = radius;

	if (self.MaterialVariant) then
		self.MaterialVariant:SetRadius(self.Radius);
	end
end

function PANEL:SetData(data)
	self.Data = data;
	self.BackgroundColour = Util.GetItemColour(self.Data.Grade or "Consumer");

	if (string.find(self.Data.ID, "csgo")) then
		if (string.find(self.Data.Name, "|")) then
			self.Data.Subname = string.sub(self.Data.Name, string.find(self.Data.Name, "|"), #self.Data.Name);
			self.Data.Subname = string.sub(self.Data.Subname, 2, #self.Data.Subname);
			self.Data.Name = string.sub(self.Data.Name, 1, string.find(self.Data.Name, "|") - 2);
		end
	end

	if (self.Data.Model) then
		self.ModelVariant = vgui.Create("DMizmoItemModelVariant", self);
		self.ModelVariant:SetData(data, self);
	elseif (self.Data.Material) then
		self.MaterialVariant = vgui.Create("DMizmoItemMaterialVariant", self);
		self.MaterialVariant:SetData(data, self);
		self.MaterialVariant:SetRadius(self.Radius);
	elseif (self.Data.Text) then
		self.TextVariant = vgui.Create("DMizmoItemTextVariant", self);
		self.TextVariant:SetData(data, self);
		self.TextVariant:SetRadius(self.Radius);
	end

	self:UpdateItemBuyable();
	self:UpdateItemEquipped();	
end

function PANEL:PaintOver(w, h)
	if (self.CanBuy == false) then
		if (self.Data.Text == nil) then
			surface.SetDrawColor(255, 255, 255, self.PadLockAlpha);
			surface.SetMaterial(self.PadLock);
			surface.DrawTexturedRect(w / 2 - 30, h / 2 - 30, 60, 60);
		else
			surface.SetDrawColor(255, 255, 255, self.PadLockAlpha);
			surface.SetMaterial(self.PadLock);
			surface.DrawTexturedRect(w / 2 - 15, h - 40, 30, 30);
		end
	end

	if (self.IsEquipped == true) then
		//surface.SetDrawColor(255, 255, 255, self.PadLockAlpha);
		surface.SetDrawColor(ColorAlpha(self.CurrentBGColour, self.PadLockAlpha));
		surface.SetMaterial(self.EquippedIcon);
		surface.DrawTexturedRect(w / 2 - 15, h - 40, 30, 30);
	end
end

function PANEL:UpdateItemBuyable()
	self.CanBuy = true;
	if (LocalPlayer():PS_HasPoints(self.Data.Price) == false) then
		self.CanBuy = false;
	end

	if (LocalPlayer():PS_HasLevel(self.Data.Level) == false) then
		self.CanBuy = false;
	end

	if (self.Data.Buyable == false) then
		self.CanBuy = false;
	end

	if (LocalPlayer():PS_HasItem(self.Data.ID) == true) then
		self.CanBuy = true;
	end
end

function PANEL:UpdateItemEquipped()
	if (LocalPlayer():PS_HasItemEquipped(self.Data.ID) == true) then
		self.IsEquipped = true;
		return;
	end

	self.IsEquipped = false;
end

function PANEL:Think()
	self.UpdateTimer = self.UpdateTimer - FrameTime();
	if (self.UpdateTimer < 0) then
		self.UpdateTimer = 1;
		self:UpdateItemBuyable();
		self:UpdateItemEquipped();
	end
end

vgui.Register("DMizmoItem", PANEL, "DButton");