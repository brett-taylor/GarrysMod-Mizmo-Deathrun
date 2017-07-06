Scoreboard = {};
Scoreboard.Parent = nil;

-- Hides the default scoreboard and opens our custom scoreboard.
function Scoreboard.OpenScoreboard()
	Scoreboard.CreateScoreboard();
	return false;
end
hook.Add("ScoreboardShow", "MizmoShowScoreboard", Scoreboard.OpenScoreboard);

-- Hides our scoreboard when tab is released
function Scoreboard.CloseScoreboard()
	Scoreboard.Parent:Hide();
end
hook.Add("ScoreboardHide", "MizmoHideScoreboard", Scoreboard.CloseScoreboard); 

-- Creates the actual scoreboard if the scoreboard does not already exist.
function Scoreboard.CreateScoreboard()
	if (IsValid(Scoreboard.Parent)) then
		-- Update the scoreboard with the new players and other changes since then -> Maybe a 1 second timer if open or something?
		Scoreboard.Parent:Show();
		return;
	end

	Scoreboard.CreateBase();
end

function Scoreboard.CreateBase()
	Scoreboard.Parent = vgui.Create("DFrame");
	Scoreboard.Parent:SetSize(500, 500);
	Scoreboard.Parent:SetPos(ScrW() / 2 - 250, ScrH() / 2 - 250);
	Scoreboard.Parent:Show();
end
