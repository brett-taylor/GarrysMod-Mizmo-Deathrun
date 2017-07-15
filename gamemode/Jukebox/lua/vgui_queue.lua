JukeBox.VGUI.Pages.Queue = {}

function JukeBox.VGUI.Pages.Queue:CreatePanel( parent )
	parent.Header = vgui.Create( "DPanel", parent )
	parent.Header:Dock( TOP )
	parent.Header:SetTall( 40 )
	parent.Header.Paint = function( self, w, h )
		draw.SimpleText( "#", "JukeBox.Font.18", 24, h/2, Color( 200, 200, 200 ), 0, 1 )
		draw.SimpleText( "SONG", "JukeBox.Font.18", 82, h/2, Color( 200, 200, 200 ), 0, 1 )
		draw.SimpleText( "ARTIST", "JukeBox.Font.18", w/2.5, h/2, Color( 200, 200, 200 ), 0, 1 )
		draw.SimpleText( "LENGTH", "JukeBox.Font.18", w-135, h/2, Color( 200, 200, 200 ), 2, 1 )
		draw.RoundedBox( 0, 0, h-1, w, 1, JukeBox.Colours.Base )
	end
	
	parent.Scroll = vgui.Create( "DScrollPanel", parent )
	parent.Scroll:Dock( FILL )
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
	
	function parent.Scroll:UpdateQueue()
		self:Clear()
		self.Count = 0
		if table.Count( JukeBox.SongList ) <= 0 then
			--self:MakeEmptyNotice()
		else
			for pos, data in pairs( JukeBox.QueueList ) do
				id = data.id
				JukeBox.VGUI.Pages.Queue:CreateSongCard( parent, pos, JukeBox.SongList[id].name, JukeBox.SongList[id].artist, JukeBox.SongList[id].id, JukeBox.SongList[id].length, data )
				self.Count = self.Count+1
			end
		end
	end
	parent.Scroll:UpdateQueue()
	hook.Add( "JukeBox_QueueUpdated", "JukeBox_VGUI_QueueUpdate", function() 
		if ValidPanel( parent ) then
			parent.Scroll:UpdateQueue()
		end 
	end )
	
	--for i=1, 100 do
	--	JukeBox.VGUI.Pages.AllSongs:CreateSongCard( parent, "Song name", "Artist", "00000000000", "1:27" )
	--end
end

function JukeBox.VGUI.Pages.Queue:CreateSongCard( parent, pos, name, artist, id, length, info ) --Eugh, this needs a re-do...
	local card = vgui.Create( "DPanel", parent )
	card:SetTall( 40 )
	card:Dock( TOP )
	card:DockMargin( 15, 0, 20, 0 )
	card.Paint = function( self, w, h )
		if JukeBox.VGUI.VGUI:GetHovered( self ) then
			draw.RoundedBox( 0, 0, 0, w, h, JukeBox.Colours.Base )
		end
		draw.SimpleText( pos, "JukeBox.Font.20", 10, h/2, Color( 255, 255, 255 ), 0, 1 )
		draw.SimpleText( name, "JukeBox.Font.20", 70, h/2, Color( 255, 255, 255 ), 0, 1 )
		draw.SimpleText( artist, "JukeBox.Font.20", w/2.5, h/2, Color( 255, 255, 255 ), 0, 1 )
		local time =  string.FormattedTime( length )
		draw.SimpleText( time.h!=0 and Format("%02i:%02i:%02i", time.h, time.m, time.s) or Format("%02i:%02i", time.m, time.s), "JukeBox.Font.20", w-144, h/2, Color( 255, 255, 255 ), 1, 1 )
		draw.RoundedBox( 0, 0, h-1, w, 1, JukeBox.Colours.Base )
	end
	
	if JukeBox:IsManager( LocalPlayer() ) then
		card.DeleteButton = vgui.Create( "DButton", card )
		card.DeleteButton:Dock( RIGHT )
		card.DeleteButton:DockMargin( 0, 5, 10, 5 )
		card.DeleteButton:SetWide( 30 )
		card.DeleteButton:SetText( "" )
		card.DeleteButton.DoClick = function()
			JukeBox.VGUI.Pages.Queue:DeletePopup( parent, info )
		end
		card.DeleteButton.Paint = function( self, w, h )
			if JukeBox.VGUI.VGUI:GetHovered( self ) then
				draw.RoundedBox( h/2+1, 0, 0, w, h, JukeBox.Colours.Issue )
			else
				draw.RoundedBox( h/2+1, 0, 0, w, h, JukeBox.Colours.Light )
			end
			JukeBox.VGUI.VGUI:DrawEmblem( h/2, h/2, 16, "jukebox/cross.png", Color( 255, 255, 255 ), 0 )
		end
		
		card.PlayerButton = vgui.Create( "DButton", card )
		card.PlayerButton:Dock( RIGHT )
		card.PlayerButton:DockMargin( 0, 5, 10, 5 )
		card.PlayerButton:SetWide( 30 )
		card.PlayerButton:SetText( "" )
		card.PlayerButton.DoClick = function()
			JukeBox.VGUI.Pages.Queue:ShowQueuerInfo( parent, info.PlayerName, info.PlayerSID )
		end
		card.PlayerButton.Paint = function( self, w, h )
			if JukeBox.VGUI.VGUI:GetHovered( self ) then
				draw.RoundedBox( h/2+1, 0, 0, w, h, JukeBox.Colours.Definition )
			else
				draw.RoundedBox( h/2+1, 0, 0, w, h, JukeBox.Colours.Light )
			end
			JukeBox.VGUI.VGUI:DrawEmblem( h/2, h/2, 16, "jukebox/list.png", Color( 255, 255, 255 ), 0 )
		end
	end
	
	parent.Scroll:AddItem( card )
