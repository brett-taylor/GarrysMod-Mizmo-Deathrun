local function LoseMizmosMessage()
    return "namereplace lost their wallet and so lost varreplace Mizmos"
end

local function LoseMizmos(ply)
    local amountToBeRemoved = math.random(10, 30);
    ply:PS_TakePoints(amountToBeRemoved);
    return { amountToBeRemoved };
end

RollTheDice.AddRoll(LoseMizmosMessage, LoseMizmos);