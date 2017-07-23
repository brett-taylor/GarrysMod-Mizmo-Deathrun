local PANEL = {}

function PANEL:Init()
	self:SetText("");
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

function PANEL:DoItemPopup()
	self.IsInItemPopup = true;
end

function PANEL:SetRadius(radius)
	self.Radius = radius;
end

function PANEL:Paint(w, h)
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
		draw.SimpleText(self.Data.Text or "", "MizmoGaming-Shop-ItemIcon-Name", w / 2, 40, self.Data.TextColour, TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM);
		Util.DrawCircle(w / 2, h / 2, 20, math.max(w, h), self.Data.TextColour)
	render.SetStencilEnable( false )
	render.ClearStencil()
end

vgui.Register("DMizmoItemTextVariant", PANEL, "DButton");