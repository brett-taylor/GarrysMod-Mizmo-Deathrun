local PANEL = {}

function PANEL:Init()
	self.Avatar = vgui.Create("DMizmoAvatar", self);
	self.Avatar:SetPlayer(LocalPlayer(), 64 );

	self.MizmosContainer = vgui.Create("DIconLayout", self);

	self.MizmosText = self.MizmosContainer:Add("DLabel");
	self.MizmosText:SetFont("MizmoGaming-Button-Medium");
	self.MizmosText:SetText("Mizmos: ");

	self.Mizmos = self.MizmosContainer:Add("DLabel");
	self.Mizmos:SetFont("MizmoGaming-Button-Medium");
	self.Mizmos:SetText("99");
	self.Mizmos:SetColor(Colours.Gold);

	self.LevelsContainer = vgui.Create("DIconLayout", self);

	self.LevelText = self.LevelsContainer:Add("DLabel");
	self.LevelText:SetFont("MizmoGaming-Button-Medium");
	self.LevelText:SetText("Level: ");

	self.Level = self.LevelsContainer:Add("DLabel");
	self.Level:SetFont("MizmoGaming-Button-Medium");
	self.Level:SetText("99");
	self.Level:SetColor(Colours.Gold);

	self:InvalidateLayout();
end

function PANEL:InvalidateLayout()
	if (self.Avatar ~= nil) then
		self.Avatar:SetSize(64, 64);
		self.Avatar:SetPos(0, 18);
	end

	if (self.MizmosContainer ~= nil) then
		self.MizmosContainer:SetSize(200, 30);
		self.MizmosContainer:SetPos(80, 50);
	end

	if (self.MizmosText ~= nil) then
		self.MizmosText:SizeToContents()
	end

	if (self.Mizmos ~= nil) then
		self.Mizmos:SizeToContents()
	end

	if (self.LevelsContainer ~= nil) then
		self.LevelsContainer:SetSize(200, 30);
		self.LevelsContainer:SetPos(80, 20);
	end

	if (self.LevelText ~= nil) then
		self.LevelText:SizeToContents()
	end

	if (self.Level ~= nil) then
		self.Level:SizeToContents()
	end
end

function PANEL:Think()
	if (self.Mizmos ~= nil) then
		self.Mizmos:SetText(LocalPlayer():PS_GetPoints());
		self.Mizmos:SizeToContents()
	end

	if (self.Level ~= nil) then
		self.Level:SetText(LocalPlayer():GetCurrentLevel());
		self.Level:SizeToContents()
	end
end

vgui.Register("DMizmoShopHeaderInfo", PANEL, "DPanel");