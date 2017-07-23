local someReasonsToDie = {
    "Aids",
    "HIV",
    "Playing Too Much Mizmo-Gaming",
    "Not Donating To Mizmo-Gaming",
    "Playing With Fire",
    "Not Playing With Fire"
}

local function DieMessage()
    return "namereplace died from varreplace"
end

local function Die(ply)
    ply:Kill();
    return { someReasonsToDie[math.random(#someReasonsToDie)] };
end

RollTheDice.AddRoll(DieMessage, Die);