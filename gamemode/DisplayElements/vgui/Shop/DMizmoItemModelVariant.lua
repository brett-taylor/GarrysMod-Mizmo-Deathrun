local PANEL = {};

function PANEL:Init()
	self:InvalidateLayout();
	self.HoveredOver = false;
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
	self:SetModel(self.Data.Model);

	if data.Skin then
		self:SetSkin(data.Skin);
	end

	self.PrevMins, self.PrevMaxs = self.Entity:GetRenderBounds();
	self:SetLookAt((self.PrevMaxs + self.PrevMins) / 2);
	self.CameraPosVector = self.PrevMins:Distance(self.PrevMaxs) * Vector(0.5, 0.5, 0.5);
end

function PANEL:Think()
	if (self.HoveredOver == true) then
		self.CameraPosVector = LerpVector(FrameTime() * 5, self.CameraPosVector, Vector(1000, 1000, 1000));
	else
		self.CameraPosVector = LerpVector(FrameTime() * 5, self.CameraPosVector, self.PrevMins:Distance(self.PrevMaxs) * Vector(0.5, 0.5, 0.5));
	end
	self:SetCamPos(self.CameraPosVector or Vector(0.5, 0.5, 0.5));
end

vgui.Register("DMizmoItemModelVariant", PANEL, "DModelPanel");