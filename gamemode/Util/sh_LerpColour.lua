if (Util == nil) then
	Util = {};
end

function Util.LerpColour(frac, from, to)
	return Color(Lerp(frac, from.r, to.r), Lerp(frac, from.g, to.g), Lerp(frac, from.b, to.b), Lerp(frac, from.a, to.a));
end