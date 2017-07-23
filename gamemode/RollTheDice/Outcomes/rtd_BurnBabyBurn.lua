local function FireMesage()
    return "namereplace was ignited by a pyromaniac for varreplace seconds. Where the heck is my on screen timer?"
end

local function SetOnFire(ply)
    local fireTimer = math.random(5, 10);
    ply:Ignite(fireTimer, 1);

    return { fireTimer };
end

RollTheDice.AddRoll(FireMesage, SetOnFire);