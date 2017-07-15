JukeBox.VGUI.Pages.QuickRequest = {}

function JukeBox.VGUI.Pages.QuickRequest:CreatePanel( parent )
	parent.Description = vgui.Create( "DLabel", parent )
	parent.Description:Dock( TOP )
	parent.Description:SetText( "This allows you to search for a song from YouTube.\nThis returns the top 20 results so that you can easily add them to the JukeBox." )
	parent.Description:SetFont( "JukeBox.Font.20" )
	parent.Description:DockMargin( 10, 10, 10, 0 )
	parent.Description:SetTall( 40 )
	parent.Description:SetWrap( true )
	
	parent.Top = vgui.Create( "DPanel", parent )
	parent.Top:Dock( TOP )
	parent.Top:SetTall( 42 )
	parent.Top.Paint = function( self, w, h )
		draw.RoundedBox( 12, 5, 10, h, h-20, Color( 255, 255, 255 ) )
		draw.RoundedBox( 12, 5+200, 10, h, h-20, Color( 255, 255, 255 ) )
		JukeBox.VGUI.VGUI:DrawEmblem( h/2, h/2, 14, "jukebox/search.png", JukeBox.Colours.Base, 0 )
		draw.RoundedBox( 0, 0, h-1, w, 1, JukeBox.Colours.Base )
	end
	
	parent.Top.Search = vgui.Create( "DTextEntry", parent.Top )
	parent.Top.Search:Dock( LEFT )
	parent.Top.Search:DockMargin( 28, 10, 0, 10 )
	parent.Top.Search:SetWide( 200 )
	parent.Top.Search:SetFont( "JukeBox.Font.16" )
	parent.Top.Search:SetDrawBorder( false )
	parent.Top.Search.Issue = 0
	parent.Top.Search.OnChange = function( self, w, h )
		
	end
	parent.Top.Search.OnEnter = function()
		parent.Scroll.SearchForSong()
	end
	parent.Top.Search.Paint = function( self, w, h )
		draw.RoundedBox( 0, 0, 0, w, h, Color( 255, 255, 255 ) )
		self:DrawTextEntryText( JukeBox.Colours.Base, Color(30, 130, 255), JukeBox.Colours.Base)
	end
	
	parent.Top.Go = vgui.Create( "DButton", parent.Top )
	parent.Top.Go:Dock( LEFT )
	parent.Top.Go:SetWide( 70 )
	parent.Top.Go:SetTall( 24 )
	parent.Top.Go:DockMargin( 24, 10, 0, 8 )
	parent.Top.Go:SetText( "" )
	parent.Top.Go.DoClick = function( self )
		parent.Scroll.SearchForSong()
	end
	parent.Top.Go.Paint = function( self, w, h )
		if self.Enabled then
			draw.RoundedBox( h/2, 0, 0, w, h, JukeBox.Colours.Accept )
		else
			draw.RoundedBox( h/2, 0, 0, w, h, JukeBox.Colours.Light )
		end
		if JukeBox.VGUI.VGUI:GetHovered( self ) then
			draw.RoundedBox( h/2, 0, 0, w, h, Color( 0, 0, 0, 100 ) )
		end
		if self.Enabled then
			draw.SimpleText( "Search", "JukeBox.Font.16", w/2, h/2, Color( 255, 255, 255 ), 1, 1 )
		else
			draw.SimpleText( "Search", "JukeBox.Font.16", w/2, h/2, Color( 255, 255, 255 ), 1, 1 )
		end
	end
	
	parent.Scroll = vgui.Create( "DScrollPanel", parent )
	parent.Scroll:Dock( FILL )
	parent.Scroll.Count = 0
	parent.Scroll.Loading = false
	parent.Scroll.Issue = false
	parent.Scroll.VBar:SetWide( 10 )
	parent.Scroll.Paint = function( self, w, h )
		if self.Loading then
			JukeBox.VGUI.VGUI:DrawEmblem( w/2, h/2-10, 80, "jukebox/loading.png", Color( 255, 255, 255 ), -CurTime()*100 )
		elseif self.Issue then
			draw.SimpleText( self.Issue, "JukeBox.Font.20", w/2, h/2, Color( 255, 255, 255 ), 1, 1 )
		end
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
	
	parent.Scroll.SearchForSong = function()
		parent.Scroll:Clear()
		parent.Scroll.Loading = true
		parent.Scroll.Issue = false
		http.Fetch( JukeBox.Settings.SearchURL..string.Replace(parent.Top.Search:GetValue(), " ", "+"), 
		function( body )
			if not ValidPanel( parent.Scroll ) then return end
			parent.Scroll.Loading = false
			local info = util.JSONToTable( body )
			if not type( info ) == "table" then
				parent.Scroll.Issue = "There was an unexpected error while searching."
				return
			end
			if table.Count( info ) >= 1 then
				for k, v in pairs( info ) do
					parent.Scroll.AddVideoCard( parent.Scroll, v )
				end
			else
				parent.Scroll.Issue = "The search returned no results!"
			end
		end,
		function( issue )
			if not ValidPanel( parent.Scroll ) then return end
			parent.Scroll.Loading = false
			parent.Scroll.Issue = "There was an unexpected error while searching."
		end
		)
	end
	
	parent.Scroll.AddVideoCard = function( parent, info )
		local card = vgui.Create( "DPanel", parent )
		card:SetTall( 110 )
		card:Dock( TOP )
		card:DockMargin( 15, 0, 20, 0 )
		card:DockPadding( 10, 10, 10, 10 )
		card.Paint = function( self, w, h )
			if JukeBox.VGUI.VGUI:GetHovered( self ) then
				draw.RoundedBox( 0, 0, 0, w, h, JukeBox.Colours.Base )
			end
			draw.RoundedBox( 0, 0, h-1, w, 1, JukeBox.Colours.Base )
		end
		
		card.Image = vgui.Create( "HTML", card )
		card.Image:Dock( LEFT )
		card.Image:SetWide( 160 )
		card.Image:DockMargin( 0, 0, 10, 0 )
		card.Image:SetHTML( [[
			<body style="margin:0;">
			<img src="]]..info.image..[[" style="width: 100%; height: 100%;">
		]] )
		
		card.Image.Overlay = vgui.Create( "DPanel", card.Image )
		card.Image.Overlay:Dock( FILL )
		card.Image.Overlay.Paint = function( self, w, h ) end
		
		card.Title = vgui.Create( "DLabel", card )
		card.Title:Dock( TOP )
		card.Title:SetText( info.title )
		card.Title:SetFont( "JukeBox.Font.24.Bold" )
		card.Title:SetTall( 30 )
		
		card.Buttons = vgui.Create( "DPanel", card )
		card.Buttons:Dock( BOTTOM )
		card.Buttons:SetTall( 24 )
		card.Buttons.Paint = function( self, w, h ) end
		
		card.Buttons.View = vgui.Create( "DButton", card.Buttons )
		card.Buttons.View:SetWide( 90 )
		card.Buttons.View:Dock( RIGHT )
		card.Buttons.View:DockMargin( 12, 0, 0, 0 )
		card.Buttons.View:SetText( "" )
		card.Buttons.View.DoClick = function( self )
			local dropdown = vgui.Create( "DMenu" )
			dropdown:SetPos( input.GetCursorPos() )
			dropdown:MakePopup()
			dropdown.Paint = function( self, w, h )
				draw.RoundedBox( 0, 0, 0, w, h, JukeBox.Colours.Background )
			end
			local dropdownVoteButton = dropdown:AddOption( "JukeBox Pop-up" )
			dropdownVoteButton:SetTextColor( Color( 255, 255, 255 ) )
			function dropdownVoteButton:DoClick()
				JukeBox.VGUI.Pages.QuickRequest:CheckURL( parent, info.url )
			end
			dropdown:AddSpacer()
			local dropdownForceButton = dropdown:AddOption( "Steam Overlay" )
			dropdownForceButton:SetTextColor( Color( 255, 255, 255 ) )
			function dropdownForceButton:DoClick()
				gui.OpenURL( "https://www.youtube.com/watch?v="..info.url )
			end
		end
		card.Buttons.View.Paint = function( self, w, h )
			if JukeBox.VGUI.VGUI:GetHovered( self ) then
				draw.RoundedBox( h/2, 0, 0, w, h, JukeBox.Colours.Accept )
			else
				draw.RoundedBox( h/2, 0, 0, w, h, JukeBox.Colours.Light )
			end
			draw.SimpleText( "View Video", "JukeBox.Font.16", w/2, h/2, Color( 255, 255, 255 ), 1, 1 )
		end
		
		card.Buttons.AddSong = vgui.Create( "DButton", card.Buttons )
		card.Buttons.AddSong:SetWide( 140 )
		card.Buttons.AddSong:Dock( RIGHT )
		card.Buttons.AddSong:DockMargin( 12, 0, 0, 0 )
		card.Buttons.AddSong:SetText( "" )
		card.Buttons.AddSong.DoClick = function( self )
			JukeBox.VGUI.Pages.QuickRequest:AddSongPopup( parent, info )
		end
		card.Buttons.AddSong.Paint = function( self, w, h )
			if JukeBox.VGUI.VGUI:GetHovered( self ) then
				draw.RoundedBox( h/2, 0, 0, w, h, JukeBox.Colours.Accept )
			else
				draw.RoundedBox( h/2, 0, 0, w, h, JukeBox.Colours.Light )
			end
			draw.SimpleText( "Add song to JukeBox", "JukeBox.Font.16", w/2, h/2, Color( 255, 255, 255 ), 1, 1 )
		end
		
		card.Description = vgui.Create( "DLabel", card )
		card.Description:Dock( FILL )
		card.Description:SetText( info.desc )
		card.Description:SetFont( "JukeBox.Font.20" )
		card.Description:SetTall( 50 )
		card.Description:SetWrap( true )
		
	end
