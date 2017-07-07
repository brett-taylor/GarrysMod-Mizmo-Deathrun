util.AddNetworkString("UpdateAutoJumpStatus");
AutoJumpServer = {};
AutoJumpServer.Enabled = true;

function AutoJumpServer.RoundStarted()
	AutoJumpServer.ChangeAutoJump(false, true);
	timer.Create("MizmoServerAutoJumpTempDisabled", 20, 0, function() AutoJumpServer.ChangeAutoJump(true, false) end);
end
hook.Add("DeathrunBeginActive", "MizmoDisableAutojumpStartServer", AutoJumpServer.RoundStarted);

function AutoJumpServer.RoundEnded()
	timer.Stop("MizmoServerAutoJumpTempDisabled");
	AutoJumpServer.ChangeAutoJump(true, false);
end
hook.Add("DeathrunBeginOver", "MizmoDisableAutojumpEndServer", AutoJumpServer.RoundEnded);
hook.Add("DeathrunBeginWaiting", "MizmoDisableAutojumpEndServerWaiting", AutoJumpServer.RoundEnded);
hook.Add("DeathrunBeginPrep", "MizmoDisableAutojumpEndServerBeginActive", AutoJumpServer.RoundEnded);

function AutoJumpServer.ChangeAutoJump(enabled, countdown)
	AutoJumpServer.Enabled = enabled;
	net.Start("UpdateAutoJumpStatus");
		net.WriteBool(AutoJumpServer.Enabled);
		net.WriteBool(countdown);
	net.Broadcast();
end