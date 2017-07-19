local PANEL = {}

function PANEL:Init()
	self.m_Image:SetPaintedManually(true);
	self.HoveredOver = false;
	self.IsInItemPopup = false;
	self.Radius = 72;

	self:InvalidateLayout();
end

function PANEL:InvalidateLayout()
	self:Dock(FILL);
end

function PANEL:DoClick()
	self:GetParent():DoClick()
end

function PANEL:OnCursorEntered()
	self:GetParent():OnCursorEntered()
	self.HoveredOver = true;
end

function PANEL:OnCursorExited()
	self:GetParent():OnCursorExited()
	self.HoveredOver = false;
end

function PANEL:SetData(data)
	self.Data = data;
	self:SetMaterial(self.Data.Material);
	self.m_Image.FrameTime = 0;
end

function PANEL:SetDataMaterial(data, material)
	self.Data = data;
	self:SetMaterial(material);
	self.m_Image.FrameTime = 5;
end

function PANEL:Think()
	if (self.IsInItemPopup == false) then
		if (self.HoveredOver == true) then
			self:SetAlpha(Lerp(FrameTime() * 5, self:GetAlpha(), 0));
		else
			self:SetAlpha(Lerp(FrameTime() * 5, self:GetAlpha(), 255));
		end
	end
end

function PANEL:PaintOver(w, h)
	render.ClearStencil()
	render.SetStencilEnable( true )
	render.SetStencilWriteMask( 1 )
	render.SetStencilTestMask( 1 )
	render.SetStencilFailOperation( STENCILOPERATION_REPLACE )
	render.SetStencilPassOperation( STENCILOPERATION_ZERO )
	render.SetStencilZFailOperation( STENCILOPERATION_ZERO )
	render.SetStencilCompareFunction( STENCILCOMPARISONFUNCTION_NEVER )
	render.SetStencilReferenceValue( 1 )
		Util.DrawCircle(w / 2, h / 2, self.Radius, math.max(w, h) / 2, Color(0, 0, 0, 255))
	render.SetStencilFailOperation( STENCILOPERATION_ZERO )
	render.SetStencilPassOperation( STENCILOPERATION_REPLACE )
	render.SetStencilZFailOperation( STENCILOPERATION_ZERO )
	render.SetStencilCompareFunction( STENCILCOMPARISONFUNCTION_EQUAL )
	render.SetStencilReferenceValue(1)
		self.m_Image:PaintManual();
	render.SetStencilEnable( false )
	render.ClearStencil()
end

function PANEL:DoItemPopup()
	self.IsInItemPopup = true;
end

function PANEL:SetRadius(radius)
	self.Radius = radius;
end

vgui.Register("DMizmoItemMaterialVariant", PANEL, "DImageButton");