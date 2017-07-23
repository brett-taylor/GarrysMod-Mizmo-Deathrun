local function GiveHpMessage()
    return "namereplace recieved varreplace health points"
end

local function GiveHealth(ply)
    local hpToGain = math.random(1, 50);
    ply:SetHealth((ply:Health() or 0) + tonumber(hpToGain));
    return { hpToGain };
end

RollTheDice.AddRoll(GiveHpMessage, GiveHealth);