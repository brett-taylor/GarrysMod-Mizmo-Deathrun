local listOfAnimals = {
    "Dog",
    "Cat",
    "Rabbit",
    "Lion",
    "Tiger",
    "Gorilla",
    "Human"
}

local function LoseHpMessage()
    return "namereplace was biten by a varreplace and so lost varreplace health points"
end

local function LoseHealth(ply)
    local hpToLose = math.random(1, 25);
    ply:SetHealth(ply:Health() - hpToLose);
    return { listOfAnimals[math.random(#listOfAnimals)], hpToLose };
end

RollTheDice.AddRoll(LoseHpMessage, LoseHealth);