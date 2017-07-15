function ulx.GiveMizmos(callingPlayer, targetPlayer, value)
	ulx.fancyLogAdmin(callingPlayer, "#A gave #T #s Mizmos.", targetPlayer, value);
	targetPlayer:PS_GivePoints(value);
end

local giveMizmos = ulx.command("User Management", "ulx mizmosadd", ulx.GiveMizmos, "!mizmosadd");
giveMizmos:defaultAccess(ULib.ACCESS_ADMIN);
giveMizmos:addParam{ type=ULib.cmds.PlayerArg };
giveMizmos:addParam{ type=ULib.cmds.NumArg };
giveMizmos:help("");

function ulx.SetMizmos(callingPlayer, targetPlayer, value)
	ulx.fancyLogAdmin(callingPlayer, "#A set #T's Mizmos to #s.", targetPlayer, value);
	targetPlayer:PS_SetPoints(value);
end

local setMizmos = ulx.command("User Management", "ulx mizmosset", ulx.SetMizmos, "!mizmosset");
setMizmos:defaultAccess(ULib.ACCESS_ADMIN);
setMizmos:addParam{ type=ULib.cmds.PlayerArg };
setMizmos:addParam{ type=ULib.cmds.NumArg };
setMizmos:help("");