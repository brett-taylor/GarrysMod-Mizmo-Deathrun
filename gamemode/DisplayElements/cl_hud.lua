local HUD = {}
HUD.HideElements = {}
HUD.HideElements["CHudBattery"] = true;
HUD.HideElements["CHudHealth"] = true;
HUD.HideElements["CHudAmmo"] = true;
HUD.HideElements["CHudDamageIndicator"] = true;

HUD.Size = {};
HUD.Size.W = 332;
HUD.Size.H = 90;

HUD.Anchor = {};
HUD.Anchor.X = 30;
HUD.Anchor.Y = ScrH() - (HUD.Size.H + 30);

HUD.PlayerData = LocalPlayer();

HUD.Health = {};

HUD.Health.This = 0;
HUD.Health.Last = 0;

HUD.FilledHealthBarColour = Colours.Gold;
HUD.EmptyHealthBarColour = Colours.Grey;

HUD.HealthElements = {};
HUD.HealthOutlines = {};

HUD.EmptyHealth = 0;

HUD.Elements = {};
                                                                                                
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

HUD.Elements.Element1 = { //Thick slanted bar on the left of the HUD
    { x = 0,    y = (HUD.Size.H / 2)        },
    { x = 16,    y = 0                          },
    { x = 32,   y = 0                           },
    { x = 16,    y = (HUD.Size.H / 2)       }
}

HUD.Elements.Element2 = { //Middle Triangle
    { x = ((HUD.Size.W-16) / 2) + 15,       y = (HUD.Size.H / 2) + 3    },
    { x = ((HUD.Size.W-16) / 2) + 23,       y = (HUD.Size.H / 2) + 3    },
    { x = ((HUD.Size.W-16) / 2) + 19,       y = (HUD.Size.H / 2) + 10   }
}

HUD.Elements.Element3 = { //Right Triangle
    { x = (((HUD.Size.W-16) / 4) * 3) + 3,   y = (HUD.Size.H / 2)},
    { x = (((HUD.Size.W-16) / 4) * 3) + 7,   y = (HUD.Size.H / 2) - 7},
    { x = (((HUD.Size.W-16) / 4) * 3) + 11,  y = (HUD.Size.H / 2)}
}

function HUD.LostHealth()
    for i = 1, 20 do
        if (i*5 > HUD.PlayerData:Health() + 4) then     //
            HUD.EmptyHealth = HUD.EmptyHealth + 1;      //Calculates and draws the health elements that should be grey
            surface.DrawPoly(HUD.HealthElements[i]);    //              
        end
    end
end

function HUD.SetHealthElements()
    for i = 1, 20 do
        HUD.HealthElements[i] = {
            {x = 28 + (11 * (i-1)), y = (HUD.Size.H / 4) - 2}, //Sets coords for the health elements
            {x = 36 + (11 * (i-1)), y = (HUD.Size.H / 4) - 2}, //
            {x = 28 + (11 * (i-1)), y = (HUD.Size.H / 2) - 2}, //
            {x = 20 + (11 * (i-1)), y = (HUD.Size.H / 2) - 2}  //
        }
        HUD.HealthOutlines[i] = {
            {x = (11 * (i-1)) + 27, y = (HUD.Size.H / 4) - 3}, //Sets coords for Health outlines
            {x = (11 * (i-1)) + 37, y = (HUD.Size.H / 4) - 3}, //
            {x = (11 * (i-1)) + 29, y = (HUD.Size.H / 2) - 1}, //
            {x = (11 * (i-1)) + 19, y = (HUD.Size.H / 2) - 1}  //
        }   
    end
end

function HUD.SetToAnchorPoint()
    for key, elementTable in pairs(HUD.Elements) do
        for i = 1, #elementTable do
            elementTable[i].x = elementTable[i].x + HUD.Anchor.X;
            elementTable[i].y = elementTable[i].y + HUD.Anchor.Y;
        end
    end
    for key, healthTable in pairs(HUD.HealthElements) do
        for i = 1, #healthTable do
            healthTable[i].x = healthTable[i].x + HUD.Anchor.X;
            healthTable[i].y = healthTable[i].y + HUD.Anchor.Y;
        end
    end
    for key, outlineTable in pairs(HUD.HealthOutlines) do
        for i = 1, #outlineTable do
            outlineTable[i].x = outlineTable[i].x + HUD.Anchor.X;
            outlineTable[i].y = outlineTable[i].y + HUD.Anchor.Y;
        end
    end
