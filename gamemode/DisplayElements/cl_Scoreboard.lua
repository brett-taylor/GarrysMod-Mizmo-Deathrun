Scoreboard = {};
Scoreboard.Parent = nil;
Scoreboard.MaxRounds = nil;
Scoreboard.LineColour = Color(150, 150, 150);
Scoreboard.ply = nil;


-- Hides the default scoreboard and opens our custom scoreboard.
function Scoreboard.OpenScoreboard()
    Scoreboard.CreateScoreboard();
    return false;
end
hook.Add("ScoreboardShow", "MizmoShowScoreboard", Scoreboard.OpenScoreboard);
 
-- Hides our scoreboard when tab is released
function Scoreboard.CloseScoreboard()
    Scoreboard.Parent:Hide();
    gui.EnableScreenClicker(false)
    timer.Pause("ScoreboardTimer")
    if (IsValid(Scoreboard.DMenu)) then
    	Scoreboard.DMenu:Remove()
    end
end
hook.Add("ScoreboardHide", "MizmoHideScoreboard", Scoreboard.CloseScoreboard);
 
-- Creates the actual scoreboard if the scoreboard does not already exist.
function Scoreboard.CreateScoreboard()
    if (IsValid(Scoreboard.Parent)) then
        -- Update the scoreboard with the new players and other changes since then -> Maybe a 1 second timer if open or something?
        Scoreboard.Parent:Show();
        timer.Start("ScoreboardTimer")
        Scoreboard.Update()
        return;
    end
    Scoreboard.GetConvars()
    Scoreboard.CreateBase();
    timer.Create("ScoreboardTimer", 1, 0, function() Scoreboard.Update() end)
    Scoreboard.Update()

end

function Scoreboard.GetConvars()
    Scoreboard.MaxRounds = GetConVar("deathrun_round_limit"):GetString()
end