end

function JukeBox.VGUI.Pages.QuickRequest:CheckURL( parent, id )
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
		draw.SimpleText( "JukeBox - Check URL", "JukeBox.Font.18", w/2, h/2, Color( 255, 255, 255 ), 1, 1 )
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
	popup.Content:DockPadding( 2, 2, 2, 0 )
	popup.Content:Dock( FILL )
	popup.Content.Progress = 1
	popup.Content.ProgressData = ""
	popup.Content.Paint = function( self, w, h )
		draw.RoundedBox( 0, 0, 0, w, h, JukeBox.Colours.Base )
	end
	
	popup.HTML = vgui.Create( "HTML", popup.Content )
	popup.HTML:Dock( FILL )
	popup.HTML.Progress = 1
	popup.HTML.Length = 0
	popup.HTML.LengthString = ""
	popup.HTML.ProgressData = ""
	popup.HTML:OpenURL( JukeBox.Settings.PlayerURL )
	timer.Simple( 1, function()
		if !IsValid( bg ) or !ValidPanel( bg ) then return end
		popup.HTML:RunJavascript( "player.loadVideoById(\"" .. id .. "\", 0, \"medium\");")
		popup.HTML:RunJavascript( "player.setVolume( 50 );")
	end )
	popup.HTML.PaintOver = function( self, w, h )
		if not JukeBox.VGUI.VGUI:GetHovered( self ) then return end
		draw.RoundedBox( 0, 0, 0, w, h, Color( 0, 0, 0, 240 ) )
		if self.Progress == 1 then
			draw.SimpleText( "Checking YouTube URL and data...", "JukeBox.Font.20", w/2, h*0.25, Color( 255, 255, 255 ), 1, 1 )
			JukeBox.VGUI.VGUI:DrawEmblem( w/2, h/2-10, 80, "jukebox/loading.png", Color( 255, 255, 255 ), -CurTime()*100 )
		elseif self.Progress == 2 then
			draw.SimpleText( "Video exists", "JukeBox.Font.20", w/2, h*0.25, Color( 255, 255, 255 ), 1, 1 )
			JukeBox.VGUI.VGUI:DrawEmblem( w/2, h/2-10, 80, "jukebox/tick.png", Color( 255, 255, 255 ), 0 )
			draw.SimpleText( "Length: "..self.LengthString.." ("..self.Length.."s)", "JukeBox.Font.20", w/2, h*0.75, Color( 255, 255, 255 ), 1, 1 )
		elseif self.Progress == 3 then
			draw.SimpleText( "Video doesn't exist", "JukeBox.Font.20", w/2, h*0.25, Color( 255, 255, 255 ), 1, 1 )
			JukeBox.VGUI.VGUI:DrawEmblem( w/2, h/2-10, 80, "jukebox/cross.png", Color( 255, 255, 255 ), 0 )
		elseif self.Progress == 4 then
			draw.SimpleText( "Error contacting server", "JukeBox.Font.20", w/2, h*0.25, Color( 255, 255, 255 ), 1, 1 )
			JukeBox.VGUI.VGUI:DrawEmblem( w/2, h/2-10, 80, "jukebox/error.png", Color( 255, 255, 255 ), 0 )
			draw.SimpleText( "Error: "..self.ProgressData, "JukeBox.Font.20", w/2, h-20, Color( 255, 255, 255 ), 1, 1 )
		end
	end
	
	popup.HTML.Cover = vgui.Create("DPanel", popup.HTML)
	popup.HTML.Cover:Dock( FILL )
	popup.HTML.Cover.Paint = function() end
	
	popup.BottomButton = vgui.Create( "DButton", popup.Content )
	popup.BottomButton:SetSize( 100, 40 )
	popup.BottomButton:Dock( BOTTOM )
	popup.BottomButton:SetVisible( true )
	popup.BottomButton:DockMargin( 75, 20, 75, 10 )
	popup.BottomButton:SetText( "" )
	popup.BottomButton.Text = "Close"
	popup.BottomButton.DoClick = function()
		popup.HTML:RunJavascript( "player.stopVideo();")
		bg:Remove()
	end
	popup.BottomButton.Paint = function( self, w, h )
		if JukeBox.VGUI.VGUI:GetHovered( self ) then
			draw.RoundedBox( h/2, 0, 0, w, h, JukeBox.Colours.Definition )
		else
			draw.RoundedBox( h/2, 0, 0, w, h, JukeBox.Colours.Light )
		end
		draw.SimpleText( self.Text, "JukeBox.Font.20", w/2, h/2-2, Color( 255, 255, 255 ), 1, 1 )
	end
	
	http.Fetch( JukeBox.Settings.CheckerURL..id, 
		function( body )
			if !IsValid( bg ) or !ValidPanel( bg ) then return end
			local info = util.JSONToTable( body )
			if not info then
				popup.HTML.Progress = 4
			elseif info.videoExists then
				popup.HTML.Progress = 2
				popup.HTML.Length = info.videoLength
				popup.HTML.LengthString = info.videoLengthString
			else
				popup.HTML.Progress = 3
			end
		end,
		function( issue )
			if not ValidPanel( bg ) then return end
			popup.HTML.Progress = 4
		end )
end