end

function JukeBox.VGUI.Pages.Queue:ShowQueuerInfo( parent, name, steamid )
	if not name then name = "" end
	if not steamid then steamid = "" end
	local text = "Information about the queuer:\n\nSteam Name : "..name.."\nSteamID       : "..steamid.."\n\nIf this is blank, the song was queued before an update."
	
	local bg = vgui.Create( "DFrame" )
	bg:SetSize( ScrW(), ScrH() )
	bg:Center()
	bg:SetTitle( " " )
	bg:ShowCloseButton( false )
	bg:SetDraggable( false )
	bg:DockPadding( 0, 0, 0, 0 )
	bg:MakePopup()
	bg.Paint = function( self, w, h )
		Derma_DrawBackgroundBlur( self, CurTime() )
	end
	
	local popup = vgui.Create( "DPanel", bg )
	popup:SetSize( 500, 400 )
	popup:Center()
	popup.Paint = function( self, w, h )
		draw.RoundedBox( 0, 0, 0, w, h, JukeBox.Colours.Background )
	end
	
	popup.TopBar = vgui.Create( "DPanel", popup )
	popup.TopBar:Dock( TOP )
	popup.TopBar:SetTall( 28 )
	popup.TopBar:DockPadding( 4, 4, 4, 4 )
	popup.TopBar.Paint = function( self, w, h )
		draw.RoundedBox( 0, 0, 0, w, h, JukeBox.Colours.Base )
		draw.SimpleText( "JukeBox - Queuer Info", "JukeBox.Font.18", w/2, h/2, Color( 255, 255, 255 ), 1, 1 )
	end
	
	popup.TopBar.CloseButton = vgui.Create( "DButton", popup.TopBar )
	popup.TopBar.CloseButton:Dock( RIGHT )
	popup.TopBar.CloseButton:SetWide( 50 )
	popup.TopBar.CloseButton:SetText( "" )
	popup.TopBar.CloseButton.DoClick = function()
		bg:Remove()
	end
	popup.TopBar.CloseButton.Paint = function( self, w, h )
		draw.RoundedBox( 0, 0, 0, w, h, Color( 192, 57, 43 ) )
		if not JukeBox.VGUI.VGUI:GetHovered( self ) then
			draw.RoundedBox( 0, 0, 0, w, h, Color( 0, 0, 0, 100 ) )
		end
		JukeBox.VGUI.VGUI:DrawEmblem( w/2, h/2, 10, "jukebox/close.png", Color( 255, 255, 255 ), 0 )
	end
	
	popup.Content = vgui.Create( "DPanel", popup )
	popup.Content:DockMargin( 0, 1, 0, 0 )
	popup.Content:DockPadding( 5, 5, 5, 5 )
	popup.Content:Dock( FILL )
	popup.Content.Progress = 1
	popup.Content.ProgressData = ""
	popup.Content.Paint = function( self, w, h )
		draw.RoundedBox( 0, 0, 0, w, h, JukeBox.Colours.Base )
	end
	
	popup.Body = vgui.Create( "DLabel", popup.Content )
	popup.Body:SetFont( "JukeBox.Font.18" )
	popup.Body:SetTextColor( Color( 255, 255, 255 ) )
	popup.Body:SetText( text )
	popup.Body:SizeToContents()
	popup:SetWide( popup.Body:GetWide()+10 )
	popup:SetTall( popup.Body:GetTall()+popup.TopBar:GetTall()+11+50 )
	popup.Body:Dock( TOP )
	
	popup.BottomBar = vgui.Create( "DPanel", popup.Content )
	popup.BottomBar:Dock( BOTTOM )
	popup.BottomBar:SetTall( 30 )
	popup.BottomBar:DockMargin( 0, 0, 0, 5 )
	popup.BottomBar.Paint = function( self, w, h ) end
	
	popup.AcceptButton = vgui.Create( "DButton", popup.BottomBar )
	popup.AcceptButton:SetWide( 160 )
	popup.AcceptButton:Dock( LEFT )
	popup.AcceptButton:SetVisible( true )
	popup.AcceptButton:DockMargin( 10, 0, 0, 0 )
	popup.AcceptButton:SetText( "" )
	popup.AcceptButton.Text = "Copy SteamID"
	popup.AcceptButton.DoClick = function()
		SetClipboardText( steamid )
	end
	popup.AcceptButton.Paint = function( self, w, h )
		if JukeBox.VGUI.VGUI:GetHovered( self ) then
			draw.RoundedBox( h/2-1, 0, 0, w, h, JukeBox.Colours.Accept )
		else
			draw.RoundedBox( h/2-1, 0, 0, w, h, JukeBox.Colours.Light )
		end
		JukeBox.VGUI.VGUI:DrawEmblem( h*0.75, h/2, 16, "jukebox/edit.png", Color( 255, 255, 255 ), 0 )
		draw.SimpleText( self.Text, "JukeBox.Font.20", h+10, h/2-2, Color( 255, 255, 255 ), 0, 1 )
	end
	
	popup.CancelButton = vgui.Create( "DButton", popup.BottomBar )
	popup.CancelButton:SetWide( 100 )
	popup.CancelButton:Dock( RIGHT )
	popup.CancelButton:SetVisible( true )
	popup.CancelButton:DockMargin( 0, 0, 10, 0 )
	popup.CancelButton:SetText( "" )
	popup.CancelButton.Text = "Close"
	popup.CancelButton.DoClick = function()
		bg:Remove()
	end
	popup.CancelButton.Paint = function( self, w, h )
		if JukeBox.VGUI.VGUI:GetHovered( self ) then
			draw.RoundedBox( h/2-1, 0, 0, w, h, Color( 0, 0, 0, 100 ) )
		else
			draw.RoundedBox( h/2-1, 0, 0, w, h, JukeBox.Colours.Light )
		end
		draw.SimpleText( self.Text, "JukeBox.Font.20", w/2, h/2-2, Color( 255, 255, 255 ), 1, 1 )
	end
	
	popup:Center()
