local NoAutoJumpSpecialClient = {};

net.Receive("MizmoUniqueRoundTurnAutoJumpOff", function()
	AutoJumpClient.UniqueRoundNoJump = net.ReadBool();
end);