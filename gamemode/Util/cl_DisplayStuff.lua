if (Util == nil) then
	Util = {};
end

function Util.DrawCircle(x, y, radius, seg, colour)
	local cir = {}
	table.insert( cir, { x = x, y = y } )
	for i = 0, seg do
		local a = math.rad( ( i / seg ) * -360 )
		table.insert( cir, { x = x + math.sin( a ) * radius, y = y + math.cos( a ) * radius } )
	end
	local a = math.rad( 0 )
	table.insert( cir, { x = x + math.sin( a ) * radius, y = y + math.cos( a ) * radius } )

	draw.NoTexture()
	surface.SetDrawColor(colour);
	surface.DrawPoly( cir )
end

function Util.DrawRotatedText(text, x, y, color, font, ang)
	render.PushFilterMag(TEXFILTER.ANISOTROPIC)
	render.PushFilterMin(TEXFILTER.ANISOTROPIC)
	surface.SetFont(font)
	surface.SetTextColor(color)
	surface.SetTextPos(0, 0)

	local textWidth, textHeight = surface.GetTextSize(text)
	local rad = -math.rad(ang)
	x = x - (math.cos(rad) * textWidth / 2 + math.sin(rad) * textHeight / 2)
	y = y + (math.sin(rad) * textWidth / 2 + math.cos(rad) * textHeight / 2)
	local m = Matrix()
	m:SetAngles(Angle(0, ang, 0))
	m:SetTranslation(Vector(x, y, 0))

	cam.PushModelMatrix(m)
	surface.DrawText(text)
	cam.PopModelMatrix()
	render.PopFilterMag()
	render.PopFilterMin()
end