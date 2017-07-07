EndOfRound = {};
EndOfRound.ParentPanel = nil;
EndOfRound.Lerp = 0;
EndOfRound.SpeedMultipler = 1;
EndOfRound.Closing = 0;

function EndOfRound.CreatePanel(winner, mizmosToGive, expToGive)
	EndOfRound.Lerp = 0;
	EndOfRound.Closing = 0;
	EndOfRound.ParentPanel = vgui.Create("DFrame");
	EndOfRound.ParentPanel:SetPos(-5, 150);
	EndOfRound.ParentPanel:SetSize(ScrW() + 10, 150);
	EndOfRound.ParentPanel:SetTitle("");
	EndOfRound.ParentPanel:ShowCloseButton(false);
	EndOfRound.ParentPanel:SetDeleteOnClose(true);
	EndOfRound.ParentPanel.Paint = function(self, w, h)
		local slantedRectangle = {
			{ x = 0, y = 0 },
			{ x = w * EndOfRound.Lerp, y = 16 },
			{ x = w * EndOfRound.Lerp, y = h - 16 },
			{ x = 0, y = h },
		}

		surface.SetDrawColor(ColorAlpha(Colours.Gold, math.Clamp(230 * EndOfRound.Lerp, 100, 230)));
		draw.NoTexture();
		surface.DrawPoly(slantedRectangle);

		draw.SimpleText(winner, "MizmoGaming-EndOfRound-Big", ScrW() / 2, 75, Color(255, 255, 255, 255 * EndOfRound.Lerp), TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM);
		draw.SimpleText("You recieved "..mizmosToGive.." Mizmos and "..expToGive.." Experience.", "MizmoGaming-EndOfRound-Small", ScrW() / 2, 80, Color(255, 255, 255, 255 * EndOfRound.Lerp), TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP);
	end
	EndOfRound.ParentPanel.Think = function()
		if (EndOfRound.Closing == 0) then
			EndOfRound.Lerp = math.Clamp(EndOfRound.Lerp + (FrameTime() * EndOfRound.SpeedMultipler), 0, 1);
		else
			EndOfRound.Lerp = math.Clamp(EndOfRound.Lerp - (FrameTime() * EndOfRound.SpeedMultipler), 0, 1);
		end

		if (EndOfRound.Closing == 1 && EndOfRound.Lerp == 0) then
			EndOfRound.HidePanel();
		end
	end

	timer.Simple(5, function() EndOfRound.Closing = 1 end);
end

function EndOfRound.HidePanel()
	EndOfRound.ParentPanel:Remove();
	EndOfRound.ParentPanel = nil;
end

net.Receive("MizmoEndOfRoundBannerTrigger", function()
	local winnerTeam = net.ReadString();
	local points = net.ReadString();
	local exp = net.ReadString();
	timer.Simple(1, function() EndOfRound.CreatePanel(winnerTeam, points, exp) end)
end)