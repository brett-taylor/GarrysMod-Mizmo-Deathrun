local function GiveInvisibleMessage()
    return "namereplace gained invisibility for varreplace seconds. Where the heck is my on screen timer?"
end

local function GiveInvisible(ply)
    local invisTimer = math.random(5, 10);
    ply:SetNoDraw(true);
    timer.Simple(invisTimer, function()
        ply:SetNoDraw(false);
    end)

    return { invisTimer };
end

RollTheDice.AddRoll(GiveInvisibleMessage, GiveInvisible);