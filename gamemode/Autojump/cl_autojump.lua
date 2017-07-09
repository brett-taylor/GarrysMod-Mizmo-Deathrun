AutoJumpClient = {};
AutoJumpClient.Enabled = true;
AutoJumpClient.Notifiy = false;

function AutoJumpClient.RecievedUpdate(bool, alert)
	AutoJumpClient.Enabled = bool;
	if (alert == true) then
		AutoJumpClient.StartAlert();
	else
		AutoJumpClient.Notifiy = false;
	end
end

net.Receive("UpdateAutoJumpStatus", function() 
	AutoJumpClient.RecievedUpdate(net.ReadBool(), net.ReadBool()); 
end);

function AutoJumpClient.StartAlert()
	AutoJumpClient.Notifiy = true;
	timer.Create("MizmoServerAutoJumpTempDisabledClient", 59, 1, function() AutoJumpClient.CountdownExpired() end);
end

function AutoJumpClient.CountdownExpired()
	AutoJumpClient.Notifiy = false;
	timer.Destroy("MizmoServerAutoJumpTempDisabledClient");
end

function AutoJumpClient.HUDPaint()
	if (AutoJumpClient.Notifiy == false) then
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