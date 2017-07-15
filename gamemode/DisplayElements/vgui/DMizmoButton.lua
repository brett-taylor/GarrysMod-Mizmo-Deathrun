local PANEL = {}

function PANEL:Init()
	self:SetText("");
	self:SetTextColor(Color(255, 255, 255, 0));
	self.Font = "MizmoGaming-Button-Medium";
	self.Text = "DMizmoButton";
	self.TextColor = Color(200, 200, 200);
	self.TextOutline = true;
	self.TextOutlineWidth = 1;
	self.TextOutlineColor = Color(0, 0, 0);
	self.Outline = true;
	self.OutlineWidth = 2;
	self.OutlineColour = Colours.Gold;
	self.BackgroundColour = Colours.Grey;

	self.FadeMultipler = 5;
	self.BackgroundColourHover = Color(20, 20, 20);
	self.OutlineColourHover = Color(230, 60, 100);
	self.TextColourHovered = Color(255, 255, 255);
	self.TextColourOutlineHovered = Color(230, 60, 100);

	self.OnClicked = nil;
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
	surface.PlaySound("UI/buttonclick.wav");
	if (self.OnClicked ~= nil) then
		self.OnClicked();
	end
end

function PANEL:SetTextSmall()
	self.Font = "MizmoGaming-Button-Small";
end

function PANEL:SetTextMedium()
	self.Font = "MizmoGaming-Button-Medium";
end

function PANEL:SetTextLarge()
	self.Font = "MizmoGaming-Button-Large";
end

function PANEL:SetFont(font)
	self.Font = font;
end

function PANEL:SetText(text)
	self.Text = text;
end

function PANEL:SetTextColour(color)
	self.TextColor = color;
end

function PANEL:EnableTextOutline()
	self.TextOutline = true;
end

function PANEL:DisableTextOutline()
	self.TextOutline = false;
end

function PANEL:SetOutlineWidth(width)
	self.OutlineWidth = width;
end

function PANEL:SetTextOutlineColour(color)
	self.TextOutlineColor = color;
end

function PANEL:EnableOutline()
	self.Outline = true;
end

function PANEL:DisableOutline()
	self.Outline = false;
end

function PANEL:SetOutlineWidth(width)
	self.OutlineWidth = width;
end

function PANEL:SetOutlineColour(color)
	self.OutlineColour = color;
end

function PANEL:SetColour(color)
	self.BackgroundColour = color;
end

function PANEL:SetFadeMultipler(m)
	self.FadeMultipler = m;
end

function PANEL:SetColourHovered(color)
	self.BackgroundColourHover = color;
end

function PANEL:SetOutlineColouredHovered(color)
	self.OutlineColourHover = color;
end

function PANEL:SetTextColourHovered(color)
	self.TextColourHovered = color;
end

function PANEL:SetTextOutlineColourHovered(color)
	self.TextColourOutlineHovered = color;
end

function PANEL:Paint(w, h)
	self.CurrentOutlineColour = self.CurrentOutlineColour or self.OutlineColour;
	self.CurrentBGColour = self.CurrentBGColour or self.BackgroundColour;
	self.CurrentTextColour = self.CurrentTextColour or self.TextColor;
	self.CurrentTextOutlineColour = self.CurrentTextOutlineColour or self.TextOutlineColor;

	if (self.HoveredOver == true) then
		self.CurrentOutlineColour = Util.LerpColour(FrameTime() * self.FadeMultipler, self.CurrentOutlineColour, self.OutlineColourHover);
		self.CurrentBGColour = Util.LerpColour(FrameTime() * self.FadeMultipler, self.CurrentBGColour, self.BackgroundColourHover);
		self.CurrentTextColour = Util.LerpColour(FrameTime() * self.FadeMultipler, self.CurrentTextColour, self.TextColourHovered);
		self.CurrentTextOutlineColour = Util.LerpColour(FrameTime() * self.FadeMultipler, self.CurrentTextOutlineColour, self.TextColourOutlineHovered);
	else
		self.CurrentOutlineColour = Util.LerpColour(FrameTime() * self.FadeMultipler, self.CurrentOutlineColour, self.OutlineColour);
		self.CurrentBGColour = Util.LerpColour(FrameTime() * self.FadeMultipler, self.CurrentBGColour, self.BackgroundColour);
		self.CurrentTextColour = Util.LerpColour(FrameTime() * self.FadeMultipler, self.CurrentTextColour, self.TextColor);
		self.CurrentTextOutlineColour = Util.LerpColour(FrameTime() * self.FadeMultipler, self.CurrentTextOutlineColour, self.TextOutlineColor);
	end

	if (self.Outline == true) then
		surface.SetDrawColor(self.CurrentOutlineColour);
		surface.DrawRect(0, 0, w, h);

		surface.SetDrawColor(self.CurrentBGColour);
		surface.DrawRect(self.OutlineWidth, self.OutlineWidth, w - (self.OutlineWidth * 2), h - (self.OutlineWidth) * 2);
	else
		surface.SetDrawColor(self.CurrentBGColour);
		surface.DrawRect(0, 0, w, h);
	end

	if (self.TextOutline == true) then
		draw.SimpleTextOutlined(self.Text, self.Font, w / 2, h / 2, self.CurrentTextColour, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, self.TextOutlineWidth, self.CurrentTextOutlineColour);
	else
		draw.SimpleText(self.Text, self.Font, w / 2, h / 2, self.CurrentTextColour, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER);
	end
end

vgui.Register("DMizmoButton", PANEL, "DButton");