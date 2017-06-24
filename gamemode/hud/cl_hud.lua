local HUD = {}
HUD.HideElements = {}
HUD.HideElements["CHudBattery"] = true;
HUD.HideElements["CHudCrosshair"] = true;
HUD.HideElements["CHudHealth"] = true;
HUD.HideElements["CHudAmmo"] = true;
HUD.HideElements["CHudDamageIndicator"] = true;

function HUD:DrawHUD()
	draw.RoundedBox(5, 10, 10, 100, 100, Color(255, 0, 0));
end
hook.Add("HUDPaint", "MizmoDrawHUD", HUD.DrawHUD);

function HUD.RemoveGarrysmodDefaultHud(name)
	if (HUD.HideElements[name]) then 
		return false;
	end
end
hook.Add("HUDShouldDraw", "RemoveGarrysmodDefaultHud", HUD.RemoveGarrysmodDefaultHud);