end
HUD.SetHealthElements();
HUD.SetToAnchorPoint();

function HUD.GetPlayer() //The variable is told whether the player is alive or spectating
    if (LocalPlayer():Alive() == true) then
        HUD.PlayerData = LocalPlayer();
    else
        HUD.PlayerData = LocalPlayer():GetObserverTarget();
    end
    if (HUD.PlayerData == nil) then
        HUD.PlayerData = LocalPlayer();
    end
end

function HUD.DrawBasicElements()
    draw.RoundedBox(2, HUD.Anchor.X, (HUD.Size.H / 2) + HUD.Anchor.Y, HUD.Size.W, 3, Color(223, 163, 0)); //Middle Horizontal line of HUD
    draw.RoundedBox(2, HUD.Anchor.X + 16, (HUD.Size.H / 2) + 3 + HUD.Anchor.Y, 3, HUD.Size.H/2 - 15, Color(223, 163, 0)); //vertical line going down near left of HUD
    draw.RoundedBox(2, HUD.Anchor.X + 23, (HUD.Size.H / 2) + 3 + (HUD.Size.H/2 - 15)/2 + HUD.Anchor.Y, (HUD.Size.W - (HUD.Anchor.X + 16)) + 18, 2, Color(223, 163, 0)); //Horizontal line between the labels
end

