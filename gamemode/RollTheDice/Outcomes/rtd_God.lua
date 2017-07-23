local function GiveGodMessage()
    return "namereplace recieved god for varreplace seconds. Where the heck is my on screen timer?"
end

local function GiveGod(ply)
    local godTimer = math.random(5, 10);
    ply:GodEnable()
    timer.Simple(godTimer, function()
        ply:GodDisable();
    end)

    return { godTimer };
end

RollTheDice.AddRoll(GiveGodMessage, GiveGod);