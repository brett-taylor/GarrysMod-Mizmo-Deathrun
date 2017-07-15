--// Creates the player (hidden) \\--
function JukeBox:InitPlayer()
	if not (self.HTMLPlayer) then
		self.HTMLPlayer = vgui.Create( "DHTML" )
	end
	self.HTMLPlayer:SetPos( 0, 0 )
	self.HTMLPlayer:SetSize( 0, 0 )
	self.HTMLPlayer:SetAllowLua( true )
	/*																							*\
		A word of apology here. I've had to overwrite this function because
        the YouTube API causes HTML errors to be spammed into the console on first song start.
		Overwriting this seems to suppress the messages.
		I don't want to have to do this but I see no other alternative.
		Sorry to delete your error messages.
	\*																							*/
	function self.HTMLPlayer:ConsoleMessage( msg )
		if ( !isstring( msg ) ) then msg = "*js variable*" end
		if ( string.StartWith( msg, "RUNLUA:" ) ) then
			local strLua = string.sub( msg, 8 )
			RunString( strLua )
			return; 
		end
		--MsgC( Color( 255, 160, 255 ), "[HTML] " )
		--MsgC( Color( 255, 255, 255 ), msg, "\n" )	
	end
	self.HTMLPlayer:OpenURL( JukeBox.Settings.PlayerURL )
end

--// Stops the video \\--
function JukeBox:StopVideo()
	if not (self.HTMLPlayer) then return end
	self.HTMLPlayer:RunJavascript( "player.stopVideo();")
end

--// Plays the video \\--
function JukeBox:PlayVideo( id )
	if not (self.HTMLPlayer) then return end
	if not tobool( cookie.GetString( "JukeBox_Enabled", "false" ) ) then return end
	if not JukeBox.Settings.PlayWhileAlive and LocalPlayer():Alive() then return end
	self.HTMLPlayer:RunJavascript( 'player.loadVideoById("'..id..'", 0, "medium");')
end

--// Sets the volume of the player \\--
function JukeBox:SetVolume( volume )
	if not (self.HTMLPlayer) then return end
	self.HTMLPlayer:RunJavascript( "player.setVolume("..volume..");")
end

--// Goes to specific point in video \\--
function JukeBox:PlayVideoFromTime( id, time )
	if not (self.HTMLPlayer) then return end
	if not tobool( cookie.GetString( "JukeBox_Enabled", "false" ) ) then return end
	if not JukeBox.Settings.PlayWhileAlive and LocalPlayer():Alive() then return end
	self.HTMLPlayer:RunJavascript( 'player.loadVideoById("'.. id .. '", '..time..', "medium");')
end

--// Ends at specific point in video \\--
function JukeBox:PlayVideoUntilTime( id, time )
	if not (self.HTMLPlayer) then return end
	if not tobool( cookie.GetString( "JukeBox_Enabled", "false" ) ) then return end
	if not JukeBox.Settings.PlayWhileAlive and LocalPlayer():Alive() then return end
	self.HTMLPlayer:RunJavascript( 'player.loadVideoById({ "videoId" : "'..id..'", "startSeconds" : 0, "endSeconds" : '..time..', "suggestedQuality" : "medium" });')
end

--// Makes use of startTime and endTime \\--
function JukeBox:PlayVideoWithTimes( id, startTime, endTime )
	if not (self.HTMLPlayer) then return end
	if not tobool( cookie.GetString( "JukeBox_Enabled", "false" ) ) then return end
	if not JukeBox.Settings.PlayWhileAlive and LocalPlayer():Alive() then return end
	self.HTMLPlayer:RunJavascript( 'player.loadVideoById({ "videoId" : "'..id..'", "startSeconds" : '..startTime..', "endSeconds" : '..endTime..', "suggestedQuality" : "medium" });')
end

--// Start-up Hook \\--
hook.Add( "Initialize", "JukeBox_ClientStartUp", function() 
	JukeBox:InitPlayer()
	timer.Simple( 1, function()
		JukeBox:SetVolume( cookie.GetNumber( "JukeBox_Volume", 25 ) )
	end )
end)