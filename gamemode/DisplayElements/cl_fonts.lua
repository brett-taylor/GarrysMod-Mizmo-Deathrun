/*
 * The Following Is For The Cut Scene System.
 */
-- Used in the introduction for "Mizmo-Gaming"
surface.CreateFont("MizmoGaming-Intro-Big", {
	font = "Roboto Light",
	size = 70,
	weight = 1000,
	antialias = true,
	shadow = true,
});

-- Used in the introduction for "Welcome to", "www.", ".co.uk"
surface.CreateFont("MizmoGaming-Intro-Small", {
	font = "Roboto Thin",
	size = 30,
	weight = 200,
	antialias = true,
	shadow = true,
});

-- Used in the introduction for ">> Press Enter To Continue <<"
surface.CreateFont("MizmoGaming-Intro-Subhead", {
	font = "Roboto Thin",
	size = 25,
	weight = 100,
	antialias = true,
	shadow = true,
});


/*
 * The Following Is For The Main HUD Element.
 */
surface.CreateFont("HUDLabelfont", {
	font = "Roboto Light",
	size = 13,
	weight = 500,
	antialias = true,
});

surface.CreateFont("NameFont", {
	font = "Roboto Regular",
	size = 18,
	weight = 500,
	antialias = true,
});

surface.CreateFont("HealthFont", {
	font = "Roboto Medium",
	size = 48,
	weight = 500,
	antialias = true,
});

-- Used to show button claiming
surface.CreateFont("MizmoGaming-Button-Claimed", {
	font = "Roboto Thin",
	size = 25,
	weight = 300,
	antialias = true,
	shadow = true,
});