function JukeBox.VGUI.Pages.QuickRequest:AddSongPopup( parent, data2 )
	local split = string.Explode( " - ", data2.title )
	local data = {}
	if #split == 2 then
		data = {
			name = split[2],
			artist = split[1],
			id = data2.url
		}
	else
		data = {
			name = data2.title,
			artist = data2.title,
			id = data2.url
		}
	end

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
	popup:SetSize( 640, 325 )
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
		draw.SimpleText( "JukeBox - Add a Song", "JukeBox.Font.18", w/2, h/2, Color( 255, 255, 255 ), 1, 1 )
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
	
	popup.EditArea = vgui.Create( "DPanel", popup.Content )
	popup.EditArea:Dock( FILL )
	popup.EditArea:DockPadding( 50, 10, 50, 10 )
	popup.EditArea:SetTall( 276 )
	popup.EditArea.Paint = function( self, w, h )
		draw.RoundedBox( 0, 0, 0, w, 1, JukeBox.Colours.Base )
	end
	
	popup.EditArea.NamePanel = vgui.Create( "DPanel", popup.EditArea )
	popup.EditArea.NamePanel:Dock( TOP )
	popup.EditArea.NamePanel:DockPadding( 150, 0, 12, 0 )
	popup.EditArea.NamePanel:DockMargin( 0, 0, 0, 10 )
	popup.EditArea.NamePanel.Paint = function( self, w, h )
		draw.RoundedBox( h/2, 138, 0, w-138, h, Color( 255, 255, 255 ) )
		draw.SimpleText( "Song name:", "JukeBox.Font.18", 5, h/2, Color( 255, 255, 255 ), 0, 1 )
	end
	
	popup.EditArea.NameEntry = vgui.Create( "DTextEntry", popup.EditArea.NamePanel )
	popup.EditArea.NameEntry:Dock( FILL )
	popup.EditArea.NameEntry.Val = ""
	popup.EditArea.NameEntry.Error1 = true
	popup.EditArea.NameEntry:SetFont( "JukeBox.Font.16" )
	popup.EditArea.NameEntry.Think = function( self )
		if self.Val != self:GetValue() then
			self:OnChange( self )
		end
	end
	popup.EditArea.NameEntry.Paint = function( self, w, h )
		draw.RoundedBox( 0, 0, 0, w, h, Color( 255, 255, 255 ) )
		self:DrawTextEntryText( JukeBox.Colours.Base, Color( 30, 130, 255 ), JukeBox.Colours.Base )
	end
	popup.EditArea.NameEntry.OnChange = function( self )
		self.Val = self:GetValue()
		if self:GetValue() != "" then
			self.Error1 = false
		else
			self.Error1 = true
		end
	end
	
	popup.EditArea.ArtistPanel = vgui.Create( "DPanel", popup.EditArea )
	popup.EditArea.ArtistPanel:Dock( TOP )
	popup.EditArea.ArtistPanel:DockPadding( 150, 0, 12, 0 )
	popup.EditArea.ArtistPanel:DockMargin( 0, 0, 0, 10 )
	popup.EditArea.ArtistPanel.Paint = function( self, w, h )
		draw.RoundedBox( h/2, 138, 0, w-138, h, Color( 255, 255, 255 ) )
		draw.SimpleText( "Artist:", "JukeBox.Font.18", 5, h/2, Color( 255, 255, 255 ), 0, 1 )
	end
	
	popup.EditArea.ArtistEntry = vgui.Create( "DTextEntry", popup.EditArea.ArtistPanel )
	popup.EditArea.ArtistEntry:Dock( FILL )
	popup.EditArea.ArtistEntry.Val = ""
	popup.EditArea.ArtistEntry.Error1 = true
	popup.EditArea.ArtistEntry:SetFont( "JukeBox.Font.16" )
	popup.EditArea.ArtistEntry.Think = function( self )
		if self.Val != self:GetValue() then
			self:OnChange( self )
		end
	end
	popup.EditArea.ArtistEntry.Paint = function( self, w, h )
		draw.RoundedBox( 0, 0, 0, w, h, Color( 255, 255, 255 ) )
		self:DrawTextEntryText( JukeBox.Colours.Base, Color( 30, 130, 255 ), JukeBox.Colours.Base )
	end
	popup.EditArea.ArtistEntry.OnChange = function( self )
		self.Val = self:GetValue()
		if self:GetValue() != "" then
			self.Error1 = false
		else
			self.Error1 = true
		end
	end
	
	popup.EditArea.URLPanel = vgui.Create( "DPanel", popup.EditArea )
	popup.EditArea.URLPanel:Dock( TOP )
	popup.EditArea.URLPanel:DockPadding( 150, 0, 0, 0 )
	popup.EditArea.URLPanel:DockMargin( 0, 0, 0, 10 )
	popup.EditArea.URLPanel.Paint = function( self, w, h )
		draw.RoundedBox( h/2, 138, 0, w-138-120-10, h, Color( 100, 100, 100 ) )
		draw.SimpleText( "YouTube ID:", "JukeBox.Font.18", 5, h/2, Color( 255, 255, 255 ), 0, 1 )
	end	
	
	popup.EditArea.URLEntry = vgui.Create( "DTextEntry", popup.EditArea.URLPanel )
	popup.EditArea.URLEntry:Dock( FILL )
	popup.EditArea.URLEntry.Val = ""
	popup.EditArea.URLEntry.Error1 = true
	popup.EditArea.URLEntry.Error2 = true
	popup.EditArea.URLEntry.URLID = nil
	popup.EditArea.URLEntry:SetDisabled( true )
	popup.EditArea.URLEntry:SetEditable( false )
	popup.EditArea.URLEntry:SetFont( "JukeBox.Font.18" )
	popup.EditArea.URLEntry.Think = function( self )
		if self.Val != self:GetValue() then
			self:OnChange( self )
		end
	end
	popup.EditArea.URLEntry.Paint = function( self, w, h )
		draw.RoundedBox( 0, 0, 0, w, h, Color( 100, 100, 100 ) )
		if not self.Error1 and not self.Error2 and self.URLID then
			surface.SetFont( "JukeBox.Font.18" )
			local beg, en = string.find( self:GetValue(), self.URLID, 0, true )
			local subw, subh = surface.GetTextSize( string.sub( self:GetValue(), 1, beg-1 ) )
			local idw, idh = surface.GetTextSize( string.sub( self:GetValue(), beg, en ) )
			draw.RoundedBox( 4, subw+1, 2, idw+4, h-4, JukeBox.Colours.Accept )
		end
		self:DrawTextEntryText( JukeBox.Colours.Base, Color( 30, 130, 255 ), JukeBox.Colours.Base)
	end
	popup.EditArea.URLEntry.OnChange = function( self )
		self.Val = self:GetValue()
		if self:GetValue() and self:GetValue() != "" then
			self.Error1 = false
			if (string.len( self:GetValue() ) == 11) then
				self.URLID = self:GetValue()
				self.Error2 = false
				return
			else
				self.URLID = nil
				self.Error2 = true
			end
		else
			self.Error1 = true
			self.Error2 = true
		end
	end
	
	popup.EditArea.URLCheck = vgui.Create( "DButton", popup.EditArea.URLPanel )
	popup.EditArea.URLCheck:SetWide( 120 )
	popup.EditArea.URLCheck:Dock( RIGHT )
	popup.EditArea.URLCheck:DockMargin( 24, 0, 0, 0 )
	popup.EditArea.URLCheck:SetText( "" )
	popup.EditArea.URLCheck.DoClick = function( self )
		local dropdown = vgui.Create( "DMenu" )
		dropdown:SetPos( input.GetCursorPos() )
		dropdown:MakePopup()
		dropdown.Paint = function( self, w, h )
			draw.RoundedBox( 0, 0, 0, w, h, JukeBox.Colours.Background )
		end
		local dropdownVoteButton = dropdown:AddOption( "JukeBox Pop-up" )
		dropdownVoteButton:SetTextColor( Color( 255, 255, 255 ) )
		function dropdownVoteButton:DoClick()
			JukeBox.VGUI.Pages.AllSongs:CheckURL( popup, popup.EditArea.URLEntry:GetValue() )
		end
		dropdown:AddSpacer()
		local dropdownForceButton = dropdown:AddOption( "Steam Overlay" )
		dropdownForceButton:SetTextColor( Color( 255, 255, 255 ) )
		function dropdownForceButton:DoClick()
			gui.OpenURL( "https://www.youtube.com/watch?v="..popup.EditArea.URLEntry:GetValue() )
		end
	end
	popup.EditArea.URLCheck.Paint = function( self, w, h )
		if JukeBox.VGUI.VGUI:GetHovered( self ) then
			draw.RoundedBox( h/2, 0, 0, w, h, JukeBox.Colours.Accept )
		else
			draw.RoundedBox( h/2, 0, 0, w, h, JukeBox.Colours.Light )
		end
		draw.SimpleText( "Check YouTube ID", "JukeBox.Font.16", w/2, h/2, Color( 255, 255, 255 ), 1, 1 )
	end
	
	--// LENGTH \\--
	popup.EditArea.TimePanel = vgui.Create( "DPanel", popup.EditArea )
	popup.EditArea.TimePanel:Dock( TOP )
	popup.EditArea.TimePanel:SetTall( 36 )
	popup.EditArea.TimePanel:DockPadding( 138, 0, 12, 0 )
	popup.EditArea.TimePanel:DockMargin( 0, 0, 0, 4 )
	popup.EditArea.TimePanel.Paint = function( self, w, h )
		--draw.RoundedBox( h/2, 0, 0, w, h, Color( 255, 0, 255 ) )
		draw.SimpleText( "Length:", "JukeBox.Font.18", 5, 24/2, Color( 255, 255, 255 ), 0, 1 )
	end
	
	popup.EditArea.TimeMinsPanel = vgui.Create( "DPanel", popup.EditArea.TimePanel )
	popup.EditArea.TimeMinsPanel:Dock( LEFT )
	popup.EditArea.TimeMinsPanel:DockPadding( 12, 0, 12, 12)
	popup.EditArea.TimeMinsPanel:DockMargin( 0, 0, 12, 0 )
	popup.EditArea.TimeMinsPanel.Paint = function( self, w, h )
		draw.RoundedBox( 24/2, 0, 0, w, 24, Color( 255, 255, 255 ) )
		draw.SimpleText( "MINS", "JukeBox.Font.12", w/2, h, Color( 200, 200, 200 ), 1, 4 )
	end
	
	popup.EditArea.TimeMinsEntry = vgui.Create( "DNumberWang", popup.EditArea.TimeMinsPanel )
	popup.EditArea.TimeMinsEntry:Dock( FILL )
	popup.EditArea.TimeMinsEntry:SetFont( "JukeBox.Font.18" )
	popup.EditArea.TimeMinsEntry:SetMin( 0 )
	popup.EditArea.TimeMinsEntry:SetMax( math.floor(JukeBox.Settings.MaxSongLength/60) )
	popup.EditArea.TimeMinsEntry.Val = 0
	popup.EditArea.TimeMinsEntry.Issue1 = true
	popup.EditArea.TimeMinsEntry.Paint = function( self, w, h )
		draw.RoundedBox( 0, 0, 0, w, h, Color( 255, 255, 255 ) )
		self:DrawTextEntryText( JukeBox.Colours.Base, Color( 30, 130, 255 ), JukeBox.Colours.Base)
	end
	popup.EditArea.TimeMinsEntry.Think = function( self )
		if self.Val != self:GetValue() then
			self:OnValueChanged( self )
		end
	end
	popup.EditArea.TimeMinsEntry.OnValueChanged = function( self )
		self.Val = self:GetValue()
		popup.EditArea.TimePanel.Checks()
		popup.EditArea.StartTimePanel.Checks()
		popup.EditArea.EndTimePanel.Checks()
	end
	
	popup.EditArea.TimeSecsPanel = vgui.Create( "DPanel", popup.EditArea.TimePanel )
	popup.EditArea.TimeSecsPanel:Dock( LEFT )
	popup.EditArea.TimeSecsPanel:DockPadding( 12, 0, 12, 12)
	popup.EditArea.TimeSecsPanel.Paint = function( self, w, h )
		draw.RoundedBox( 24/2, 0, 0, w, 24, Color( 255, 255, 255 ) )
		draw.SimpleText( "SECS", "JukeBox.Font.12", w/2, h, Color( 200, 200, 200 ), 1, 4 )
	end
	
	popup.EditArea.TimeSecsEntry = vgui.Create( "DNumberWang", popup.EditArea.TimeSecsPanel )
	popup.EditArea.TimeSecsEntry:Dock( FILL )
	popup.EditArea.TimeSecsEntry:SetFont( "JukeBox.Font.18" )
	popup.EditArea.TimeSecsEntry:SetMin( 0 )
	popup.EditArea.TimeSecsEntry:SetMax( 59 )
	popup.EditArea.TimeSecsEntry.Val = 0
	popup.EditArea.TimeSecsEntry.Issue1 = true
	popup.EditArea.TimeSecsEntry.Paint = function( self, w, h )
		draw.RoundedBox( 0, 0, 0, w, h, Color( 255, 255, 255 ) )
		self:DrawTextEntryText( JukeBox.Colours.Base, Color( 30, 130, 255 ), JukeBox.Colours.Base)
	end
	popup.EditArea.TimeSecsEntry.Think = function( self )
		if self.Val != self:GetValue() then
			self:OnValueChanged( self )
		end
	end
	popup.EditArea.TimeSecsEntry.OnValueChanged = function( self )
		self.Val = self:GetValue()
		popup.EditArea.TimePanel.Checks()
		popup.EditArea.StartTimePanel.Checks()
		popup.EditArea.EndTimePanel.Checks()
	end
	
	function popup.EditArea.TimePanel.Checks()
		if popup.EditArea.TimeSecsEntry:GetValue()+popup.EditArea.TimeMinsEntry:GetValue()*60 > 0 then
			popup.EditArea.TimeSecsEntry.Issue1 = false
			popup.EditArea.TimeMinsEntry.Issue1  = false
		else
			popup.EditArea.TimeSecsEntry.Issue1 = true
			popup.EditArea.TimeMinsEntry.Issue1  = true
		end
	end
	
	popup.EditArea.TimeAutoGet = vgui.Create( "DButton", popup.EditArea.TimePanel )
	popup.EditArea.TimeAutoGet:Dock( LEFT )
	popup.EditArea.TimeAutoGet:SetWide( 120 )
	popup.EditArea.TimeAutoGet:SetTall( 24 )
	popup.EditArea.TimeAutoGet.State = 0
	popup.EditArea.TimeAutoGet:DockMargin( 20, 0, 0, 12 )
	popup.EditArea.TimeAutoGet:SetText( "" )
	popup.EditArea.TimeAutoGet.DoClick = function( self )
		if not popup.EditArea.URLEntry.URLID then
			--JukeBox.VGUI.VGUI:MakeNotification( "There's currently no valid YouTube URL entered!", JukeBox.Colours.Issue, "jukebox/warning.png", "REQUEST", true )
			return
		end
		if popup.EditArea.TimeAutoGet.State == 0 then
			popup.EditArea.TimeAutoGet.State = 1
			http.Fetch( JukeBox.Settings.CheckerURL..popup.EditArea.URLEntry.URLID, 
				function( body )
					local info = util.JSONToTable( body )
					if not info then
						--JukeBox.VGUI.VGUI:MakeNotification( "The YouTube URL entered seems to be invalid!", JukeBox.Colours.Issue, "jukebox/warning.png", "REQUEST", true )
					elseif info.videoExists then
						local time = info.videoLength
						local mins = math.floor( time/60 )
						if time > JukeBox.Settings.MaxSongLength then
							--JukeBox.VGUI.VGUI:MakeNotification( "The song is too long (maximum "..JukeBox.Settings.MaxSongLength.."s)", JukeBox.Colours.Issue, "jukebox/warning.png", "REQUEST", true )
						end
						local secs = time-(mins*60)
						popup.EditArea.TimeMinsEntry:SetValue( mins )
						popup.EditArea.TimeSecsEntry:SetValue( secs )
					else
						--JukeBox.VGUI.VGUI:MakeNotification( "The YouTube URL entered seems to be invalid!", JukeBox.Colours.Issue, "jukebox/warning.png", "REQUEST", true )
					end
					popup.EditArea.TimeAutoGet.State = 0
				end,
				function( issue )
					--JukeBox.VGUI.VGUI:MakeNotification( "There was an issue contacting the server when getting video length!", JukeBox.Colours.Warning, "jukebox/warning.png", "REQUEST", true )
				end )
		end
	end
	popup.EditArea.TimeAutoGet.Paint = function( self, w, h )
		if not popup.EditArea.URLEntry.URLID then
			draw.RoundedBox( h/2, 0, 0, w, h, JukeBox.Colours.Light )
		else
			draw.RoundedBox( h/2, 0, 0, w, h, JukeBox.Colours.Accept )
		end
		if JukeBox.VGUI.VGUI:GetHovered( self ) then
			draw.RoundedBox( h/2, 0, 0, w, h, Color( 0, 0, 0, 100 ) )
		end
		if self.State == 0 then
			draw.SimpleText( "Get Video Length", "JukeBox.Font.16", w/2, h/2, Color( 255, 255, 255 ), 1, 1 )
		elseif self.State == 1 then
			JukeBox.VGUI.VGUI:DrawEmblem( w/2, h/2, 20, "jukebox/loading.png", Color( 255, 255, 255 ), -CurTime()*100 )
		end
	end
	
	--// START TIME \\--
	popup.EditArea.StartTimePanel = vgui.Create( "DPanel", popup.EditArea )
	popup.EditArea.StartTimePanel:Dock( TOP )
	popup.EditArea.StartTimePanel:SetTall( 36 )
	popup.EditArea.StartTimePanel:DockPadding( 138, 0, 12, 0 )
	popup.EditArea.StartTimePanel:DockMargin( 0, 0, 0, 4 )
	popup.EditArea.StartTimePanel.Paint = function( self, w, h )
		--draw.RoundedBox( h/2, 0, 0, w, h, Color( 255, 0, 255 ) )
		draw.SimpleText( "Start time:", "JukeBox.Font.18", 5, 24/2, Color( 255, 255, 255 ), 0, 1 )
	end
	
	popup.EditArea.StartTimeMinsPanel = vgui.Create( "DPanel", popup.EditArea.StartTimePanel )
	popup.EditArea.StartTimeMinsPanel:Dock( LEFT )
	popup.EditArea.StartTimeMinsPanel:DockPadding( 12, 0, 12, 12)
	popup.EditArea.StartTimeMinsPanel:DockMargin( 0, 0, 12, 0 )
	popup.EditArea.StartTimeMinsPanel.Paint = function( self, w, h )
		if popup.EditArea.StartTimeMinsEntry:GetDisabled() then
			draw.RoundedBox( 24/2, 0, 0, w, 24, Color( 100, 100, 100 ) )
		else
			draw.RoundedBox( 24/2, 0, 0, w, 24, Color( 255, 255, 255 ) )
		end
		draw.SimpleText( "MINS", "JukeBox.Font.12", w/2, h, Color( 200, 200, 200 ), 1, 4 )
	end
	
	popup.EditArea.StartTimeMinsEntry = vgui.Create( "DNumberWang", popup.EditArea.StartTimeMinsPanel )
	popup.EditArea.StartTimeMinsEntry:Dock( FILL )
	popup.EditArea.StartTimeMinsEntry:SetFont( "JukeBox.Font.18" )
	popup.EditArea.StartTimeMinsEntry:SetMin( 0 )
	popup.EditArea.StartTimeMinsEntry:SetMax( math.floor(JukeBox.Settings.MaxSongLength/60) )
	popup.EditArea.StartTimeMinsEntry:SetDisabled( true )
	popup.EditArea.StartTimeMinsEntry.Val = 0
	popup.EditArea.StartTimeMinsEntry.Issue1 = true
	popup.EditArea.StartTimeMinsEntry.Paint = function( self, w, h )
		if self:GetDisabled() then
			draw.RoundedBox( 24/2, 0, 0, w, 24, Color( 100, 100, 100 ) )
		else
			draw.RoundedBox( 24/2, 0, 0, w, 24, Color( 255, 255, 255 ) )
		end
		self:DrawTextEntryText( JukeBox.Colours.Base, Color( 30, 130, 255 ), JukeBox.Colours.Base)
	end
	popup.EditArea.StartTimeMinsEntry.Think = function( self )
		if self.Val != self:GetValue() then
			self:OnValueChanged( self )
		end
	end
	popup.EditArea.StartTimeMinsEntry.OnValueChanged = function( self )
		self.Val = self:GetValue()
		popup.EditArea.TimePanel.Checks()
		popup.EditArea.StartTimePanel.Checks()
		popup.EditArea.EndTimePanel.Checks()
	end
	
	popup.EditArea.StartTimeSecsPanel = vgui.Create( "DPanel", popup.EditArea.StartTimePanel )
	popup.EditArea.StartTimeSecsPanel:Dock( LEFT )
	popup.EditArea.StartTimeSecsPanel:DockPadding( 12, 0, 12, 12)
	popup.EditArea.StartTimeSecsPanel.Paint = function( self, w, h )
		if popup.EditArea.StartTimeSecsEntry:GetDisabled() then
			draw.RoundedBox( 24/2, 0, 0, w, 24, Color( 100, 100, 100 ) )
		else
			draw.RoundedBox( 24/2, 0, 0, w, 24, Color( 255, 255, 255 ) )
		end
		draw.SimpleText( "SECS", "JukeBox.Font.12", w/2, h, Color( 200, 200, 200 ), 1, 4 )
	end
	
	popup.EditArea.StartTimeSecsEntry = vgui.Create( "DNumberWang", popup.EditArea.StartTimeSecsPanel )
	popup.EditArea.StartTimeSecsEntry:Dock( FILL )
	popup.EditArea.StartTimeSecsEntry:SetFont( "JukeBox.Font.18" )
	popup.EditArea.StartTimeSecsEntry:SetMin( 0 )
	popup.EditArea.StartTimeSecsEntry:SetMax( 59 )
	popup.EditArea.StartTimeSecsEntry:SetDisabled( true )
	popup.EditArea.StartTimeSecsEntry.Val = 0
	popup.EditArea.StartTimeSecsEntry.Issue1 = true
	popup.EditArea.StartTimeSecsEntry.Paint = function( self, w, h )
		if self:GetDisabled() then
			draw.RoundedBox( 24/2, 0, 0, w, 24, Color( 100, 100, 100 ) )
		else
			draw.RoundedBox( 24/2, 0, 0, w, 24, Color( 255, 255, 255 ) )
		end
		self:DrawTextEntryText( JukeBox.Colours.Base, Color( 30, 130, 255 ), JukeBox.Colours.Base)
	end
	popup.EditArea.StartTimeSecsEntry.Think = function( self )
		if self.Val != self:GetValue() then
			self:OnValueChanged( self )
		end
	end
	popup.EditArea.StartTimeSecsEntry.OnValueChanged = function( self )
		self.Val = self:GetValue()
		popup.EditArea.TimePanel.Checks()
		popup.EditArea.StartTimePanel.Checks()
		popup.EditArea.EndTimePanel.Checks()
	end

	popup.EditArea.StartTimeEnable = vgui.Create( "DButton", popup.EditArea.StartTimePanel )
	popup.EditArea.StartTimeEnable:Dock( LEFT )
	popup.EditArea.StartTimeEnable:SetWide( 70 )
	popup.EditArea.StartTimeEnable:SetTall( 24 )
	popup.EditArea.StartTimeEnable.Enabled = false
	popup.EditArea.StartTimeEnable:DockMargin( 20, 0, 0, 12 )
	popup.EditArea.StartTimeEnable:SetText( "" )
	popup.EditArea.StartTimeEnable.DoClick = function( self )
		self.Enabled = !self.Enabled
		popup.EditArea.StartTimeSecsEntry:SetDisabled( !self.Enabled )
		popup.EditArea.StartTimeMinsEntry:SetDisabled( !self.Enabled )
	end
	popup.EditArea.StartTimeEnable.Paint = function( self, w, h )
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
	
	function popup.EditArea.StartTimePanel.Checks()
		if popup.EditArea.StartTimeSecsEntry:GetValue()+popup.EditArea.StartTimeMinsEntry:GetValue()*60 >= 0 then
			popup.EditArea.StartTimeSecsEntry.Issue1 = false
			popup.EditArea.StartTimeMinsEntry.Issue1  = false
			if ( popup.EditArea.StartTimeSecsEntry:GetValue()+popup.EditArea.StartTimeMinsEntry:GetValue()*60 >= popup.EditArea.TimeSecsEntry:GetValue()+popup.EditArea.TimeMinsEntry:GetValue()*60 ) then
				popup.EditArea.StartTimeSecsEntry.Issue2 = true
				popup.EditArea.StartTimeMinsEntry.Issue2 = true
			else
				popup.EditArea.StartTimeSecsEntry.Issue2 = false
				popup.EditArea.StartTimeMinsEntry.Issue2 = false
			end
		else
			popup.EditArea.StartTimeSecsEntry.Issue1 = true
			popup.EditArea.StartTimeMinsEntry.Issue1  = true
		end
	end
	
	--// END TIME \\--
	popup.EditArea.EndTimePanel = vgui.Create( "DPanel", popup.EditArea )
	popup.EditArea.EndTimePanel:Dock( TOP )
	popup.EditArea.EndTimePanel:SetTall( 36 )
	popup.EditArea.EndTimePanel:DockPadding( 138, 0, 12, 0 )
	popup.EditArea.EndTimePanel:DockMargin( 0, 0, 0, 4 )
	popup.EditArea.EndTimePanel.Paint = function( self, w, h )
		--draw.RoundedBox( h/2, 0, 0, w, h, Color( 255, 0, 255 ) )
		draw.SimpleText( "End time:", "JukeBox.Font.18", 5, 24/2, Color( 255, 255, 255 ), 0, 1 )
	end
	
	popup.EditArea.EndTimeMinsPanel = vgui.Create( "DPanel", popup.EditArea.EndTimePanel )
	popup.EditArea.EndTimeMinsPanel:Dock( LEFT )
	popup.EditArea.EndTimeMinsPanel:DockPadding( 12, 0, 12, 12)
	popup.EditArea.EndTimeMinsPanel:DockMargin( 0, 0, 12, 0 )
	popup.EditArea.EndTimeMinsPanel.Paint = function( self, w, h )
		if popup.EditArea.EndTimeMinsEntry:GetDisabled() then
			draw.RoundedBox( 24/2, 0, 0, w, 24, Color( 100, 100, 100 ) )
		else
			draw.RoundedBox( 24/2, 0, 0, w, 24, Color( 255, 255, 255 ) )
		end
		draw.SimpleText( "MINS", "JukeBox.Font.12", w/2, h, Color( 200, 200, 200 ), 1, 4 )
	end
	
	popup.EditArea.EndTimeMinsEntry = vgui.Create( "DNumberWang", popup.EditArea.EndTimeMinsPanel )
	popup.EditArea.EndTimeMinsEntry:Dock( FILL )
	popup.EditArea.EndTimeMinsEntry:SetFont( "JukeBox.Font.18" )
	popup.EditArea.EndTimeMinsEntry:SetMin( 0 )
	popup.EditArea.EndTimeMinsEntry:SetMax( math.floor(JukeBox.Settings.MaxSongLength/60) )
	popup.EditArea.EndTimeMinsEntry:SetDisabled( true )
	popup.EditArea.EndTimeMinsEntry.Val = 0
	popup.EditArea.EndTimeMinsEntry.Issue1 = true
	popup.EditArea.EndTimeMinsEntry.Paint = function( self, w, h )
		if self:GetDisabled() then
			draw.RoundedBox( 24/2, 0, 0, w, 24, Color( 100, 100, 100 ) )
		else
			draw.RoundedBox( 24/2, 0, 0, w, 24, Color( 255, 255, 255 ) )
		end
		self:DrawTextEntryText( JukeBox.Colours.Base, Color( 30, 130, 255 ), JukeBox.Colours.Base)
	end
	popup.EditArea.EndTimeMinsEntry.Think = function( self )
		if self.Val != self:GetValue() then
			self:OnValueChanged( self )
		end
	end
	popup.EditArea.EndTimeMinsEntry.OnValueChanged = function( self )
		if self.Override then return end
		self.Val = self:GetValue()
		popup.EditArea.EndTimePanel.Checks()
	end
	popup.EditArea.EndTimeMinsEntry.ChangeValue = function( value )
		popup.EditArea.EndTimeMinsEntry.Override = true
		popup.EditArea.EndTimeMinsEntry:SetValue( value )
		popup.EditArea.EndTimeMinsEntry.Override = false
	end
	
	popup.EditArea.EndTimeSecsPanel = vgui.Create( "DPanel", popup.EditArea.EndTimePanel )
	popup.EditArea.EndTimeSecsPanel:Dock( LEFT )
	popup.EditArea.EndTimeSecsPanel:DockPadding( 12, 0, 12, 12)
	popup.EditArea.EndTimeSecsPanel.Paint = function( self, w, h )
		if popup.EditArea.EndTimeSecsEntry:GetDisabled() then
			draw.RoundedBox( 24/2, 0, 0, w, 24, Color( 100, 100, 100 ) )
		else
			draw.RoundedBox( 24/2, 0, 0, w, 24, Color( 255, 255, 255 ) )
		end
		draw.SimpleText( "SECS", "JukeBox.Font.12", w/2, h, Color( 200, 200, 200 ), 1, 4 )
	end
	
	popup.EditArea.EndTimeSecsEntry = vgui.Create( "DNumberWang", popup.EditArea.EndTimeSecsPanel )
	popup.EditArea.EndTimeSecsEntry:Dock( FILL )
	popup.EditArea.EndTimeSecsEntry:SetFont( "JukeBox.Font.18" )
	popup.EditArea.EndTimeSecsEntry:SetMin( 0 )
	popup.EditArea.EndTimeSecsEntry:SetMax( 59 )
	popup.EditArea.EndTimeSecsEntry:SetDisabled( true )
	popup.EditArea.EndTimeSecsEntry.Val = 0
	popup.EditArea.EndTimeSecsEntry.Issue1 = true
	popup.EditArea.EndTimeSecsEntry.Override = false
	popup.EditArea.EndTimeSecsEntry.Paint = function( self, w, h )
		if self:GetDisabled() then
			draw.RoundedBox( 24/2, 0, 0, w, 24, Color( 100, 100, 100 ) )
		else
			draw.RoundedBox( 24/2, 0, 0, w, 24, Color( 255, 255, 255 ) )
		end
		self:DrawTextEntryText( JukeBox.Colours.Base, Color( 30, 130, 255 ), JukeBox.Colours.Base)
	end
	popup.EditArea.EndTimeSecsEntry.Think = function( self )
		if self.Val != self:GetValue() then
			self:OnValueChanged( self )
		end
	end
	popup.EditArea.EndTimeSecsEntry.OnValueChanged = function( self )
		if self.Override then return end
		self.Val = self:GetValue()
		popup.EditArea.EndTimePanel.Checks()
	end
	popup.EditArea.EndTimeSecsEntry.ChangeValue = function( value )
		popup.EditArea.EndTimeSecsEntry.Override = true
		popup.EditArea.EndTimeSecsEntry:SetValue( value )
		popup.EditArea.EndTimeSecsEntry.Override = false
	end
	
	popup.EditArea.EndTimeEnable = vgui.Create( "DButton", popup.EditArea.EndTimePanel )
	popup.EditArea.EndTimeEnable:Dock( LEFT )
	popup.EditArea.EndTimeEnable:SetWide( 70 )
	popup.EditArea.EndTimeEnable:SetTall( 24 )
	popup.EditArea.EndTimeEnable.Enabled = false
	popup.EditArea.EndTimeEnable:DockMargin( 20, 0, 0, 12 )
	popup.EditArea.EndTimeEnable:SetText( "" )
	popup.EditArea.EndTimeEnable.DoClick = function( self )
		self.Enabled = !self.Enabled
		popup.EditArea.EndTimeSecsEntry:SetDisabled( !self.Enabled )
		popup.EditArea.EndTimeMinsEntry:SetDisabled( !self.Enabled )
	end
	popup.EditArea.EndTimeEnable.Paint = function( self, w, h )
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
	
	function popup.EditArea.EndTimePanel.Checks()
		if not popup.EditArea.EndTimeEnable.Enabled then
			popup.EditArea.EndTimeSecsEntry.ChangeValue( popup.EditArea.TimeSecsEntry:GetValue() )
			popup.EditArea.EndTimeMinsEntry.ChangeValue( popup.EditArea.TimeMinsEntry:GetValue() )
		end
		if popup.EditArea.EndTimeSecsEntry:GetValue()+popup.EditArea.EndTimeMinsEntry:GetValue()*60 > 0 then
			popup.EditArea.EndTimeSecsEntry.Issue1 = false
			popup.EditArea.EndTimeMinsEntry.Issue1  = false
			if ( popup.EditArea.EndTimeSecsEntry:GetValue()+popup.EditArea.EndTimeMinsEntry:GetValue()*60 > popup.EditArea.TimeSecsEntry:GetValue()+popup.EditArea.TimeMinsEntry:GetValue()*60) then
				popup.EditArea.EndTimeSecsEntry.Issue2 = true
				popup.EditArea.EndTimeMinsEntry.Issue2 = true
			else
				popup.EditArea.EndTimeSecsEntry.Issue2 = false
				popup.EditArea.EndTimeMinsEntry.Issue2 = false
			end
		else
			popup.EditArea.EndTimeSecsEntry.Issue1 = true
			popup.EditArea.EndTimeMinsEntry.Issue1  = true
		end
	end
	
	popup.EditArea.ActionButtons = vgui.Create( "DPanel", popup.EditArea )
	popup.EditArea.ActionButtons:Dock( BOTTOM )
	popup.EditArea.ActionButtons:SetTall( 30 )
	popup.EditArea.ActionButtons.Paint = function( self, w, h )
		
	end
	
	popup.EditArea.ActionButtons.Accept = vgui.Create( "DButton", popup.EditArea.ActionButtons )
	popup.EditArea.ActionButtons.Accept:Dock( LEFT )
	popup.EditArea.ActionButtons.Accept:DockMargin( 0, 0, 10, 0 )
	popup.EditArea.ActionButtons.Accept:SetWide( 125 )
	popup.EditArea.ActionButtons.Accept:SetText( "" )
	popup.EditArea.ActionButtons.Accept.DoClick = function( self )
		popup.EditArea.CheckValues()
	end
	popup.EditArea.ActionButtons.Accept.Paint = function( self, w, h )
		if JukeBox.VGUI.VGUI:GetHovered( self ) then
			draw.RoundedBox( h/2-1, 0, 0, w, h, JukeBox.Colours.Accept )
		else
			draw.RoundedBox( h/2-1, 0, 0, w, h, JukeBox.Colours.Light )
		end
		JukeBox.VGUI.VGUI:DrawEmblem( h*0.75, h/2, 16, "jukebox/tick.png", Color( 255, 255, 255 ), 0 )
		draw.SimpleText( "Add Song", "JukeBox.Font.20", h+10, h/2-2, Color( 255, 255, 255 ), 0, 1 )
	end
	
	popup.EditArea.ActionButtons.Cancel = vgui.Create( "DButton", popup.EditArea.ActionButtons )
	popup.EditArea.ActionButtons.Cancel:SetWide( 100 )
	popup.EditArea.ActionButtons.Cancel:Dock( RIGHT )
	popup.EditArea.ActionButtons.Cancel:SetVisible( true )
	popup.EditArea.ActionButtons.Cancel:DockMargin( 0, 0, 10, 0 )
	popup.EditArea.ActionButtons.Cancel:SetText( "" )
	popup.EditArea.ActionButtons.Cancel.Text = "Cancel"
	popup.EditArea.ActionButtons.Cancel.DoClick = function()
		bg:Remove()
	end
	popup.EditArea.ActionButtons.Cancel.Paint = function( self, w, h )
		if JukeBox.VGUI.VGUI:GetHovered( self ) then
			draw.RoundedBox( h/2-1, 0, 0, w, h, Color( 0, 0, 0, 100 ) )
		else
			draw.RoundedBox( h/2-1, 0, 0, w, h, JukeBox.Colours.Light )
		end
		draw.SimpleText( self.Text, "JukeBox.Font.20", w/2, h/2-2, Color( 255, 255, 255 ), 1, 1 )
	end
	
	function popup.EditArea.SetValues( info )
		popup.EditArea.NameEntry:SetValue( info.name )
		popup.EditArea.ArtistEntry:SetValue( info.artist )
		popup.EditArea.URLEntry:SetValue( info.id )
		timer.Simple( 0.1, function()
			popup.EditArea.TimeAutoGet.DoClick()
		end )
		if info.starttime then
			if not popup.EditArea.StartTimeEnable.Enabled then
				popup.EditArea.StartTimeEnable:DoClick()
			end
			popup.EditArea.StartTimeMinsEntry:SetValue( math.floor( info.starttime/60 ) )
			popup.EditArea.StartTimeSecsEntry:SetValue( info.starttime%60 )
		else
			if popup.EditArea.StartTimeEnable.Enabled then
				popup.EditArea.StartTimeEnable:DoClick()
			end
			popup.EditArea.StartTimeMinsEntry:SetValue( 0 )
			popup.EditArea.StartTimeSecsEntry:SetValue( 0 )
		end
		if info.endtime then
			if not popup.EditArea.EndTimeEnable.Enabled then
				popup.EditArea.EndTimeEnable:DoClick()
			end
			popup.EditArea.EndTimeMinsEntry.ChangeValue( math.floor( info.endtime/60 ) )
			popup.EditArea.EndTimeSecsEntry.ChangeValue( info.endtime%60 )
		else
			if popup.EditArea.EndTimeEnable.Enabled then
				popup.EditArea.EndTimeEnable:DoClick()
			end
			popup.EditArea.EndTimePanel.Checks()
		end
	end
	popup.EditArea.SetValues( data )
	
	function popup.EditArea.GetValues()
		local data = {}
		data.name = popup.EditArea.NameEntry:GetValue()
		data.artist = popup.EditArea.ArtistEntry:GetValue()
		data.id = popup.EditArea.URLEntry:GetValue()
		data.length = popup.EditArea.TimeMinsEntry:GetValue()*60+popup.EditArea.TimeSecsEntry:GetValue()
		if popup.EditArea.StartTimeEnable.Enabled then
			data.starttime = popup.EditArea.StartTimeMinsEntry:GetValue()*60+popup.EditArea.StartTimeSecsEntry:GetValue()
		end
		if popup.EditArea.EndTimeEnable.Enabled then
			data.endtime = popup.EditArea.EndTimeMinsEntry:GetValue()*60+popup.EditArea.EndTimeSecsEntry:GetValue()
		end
		return data
	end
	
	function popup.EditArea.CheckValues()
		local errors = {}
		if popup.EditArea.NameEntry.Error1 then
			table.insert( errors, "Song Name" )
		end
		if popup.EditArea.ArtistEntry.Error1 then
			table.insert( errors, "Artist" )
		end
		if popup.EditArea.URLEntry.Error1 or popup.EditArea.URLEntry.Error2 then
			table.insert( errors, "YouTube URL" )
		end
		if popup.EditArea.TimeMinsEntry.Issue1 or popup.EditArea.TimeSecsEntry.Issue1 then
			table.insert( errors, "Length" )
		end
		if (!popup.EditArea.StartTimeMinsEntry:GetDisabled() or !popup.EditArea.StartTimeSecsEntry:GetDisabled())  and (popup.EditArea.StartTimeMinsEntry.Issue1 or popup.EditArea.StartTimeSecsEntry.Issue1 or popup.EditArea.StartTimeMinsEntry.Issue2 or popup.EditArea.StartTimeSecsEntry.Issue2) then
			table.insert( errors, "Start Time" )
		end
		if (!popup.EditArea.EndTimeMinsEntry:GetDisabled() or !popup.EditArea.EndTimeSecsEntry:GetDisabled())  and (popup.EditArea.EndTimeMinsEntry.Issue1 or popup.EditArea.EndTimeSecsEntry.Issue1 or popup.EditArea.EndTimeMinsEntry.Issue2 or popup.EditArea.EndTimeSecsEntry.Issue2) then
			table.insert( errors, "End Time" )
		end
		if table.Count( errors ) > 0 then
			local words = ""
			for k, v in pairs( errors ) do
				if k == 1 then
					words = words.."- "..v
				else
					words = words.."\n".."- "..v
				end
			end
			popup.EditArea.DisplayIssues( words )
		else
			popup.EditArea.AcceptPopup( popup.EditArea.GetValues(), bg )
		end
	end
	
	function popup.EditArea.DisplayIssues( words )
		local text = "There are issues with the following fields: \n"..words
		
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
		
		local newpopup = vgui.Create( "DPanel", bg )
		newpopup:SetSize( 500, 400 )
		newpopup:Center()
		newpopup.Paint = function( self, w, h )
			draw.RoundedBox( 0, 0, 0, w, h, JukeBox.Colours.Background )
		end
		
		newpopup.TopBar = vgui.Create( "DPanel", newpopup )
		newpopup.TopBar:Dock( TOP )
		newpopup.TopBar:SetTall( 28 )
		newpopup.TopBar:DockPadding( 4, 4, 4, 4 )
		newpopup.TopBar.Paint = function( self, w, h )
			draw.RoundedBox( 0, 0, 0, w, h, JukeBox.Colours.Base )
			draw.SimpleText( "JukeBox - Error", "JukeBox.Font.18", w/2, h/2, Color( 255, 255, 255 ), 1, 1 )
		end
		
		newpopup.TopBar.CloseButton = vgui.Create( "DButton", newpopup.TopBar )
		newpopup.TopBar.CloseButton:Dock( RIGHT )
		newpopup.TopBar.CloseButton:SetWide( 50 )
		newpopup.TopBar.CloseButton:SetText( "" )
		newpopup.TopBar.CloseButton.DoClick = function()
			bg:Remove()
		end
		newpopup.TopBar.CloseButton.Paint = function( self, w, h )
			draw.RoundedBox( 0, 0, 0, w, h, Color( 192, 57, 43 ) )
			if not JukeBox.VGUI.VGUI:GetHovered( self ) then
				draw.RoundedBox( 0, 0, 0, w, h, Color( 0, 0, 0, 100 ) )
			end
			JukeBox.VGUI.VGUI:DrawEmblem( w/2, h/2, 10, "jukebox/close.png", Color( 255, 255, 255 ), 0 )
		end
		
		newpopup.Content = vgui.Create( "DPanel", newpopup )
		newpopup.Content:DockMargin( 0, 1, 0, 0 )
		newpopup.Content:DockPadding( 5, 5, 5, 5 )
		newpopup.Content:Dock( FILL )
		newpopup.Content.Progress = 1
		newpopup.Content.ProgressData = ""
		newpopup.Content.Paint = function( self, w, h )
			draw.RoundedBox( 0, 0, 0, w, h, JukeBox.Colours.Base )
		end
		
		newpopup.Body = vgui.Create( "DLabel", newpopup.Content )
		newpopup.Body:SetFont( "JukeBox.Font.18" )
		newpopup.Body:SetTextColor( Color( 255, 255, 255 ) )
		newpopup.Body:SetText( text )
		newpopup.Body:SizeToContents()
		newpopup:SetWide( newpopup.Body:GetWide()+10 )
		newpopup:SetTall( newpopup.Body:GetTall()+newpopup.TopBar:GetTall()+11+50 )
		newpopup.Body:Dock( TOP )
		newpopup:Center()
		
		newpopup.BottomBar = vgui.Create( "DPanel", newpopup.Content )
		newpopup.BottomBar:Dock( BOTTOM )
		newpopup.BottomBar:SetTall( 30 )
		newpopup.BottomBar:DockMargin( 0, 0, 0, 5 )
		newpopup.BottomBar.Paint = function( self, w, h ) end
		
		newpopup.CancelButton = vgui.Create( "DButton", newpopup.BottomBar )
		newpopup.CancelButton:SetTall( 30 )
		newpopup.CancelButton:Dock( BOTTOM )
		newpopup.CancelButton:SetVisible( true )
		newpopup.CancelButton:DockMargin( 30, 0, 30, 0 )
		newpopup.CancelButton:SetText( "" )
		newpopup.CancelButton.Text = "Close"
		newpopup.CancelButton.DoClick = function()
			bg:Remove()
		end
		newpopup.CancelButton.Paint = function( self, w, h )
			if JukeBox.VGUI.VGUI:GetHovered( self ) then
				draw.RoundedBox( h/2-1, 0, 0, w, h, Color( 0, 0, 0, 100 ) )
			else
				draw.RoundedBox( h/2-1, 0, 0, w, h, JukeBox.Colours.Light )
			end
			draw.SimpleText( self.Text, "JukeBox.Font.20", w/2, h/2-2, Color( 255, 255, 255 ), 1, 1 )
		end
	end
	
	function popup.EditArea.AcceptPopup( data, oldbg )
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
		popup:SetSize( 400, 200 )
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
			draw.SimpleText( "JukeBox - Sending Request", "JukeBox.Font.18", w/2, h/2, Color( 255, 255, 255 ), 1, 1 )
		end
		
		popup.TopBar.CloseButton = vgui.Create( "DButton", popup.TopBar )
		popup.TopBar.CloseButton:Dock( RIGHT )
		popup.TopBar.CloseButton:SetWide( 50 )
		popup.TopBar.CloseButton:SetText( "" )
		popup.TopBar.CloseButton.DoClick = function()
			JukeBox.VGUI.VGUI:MakeNotification( "Request was not sent, user cancelled process.", JukeBox.Colours.Warning, "jukebox/warning.png", "REQUEST", true )
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
		popup.Content:Dock( FILL )
		popup.Content.Progress = 1
		popup.Content.ProgressData = ""
		popup.Content.Paint = function( self, w, h )
			draw.RoundedBox( 0, 0, 0, w, h, JukeBox.Colours.Base )
			if self.Progress == 1 then
				draw.SimpleText( "Checking YouTube URL and data...", "JukeBox.Font.20", w/2, 15, Color( 255, 255, 255 ), 1, 1 )
				JukeBox.VGUI.VGUI:DrawEmblem( w/2, h/2-10, 80, "jukebox/loading.png", Color( 255, 255, 255 ), -CurTime()*100 )
			elseif self.Progress == 2 then
				draw.SimpleText( "Video exists", "JukeBox.Font.20", w/2, 15, Color( 255, 255, 255 ), 1, 1 )
				JukeBox.VGUI.VGUI:DrawEmblem( w/2, h/2-10, 80, "jukebox/tick.png", Color( 255, 255, 255 ), 0 )
			elseif self.Progress == 3 then
				draw.SimpleText( "Video doesn't exist", "JukeBox.Font.20", w/2, 15, Color( 255, 255, 255 ), 1, 1 )
				JukeBox.VGUI.VGUI:DrawEmblem( w/2, h/2-10, 80, "jukebox/cross.png", Color( 255, 255, 255 ), 0 )
			elseif self.Progress == 4 then
				draw.SimpleText( "Error contacting server", "JukeBox.Font.20", w/2, 15, Color( 255, 255, 255 ), 1, 1 )
				JukeBox.VGUI.VGUI:DrawEmblem( w/2, h/2-10, 80, "jukebox/error.png", Color( 255, 255, 255 ), 0 )
				draw.SimpleText( "Error: "..self.ProgressData, "JukeBox.Font.20", w/2, h-20, Color( 255, 255, 255 ), 1, 1 )
			end
		end
		
		popup.BottomButton = vgui.Create( "DButton", popup.Content )
		popup.BottomButton:SetSize( 100, 40 )
		popup.BottomButton:Dock( BOTTOM )
		popup.BottomButton:SetVisible( false )
		popup.BottomButton:DockMargin( 75, 5, 75, 10 )
		popup.BottomButton:SetText( "" )
		popup.BottomButton.Text = ""
		popup.BottomButton.SetSend = function()
			popup.BottomButton.Text = "Submit Request"
			popup.BottomButton.DoClick = function()
				JukeBox:AddRequest( data )
				bg:Remove()
				if ValidPanel( oldbg ) then oldbg:Remove() end
				JukeBox.VGUI.VGUI:MakeNotification( "Request has been sent. It will appear in the 'All Songs' list after Admin approval.", JukeBox.Colours.Accept, "jukebox/tick.png", "REQUEST", true )
			end
			popup.BottomButton:SetVisible( true )
			if popup.BottomButton2 then
				popup.BottomButton2:SetVisible( true )
			end
		end
		popup.BottomButton.SetClose = function()
			popup.BottomButton.Text = "Close"
			popup.BottomButton.DoClick = function()
				bg:Remove()
				JukeBox.VGUI.VGUI:MakeNotification( "Request was not sent, Video ID was found invalid.", JukeBox.Colours.Warning, "jukebox/warning.png", "REQUEST", true )
			end
			popup.BottomButton:SetVisible( true )
		end
		popup.BottomButton.DoClick = function()
			
		end
		popup.BottomButton.Paint = function( self, w, h )
			if JukeBox.VGUI.VGUI:GetHovered( self ) then
				draw.RoundedBox( h/2, 0, 0, w, h, JukeBox.Colours.Definition )
			else
				draw.RoundedBox( h/2, 0, 0, w, h, JukeBox.Colours.Light )
			end
			draw.SimpleText( self.Text, "JukeBox.Font.20", w/2, h/2-2, Color( 255, 255, 255 ), 1, 1 )
		end
		
		if JukeBox:IsManager( LocalPlayer() ) then
			popup.BottomButton2 = vgui.Create( "DButton", popup.Content )
			popup.BottomButton2:SetSize( 140, 20 )
			popup.BottomButton2:Dock( BOTTOM )
			popup.BottomButton2:SetVisible( false )
			popup.BottomButton2:DockMargin( 70, 20, 70, 0 )
			popup.BottomButton2:SetText( "" )
			popup.BottomButton2.Text = "Add song straight to All Songs list."
			popup.BottomButton2.DoClick = function()
				JukeBox:AcceptRequest( data )
				bg:Remove()
			end
			popup.BottomButton2.Paint = function( self, w, h )
				if JukeBox.VGUI.VGUI:GetHovered( self ) then
					draw.RoundedBox( h/2, 0, 0, w, h, JukeBox.Colours.Definition )
				else
					draw.RoundedBox( h/2, 0, 0, w, h, JukeBox.Colours.Light )
				end
				draw.SimpleText( self.Text, "JukeBox.Font.20", w/2, h/2-2, Color( 255, 255, 255 ), 1, 1 )
			end
			popup:SetTall( 250 )
		end
		
		http.Fetch( JukeBox.Settings.CheckerURL..data.id, 
			function( body )
				if not ValidPanel( bg ) then return end
				local info = util.JSONToTable( body )
				if not info then
					popup.Content.Progress = 4
					popup.BottomButton:SetSend()
				elseif info.videoExists then
					popup.Content.Progress = 2
					popup.BottomButton:SetSend()
				else
					popup.Content.Progress = 3
					popup.BottomButton:SetClose()
				end
			end,
			function( issue )
				if not ValidPanel( bg ) then return end
				popup.Content.Progress = 4
				popup.BottomButton:SetClose()
			end )
	end
	
end

JukeBox.VGUI:RegisterPage( "ADD A SONG", "QuickRequest", "Search", "jukebox/search.png", function( parent ) JukeBox.VGUI.Pages.QuickRequest:CreatePanel( parent ) end )