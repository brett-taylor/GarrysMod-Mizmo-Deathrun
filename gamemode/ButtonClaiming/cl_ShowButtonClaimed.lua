ButtonClaimingClient = {};
ButtonClaimingClient.Buttons = {};
ButtonClaimingClient.ClaimingRadius = 75;

net.Receive("MizmoUpdateClaimedButtonsTable", function()
	ButtonClaimingClient.Buttons = net.ReadTable();
end)

function ButtonClaimingClient.DrawClaimedButtons()
	if (LocalPlayer():Team() == TEAM_RUNNER) && (LocalPlayer():GetNWString(PlayerSettings.Enums.IS_DEBUGGING.Name) == "0") then 
		return;
 	end

	for k, v in pairs(ButtonClaimingClient.Buttons) do
		local distanceFromButton = v.Position:Distance(LocalPlayer():EyePos());
		if (distanceFromButton < ButtonClaimingClient.ClaimingRadius * 3) then
			local textAlpha = 255;
			local x = v.Position:ToScreen().x;
			local y = v.Position:ToScreen().y;
			local claimtext = "Unclaimed";

			if (distanceFromButton > ButtonClaimingClient.ClaimingRadius) then
				textAlpha = Lerp(InverseLerp(distanceFromButton, ButtonClaimingClient.ClaimingRadius, ButtonClaimingClient.ClaimingRadius * 3), 255, 0);
			end

			for _, ply in ipairs(team.GetPlayers(TEAM_DEATH)) do
				if (ply:SteamID() == v.ClaimedPlayer) then
					claimtext = "Claimed by "..ply:Nick();
				end
			end
			draw.SimpleText(claimtext , "MizmoGaming-Button-Claimed", x, y, Color(v.Claimed and 255 or 100, (not v.Claimed) and 255 or 100,100, textAlpha), TEXT_ALIGN_CENTER);
		end
	end
end
hook.Add("HUDPaint", "MizmoDrawClaimedButtons", ButtonClaimingClient.DrawClaimedButtons);