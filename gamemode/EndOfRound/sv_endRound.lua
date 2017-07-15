util.AddNetworkString("MizmoEndOfRoundBannerTrigger");
util.AddNetworkString("MizmoEndOfRoundBannerTriggerSpectator");
EndOfRound = {};

function EndOfRound.RoundEnded(winner)
	for k, v in pairs(player.GetAll()) do
		if (IsValid(v) == true && v:IsBot() == false) then
			if (v:Team() ~= TEAM_SPECTATOR) then
				if (v:Team() == winner) then
					if (v:Alive() == true) then
						EndOfRound.AlertPlayer(v, winner, 20, 100);
						v:PS_GivePoints(20)
						v:AddExp(100) 
					else
						EndOfRound.AlertPlayer(v, winner, 15, 75);
						v:PS_GivePoints(15)
						v:AddExp(75)
					end
				else
					if (v:Alive() == true) then
						EndOfRound.AlertPlayer(v, winner, 10, 50);
						v:PS_GivePoints(10)
						v:AddExp(50)
					else
						EndOfRound.AlertPlayer(v, winner, 10, 50);
						v:PS_GivePoints(10)
						v:AddExp(50)
					end
				end
			else
				net.Start("MizmoEndOfRoundBannerTriggerSpectator");
					net.WriteString(winner);
				net.Send(v);
			end
		end
	end
end
hook.Add("DeathrunRoundWin", "MizmoEndOfRound", EndOfRound.RoundEnded);

function EndOfRound.AlertPlayer(ply, winnerString, pointsGiven, expGive)
	net.Start("MizmoEndOfRoundBannerTrigger");
		net.WriteString(winnerString);
		net.WriteFloat(tonumber(pointsGiven));
		net.WriteFloat(tonumber(expGive));
	net.Send(ply);
end