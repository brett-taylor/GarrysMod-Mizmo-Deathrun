local function GiveMizmosMessage()
    return "namereplace gained varreplace Mizmos"
end

local function GiveMizmos(ply)
    local mizmosToGive = math.random(20, 100);
    ply:PS_GivePoints(mizmosToGive);
    return { mizmosToGive };
end

RollTheDice.AddRoll(GiveMizmosMessage, GiveMizmos);