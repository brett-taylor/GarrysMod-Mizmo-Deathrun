local Singers = {
    "Madonna",
    "Selena Gomez",
    "Miley Cyrus",
    "Justin Bieber"
}

local function LoseExpMessage()
    return "namereplace was in a song with varreplace and so lost varreplace experience points"
end

local function LoseExp(ply)
    local expToLose = math.random(10, 100);
    ply:RemoveExp(expToLose) 
    return { Singers[math.random(#Singers)], expToLose };
end

RollTheDice.AddRoll(LoseExpMessage, LoseExp);