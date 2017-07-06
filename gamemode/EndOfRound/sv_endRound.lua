EndOfRound = {};

function EndOfRound.RoundEnded(winner)
	-- Give Points & Exp
	-- Show end of round banner
	-- cut scene maybe?
	if (winner == TEAM_RUNNER) then
		Util.SendMessage("Runners have won.");
	elseif (winner == TEAM_DEATH) then
		Util.SendMessage("Deaths have won.");
	end
end
hook.Add("DeathrunRoundWin", "MizmoEndOfRound", EndOfRound.RoundEnded);