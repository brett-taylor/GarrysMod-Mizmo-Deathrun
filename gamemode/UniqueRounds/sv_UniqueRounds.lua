UniqueRounds = {};
UniqueRounds.Specials = {};
UniqueRounds.CurrentSpecial = nil;
UniqueRounds.Count = 0;

UniqueRounds.Special = {};
UniqueRounds.Special.Name = nil;
UniqueRounds.Special.Help = nil;
UniqueRounds.Special.OnRoundPrep = nil;
UniqueRounds.Special.OnRoundStart = nil;
UniqueRounds.Special.OnRoundEnd = nil;
UniqueRounds.Special.Think = nil;

function UniqueRounds.AddType(name, Help, OnRoundPrep, OnRoundStart, OnRoundEnd, Think)
	local special = table.Copy(UniqueRounds.Special);
	special.Name = name;
	special.Help = Help;
	special.OnRoundPrep = OnRoundPrep;
	special.OnRoundStart = OnRoundStart;
	special.OnRoundEnd = OnRoundEnd;
	special.Think = Think;

	UniqueRounds.Specials[(table.Count(UniqueRounds.Specials) + 1)] = special;
end

function UniqueRounds.DecideType()
	if (table.Count(UniqueRounds.Specials) == 0) then
		return;
	end

	local random = math.random(0, 100);
	if (random > 20) then
		return;
	end
	UniqueRounds.Count = UniqueRounds.Count + 1;
	if (UniqueRounds.Count >= 2) then
		return;
	end

	UniqueRounds.CurrentSpecial = UniqueRounds.Specials[math.random(1, table.Count(UniqueRounds.Specials))];
	UniqueRounds.PrepRound()
	if (UniqueRounds.CurrentSpecial ~= nil) then
		Notify.SendNotificationAll("Special Round: "..UniqueRounds.CurrentSpecial.Name, 10);
		Util.SendMessage(""..UniqueRounds.CurrentSpecial.Name..": "..UniqueRounds.CurrentSpecial.Help);
	end
end
hook.Add("DeathrunBeginPrep", "MizmoUniqueRoundSystemDeide", UniqueRounds.DecideType);

function UniqueRounds.Think()
	if (UniqueRounds.CurrentSpecial ~= nil) then
		UniqueRounds.CurrentSpecial.Think();
	end
end
hook.Add("Think", "MizmoUnqiueRoundThink", UniqueRounds.Think);

function UniqueRounds.PrepRound()
	if (UniqueRounds.CurrentSpecial ~= nil) then
		UniqueRounds.CurrentSpecial.OnRoundPrep();
	end
end

function UniqueRounds.StartRound()
	if (UniqueRounds.CurrentSpecial ~= nil) then
		UniqueRounds.CurrentSpecial.OnRoundStart();
	end
end
hook.Add("DeathrunBeginActive", "MizmoUniqueRoundStartRound", UniqueRounds.StartRound);

function UniqueRounds.EndRound()
	if (UniqueRounds.CurrentSpecial ~= nil) then
		UniqueRounds.CurrentSpecial.OnRoundEnd();
		UniqueRounds.CurrentSpecial = nil;
	end
end
hook.Add("DeathrunBeginOver", "MizmoUniqueRoundEndRound", UniqueRounds.EndRound);

include("Specials/sv_NoAutojump.lua");
AddCSLuaFile("Specials/cl_NoAutojump.lua");

include("Specials/sv_TrafficLights.lua");
AddCSLuaFile("Specials/cl_TrafficLights.lua");

include("Specials/sv_BlindMovement.lua");
AddCSLuaFile("Specials/cl_BlindMovement.lua");