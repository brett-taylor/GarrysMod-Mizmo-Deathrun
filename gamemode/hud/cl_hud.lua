local HUD = {}
HUD.HideElements = {}
HUD.HideElements["CHudBattery"] = true;
HUD.HideElements["CHudCrosshair"] = true;
HUD.HideElements["CHudHealth"] = true;
HUD.HideElements["CHudAmmo"] = true;
HUD.HideElements["CHudDamageIndicator"] = true;

function HUD:DrawHUD()
end
hook.Add("HUDPaint", "MizmoDrawHUD", HUD.DrawHUD);
 
function HUD:RemoveGarrysmodDefaultHud(name)
    if (HUD.HideElements[name]) then
        return false ;
    end
end
hook.Add("HUDShouldDraw", "RemoveGarrysmodDefaultHud", HUD.RemoveGarrysmodDefaultHud);