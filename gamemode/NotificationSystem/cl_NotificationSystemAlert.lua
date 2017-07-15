MizmoAlert = {}

function MizmoAlert.GenerateNotification(listitem, string, seconds)
	local parent =  vgui.Create("DPanel");
	parent.TimeLeft = tonumber(seconds);
	parent.FullTime = tonumber(seconds);
	parent.offsetX = 300;
	parent.shouldRemove = false;

	parent:SetSize(listitem:GetWide(), 40);
	parent.Paint = function(self, w, h)
		draw.RoundedBox(0, parent.offsetX, 0, w, h, Colours.Gold);
		draw.RoundedBox(0, parent.offsetX + 2, 2, w - 4, h - 4, Colours.Grey);
		draw.RoundedBox(0, parent.offsetX + 2, h - 7, math.Clamp((parent.TimeLeft / parent.FullTime) * (w - 4), 0, w - 4), 5, Colours.HealthRed);
	 	draw.SimpleText(string, "MizmoGaming-Notification-Title", parent.offsetX + 7, 20, Color(255, 255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER);
	end
	parent.Think = function()
		if (parent.offsetX > 5 && parent.shouldRemove == false) then
			parent.offsetX = parent.offsetX - (FrameTime() * 300);
			if (parent.offsetX < 0) then
				parent.offsetX = 0;
			end
		end

		if (parent.shouldRemove == true) then
			parent.offsetX = parent.offsetX + (FrameTime() * 300);
		end

		if (parent.shouldRemove == true && parent.TimeLeft < 0 && parent.offsetX > 310) then
			parent:Remove();
		end

		parent.TimeLeft = parent.TimeLeft - FrameTime();
		if (parent.TimeLeft < 0) then
			parent.shouldRemove = true;
		end
	end

	surface.PlaySound("UI/buttonclick.wav");
	return parent;
end