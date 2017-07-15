JukeBox.VGUI.Pages.Options = {}

function JukeBox.VGUI.Pages.Options:CreatePanel( parent )
	parent.Scroll = vgui.Create( "DScrollPanel", parent )
	parent.Scroll:Dock( FILL )
	parent.Scroll.pnlCanvas:DockPadding( 100, 30, 100, 30 )
	parent.Scroll.Count = 0
	parent.Scroll.VBar:SetWide( 10 )
	parent.Scroll.Paint = function( self, w, h )

	end
	parent.Scroll.VBar.Paint = function( self, w, h )
		draw.RoundedBox( 0, 0, 0, w, h, JukeBox.Colours.Base )
	end
	parent.Scroll.VBar.btnGrip.Paint = function( self, w, h )
		draw.RoundedBox( w/2, 0, 0, w, h, JukeBox.Colours.Light )
	end
	parent.Scroll.VBar.btnUp.Paint = function( self, w, h )
		JukeBox.VGUI.VGUI:DrawEmblem( w/2, h/2, w, "jukebox/arrow.png", Color( 200, 200, 200 ), 0 )
	end
	parent.Scroll.VBar.btnDown.Paint = function( self, w, h )
		JukeBox.VGUI.VGUI:DrawEmblem( w/2, h/2, w, "jukebox/arrow.png", Color( 200, 200, 200 ), 180 )
	end
	
	parent.ChatLabel = vgui.Create( "DLabel", parent.Scroll )
	parent.ChatLabel:SetText( "Chat Messages:" )
	parent.ChatLabel:SetFont( "JukeBox.Font.18" )
	parent.ChatLabel:SetTextColor( Color( 255, 255, 255 ) )
	parent.ChatLabel:SetTall( 24 )
	parent.ChatLabel:Dock( TOP )
	parent.ChatLabel:DockMargin( 0, 0, 0, 10 )
	parent.ChatLabel.PaintOver = function( self, w, h )
		draw.RoundedBox( 0, 0, h-1, w, 1, JukeBox.Colours.Light )
	end
	
	parent.StartSong = vgui.Create( "DPanel", parent.Scroll )
	parent.StartSong:Dock( TOP )
	parent.StartSong:DockPadding( 0, 3, 0, 3 )
	parent.StartSong:DockMargin( 0, 0, 0, 0 )
	parent.StartSong:SetTall( 30 )
	parent.StartSong.Paint = function( self, w, h )
		--draw.RoundedBox( 0, 0, 0, w, h, Color( 255, 0, 0 ) )
		draw.SimpleText( "When a song starts playing.", "JukeBox.Font.16", 80, h/2, Color( 255, 255, 255 ), 0, 1 )
	end
	
	parent.StartSongButton = vgui.Create( "DButton", parent.StartSong )
	parent.StartSongButton:Dock( LEFT )
	parent.StartSongButton:SetWide( 70 )
	parent.StartSongButton:SetTall( 24 )
	parent.StartSongButton.Enabled = tobool( cookie.GetString( "JukeBox_ChatStartSong", "failure" ) )
	parent.StartSongButton:SetText( "" )
	parent.StartSongButton.DoClick = function( self )
		self.Enabled = !self.Enabled
		cookie.Set( "JukeBox_ChatStartSong", tostring(self.Enabled) )
	end
	parent.StartSongButton.Paint = function( self, w, h )
		if self.Enabled then
			draw.RoundedBox( h/2, 0, 0, w, h, JukeBox.Colours.Accept )
		else
			draw.RoundedBox( h/2, 0, 0, w, h, JukeBox.Colours.Light )
		end
		if JukeBox.VGUI.VGUI:GetHovered( self ) then
			draw.RoundedBox( h/2, 0, 0, w, h, Color( 0, 0, 0, 100 ) )
		end
		if self.Enabled then
			draw.SimpleText( "Enabled", "JukeBox.Font.16", w/2, h/2, Color( 255, 255, 255 ), 1, 1 )
		else
			draw.SimpleText( "Enable", "JukeBox.Font.16", w/2, h/2, Color( 255, 255, 255 ), 1, 1 )
		end
	end
	
	parent.SkipSong = vgui.Create( "DPanel", parent.Scroll )
	parent.SkipSong:Dock( TOP )
	parent.SkipSong:DockPadding( 0, 3, 0, 3 )
	parent.SkipSong:DockMargin( 0, 0, 0, 0 )
	parent.SkipSong:SetTall( 30 )
	parent.SkipSong.Paint = function( self, w, h )
		--draw.RoundedBox( 0, 0, 0, w, h, Color( 255, 0, 0 ) )
		draw.SimpleText( "When a song is skipped.", "JukeBox.Font.16", 80, h/2, Color( 255, 255, 255 ), 0, 1 )
	end
	
	parent.SkipSongButton = vgui.Create( "DButton", parent.SkipSong )
	parent.SkipSongButton:Dock( LEFT )
	parent.SkipSongButton:SetWide( 70 )
	parent.SkipSongButton:SetTall( 24 )
	parent.SkipSongButton.Enabled = tobool( cookie.GetString( "JukeBox_ChatSkipSong", "failure" ) )
	parent.SkipSongButton:SetText( "" )
	parent.SkipSongButton.DoClick = function( self )
		self.Enabled = !self.Enabled
		cookie.Set( "JukeBox_ChatSkipSong", tostring(self.Enabled) )
	end
	parent.SkipSongButton.Paint = function( self, w, h )
		if self.Enabled then
			draw.RoundedBox( h/2, 0, 0, w, h, JukeBox.Colours.Accept )
		else
			draw.RoundedBox( h/2, 0, 0, w, h, JukeBox.Colours.Light )
		end
		if JukeBox.VGUI.VGUI:GetHovered( self ) then
			draw.RoundedBox( h/2, 0, 0, w, h, Color( 0, 0, 0, 100 ) )
		end
		if self.Enabled then
			draw.SimpleText( "Enabled", "JukeBox.Font.16", w/2, h/2, Color( 255, 255, 255 ), 1, 1 )
		else
			draw.SimpleText( "Enable", "JukeBox.Font.16", w/2, h/2, Color( 255, 255, 255 ), 1, 1 )
		end
	end
	
	parent.VoteSkipSong = vgui.Create( "DPanel", parent.Scroll )
	parent.VoteSkipSong:Dock( TOP )
	parent.VoteSkipSong:DockPadding( 0, 3, 0, 3 )
	parent.VoteSkipSong:DockMargin( 0, 0, 0, 0 )
	parent.VoteSkipSong:SetTall( 30 )
	parent.VoteSkipSong.Paint = function( self, w, h )
		--draw.RoundedBox( 0, 0, 0, w, h, Color( 255, 0, 0 ) )
		draw.SimpleText( "When someone votes to skip a song.", "JukeBox.Font.16", 80, h/2, Color( 255, 255, 255 ), 0, 1 )
	end
	
	parent.VoteSkipSongButton = vgui.Create( "DButton", parent.VoteSkipSong )
	parent.VoteSkipSongButton:Dock( LEFT )
	parent.VoteSkipSongButton:SetWide( 70 )
	parent.VoteSkipSongButton:SetTall( 24 )
	parent.VoteSkipSongButton.Enabled = tobool( cookie.GetString( "JukeBox_ChatVoteSkip", "failure" ) )
	parent.VoteSkipSongButton:SetText( "" )
	parent.VoteSkipSongButton.DoClick = function( self )
		self.Enabled = !self.Enabled
		cookie.Set( "JukeBox_ChatVoteSkip", tostring(self.Enabled) )
	end
	parent.VoteSkipSongButton.Paint = function( self, w, h )
		if self.Enabled then
			draw.RoundedBox( h/2, 0, 0, w, h, JukeBox.Colours.Accept )
		else
			draw.RoundedBox( h/2, 0, 0, w, h, JukeBox.Colours.Light )
		end
		if JukeBox.VGUI.VGUI:GetHovered( self ) then
			draw.RoundedBox( h/2, 0, 0, w, h, Color( 0, 0, 0, 100 ) )
		end
		if self.Enabled then
			draw.SimpleText( "Enabled", "JukeBox.Font.16", w/2, h/2, Color( 255, 255, 255 ), 1, 1 )
		else
			draw.SimpleText( "Enable", "JukeBox.Font.16", w/2, h/2, Color( 255, 255, 255 ), 1, 1 )
		end
	end
	
	parent.QueueSong = vgui.Create( "DPanel", parent.Scroll )
	parent.QueueSong:Dock( TOP )
	parent.QueueSong:DockPadding( 0, 3, 0, 3 )
	parent.QueueSong:DockMargin( 0, 0, 0, 0 )
	parent.QueueSong:SetTall( 30 )
	parent.QueueSong.Paint = function( self, w, h )
		--draw.RoundedBox( 0, 0, 0, w, h, Color( 255, 0, 0 ) )
		draw.SimpleText( "When a song is added to the queue.", "JukeBox.Font.16", 80, h/2, Color( 255, 255, 255 ), 0, 1 )
	end
	
	parent.QueueSongButton = vgui.Create( "DButton", parent.QueueSong )
	parent.QueueSongButton:Dock( LEFT )
	parent.QueueSongButton:SetWide( 70 )
	parent.QueueSongButton:SetTall( 24 )
	parent.QueueSongButton.Enabled = tobool( cookie.GetString( "JukeBox_ChatQueueSong", "failure" ) )
	parent.QueueSongButton:SetText( "" )
	parent.QueueSongButton.DoClick = function( self )
		self.Enabled = !self.Enabled
		cookie.Set( "JukeBox_ChatQueueSong", tostring(self.Enabled) )
	end
	parent.QueueSongButton.Paint = function( self, w, h )
		if self.Enabled then
			draw.RoundedBox( h/2, 0, 0, w, h, JukeBox.Colours.Accept )
		else
			draw.RoundedBox( h/2, 0, 0, w, h, JukeBox.Colours.Light )
		end
		if JukeBox.VGUI.VGUI:GetHovered( self ) then
			draw.RoundedBox( h/2, 0, 0, w, h, Color( 0, 0, 0, 100 ) )
		end
		if self.Enabled then
			draw.SimpleText( "Enabled", "JukeBox.Font.16", w/2, h/2, Color( 255, 255, 255 ), 1, 1 )
		else
			draw.SimpleText( "Enable", "JukeBox.Font.16", w/2, h/2, Color( 255, 255, 255 ), 1, 1 )
		end
	end
	
	if JukeBox:IsManager( LocalPlayer() ) then
		parent.AdminRequestAdded = vgui.Create( "DPanel", parent.Scroll )
		parent.AdminRequestAdded:Dock( TOP )
		parent.AdminRequestAdded:DockPadding( 0, 3, 0, 3 )
		parent.AdminRequestAdded:DockMargin( 0, 0, 0, 0 )
		parent.AdminRequestAdded:SetTall( 30 )
		parent.AdminRequestAdded.Paint = function( self, w, h )
			--draw.RoundedBox( 0, 0, 0, w, h, Color( 255, 0, 0 ) )
			draw.SimpleText( "[MANAGER] When a new request is submitted.", "JukeBox.Font.16", 80, h/2, Color( 255, 255, 255 ), 0, 1 )
		end
		
		parent.AdminRequestAddedButton = vgui.Create( "DButton", parent.AdminRequestAdded )
		parent.AdminRequestAddedButton:Dock( LEFT )
		parent.AdminRequestAddedButton:SetWide( 70 )
		parent.AdminRequestAddedButton:SetTall( 24 )
		parent.AdminRequestAddedButton.Enabled = tobool( cookie.GetString( "JukeBox_ChatAdminRequest", "failure" ) )
		parent.AdminRequestAddedButton:SetText( "" )
		parent.AdminRequestAddedButton.DoClick = function( self )
			self.Enabled = !self.Enabled
			cookie.Set( "JukeBox_ChatAdminRequest", tostring(self.Enabled) )
		end
		parent.AdminRequestAddedButton.Paint = function( self, w, h )
			if self.Enabled then
				draw.RoundedBox( h/2, 0, 0, w, h, JukeBox.Colours.Accept )
			else
				draw.RoundedBox( h/2, 0, 0, w, h, JukeBox.Colours.Light )
			end
			if JukeBox.VGUI.VGUI:GetHovered( self ) then
				draw.RoundedBox( h/2, 0, 0, w, h, Color( 0, 0, 0, 100 ) )
			end
			if self.Enabled then
				draw.SimpleText( "Enabled", "JukeBox.Font.16", w/2, h/2, Color( 255, 255, 255 ), 1, 1 )
			else
				draw.SimpleText( "Enable", "JukeBox.Font.16", w/2, h/2, Color( 255, 255, 255 ), 1, 1 )
			end
		end
	end
end

JukeBox.VGUI:RegisterPage( "USER", "Options", "Options", "jukebox/options.png", function( parent ) JukeBox.VGUI.Pages.Options:CreatePanel( parent ) end )

-- Sorry, as the options page is currently empty, I left it off the main VGUI
-- When there are more options available, I'll enable this