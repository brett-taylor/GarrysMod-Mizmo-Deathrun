function ulx.RollTheDice(callingPlayer)
    callingPlayer:RollTheDice();
end

local rtd = ulx.command("rtd", "ulx rtd", ulx.RollTheDice, {"!rollthedice", "!rtd"});
rtd:defaultAccess(ULib.ACCESS_ALL);
rtd:help("Rolls the dice.");