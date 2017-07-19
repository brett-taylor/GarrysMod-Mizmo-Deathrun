local PANEL = {};

function PANEL:SetColour(colour)
	self.AccentColour = colour;
end

function PANEL:Init()
	self.AccentColour = Colours.gold;

	self:GetVBar().Paint = function(s, w, h)
		surface.SetDrawColor(Colours.GreyDark);
		surface.DrawRect(0, 0, w, h);
	end

	self:GetVBar().btnGrip.Paint = function(s, w, h)
		surface.SetDrawColor(self.AccentColour);
		surface.DrawRect(0, 0, w, h);

		surface.SetDrawColor(Colours.Grey);
		surface.DrawRect(2, 2, w - 4, h - 4);
	end

	self:GetVBar().btnUp.Paint = function(s, w, h)
		surface.SetDrawColor(self.AccentColour);
		surface.DrawRect(0, 0, w, h);

		surface.SetDrawColor(Colours.Grey);
		surface.DrawRect(2, 2, w - 4, h - 4);
	end

	self:GetVBar().btnDown.Paint = function(s, w, h)
		surface.SetDrawColor(self.AccentColour);
		surface.DrawRect(0, 0, w, h);

		surface.SetDrawColor(Colours.Grey);
		surface.DrawRect(2, 2, w - 4, h - 4);
	end
end

vgui.Register("DMizmoScroll", PANEL, "DScrollPanel");