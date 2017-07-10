util.AddNetworkString("MizmoUnqiueRoundTrafficLight");
local TrafficLightSpecial = {};
TrafficLightSpecial.Name = "Traffic Lights";
TrafficLightSpecial.Help = "There are traffic lights on screen. Only move when its green. Deaths are not affected.";

TrafficLightSpecial.OnRoundPrep = function()
end

TrafficLightSpecial.OnRoundStart = function()
	TrafficLightSpecial.Status = 1;
	TrafficLightSpecial.Decide();
end

TrafficLightSpecial.OnRoundEnd = function()
	timer.Remove("MizmoUniqueRoundTrafficLightTimer");
	TrafficLightSpecial.Status = 0;
 	TrafficLightSpecial.UpdateClient();
end

TrafficLightSpecial.Think = function()
end

UniqueRounds.AddType(TrafficLightSpecial.Name, TrafficLightSpecial.Help, TrafficLightSpecial.OnRoundPrep, TrafficLightSpecial.OnRoundStart, TrafficLightSpecial.OnRoundEnd, TrafficLightSpecial.Think);

function TrafficLightSpecial.Decide()
	// If green switch to orange and wait 3 seconds
	if (TrafficLightSpecial.Status == 3) then
		TrafficLightSpecial.Status = 2;
		TrafficLightSpecial.DoTimer(3);

	// If orange switch to red and wait 2 - 7 seconds.
	elseif (TrafficLightSpecial.Status == 2) then
		TrafficLightSpecial.Status = 1;
		TrafficLightSpecial.DoTimer(2 + math.random(1, 5));
		hook.Add("Move", "MizmoUniqueRoundTrafficLightMove", TrafficLightSpecial.PlayerMoved);

	// If red switch to gren and wait 5 - 25 seconds.
	elseif (TrafficLightSpecial.Status == 1) then
		TrafficLightSpecial.Status = 3;
		TrafficLightSpecial.DoTimer(5 + math.random(1, 20));
		hook.Remove("Move", "MizmoUniqueRoundTrafficLightMove");
	end

	TrafficLightSpecial.UpdateClient()
end

function TrafficLightSpecial.UpdateClient()
	net.Start("MizmoUnqiueRoundTrafficLight")
		net.WriteFloat(TrafficLightSpecial.Status);
	net.Broadcast()
end

function TrafficLightSpecial.DoTimer(timeLeft)
	timer.Create("MizmoUniqueRoundTrafficLightTimer", timeLeft, 1, function() TrafficLightSpecial.Decide() end);
end

function TrafficLightSpecial.PlayerMoved(ply, moveData)
	if (ply:Team() == TEAM_RUNNER) then
		if (TrafficLightSpecial.Status == 1) then
			if (ply.LastTrafficLightSlap == nil || ply.LastTrafficLightSlap < CurTime()) then
				if (moveData:GetVelocity():Length() > 0.5) then
					ULib.slap(ply, 20, 10, false);
					ply.LastTrafficLightSlap = CurTime() + 1;
				end
			end
		end
	end
end