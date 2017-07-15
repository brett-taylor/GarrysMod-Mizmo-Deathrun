EndOfRound = {};
EndOfRound.ParentPanel = nil;
EndOfRound.RunnersPicture = nil;
EndOfRound.DeathsPicture = nil;
EndOfRound.LastWinner = nil;

function EndOfRound.CreatePanel(winner)
	EndOfRound.ParentPanel =  vgui.Create("DPanel");
	EndOfRound.ParentPanel:SetSize((ScrW() / 100) * 50, (ScrH() / 100) * 50);
	EndOfRound.ParentPanel:Center();
	EndOfRound.LastWinner = winner;
	EndOfRound.ParentPanel.Paint = function(self, w, h)
		surface.SetDrawColor(255, 255, 255, 255);
		if (tonumber(winner) == 2) then
			surface.SetMaterial(EndOfRound.DeathsPicture);
		else
			surface.SetMaterial(EndOfRound.RunnersPicture);
		end
		surface.DrawTexturedRect(0, 0, w, h);
	end

	timer.Simple(7, function() EndOfRound.HidePanel() end);
end

function EndOfRound.HidePanel()
	EndOfRound.ParentPanel:Remove();
	EndOfRound.ParentPanel = nil;
end

function EndOfRound.GetMaterials()
	EndOfRound.RunnersPicture = Material("Mizmo-Gaming-Downloads/End-Of-Round-Banners/mizmorunnervten.png");
	EndOfRound.DeathsPicture = Material("Mizmo-Gaming-Downloads/End-Of-Round-Banners/mizmodeathvfour.png");
end
EndOfRound.GetMaterials();

net.Receive("MizmoEndOfRoundBannerTrigger", function()
	local winnerTeam = net.ReadString();
	local mizmosGiven = net.ReadFloat();
	local expGiven = net.ReadFloat();
	timer.Simple(1, function() 
		EndOfRound.CreatePanel(winnerTeam);
		NotificationSystemMenu.Notify("You recieved "..tostring(mizmosGiven).." Mizmos & "..tonumber(expGiven).." Experience points.", 7);
	end)
end)

net.Receive("MizmoEndOfRoundBannerTriggerSpectator", function()
	local winnerTeam = net.ReadString();
	timer.Simple(1, function() 
		EndOfRound.CreatePanel(winnerTeam);
		NotificationSystemMenu.Notify("You were spectating so recieved nothing.", 7);
	end)
end)
