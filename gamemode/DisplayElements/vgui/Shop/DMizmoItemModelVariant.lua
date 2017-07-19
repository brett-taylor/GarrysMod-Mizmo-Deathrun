local PANEL = {};

function PANEL:Init()
	self:InvalidateLayout();
	self.HoveredOver = false;
	self.IsKnife = false;
	self.IsInItemPopup = false;

	self.HoveredCameraPos = Vector(1000, 1000, 1000);
	self.UnhoveredCameraPos = Vector(1000, 1000, 1000);
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

function PANEL:SetData(data, parent)
	self.Data = data;
	self.Parent = parent;
	self:SetModel(self.Data.Model);

	if self.Data.Skin then
		self:SetSkin(data.Skin);
		self:GetEntity():SetSkin(data.Skin);
	end

	self.PrevMins, self.PrevMaxs = self.Entity:GetRenderBounds();
	self:SetLookAt((self.PrevMaxs + self.PrevMins) / 2);

	self.HoveredCameraPos = Vector(1000, 1000, 1000);
	self.UnhoveredCameraPos = (self.PrevMins:Distance(self.PrevMaxs) * Vector(0.5, 0.5, 0.5));
	self.CameraPosVector = self.UnhoveredCameraPos;

	if (string.StartWith(self.Data.ID, "csgo_")) then
		self.UnhoveredCameraPos = (self.PrevMins:Distance(self.PrevMaxs) * Vector(0.4, 0.6, 0.1));
	end
end

function PANEL:LayoutEntity(entity)
end

function PANEL:Think()
	if (self.IsInItemPopup == false) then
		if (self.HoveredOver == true) then
			self.CameraPosVector = LerpVector(FrameTime() * 5, self.CameraPosVector, self.HoveredCameraPos);
		else
			self.CameraPosVector = LerpVector(FrameTime() * 5, self.CameraPosVector, self.UnhoveredCameraPos);
		end
	end

	self:SetCamPos(self.CameraPosVector or Vector(0.5, 0.5, 0.5));
end

function PANEL:DoItemPopup()
	self.IsInItemPopup = true;
end


vgui.Register("DMizmoItemModelVariant", PANEL, "DModelPanel");