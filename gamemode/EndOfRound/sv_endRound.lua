util.AddNetworkString("MizmoEndOfRoundBannerTrigger");
EndOfRound = {};

function EndOfRound.RoundEnded(winner)
	for k, v in pairs(player.GetAll()) do
		if (IsValid(v) == true && v:IsBot() == false) then
			print(v);
			print(v);
			print(v);
			print(v);
			print(v);
			if (v:Team() ~= TEAM_SPECTATOR) then
				if (v:Team() == winner) then
					if (v:Alive() == true) then
						EndOfRound.AlertPlayer(v, EndOfRound.TeamName(winner), "X", "X");
						-- Give exp
						-- Give Mizmos
					else
						EndOfRound.AlertPlayer(v, EndOfRound.TeamName(winner), "X", "X");
						-- Give exp
						-- Give Mizmos
					end
				else
					if (v:Alive() == true) then
						EndOfRound.AlertPlayer(v, EndOfRound.TeamName(winner), "X", "X");
						-- Give exp
						-- Give Mizmos
					else
						EndOfRound.AlertPlayer(v, EndOfRound.TeamName(winner), "X", "X");
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
		net.WriteString(pointsGiven);
		net.WriteString(expGive);
	net.Send(ply);
end

function EndOfRound.TeamName(winner)
	if (winner == TEAM_RUNNER) then
		return "RUNNERS WIN!";
	elseif (winner == TEAM_DEATH) then
		return "DEATHS WIN!";
	else
		return "STALEMATE!";
	end
end