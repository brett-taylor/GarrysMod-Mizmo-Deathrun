util.AddNetworkString("UpdateAutoJumpStatus");
AutoJumpServer = {};
AutoJumpServer.Enabled = true;
AutoJumpServer.UniqueRoundNoJump = false;

function AutoJumpServer.RoundStarted()
	AutoJumpServer.ChangeAutoJump(false, true);
	timer.Create("MizmoServerAutoJumpTempDisabled", 59, 0, function() AutoJumpServer.ChangeAutoJump(true, false) end);
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

function ulx.ToggleAutoJump(callingPlayer)
	local currentSetting = callingPlayer:GetSetting(PlayerSettings.Enums.AUTO_JUMP.Name);
	if (tonumber(currentSetting) >= 1) then
		callingPlayer:SetSetting(PlayerSettings.Enums.AUTO_JUMP.Name, 0);
		callingPlayer:Notify("You disabled auto-jump.", 5);
	else
		callingPlayer:SetSetting(PlayerSettings.Enums.AUTO_JUMP.Name, 1);
		callingPlayer:Notify("You enabled auto-jump.", 5);
	end
end

local toggleAJ = ulx.command("toggleautojump", "ulx toggleautojump", ulx.ToggleAutoJump, {"!autojump", "!autoj", "!auto"});
toggleAJ:defaultAccess(ULib.ACCESS_ALL);
toggleAJ:help("Toggles autojump on or off.");