util.AddNetworkString("MizmoUniqueRoundTurnAutoJumpOff");
local NoAutoJumpSpecial = {};
NoAutoJumpSpecial.Name = "No Autojump Round";
NoAutoJumpSpecial.Help = "For this round autojump has been disabled for everybody, goodluck! Deaths are not affected.";

NoAutoJumpSpecial.OnRoundPrep = function()
end

NoAutoJumpSpecial.OnRoundStart = function()
	AutoJumpServer.UniqueRoundNoJump = true;
	net.Start("MizmoUniqueRoundTurnAutoJumpOff")
		net.WriteBool(AutoJumpServer.UniqueRoundNoJump);
	net.Broadcast();
end

NoAutoJumpSpecial.OnRoundEnd = function()
	AutoJumpServer.UniqueRoundNoJump = false;
	net.Start("MizmoUniqueRoundTurnAutoJumpOff")
		net.WriteBool(AutoJumpServer.UniqueRoundNoJump);
	net.Broadcast();
end

NoAutoJumpSpecial.Think = function()
end

UniqueRounds.AddType(NoAutoJumpSpecial.Name, NoAutoJumpSpecial.Help, NoAutoJumpSpecial.OnRoundPrep, NoAutoJumpSpecial.OnRoundStart, NoAutoJumpSpecial.OnRoundEnd, NoAutoJumpSpecial.Think);