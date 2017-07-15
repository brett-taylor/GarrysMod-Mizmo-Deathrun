JukeBox.HUD = {}
JukeBox.HUD.Width = 300
JukeBox.HUD.Height = 70
JukeBox.HUD.BarHeight = 20
JukeBox.HUD.Across = {
	["left"] = 10,
	["center"] = (ScrW()/2)-(JukeBox.HUD.Width/2),
	["right"] = ScrW()-10-JukeBox.HUD.Width,
}
JukeBox.HUD.Down = {
	["top"] = 10,
	["center"] = (ScrH()/2)-(JukeBox.HUD.Height/2),
	["bottom"] = ScrH()-10-JukeBox.HUD.Height,
}
JukeBox.HUD.X = JukeBox.HUD.Across[JukeBox.Settings.HUDAcross]
JukeBox.HUD.Y = JukeBox.HUD.Down[JukeBox.Settings.HUDDown]
JukeBox.HUD.W = JukeBox.HUD.Width
JukeBox.HUD.H = JukeBox.HUD.Height 

function JukeBox.HUD.PaintHUD()
	if JukeBox.CurPlaying and tobool( cookie.GetString( "JukeBox_Enabled", "false" ) ) then
		draw.RoundedBox( 0, JukeBox.HUD.X, JukeBox.HUD.Y, JukeBox.HUD.W, JukeBox.HUD.H-JukeBox.HUD.BarHeight, JukeBox.Colours.HUDBase )
		
		draw.RoundedBox( 0, JukeBox.HUD.X, JukeBox.HUD.Y+JukeBox.HUD.H-JukeBox.HUD.BarHeight+5, JukeBox.HUD.W, 2, JukeBox.Colours.HUDBase )
		draw.RoundedBox( 0, JukeBox.HUD.X, JukeBox.HUD.Y+JukeBox.HUD.H+5-2, JukeBox.HUD.W, 2, JukeBox.Colours.HUDBase )
		draw.RoundedBox( 0, JukeBox.HUD.X, JukeBox.HUD.Y+JukeBox.HUD.H-JukeBox.HUD.BarHeight+5+2, 2, JukeBox.HUD.BarHeight-4, JukeBox.Colours.HUDBase )
		draw.RoundedBox( 0, JukeBox.HUD.X+JukeBox.HUD.W-2, JukeBox.HUD.Y+JukeBox.HUD.H-JukeBox.HUD.BarHeight+5+2, 2, JukeBox.HUD.BarHeight-4, JukeBox.Colours.HUDBase )
		
		draw.RoundedBox( 0, JukeBox.HUD.X+2, JukeBox.HUD.Y+JukeBox.HUD.H-JukeBox.HUD.BarHeight+5+2, JukeBox.HUD.W-4, JukeBox.HUD.BarHeight-4, ColorAlpha( JukeBox.Colours.HUDBase, JukeBox.Colours.HUDBase.a/4) )
		
		surface.SetDrawColor( JukeBox.Colours.HUDFont )
		surface.SetMaterial( Material( "jukebox/play.png" ) )
		surface.DrawTexturedRectRotated( JukeBox.HUD.X+((JukeBox.HUD.H-JukeBox.HUD.BarHeight)/2), JukeBox.HUD.Y+((JukeBox.HUD.H-JukeBox.HUD.BarHeight)/2), 40, 40, 0 )
		
		draw.SimpleText( JukeBox.SongList[JukeBox.CurPlaying].name, "JukeBox.Font.20", JukeBox.HUD.X+10+40+1, JukeBox.HUD.Y+16+1, JukeBox.Colours.HUDBase, 0, 1 )
		draw.SimpleText( JukeBox.SongList[JukeBox.CurPlaying].name, "JukeBox.Font.20", JukeBox.HUD.X+10+40, JukeBox.HUD.Y+16, JukeBox.Colours.HUDFont, 0, 1 )
		
		draw.SimpleText( JukeBox.SongList[JukeBox.CurPlaying].artist, "JukeBox.Font.16", JukeBox.HUD.X+10+40+1, JukeBox.HUD.Y+(JukeBox.HUD.H-JukeBox.HUD.BarHeight)-16+1, JukeBox.Colours.HUDBase, 0, 1 )
		draw.SimpleText( JukeBox.SongList[JukeBox.CurPlaying].artist, "JukeBox.Font.16", JukeBox.HUD.X+10+40, JukeBox.HUD.Y+(JukeBox.HUD.H-JukeBox.HUD.BarHeight)-16, JukeBox.Colours.HUDFont, 0, 1 )
		
		length = tonumber(JukeBox.SongList[JukeBox.CurPlaying].length)
		local time =  string.FormattedTime( length )
		minsec1 = time.h!=0 and Format("%02i:%02i:%02i", time.h, time.m, time.s) or Format("%02i:%02i", time.m, time.s)
		time2 = string.FormattedTime( math.Clamp( math.Round(CurTime()-JukeBox.CurPlayingStart), 0, length ) )
		minsec2 = time2.h!=0 and Format("%02i:%02i:%02i", time2.h, time2.m, time2.s) or Format("%02i:%02i", time2.m, time2.s)
		percent = math.Clamp( ((CurTime()-JukeBox.CurPlayingStart)/(JukeBox.CurPlayingEnd-JukeBox.CurPlayingStart)), 0, 1 )
		
		draw.RoundedBox( 0, JukeBox.HUD.X+4, JukeBox.HUD.Y+JukeBox.HUD.H-JukeBox.HUD.BarHeight+5+4, (JukeBox.HUD.W-8)*percent, JukeBox.HUD.BarHeight-8, Color(223, 163, 0) )

		draw.SimpleText( minsec2, "JukeBox.Font.13", JukeBox.HUD.X+8+1, JukeBox.HUD.Y+JukeBox.HUD.H-(JukeBox.HUD.BarHeight/2)+4+1, JukeBox.Colours.HUDBase, 0, 1 )
		draw.SimpleText( minsec2, "JukeBox.Font.13", JukeBox.HUD.X+8, JukeBox.HUD.Y+JukeBox.HUD.H-(JukeBox.HUD.BarHeight/2)+4, JukeBox.Colours.HUDFont, 0, 1 )
		
		draw.SimpleText( minsec1, "JukeBox.Font.13", JukeBox.HUD.X+JukeBox.HUD.W-8+1, JukeBox.HUD.Y+JukeBox.HUD.H-(JukeBox.HUD.BarHeight/2)+4+1, JukeBox.Colours.HUDBase, 2, 1 )
		draw.SimpleText( minsec1, "JukeBox.Font.13", JukeBox.HUD.X+JukeBox.HUD.W-8, JukeBox.HUD.Y+JukeBox.HUD.H-(JukeBox.HUD.BarHeight/2)+4, JukeBox.Colours.HUDFont, 2, 1 )
	end
end
hook.Add("HUDPaint", "JukeBox.HUD.Hook", function() JukeBox.HUD.PaintHUD() end )