function HUD.DrawHUDText()
    HUD.GetPlayer();
    draw.SimpleTextOutlined(HUD.PlayerData:Health(), "HealthFont", ((16 + ((HUD.Size.W-16)/4)*3) - 5) + (HUD.Size.W - ((16 + ((HUD.Size.W-16)/4)*3) - 5))/2 + HUD.Anchor.X, (HUD.Size.H / 2) + 6 + HUD.Anchor.Y, HUD.FilledHealthBarColour, TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM, 1, Color(0, 0, 0, 255));
    draw.SimpleTextOutlined("Mizmos", "HUDLabelfont", (HUD.Anchor.X + 26) + ((HUD.Size.W - (HUD.Anchor.X + 16)) + 18)/8, HUD.Size.H/2 + 4 + HUD.Anchor.Y, Color( 223, 163, 0, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP, 1, Color(0, 0, 0, 255));
    draw.SimpleTextOutlined("Level", "HUDLabelfont", (HUD.Anchor.X + 26) + (((HUD.Size.W - (HUD.Anchor.X + 16)) + 18)/8) * 3, HUD.Size.H/2 + 4 + HUD.Anchor.Y, Color( 223, 163, 0, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP, 1, Color(0, 0, 0, 255));
    draw.SimpleTextOutlined("Current XP", "HUDLabelfont", (HUD.Anchor.X + 26) + (((HUD.Size.W - (HUD.Anchor.X + 16)) + 18)/8) * 5, HUD.Size.H/2 + 4 + HUD.Anchor.Y, Color( 223, 163, 0, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP, 1, Color(0, 0, 0, 255));
    draw.SimpleTextOutlined("XP Req", "HUDLabelfont", (HUD.Anchor.X + 26) + (((HUD.Size.W - (HUD.Anchor.X + 16)) + 18)/8) * 7, HUD.Size.H/2 + 4 + HUD.Anchor.Y, Color( 223, 163, 0, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP, 1, Color(0, 0, 0, 255));
    draw.SimpleTextOutlined("100", "HUDLabelfont", (HUD.Anchor.X + 26) + ((HUD.Size.W - (HUD.Anchor.X + 16)) + 18)/8, (HUD.Size.H / 2) + 3 + (HUD.Size.H/2 - 15)/2 + 3 + HUD.Anchor.Y, Color( 223, 163, 0, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP, 1, Color(0, 0, 0, 255));
    draw.SimpleTextOutlined("100", "HUDLabelfont", (HUD.Anchor.X + 26) + (((HUD.Size.W - (HUD.Anchor.X + 16)) + 18)/8) * 3, (HUD.Size.H / 2) + 3 + (HUD.Size.H/2 - 15)/2 + 3 + HUD.Anchor.Y, Color( 223, 163, 0, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP, 1, Color(0, 0, 0, 255));
    draw.SimpleTextOutlined("100", "HUDLabelfont", (HUD.Anchor.X + 26) + (((HUD.Size.W - (HUD.Anchor.X + 16)) + 18)/8) * 5, (HUD.Size.H / 2) + 3 + (HUD.Size.H/2 - 15)/2 + 3 + HUD.Anchor.Y, Color( 223, 163, 0, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP, 1, Color(0, 0, 0, 255));
    draw.SimpleTextOutlined("100", "HUDLabelfont", (HUD.Anchor.X + 26) + (((HUD.Size.W - (HUD.Anchor.X + 16)) + 18)/8) * 7, (HUD.Size.H / 2) + 3 + (HUD.Size.H/2 - 15)/2 + 3 + HUD.Anchor.Y, Color( 223, 163, 0, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP, 1, Color(0, 0, 0, 255));
    draw.SimpleTextOutlined(HUD.PlayerData:GetName(), "NameFont", HUD.Anchor.X + 40, HUD.Anchor.Y, Color( 223, 163, 0, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP, 1, Color(0, 0, 0, 255));
end

function HUD.DrawHUD()
    HUD.DrawBasicElements();
    HUD.DrawHUDText();
    HUD.DrawElements();

    -- TEMP
    if (LocalPlayer():GetNWString(PlayerSettings.Enums.IS_DEBUGGING.Name) == "1") then
        HUD.TempDrawRoundstatus();
    end
end

function HUD.TakeDamageAnim()
    HUD.GetPlayer();
    HUD.Health.This = HUD.PlayerData:Health();
    if (HUD.Health.This < HUD.Health.Last) then
        HUD.FilledHealthBarColour = Colours.HealthRed;
        HUD.EmptyHealthBarColour = Colours.HealthRed;
    end
    HUD.LerpColors();
    HUD.Health.Last = HUD.Health.This;
end

function HUD.LerpColors()
    HUD.FilledHealthBarColour = Util.LerpColour(FrameTime() * 3, HUD.FilledHealthBarColour, Colours.Gold);
    HUD.EmptyHealthBarColour = Util.LerpColour(FrameTime() * 3, HUD.EmptyHealthBarColour, Colours.Grey);
end

function HUD.DrawElements()
    surface.SetDrawColor(0, 0, 0, 255);
    draw.NoTexture();
    for key, outlineTable in pairs(HUD.HealthOutlines) do
        surface.DrawPoly(outlineTable);
    end

    surface.SetDrawColor(223, 163, 0, 255);
    for key, elementTable in pairs(HUD.Elements) do
        surface.DrawPoly(elementTable);
    end

    surface.SetDrawColor(HUD.FilledHealthBarColour);
    for key, healthTable in pairs(HUD.HealthElements) do
        surface.DrawPoly(healthTable);
    end

    surface.SetDrawColor(HUD.EmptyHealthBarColour);
    HUD.LostHealth();
end

function HUD.RemoveGarrysmodDefaultHud(name)
    if (HUD.HideElements[name]) then
        return false;
    end
end

-- TEMP FUNCTION
function HUD.TempDrawRoundstatus()
    draw.SimpleTextOutlined("Round State: "..ROUND:GetCurrent(), "MizmoGaming-Intro-Subhead", ScrW() / 2, 10, Colours.Gold, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP, 1, Colours.Grey)
    draw.SimpleTextOutlined("Time Left: "..string.ToMinutesSeconds(math.Clamp(ROUND:GetTimer(), 0, 99999)), "MizmoGaming-Intro-Subhead", ScrW() / 2, 40, Colours.Gold, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP, 1, Colours.Grey)
    draw.SimpleTextOutlined("Miniutes Played: "..LocalPlayer():GetPlaytime(), "MizmoGaming-Intro-Subhead", ScrW() / 2 - 2, 70, Colours.Gold, TEXT_ALIGN_RIGHT, TEXT_ALIGN_TOP, 1, Colours.Grey)
    draw.SimpleTextOutlined("Hours Played: "..LocalPlayer():GetPlaytimeHours(), "MizmoGaming-Intro-Subhead", ScrW() / 2 + 2, 70, Colours.Gold, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP, 1, Colours.Grey)
end

hook.Add("HUDPaint", "MizmoDrawHUD", HUD.DrawHUD); //Draws the HUD every frame
hook.Add("Think", "TakeDamage", HUD.TakeDamageAnim); //Lerps the health colour if player takes damage
hook.Add("HUDShouldDraw", "RemoveGarrysmodDefaultHud", HUD.RemoveGarrysmodDefaultHud);