util.AddNetworkString("MizmoUniqueRoundSystemBlindMovement");
local BlindMovement = {};
BlindMovement.Name = "Blind Movement";
BlindMovement.Help = "Movement will blind you! Stay still to see! Deaths are not affected.";

BlindMovement.OnRoundPrep = function()
end

BlindMovement.OnRoundStart = function()
	net.Start("MizmoUniqueRoundSystemBlindMovement");
		net.WriteBool(true);
	net.Broadcast();
end

BlindMovement.OnRoundEnd = function()
	net.Start("MizmoUniqueRoundSystemBlindMovement");
		net.WriteBool(false);
	net.Broadcast();
end

BlindMovement.Think = function()
end

//UniqueRounds.AddType(BlindMovement.Name, BlindMovement.Help, BlindMovement.OnRoundPrep, BlindMovement.OnRoundStart, BlindMovement.OnRoundEnd, BlindMovement.Think);