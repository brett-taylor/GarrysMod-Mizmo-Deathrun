util.AddNetworkString("MizmoEndOfRoundBannerTrigger");
EndOfRound = {};

function EndOfRound.RoundEnded(winner)
	for k, v in pairs(player.GetAll()) do
		if (IsValid(v) == true && v:IsBot() == false) then
			if (v:Team() ~= TEAM_SPECTATOR) then
				if (v:Team() == winner) then
					if (v:Alive() == true) then
						EndOfRound.AlertPlayer(v, winner, 5, 5);
						-- Give exp
						-- Give Mizmos
					else
						EndOfRound.AlertPlayer(v, winner, 5, 5);
						-- Give exp
						-- Give Mizmos
					end
				else
					if (v:Alive() == true) then
						EndOfRound.AlertPlayer(v, winner, 5, 5);
						-- Give exp
						-- Give Mizmos
					else
						EndOfRound.AlertPlayer(v, winner, 5, 5);
						-- Give exp
						-- Give Mizmos
					end
				end
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