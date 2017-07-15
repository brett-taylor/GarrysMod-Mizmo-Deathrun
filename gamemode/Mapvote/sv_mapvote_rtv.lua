MapvoteRTV = {};
MapvoteRTV.PlayersVoted = {}
function MapvoteRTV.Vote(ply)
	if (table.HasValue(MapvoteRTV.PlayersVoted, ply) == true) then
		ply:Notify("You have already voted for a map change!", 10);
		return;
	end

	table.insert(MapvoteRTV.PlayersVoted, ply);
	local success = MapvoteRTV.Check();
	MapvoteRTV.AlertServer(ply:Nick(), success);
end

function MapvoteRTV.Check()
	// If more than 3 players then 50% must have voted, otherwise all players must have voted
	if (#player.GetAll() > 3) then
		local amountNeeded = math.ceil((#player.GetAll() / 100) * 51);
		if (table.Count(MapvoteRTV.PlayersVoted) < amountNeeded) then
			return false;
		end 
	else
		if (table.Count(MapvoteRTV.PlayersVoted) < #player.GetAll()) then
			return false;
		end
	end

	MapVote.Start(15, false, 12, { "deathrun", "dr" });
	return true;
end

function MapvoteRTV.AlertServer(name, success)
	if (success) then
		Util.SendMessage("The players have spoken! Vote for your map now.");
	else
		local amountNeeded = 0;
		if (#player.GetAll() > 3) then
			amountNeeded = math.ceil((#player.GetAll() / 100) * 51);
		else
			amountNeeded = #player.GetAll();
		end
		amountNeeded = amountNeeded - #MapvoteRTV.PlayersVoted;
		if (amountNeeded == 1) then
			Util.SendMessage(name.." wants a map change! Type !mapvote to join them! "..amountNeeded.. " votes needed to initiate map change. Only ONE more vote needed.");
		else
			Util.SendMessage(name.." wants a map change! Type !mapvote to join them! "..amountNeeded.. " votes needed to initiate map change. "..amountNeeded.." more votes needed.");
		end
	end
end

function MapvoteRTV.PlayerDisconneted(ply)
	table.RemoveByValue(MapvoteRTV.PlayersVoted, ply);
end
hook.Add("PlayerDisconnected", "MizmoRTVPlayerRemove", MapvoteRTV.PlayerDisconneted);

function ulx.TriggerRTV(callingPlayer)
	MapvoteRTV.Vote(callingPlayer);
end

local triggerRTV = ulx.command("rtv", "ulx rtv", ulx.TriggerRTV, {"!rtv", "!rockthevote", "!mapvote"});
triggerRTV:defaultAccess(ULib.ACCESS_ALL);
triggerRTV:help("Rocks the vote.");