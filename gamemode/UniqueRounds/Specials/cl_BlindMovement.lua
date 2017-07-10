local BlindMovementClient = {};
BlindMovementClient.Enabled = false;

function BlindMovementClient.HudPaint()
	if (BlindMovementClient.Enabled == false) then
		return;
	end

	if (LocalPlayer():Team() == TEAM_RUNNER) then
		draw.RoundedBox(1, 0, 0, ScrW(), ScrH(), ColorAlpha(Color(255, 255, 255), (math.Clamp(LocalPlayer():GetVelocity():Length(), 0, 375) / 375) * 255));
	end
end
hook.Add("HUDPaint", "MizmoUniqueRoundSystemBlindMovementHudPaint", BlindMovementClient.HudPaint);

net.Receive("MizmoUniqueRoundSystemBlindMovement", function()
	BlindMovementClient.Enabled = net.ReadBool();
end)