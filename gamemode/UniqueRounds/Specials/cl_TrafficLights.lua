local TrafficLightsClient = {};
TrafficLightsClient.Status = 0;

function TrafficLightsClient.HUDDraw()
	if (TrafficLightsClient.Status == 0) then
		return;
	end

	local colour = Colours.TrafficLightGreen;
	local text = "GO!";
	if (TrafficLightsClient.Status == 1) then
		colour = Colours.TrafficLightRed;
		text = "STOP!";
	end

	if (TrafficLightsClient.Status == 2) then
		colour = Colours.TrafficLightOrange;
		text = "WARNING!";
	end

	if (TrafficLightsClient.Status == 3) then
		colour = Colours.TrafficLightGreen;
		text = "GO!";
	end

    draw.SimpleTextOutlined(text, "MizmoGaming-Traffic-Light-Text", ScrW() / 2, 247, colour, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER, 1 , Color(0, 0, 0));

    surface.SetDrawColor(colour);
    TrafficLightsClient.DrawCircle(ScrW() / 2 - 40, 250, 30, 50);
end
hook.Add("HUDPaint", "MizmoTrafficLightDrawHudClient", TrafficLightsClient.HUDDraw);

net.Receive("MizmoUnqiueRoundTrafficLight", function()
	TrafficLightsClient.Status = net.ReadFloat();

	if (TrafficLightsClient.Status == 2) then
		surface.PlaySound("hl1/fvox/blip.wav");
		timer.Simple(1, function() surface.PlaySound("hl1/fvox/blip.wav"); end);
		timer.Simple(1.6, function() surface.PlaySound("hl1/fvox/blip.wav"); end);
		timer.Simple(2, function() surface.PlaySound("hl1/fvox/blip.wav"); end);
		timer.Simple(2.3, function() surface.PlaySound("hl1/fvox/blip.wav"); end);
		timer.Simple(2.6, function() surface.PlaySound("hl1/fvox/blip.wav"); end);
		timer.Simple(3, function() surface.PlaySound("hl1/fvox/blip.wav"); end);
	end
end)

function TrafficLightsClient.DrawCircle(x, y, radius, seg)
	local cir = {}

	table.insert( cir, { x = x, y = y, u = 0.5, v = 0.5 } )
	for i = 0, seg do
		local a = math.rad( ( i / seg ) * -360 )
		table.insert( cir, { x = x + math.sin( a ) * radius, y = y + math.cos( a ) * radius, u = math.sin( a ) / 2 + 0.5, v = math.cos( a ) / 2 + 0.5 } )
	end

	local a = math.rad( 0 ) -- This is needed for non absolute segment counts
	table.insert( cir, { x = x + math.sin( a ) * radius, y = y + math.cos( a ) * radius, u = math.sin( a ) / 2 + 0.5, v = math.cos( a ) / 2 + 0.5 } )

	surface.DrawPoly( cir )
end