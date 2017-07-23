local Actors = {
    "Dohnny Jepp",
    "Prad Bitt",
    "Robert Downey Jr",
    "Hom Tanks",
    "Waisie Milliams",
    "Com Truise",
    "Lennifer Jawrence",
    "Patalie Nortman"
}

local TypeOfFilms = {
    "Action",
    "Thriller",
    "Comedy",
    "Romance",
    "Porn"
}

local function GainExpMessage()
    return "namereplace was in a varreplace film with varreplace and so gained varreplace experience points"
end

local function GainExp(ply)
    local expToGain = math.random(50, 500);
    ply:AddExp(expToGain) 
    return { TypeOfFilms[math.random(#TypeOfFilms)], Actors[math.random(#Actors)], expToGain };
end

RollTheDice.AddRoll(GainExpMessage, GainExp);