end

function JukeBox.VGUI.Pages.Queue:DeletePopup( parent, info )
	local text = "Are you sure you wish to remove this song from the Queue?"
	
	local bg = vgui.Create( "DFrame" )
	bg:SetSize( ScrW(), ScrH() )
	bg:Center()
	bg:SetTitle( " " )
	bg:ShowCloseButton( false )
	bg:SetDraggable( false )
	bg:DockPadding( 0, 0, 0, 0 )
	bg:MakePopup()
	bg.Paint = function( self, w, h )
		Derma_DrawBackgroundBlur( self, CurTime() )
	end
	
	local popup = vgui.Create( "DPanel", bg )
	popup:SetSize( 500, 400 )
	popup:Center()
	popup.Paint = function( self, w, h )
		draw.RoundedBox( 0, 0, 0, w, h, JukeBox.Colours.Background )
	end
	
	popup.TopBar = vgui.Create( "DPanel", popup )
	popup.TopBar:Dock( TOP )
	popup.TopBar:SetTall( 28 )
	popup.TopBar:DockPadding( 4, 4, 4, 4 )
	popup.TopBar.Paint = function( self, w, h )
		draw.RoundedBox( 0, 0, 0, w, h, JukeBox.Colours.Base )
		draw.SimpleText( "JukeBox - Removing Song from Queue", "JukeBox.Font.18", w/2, h/2, Color( 255, 255, 255 ), 1, 1 )
	end
	
	popup.TopBar.CloseButton = vgui.Create( "DButton", popup.TopBar )
	popup.TopBar.CloseButton:Dock( RIGHT )
	popup.TopBar.CloseButton:SetWide( 50 )
	popup.TopBar.CloseButton:SetText( "" )
	popup.TopBar.CloseButton.DoClick = function()
		bg:Remove()
	end
	popup.TopBar.CloseButton.Paint = function( self, w, h )
		draw.RoundedBox( 0, 0, 0, w, h, Color( 192, 57, 43 ) )
		if not JukeBox.VGUI.VGUI:GetHovered( self ) then
			draw.RoundedBox( 0, 0, 0, w, h, Color( 0, 0, 0, 100 ) )
		end
		JukeBox.VGUI.VGUI:DrawEmblem( w/2, h/2, 10, "jukebox/close.png", Color( 255, 255, 255 ), 0 )
	end
	
	popup.Content = vgui.Create( "DPanel", popup )
	popup.Content:DockMargin( 0, 1, 0, 0 )
	popup.Content:DockPadding( 5, 5, 5, 5 )
	popup.Content:Dock( FILL )
	popup.Content.Progress = 1
	popup.Content.ProgressData = ""
	popup.Content.Paint = function( self, w, h )
		draw.RoundedBox( 0, 0, 0, w, h, JukeBox.Colours.Base )
	end
	
	popup.Body = vgui.Create( "DLabel", popup.Content )
	popup.Body:SetFont( "JukeBox.Font.18" )
	popup.Body:SetTextColor( Color( 255, 255, 255 ) )
	popup.Body:SetText( text )
	popup.Body:SizeToContents()
	popup:SetWide( popup.Body:GetWide()+10 )
	popup:SetTall( popup.Body:GetTall()+popup.TopBar:GetTall()+11+50 )
	popup.Body:Dock( TOP )
	
	popup.BottomBar = vgui.Create( "DPanel", popup.Content )
	popup.BottomBar:Dock( BOTTOM )
	popup.BottomBar:SetTall( 30 )
	popup.BottomBar:DockMargin( 0, 0, 0, 5 )
	popup.BottomBar.Paint = function( self, w, h ) end
	
	popup.DeleteButton = vgui.Create( "DButton", popup.BottomBar )
	popup.DeleteButton:SetWide( 150 )
	popup.DeleteButton:Dock( LEFT )
	popup.DeleteButton:SetVisible( true )
	popup.DeleteButton:DockMargin( 10, 0, 0, 0 )
	popup.DeleteButton:SetText( "" )
	popup.DeleteButton.DoClick = function()
		JukeBox:DeleteQueuedSong( info.id )
		bg:Remove()
	end
	popup.DeleteButton.Paint = function( self, w, h )
		if JukeBox.VGUI.VGUI:GetHovered( self ) then
			draw.RoundedBox( h/2-1, 0, 0, w, h, JukeBox.Colours.Issue )
		else
			draw.RoundedBox( h/2-1, 0, 0, w, h, JukeBox.Colours.Light )
		end
		JukeBox.VGUI.VGUI:DrawEmblem( h*0.75, h/2, 16, "jukebox/cross.png", Color( 255, 255, 255 ), 0 )
		draw.SimpleText( "Remove Song", "JukeBox.Font.20", h+10, h/2-2, Color( 255, 255, 255 ), 0, 1 )
	end
	
	popup.CancelButton = vgui.Create( "DButton", popup.BottomBar )
	popup.CancelButton:SetWide( 100 )
	popup.CancelButton:Dock( RIGHT )
	popup.CancelButton:SetVisible( true )
	popup.CancelButton:DockMargin( 0, 0, 10, 0 )
	popup.CancelButton:SetText( "" )
	popup.CancelButton.DoClick = function()
		bg:Remove()
	end
	popup.CancelButton.Paint = function( self, w, h )
		if JukeBox.VGUI.VGUI:GetHovered( self ) then
			draw.RoundedBox( h/2-1, 0, 0, w, h, Color( 0, 0, 0, 100 ) )
		else
			draw.RoundedBox( h/2-1, 0, 0, w, h, JukeBox.Colours.Light )
		end
		draw.SimpleText( "Cancel", "JukeBox.Font.20", w/2, h/2-2, Color( 255, 255, 255 ), 1, 1 )
	end
	
	popup:Center()
end
 
JukeBox.VGUI:RegisterPage( "MAIN", "Queue", "Queue", "jukebox/list.png", function( parent ) JukeBox.VGUI.Pages.Queue:CreatePanel( parent ) end )