function Scoreboard.Update()

    Scoreboard.Grid:Clear()

    for k, v in pairs(player.GetAll()) do
        if v:Team() == TEAM_DEATH and v:Alive() == true then
            Scoreboard.AddRows(v)
        end
    end
    for k, v in pairs(player.GetAll()) do
        if v:Team() == TEAM_RUNNER and v:Alive() == true then
            Scoreboard.AddRows(v)
        end
    end
    for k, v in pairs(player.GetAll()) do
        if v:Team() == TEAM_DEATH and v:Alive() == false then
            Scoreboard.AddRows(v)
        end
    end
    for k, v in pairs(player.GetAll()) do
        if v:Team() == TEAM_RUNNER and v:Alive() == false then
            Scoreboard.AddRows(v)
        end
    end
    for k, v in pairs(player.GetAll()) do
        if v:Team() ~= TEAM_RUNNER and v:Team() ~= TEAM_DEATH then
            Scoreboard.AddRows(v)
        end
    end
    
    Scoreboard.Parent:SetTall(ScrH()/6 + 45 + 45 * math.Clamp(#player.GetAll(), 1, ScrH()/67.5))
    Scoreboard.ScrollFrame:SetTall(45 * math.Clamp(#player.GetAll(), 1, ScrH()/67.5))
    
end

function Scoreboard.AddRows(ply)

        local row = vgui.Create("DButton");
        if ply:Team() == TEAM_DEATH then
            if ply:Alive() == true then
                row.LineColour = Color(255, 0, 0)
            else
                row.LineColour = Color(217, 106, 106)
            end
        elseif ply:Team() == TEAM_RUNNER then
            if ply:Alive() == true then
                row.LineColour = Color(0, 0, 255)
            else
                row.LineColour = Color(106, 132, 217)
            end
        else
                row.LineColour = Color(150, 150, 150)
            end
        row:SetText("")
        row:SetSize(ScrW()/2 - ((ScrW()/2)/12), 40);
        row.Paint = function(s, w, h)
            if (IsValid(ply) == false) then
            	Scoreboard.Update()
            	return
            end
            draw.RoundedBox(1, 0, 38, w, 2, row.LineColour)
            draw.SimpleTextOutlined(ply:GetName(), "NameFont", (w/16), h/2, Color(255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER, 1, Color(0, 0, 0, 255))
            if (Util.PlayerHasTag(ply) == true) then
                draw.SimpleTextOutlined(ply:GetNWString(PlayerSettings.Enums.TAG_NAME.Name), "NameFont", (w/16) * 7, h/2, Util.GetTagColour(ply), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color(0, 0, 0, 255))
            else
                draw.SimpleTextOutlined(Util.GetUserGroupInfo(ply:GetUserGroup()).Name, "NameFont", (w/16) * 7, h/2, Util.GetUserGroupInfo(ply:GetUserGroup()).Colour, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color(0, 0, 0, 255))
            end
            draw.SimpleTextOutlined(tostring(ply:GetCurrentLevel()), "NameFont", (w/16) * 9, h/2, Color(255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color(0, 0, 0, 255))
            draw.SimpleTextOutlined(ply:PS_GetPoints(), "NameFont",  (w/16) * 11, h/2, Color(255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color(0, 0, 0, 255))
            draw.SimpleTextOutlined(ply:GetPlaytimeHours(), "NameFont", (w/16) * 13, h/2, Color(255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color(0, 0, 0, 255))
            draw.SimpleTextOutlined(ply:Ping(), "NameFont", (w/16) * 15, h/2, Color(255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color(0, 0, 0, 255))

        end
        row.player = ply
        row.DoClick = function(button)
        Scoreboard.ply = button.player
        Scoreboard.DMenu = vgui.Create("DMenu")   
        local x, y = input.GetCursorPos()
        Scoreboard.DMenu:SetPos(x, y)
        local btnSteam = Scoreboard.DMenu:AddOption("View Steam Profile", function()
            ply:ShowProfile()
        end)
        local btnMute = Scoreboard.DMenu:AddOption("Mute/Unmute", function()
            if Scoreboard.ply:IsMuted() then
                Scoreboard.ply:SetMuted(false)
            else
                Scoreboard.ply:SetMuted(true)
            end
        end)
        btnMute:SetIcon("Mizmo-Gaming-Downloads/icons/mute16.png")
        if LocalPlayer():IsUserGroup("admin") or LocalPlayer():IsUserGroup("superadmin") then
            Scoreboard.DMenu:AddSpacer()
            local adminOption = Scoreboard.DMenu:AddOption("Admin")
            adminOption:SetIcon("Mizmo-Gaming-Downloads/icons/shield16.png")
            local adminMenu = adminOption:AddSubMenu("AdminUtils")
            local kick = adminMenu:AddOption("kick", function()
                Derma_StringRequest(
                 "playerkick", 
                 "Kick Player", 
                 "Reason for kick", 
                 function(reason) LocalPlayer():ConCommand('ulx kick "' .. Scoreboard.ply:GetName() .. '" "' .. reason .. '"') 
                 end)
            end)
            local ban = adminMenu:AddOption("ban", function()
                Derma_StringRequest(
                 "playerban", 
                 "Ban Player", 
                 "Reason for ban", 
                 function(reason) 
                    Derma_StringRequest(
                    "bantime", 
                    "Ban Time In Minutes (0 = perm)", 
                    "Ban time in minutes (0 = perm)",
                    function(time)
                        LocalPlayer():ConCommand('ulx ban "' .. Scoreboard.ply:GetName() .. '" ' .. time .. " " .. reason) 
                    end)
                 end)
            end)
            local gag = adminMenu:AddOption("gag", function()
                LocalPlayer():ConCommand("ulx gag " .. Scoreboard.ply:GetName())
            end)    
            local mute = adminMenu:AddOption("mute", function()
                LocalPlayer():ConCommand("ulx mute " .. Scoreboard.ply:GetName())
            end)
        end
        end
        row.Avatar = vgui.Create("AvatarImage", row)
        row.Avatar:SetSize( 32, 32 )
        row.Avatar:SetPlayer(ply, 32)
        row.Avatar:SetPos(5, 4)

        Scoreboard.Grid:Add(row)
end
 
function Scoreboard.CreateBase()
    Scoreboard.Parent = vgui.Create("DFrame");
    Scoreboard.Parent:SetSize(ScrW()/2, ScrW()/7);
    Scoreboard.Parent:SetPos(ScrW()/4, ScrH()/18);
    Scoreboard.Parent:Show();
    Scoreboard.Parent:SetTitle("")
    Scoreboard.Parent:SetDraggable(false)
    Scoreboard.Parent:ShowCloseButton(false)
    Scoreboard.Parent.Paint = function(s, w, h)
            draw.RoundedBox(0, 0, 0, w, h, Color(Colours.Grey.r, Colours.Grey.g, Colours.Grey.b, 225))
            draw.RoundedBox(0, 0, ScrW()/16, w, 2, Colours.Gold)
            draw.SimpleTextOutlined("Mizmo-Gaming", "MizmoGaming-Intro-Big", w/2, ScrW()/32, Colours.Gold, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color(0, 0, 0, 255))
            surface.SetFont("MizmoGaming-Intro-Big");
            local widthOfHeading, heightOfHeading = surface.GetTextSize("Mizmo-Gaming");
            draw.SimpleTextOutlined("www.", "MizmoGaming-Intro-Small", w/2 - widthOfHeading/2, ScrW()/32 + heightOfHeading/(26/10), Colours.Gold, TEXT_ALIGN_RIGHT, TEXT_ALIGN_BOTTOM, 1, Color(0, 0, 0, 255))
            draw.SimpleTextOutlined(".co.uk", "MizmoGaming-Intro-Small", w/2 + widthOfHeading/2, ScrW()/32 + heightOfHeading/(26/10), Colours.Gold, TEXT_ALIGN_LEFT, TEXT_ALIGN_BOTTOM, 1, Color(0, 0, 0, 255))
            draw.SimpleTextOutlined("Round: " .. ROUND:GetRoundsPlayed() .. "/" .. Scoreboard.MaxRounds, "HUDLabelfont", 5, ScrW()/16 + 5, Color(255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP, 0, Color(0, 0, 0, 255))   
            draw.SimpleTextOutlined("Players: " .. #player.GetAll() .. "/32", "HUDLabelfont", w-5, ScrW()/16 + 5, Color(255, 255, 255), TEXT_ALIGN_RIGHT, TEXT_ALIGN_TOP, 0, Color(0, 0, 0, 255))   
            draw.SimpleTextOutlined("Map: " .. game.GetMap(), "HUDLabelfont", w-5, h - 10, Color(255, 255, 255), TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER, 0, Color(0, 0, 0, 255))
            draw.RoundedBox(0, ((ScrW()/2)/12)/2, (ScrH()/6 + 20) - ScrW()/40, ScrW()/2 - ((ScrW()/2)/12), ScrW()/40, Colours.Gold)
            draw.RoundedBox(0, (((ScrW()/2)/12)/2) + 2, ((ScrH()/6 + 20) - ScrW()/40) + 2, (ScrW()/2 - ((ScrW()/2)/12)) - 4, ScrW()/40 - 4, Color(Colours.Grey.r, Colours.Grey.g, Colours.Grey.b,255))
            draw.SimpleTextOutlined("Name", "NameFont", ((((ScrW()/2)/12)/2) + 2) + (((ScrW()/2 - ((ScrW()/2)/12)) - 4)/16)*(3/2), (((ScrH()/6 + 20) - ScrW()/40) + 2) + ((ScrW()/40) - 4)/2, Colours.Gold, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color(0, 0, 0, 255))
            draw.SimpleTextOutlined("Rank", "NameFont", ((((ScrW()/2)/12)/2) + 2) + (((ScrW()/2 - ((ScrW()/2)/12)) - 4)/16)*7, (((ScrH()/6 + 20) - ScrW()/40) + 2) + ((ScrW()/40) - 4)/2, Colours.Gold, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color(0, 0, 0, 255))
            draw.SimpleTextOutlined("Level", "NameFont", ((((ScrW()/2)/12)/2) + 2) + (((ScrW()/2 - ((ScrW()/2)/12)) - 4)/16)*9, (((ScrH()/6 + 20) - ScrW()/40) + 2) + ((ScrW()/40) - 4)/2, Colours.Gold, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color(0, 0, 0, 255))
            draw.SimpleTextOutlined("Mizmos", "NameFont", ((((ScrW()/2)/12)/2) + 2) + (((ScrW()/2 - ((ScrW()/2)/12)) - 4)/16)*11, (((ScrH()/6 + 20) - ScrW()/40) + 2) + ((ScrW()/40) - 4)/2, Colours.Gold, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color(0, 0, 0, 255))
            local playtimestr = "Playtime (hours)"
            if ScrH() > 1000 then
            	playtimestr = "Playtime (hours)";
            else
            	playtimestr = "Time";
            end
            draw.SimpleTextOutlined(playtimestr, "NameFont", ((((ScrW()/2)/12)/2) + 2) + (((ScrW()/2 - ((ScrW()/2)/12)) - 4)/16)*13, (((ScrH()/6 + 20) - ScrW()/40) + 2) + ((ScrW()/40) - 4)/2, Colours.Gold, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color(0, 0, 0, 255))
            draw.SimpleTextOutlined("Ping", "NameFont", ((((ScrW()/2)/12)/2) + 2) + (((ScrW()/2 - ((ScrW()/2)/12)) - 4)/16)*15, (((ScrH()/6 + 20) - ScrW()/40) + 2) + ((ScrW()/40) - 4)/2, Colours.Gold, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color(0, 0, 0, 255))
        end

    Scoreboard.ScrollFrame = vgui.Create("DScrollPanel", Scoreboard.Parent)
    Scoreboard.ScrollFrame:SetSize(ScrW()/2 - ((ScrW()/2)/12), 42 * 1);
    Scoreboard.ScrollFrame:SetPos(((ScrW()/2)/12)/2, ScrH()/6 + 25);
    Scoreboard.ScrollFrame:Show();
    Scoreboard.ScrollFrame.Paint = function(s, w, h)
            draw.RoundedBox(0, 0, 0, w, h, Color(0, 0, 0, 0))
        end
    Scoreboard.ScrollFrame:GetVBar().Paint = function(s, w, h)
    	draw.RoundedBox(0, 0, 0, w, h, Colours.Grey)
    end
    Scoreboard.ScrollFrame:GetVBar().btnUp.Paint = function(s, w, h)
    	draw.RoundedBox(0, 0, 0, w, h, Colours.Gold)
    end
    Scoreboard.ScrollFrame:GetVBar().btnDown.Paint = function(s, w, h)
    	draw.RoundedBox(0, 0, 0, w, h, Colours.Gold)
    end
    Scoreboard.ScrollFrame:GetVBar().btnGrip.Paint = function(s, w, h)
    	draw.RoundedBox(0, 0, 0, w, h, Colours.Gold)
    end

    Scoreboard.Grid = vgui.Create("DIconLayout", Scoreboard.ScrollFrame)
    Scoreboard.Grid:SetWide(ScrW()/2 - ((ScrW()/2)/12))
    Scoreboard.Grid:SetSpaceY(5)
    

end

function Scoreboard.ShowCursor(ply, key)
    if (IsValid(Scoreboard.Parent)) then
        if (key == IN_ATTACK2 and Scoreboard.Parent:IsVisible()) then
            gui.EnableScreenClicker(true)

        end
    end
end

hook.Add("KeyPress", "showcursor", Scoreboard.ShowCursor)