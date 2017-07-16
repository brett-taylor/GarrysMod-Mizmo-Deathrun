local PANEL = {};

function PANEL:Init()
	self:InvalidateLayout();
	self.HoveredOver = false;
	self.IsKnife = false;

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

function PANEL:SetData(data)
	self.Data = data;
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
		self.IsKnife = true;
		if (string.StartWith(self.Data.ID, "csgo_karambit")) then
			--self.UnhoveredCameraPos = (self.PrevMaxs:Distance(self.PrevMins) * Vector(0.3, 0.2, 0.2));
			self.UnhoveredCameraPos = self.PrevMaxs:Distance(self.PrevMins) * (self.Entity:GetAngles():Right() * 0.3);
			print(self.UnhoveredCameraPos);
		else
			self.UnhoveredCameraPos = (self.PrevMins:Distance(self.PrevMaxs) * Vector(0.4, 0.4, 0.4));
		end

		self.LayoutEntity = function(entity)
		end
	end
end

function PANEL:Think()
	if (self.HoveredOver == true) then
		self.CameraPosVector = LerpVector(FrameTime() * 5, self.CameraPosVector, self.HoveredCameraPos);
	else
		self.CameraPosVector = LerpVector(FrameTime() * 5, self.CameraPosVector, self.UnhoveredCameraPos);
	end

	self:SetCamPos(self.CameraPosVector or Vector(0.5, 0.5, 0.5));
end

vgui.Register("DMizmoItemModelVariant", PANEL, "DModelPanel");