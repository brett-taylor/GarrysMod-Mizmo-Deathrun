RollTheDice = {};
RollTheDice.IsAble = false;
RollTheDice.Outcomes = {};

RollTheDice.OutcomeTemplate = {};
RollTheDice.OutcomeTemplate.MsgFunction = nil;
RollTheDice.OutcomeTemplate.RollFunction = nil;

local meta = FindMetaTable("Player");
function meta:RollTheDice()
    RollTheDice.AttemptRollTheDice(self);
end

function RollTheDice.AttemptRollTheDice(ply)
    if (IsValid(ply) == false) then
        return;
    end

    if (ply:GetSetting(PlayerSettings.Enums.IS_DEBUGGING.Name) == "0") then
        if (ply:Alive() == false) then
            RollTheDice.DoFailedAlert("You can't roll dice if you're dead");
            return;
        end

        if (RollTheDice.IsAble == false) then
            RollTheDice.DoFailedAlert("It must be an active round to roll");
            return;
        end

        if (ply:PS_HasPoints(20) == false) then
            RollTheDice.DoFailedAlert("You must have 20 Mizmos to roll");
            return;
        end

        if (ply.CanRoll == nil || ply.CanRoll == false) then
            RollTheDice.DoFailedAlert("You have already rolled this round");
            return;
        end
    end

    ply:PS_TakePoints(20);
    ply.CanRoll = false;
    local rtd = RollTheDice.Outcomes[math.random(#RollTheDice.Outcomes)];
    local results = rtd.RollFunction(ply);
    RollTheDice.AlertServer(ply, rtd, results);
    ply:Notify("That cost 20 Mizmos.", 5)
end

function RollTheDice.AlertServer(ply, rtd, results)
    local stringTable = string.Explode(" ", rtd.MsgFunction());
    local newStringTable = {};

    local var = 1;
    for i = 1, #stringTable do
        if (stringTable[i] == "namereplace") then
            table.insert(newStringTable, Util.GetUserGroupInfo(ply:GetUserGroup()).Colour);
            table.insert(newStringTable, ply:Nick());
            table.insert(newStringTable, Color(255, 255, 255));
        elseif (stringTable[i] == "varreplace" && var <= #results) then
            table.insert(newStringTable, Colours.TrafficLightGreen);
            table.insert(newStringTable, tostring(results[var]));
            table.insert(newStringTable, Color(255, 255, 255));
            var = var + 1;
        else
            table.insert(newStringTable, stringTable[i]);
        end
        
        if (i ~= #stringTable) then
            table.insert(newStringTable, " ");
        end
    end

    // This is done backwards here. So its <gold> Mizmo !RTD <white> 'contents of the table' fullstop.
    table.insert(newStringTable, 1, Color(255, 255, 255));
    table.insert(newStringTable, 1, "[Mizmo !RTD] ");
    table.insert(newStringTable, 1, Colours.Gold);
    table.insert(newStringTable, "!");
    Util.SendMessageTable(newStringTable);
end

function RollTheDice.DoFailedAlert(msg)
    local tbl = {};
    table.insert(tbl, Colours.Gold);
    table.insert(tbl, "[Mizmo !RTD] ");
    table.insert(tbl, Color(255, 255, 255));
    table.insert(tbl, msg);
    table.insert(tbl, ".");
    Util.SendMessageTable(tbl);
end

function RollTheDice.AddRoll(message, rollFunction)
    if (RollTheDice.Outcomes == nil) then
        RollTheDice.Outcomes = {};
    end

    local newOutcome = table.Copy(RollTheDice.OutcomeTemplate);
    newOutcome.MsgFunction = message;
    newOutcome.RollFunction = rollFunction;

    table.insert(RollTheDice.Outcomes, newOutcome);
end

function RollTheDice.IncludeFiles()
    RollTheDice.Outcomes = {};

    for _, fileName in pairs(file.Find("deathrun/gamemode/RollTheDice/Outcomes/*.lua", "LUA")) do
        include("Outcomes/"..fileName);
    end
end
RollTheDice.IncludeFiles();

function RollTheDice.RoundStart()
    RollTheDice.IsAble = true;
    for v, k in pairs(player.GetAll()) do
        k.CanRoll = true;
    end
end
hook.Add("DeathrunBeginActive", "MizmoEnableRTD", RollTheDice.RoundStart);

function RollTheDice.RoundEnd()
    RollTheDice.IsAble = false;
end
hook.Add("DeathrunBeginOver", "MizmoDisableRTD", RollTheDice.RoundEnd);