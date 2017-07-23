AutoJumpClient = {};
AutoJumpClient.Enabled = true;
AutoJumpClient.EnabledEnhanced = true;
AutoJumpClient.Notifiy = false;
AutoJumpClient.UniqueRoundNoJump = false;

function AutoJumpClient.RecievedUpdate(bool, alert)
	AutoJumpClient.Enabled = bool;
	if (tonumber(LocalPlayer():GetNWString(PlayerSettings.Enums.ENHANCED_AUTOJUMP.Name)) ~= 0) then
		return;
	end

	if (alert == true) then
		AutoJumpClient.StartAlert();
	else
		AutoJumpClient.Notifiy = false;
	end
end

function AutoJumpClient.RecievedUpdateEnhanced(bool, alert)
	AutoJumpClient.EnabledEnhanced = bool;
	if (tonumber(LocalPlayer():GetNWString(PlayerSettings.Enums.ENHANCED_AUTOJUMP.Name)) ~= 1) then
		return;
	end

	if (alert == true) then
		AutoJumpClient.StartAlertEnhanced();
	else
		AutoJumpClient.Notifiy = false;
	end
end

net.Receive("MizmoUpdateAutoJumpStatus", function() 
	AutoJumpClient.RecievedUpdate(net.ReadBool(), net.ReadBool()); 
end);

net.Receive("MizmoUpdateAutoJumpStatusEnhanced", function() 
	AutoJumpClient.RecievedUpdateEnhanced(net.ReadBool(), net.ReadBool()); 
end);

function AutoJumpClient.StartAlert()
	AutoJumpClient.Notifiy = true;
	timer.Create("MizmoServerAutoJumpTempDisabledClient", 59, 1, function() AutoJumpClient.CountdownExpired() end);
end

function AutoJumpClient.StartAlertEnhanced()
	AutoJumpClient.Notifiy = true;
	timer.Create("MizmoServerAutoJumpTempDisabledClient", 29, 1, function() AutoJumpClient.CountdownExpired() end);
end

function AutoJumpClient.CountdownExpired()
	AutoJumpClient.Notifiy = false;
	timer.Destroy("MizmoServerAutoJumpTempDisabledClient");
end

function AutoJumpClient.HUDPaint()
	if (AutoJumpClient.Notifiy == false) then
		return;
	end

	if (AutoJumpClient.UniqueRoundNoJump == true) then
		return;
	end

	draw.SimpleTextOutlined("Auto-Jump In:", "MizmoGaming-AutoJump-Notifier", ScrW() - 5, 100, Colours.TextWhite, TEXT_ALIGN_RIGHT, TEXT_ALIGN_BOTTOM, 2, Color(0, 0, 0))
	if (math.floor(timer.TimeLeft("MizmoServerAutoJumpTempDisabledClient")) < 10) then
		draw.SimpleTextOutlined("00:0"..math.floor(timer.TimeLeft("MizmoServerAutoJumpTempDisabledClient")), "MizmoGaming-AutoJump-Notifier-Countdown", ScrW() - 5, 102, Colours.Gold, TEXT_ALIGN_RIGHT, TEXT_ALIGN_TOP, 2, Color(0, 0, 0))
	else
		draw.SimpleTextOutlined("00:"..math.floor(timer.TimeLeft("MizmoServerAutoJumpTempDisabledClient")), "MizmoGaming-AutoJump-Notifier-Countdown", ScrW() - 5, 102, Colours.Gold, TEXT_ALIGN_RIGHT, TEXT_ALIGN_TOP, 2, Color(0, 0, 0))
	end
end
hook.Add("HUDPaint", "MizmoDrawHudPaintAutoJumpNotifier", AutoJumpClient.HUDPaint);