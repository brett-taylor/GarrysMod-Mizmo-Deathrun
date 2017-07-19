local PANEL = {};

function PANEL:Init()
	self.AccentColour = Colours.Gold;
	self:SetText("");
	self:SetEditable(true);
	self:SetUpdateOnType(true);
	self:SetHighlightColor(self.AccentColour);
	self.PlaceHolderText = true;
	self.OnUpdate = nil;
end

function PANEL:SetColour(colour)
	self.AccentColour = colour;
end

function PANEL:Paint(w, h)
	if (self:IsEditing()) then
		surface.SetDrawColor(Colours.Gold);
	else
		surface.SetDrawColor(self.AccentColour);
	end
	surface.DrawRect(0, 0, w, h);

	if (self:IsEditing()) then
		surface.SetDrawColor(Colours.Grey);
	else
		surface.SetDrawColor(Colours.GreyDark);
	end
	surface.DrawRect(2, 2, w - 4, h - 4);

	draw.SimpleText(self:GetValue(), "MizmoGaming-Button-Small", 5, h / 2, Colours.White, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER);
	if (self.PlaceHolderText) then
		draw.SimpleText("Search For A Name Of A Item...", "MizmoGaming-Button-Small", 5, h / 2, Colours.White, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER);
	end
end

function PANEL:OnValueChange(value)
	self.PlaceHolderText = false;
	if (self:GetValue() == "") then
		self.PlaceHolderText = true;
	end

	if (self.OnUpdate) then
		self.OnUpdate();
	end
end

vgui.Register("DMizmoTextEntry", PANEL, "DTextEntry");