local HUD = HUD or {}
HUD.HideElements = {}
HUD.HideElements["CHudBattery"] = true;
HUD.HideElements["CHudCrosshair"] = true;
HUD.HideElements["CHudHealth"] = true;
HUD.HideElements["CHudAmmo"] = true;
HUD.HideElements["CHudDamageIndicator"] = true;

function HUD:DrawHUD()
	draw.RoundedBox(32, ScrW() - 100, 15, 50, 50, Color(255, 0, 0))
end
hook.Add("HUDPaint", "MizmoDrawHUD", HUD.DrawHUD);

hook.Add("HUDShouldDraw", "MizmoHideDefaultHUD", function(name)
	if (HUD.HideElements[name]) then 
		return false;
	end
end)