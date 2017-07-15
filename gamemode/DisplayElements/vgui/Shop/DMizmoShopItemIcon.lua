local PANEL = {};

function PANEL:Init()
	self:SetText("");

	self:InvalidateLayout();
end

function PANEL:InvalidateLayout()
	self:SetSize(150, 100);
end

function PANEL:Paint(w, h)
	draw.RoundedBox(16, 0, 0, w, h, Colours.Gold);
	draw.RoundedBox(16, 2, 2, w - 4, h - 4, Colours.Grey);
end

function PANEL:SetData(data)
	self.Data = data
	self.Info = data.Name
	
	if data.Model then
		local DModelPanel = vgui.Create('DModelPanel', self)
		DModelPanel:SetModel(data.Model)
		
		DModelPanel:Dock(FILL)
		DModelPanel:DockMargin(5, 5, 5, 5);
		
		if data.Skin then
			DModelPanel:SetSkin(data.Skin)
		end
		
		local PrevMins, PrevMaxs = DModelPanel.Entity:GetRenderBounds()
		DModelPanel:SetCamPos(PrevMins:Distance(PrevMaxs) * Vector(0.5, 0.5, 0.5))
		DModelPanel:SetLookAt((PrevMaxs + PrevMins) / 2)
		
		function DModelPanel:LayoutEntity(ent)
			if self:GetParent().Hovered then
				ent:SetAngles(Angle(0, ent:GetAngles().y + 2, 0))
			end
			
			local ITEM = PS.Items[data.ID]
			
			ITEM:ModifyClientsideModel(LocalPlayer(), ent, Vector(), Angle())
		end
		
		function DModelPanel:DoClick()
			self:GetParent():DoClick()
		end
		
		function DModelPanel:OnCursorEntered()
			self:GetParent():OnCursorEntered()
		end
		
		function DModelPanel:OnCursorExited()
			self:GetParent():OnCursorExited()
		end

	else
		local DImageButton = vgui.Create('DImageButton', self)
		DImageButton:SetMaterial(data.Material)
		DImageButton.m_Image.FrameTime = 0
		
		DImageButton:Dock(FILL)
		DImageButton:DockMargin(5, 5, 5, 5);
		
		function DImageButton:DoClick()
			self:GetParent():DoClick()
		end
		
		function DImageButton:OnCursorEntered()
			self:GetParent():OnCursorEntered()
		end
		
		function DImageButton:OnCursorExited()
			self:GetParent():OnCursorExited()
		end

		function DImageButton.m_Image:Paint(w, h)
			if not self:GetParent():GetParent().Data.NoScroll and self:GetParent():GetParent().Hovered then
				self.FrameTime = self.FrameTime + 1
			end

			self:PaintAt( 0, self.FrameTime % self:GetTall() - self:GetTall() , self:GetWide(), self:GetTall() )
			self:PaintAt( 0, self.FrameTime % self:GetTall(), 					self:GetWide(), self:GetTall() )
		end
	end
	
	if data.Description then
		self:SetTooltip(data.Description)
	end
end

vgui.Register("DMizmoShopItemIcon", PANEL, "DButton");