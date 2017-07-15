JukeBox.VGUI.Pages.AdminRequests = {}

function JukeBox.VGUI.Pages.AdminRequests:CreatePanel( parent )
	parent.Header = vgui.Create( "DPanel", parent )
	parent.Header:Dock( TOP )
	parent.Header:SetTall( 40 )
	parent.Header.Paint = function( self, w, h )
		draw.SimpleText( "SONG", "JukeBox.Font.18", 20, h/2, Color( 200, 200, 200 ), 0, 1 )
		draw.SimpleText( "ARTIST", "JukeBox.Font.18", w/2.5, h/2, Color( 200, 200, 200 ), 0, 1 )
		draw.SimpleText( "LENGTH", "JukeBox.Font.18", (w-35)*0.75+15, h/2, Color( 200, 200, 200 ), 1, 1 )
		draw.SimpleText( "ACTIONS", "JukeBox.Font.18", w-35, h/2, Color( 200, 200, 200 ), 2, 1 )
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
	
	function parent.Scroll:UpdateRequests()
		self:Clear()
		self.Count = 0
		if table.Count( JukeBox.RequestsList ) <= 0 then

		else
			for id, info in SortedPairsByMemberValue( JukeBox.RequestsList, "artist", false ) do
				JukeBox.VGUI.Pages.AdminRequests:CreateSongCard( parent, info )
				self.Count = self.Count+1
			end
		end
	end
	parent.Scroll:UpdateRequests()
	hook.Add( "JukeBox_RequestsUpdated", "JukeBox_VGUI_RequestsUpdate", function() 
		if ValidPanel( parent ) then		
			parent.Scroll:UpdateRequests()
		end
	end )
	
	parent.EditArea = vgui.Create( "DPanel", parent )
	parent.EditArea:Dock( BOTTOM )
	parent.EditArea:DockPadding( 50, 10, 50, 10 )
	parent.EditArea:SetTall( 276 )
	parent.EditArea.Paint = function( self, w, h )
		draw.RoundedBox( 0, 0, 0, w, 1, JukeBox.Colours.Base )
	end
	
	parent.EditArea.NamePanel = vgui.Create( "DPanel", parent.EditArea )
	parent.EditArea.NamePanel:Dock( TOP )
	parent.EditArea.NamePanel:DockPadding( 150, 0, 12, 0 )
	parent.EditArea.NamePanel:DockMargin( 0, 0, 0, 10 )
	parent.EditArea.NamePanel.Paint = function( self, w, h )
		draw.RoundedBox( h/2, 138, 0, w-138, h, Color( 255, 255, 255 ) )
		draw.SimpleText( "Song name:", "JukeBox.Font.18", 5, h/2, Color( 255, 255, 255 ), 0, 1 )
	end
	
	parent.EditArea.NameEntry = vgui.Create( "DTextEntry", parent.EditArea.NamePanel )
	parent.EditArea.NameEntry:Dock( FILL )
	parent.EditArea.NameEntry.Val = ""
	parent.EditArea.NameEntry.Error1 = true
	parent.EditArea.NameEntry:SetFont( "JukeBox.Font.16" )
	parent.EditArea.NameEntry.Think = function( self )
		if self.Val != self:GetValue() then
			self:OnChange( self )
		end
	end
	parent.EditArea.NameEntry.Paint = function( self, w, h )
		draw.RoundedBox( 0, 0, 0, w, h, Color( 255, 255, 255 ) )
		self:DrawTextEntryText( JukeBox.Colours.Base, Color( 30, 130, 255 ), JukeBox.Colours.Base )
	end
	parent.EditArea.NameEntry.OnChange = function( self )
		self.Val = self:GetValue()
		if self:GetValue() != "" then
			self.Error1 = false
		else
			self.Error1 = true
		end
	end
	
	parent.EditArea.ArtistPanel = vgui.Create( "DPanel", parent.EditArea )
	parent.EditArea.ArtistPanel:Dock( TOP )
	parent.EditArea.ArtistPanel:DockPadding( 150, 0, 12, 0 )
	parent.EditArea.ArtistPanel:DockMargin( 0, 0, 0, 10 )
	parent.EditArea.ArtistPanel.Paint = function( self, w, h )
		draw.RoundedBox( h/2, 138, 0, w-138, h, Color( 255, 255, 255 ) )
		draw.SimpleText( "Artist:", "JukeBox.Font.18", 5, h/2, Color( 255, 255, 255 ), 0, 1 )
	end
	
	parent.EditArea.ArtistEntry = vgui.Create( "DTextEntry", parent.EditArea.ArtistPanel )
	parent.EditArea.ArtistEntry:Dock( FILL )
	parent.EditArea.ArtistEntry.Val = ""
	parent.EditArea.ArtistEntry.Error1 = true
	parent.EditArea.ArtistEntry:SetFont( "JukeBox.Font.16" )
	parent.EditArea.ArtistEntry.Think = function( self )
		if self.Val != self:GetValue() then
			self:OnChange( self )
		end
	end
	parent.EditArea.ArtistEntry.Paint = function( self, w, h )
		draw.RoundedBox( 0, 0, 0, w, h, Color( 255, 255, 255 ) )
		self:DrawTextEntryText( JukeBox.Colours.Base, Color( 30, 130, 255 ), JukeBox.Colours.Base )
	end
	parent.EditArea.ArtistEntry.OnChange = function( self )
		self.Val = self:GetValue()
		if self:GetValue() != "" then
			self.Error1 = false
		else
			self.Error1 = true
		end
	end
	
	parent.EditArea.URLPanel = vgui.Create( "DPanel", parent.EditArea )
	parent.EditArea.URLPanel:Dock( TOP )
	parent.EditArea.URLPanel:DockPadding( 150, 0, 0, 0 )
	parent.EditArea.URLPanel:DockMargin( 0, 0, 0, 10 )
	parent.EditArea.URLPanel.Paint = function( self, w, h )
		draw.RoundedBox( h/2, 138, 0, w-138-120-10, h, Color( 100, 100, 100 ) )
		draw.SimpleText( "YouTube ID:", "JukeBox.Font.18", 5, h/2, Color( 255, 255, 255 ), 0, 1 )
	end	
	
	parent.EditArea.URLEntry = vgui.Create( "DTextEntry", parent.EditArea.URLPanel )
	parent.EditArea.URLEntry:Dock( FILL )
	parent.EditArea.URLEntry.Val = ""
	parent.EditArea.URLEntry.Error1 = true
	parent.EditArea.URLEntry.Error2 = true
	parent.EditArea.URLEntry.URLID = nil
	parent.EditArea.URLEntry:SetDisabled( true )
	parent.EditArea.URLEntry:SetEditable( false )
	parent.EditArea.URLEntry:SetFont( "JukeBox.Font.18" )
	parent.EditArea.URLEntry.Think = function( self )
		if self.Val != self:GetValue() then
			self:OnChange( self )
		end
	end
	parent.EditArea.URLEntry.Paint = function( self, w, h )
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
	parent.EditArea.URLEntry.OnChange = function( self )
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
	
	parent.EditArea.URLCheck = vgui.Create( "DButton", parent.EditArea.URLPanel )
	parent.EditArea.URLCheck:SetWide( 120 )
	parent.EditArea.URLCheck:Dock( RIGHT )
	parent.EditArea.URLCheck:DockMargin( 24, 0, 0, 0 )
	parent.EditArea.URLCheck:SetText( "" )
	parent.EditArea.URLCheck.DoClick = function( self )
		local dropdown = vgui.Create( "DMenu" )
		dropdown:SetPos( input.GetCursorPos() )
		dropdown:MakePopup()
		dropdown.Paint = function( self, w, h )
			draw.RoundedBox( 0, 0, 0, w, h, JukeBox.Colours.Background )
		end
		local dropdownVoteButton = dropdown:AddOption( "JukeBox Pop-up" )
		dropdownVoteButton:SetTextColor( Color( 255, 255, 255 ) )
		function dropdownVoteButton:DoClick()
			JukeBox.VGUI.Pages.AdminRequests:CheckURL( parent, parent.EditArea.URLEntry:GetValue() )
		end
		dropdown:AddSpacer()
		local dropdownForceButton = dropdown:AddOption( "Steam Overlay" )
		dropdownForceButton:SetTextColor( Color( 255, 255, 255 ) )
		function dropdownForceButton:DoClick()
			gui.OpenURL( "https://www.youtube.com/watch?v="..parent.EditArea.URLEntry:GetValue() )
		end
	end
	parent.EditArea.URLCheck.Paint = function( self, w, h )
		if JukeBox.VGUI.VGUI:GetHovered( self ) then
			draw.RoundedBox( h/2, 0, 0, w, h, JukeBox.Colours.Accept )
		else
			draw.RoundedBox( h/2, 0, 0, w, h, JukeBox.Colours.Light )
		end
		draw.SimpleText( "Check YouTube ID", "JukeBox.Font.16", w/2, h/2, Color( 255, 255, 255 ), 1, 1 )
	end
	
	--// LENGTH \\--
	parent.EditArea.TimePanel = vgui.Create( "DPanel", parent.EditArea )
	parent.EditArea.TimePanel:Dock( TOP )
	parent.EditArea.TimePanel:SetTall( 36 )
	parent.EditArea.TimePanel:DockPadding( 138, 0, 12, 0 )
	parent.EditArea.TimePanel:DockMargin( 0, 0, 0, 4 )
	parent.EditArea.TimePanel.Paint = function( self, w, h )
		--draw.RoundedBox( h/2, 0, 0, w, h, Color( 255, 0, 255 ) )
		draw.SimpleText( "Length:", "JukeBox.Font.18", 5, 24/2, Color( 255, 255, 255 ), 0, 1 )
	end
	
	parent.EditArea.TimeMinsPanel = vgui.Create( "DPanel", parent.EditArea.TimePanel )
	parent.EditArea.TimeMinsPanel:Dock( LEFT )
	parent.EditArea.TimeMinsPanel:DockPadding( 12, 0, 12, 12)
	parent.EditArea.TimeMinsPanel:DockMargin( 0, 0, 12, 0 )
	parent.EditArea.TimeMinsPanel.Paint = function( self, w, h )
		draw.RoundedBox( 24/2, 0, 0, w, 24, Color( 255, 255, 255 ) )
		draw.SimpleText( "MINS", "JukeBox.Font.12", w/2, h, Color( 200, 200, 200 ), 1, 4 )
	end
	
	parent.EditArea.TimeMinsEntry = vgui.Create( "DNumberWang", parent.EditArea.TimeMinsPanel )
	parent.EditArea.TimeMinsEntry:Dock( FILL )
	parent.EditArea.TimeMinsEntry:SetFont( "JukeBox.Font.18" )
	parent.EditArea.TimeMinsEntry:SetMin( 0 )
	parent.EditArea.TimeMinsEntry:SetMax( math.floor(JukeBox.Settings.MaxSongLength/60) )
	parent.EditArea.TimeMinsEntry.Val = 0
	parent.EditArea.TimeMinsEntry.Issue1 = true
	parent.EditArea.TimeMinsEntry.Paint = function( self, w, h )
		draw.RoundedBox( 0, 0, 0, w, h, Color( 255, 255, 255 ) )
		self:DrawTextEntryText( JukeBox.Colours.Base, Color( 30, 130, 255 ), JukeBox.Colours.Base)
	end
	parent.EditArea.TimeMinsEntry.Think = function( self )
		if self.Val != self:GetValue() then
			self:OnValueChanged( self )
		end
	end
	parent.EditArea.TimeMinsEntry.OnValueChanged = function( self )
		self.Val = self:GetValue()
		parent.EditArea.TimePanel.Checks()
		parent.EditArea.StartTimePanel.Checks()
		parent.EditArea.EndTimePanel.Checks()
	end
	
	parent.EditArea.TimeSecsPanel = vgui.Create( "DPanel", parent.EditArea.TimePanel )
	parent.EditArea.TimeSecsPanel:Dock( LEFT )
	parent.EditArea.TimeSecsPanel:DockPadding( 12, 0, 12, 12)
	parent.EditArea.TimeSecsPanel.Paint = function( self, w, h )
		draw.RoundedBox( 24/2, 0, 0, w, 24, Color( 255, 255, 255 ) )
		draw.SimpleText( "SECS", "JukeBox.Font.12", w/2, h, Color( 200, 200, 200 ), 1, 4 )
	end
	
	parent.EditArea.TimeSecsEntry = vgui.Create( "DNumberWang", parent.EditArea.TimeSecsPanel )
	parent.EditArea.TimeSecsEntry:Dock( FILL )
	parent.EditArea.TimeSecsEntry:SetFont( "JukeBox.Font.18" )
	parent.EditArea.TimeSecsEntry:SetMin( 0 )
	parent.EditArea.TimeSecsEntry:SetMax( 59 )
	parent.EditArea.TimeSecsEntry.Val = 0
	parent.EditArea.TimeSecsEntry.Issue1 = true
	parent.EditArea.TimeSecsEntry.Paint = function( self, w, h )
		draw.RoundedBox( 0, 0, 0, w, h, Color( 255, 255, 255 ) )
		self:DrawTextEntryText( JukeBox.Colours.Base, Color( 30, 130, 255 ), JukeBox.Colours.Base)
	end
	parent.EditArea.TimeSecsEntry.Think = function( self )
		if self.Val != self:GetValue() then
			self:OnValueChanged( self )
		end
	end
	parent.EditArea.TimeSecsEntry.OnValueChanged = function( self )
		self.Val = self:GetValue()
		parent.EditArea.TimePanel.Checks()
		parent.EditArea.StartTimePanel.Checks()
		parent.EditArea.EndTimePanel.Checks()
	end
	
	function parent.EditArea.TimePanel.Checks()
		if parent.EditArea.TimeSecsEntry:GetValue()+parent.EditArea.TimeMinsEntry:GetValue()*60 > 0 then
			parent.EditArea.TimeSecsEntry.Issue1 = false
			parent.EditArea.TimeMinsEntry.Issue1  = false
		else
			parent.EditArea.TimeSecsEntry.Issue1 = true
			parent.EditArea.TimeMinsEntry.Issue1  = true
		end
	end
	
	--// START TIME \\--
	parent.EditArea.StartTimePanel = vgui.Create( "DPanel", parent.EditArea )
	parent.EditArea.StartTimePanel:Dock( TOP )
	parent.EditArea.StartTimePanel:SetTall( 36 )
	parent.EditArea.StartTimePanel:DockPadding( 138, 0, 12, 0 )
	parent.EditArea.StartTimePanel:DockMargin( 0, 0, 0, 4 )
	parent.EditArea.StartTimePanel.Paint = function( self, w, h )
		--draw.RoundedBox( h/2, 0, 0, w, h, Color( 255, 0, 255 ) )
		draw.SimpleText( "Start time:", "JukeBox.Font.18", 5, 24/2, Color( 255, 255, 255 ), 0, 1 )
	end
	
	parent.EditArea.StartTimeMinsPanel = vgui.Create( "DPanel", parent.EditArea.StartTimePanel )
	parent.EditArea.StartTimeMinsPanel:Dock( LEFT )
	parent.EditArea.StartTimeMinsPanel:DockPadding( 12, 0, 12, 12)
	parent.EditArea.StartTimeMinsPanel:DockMargin( 0, 0, 12, 0 )
	parent.EditArea.StartTimeMinsPanel.Paint = function( self, w, h )
		if parent.EditArea.StartTimeMinsEntry:GetDisabled() then
			draw.RoundedBox( 24/2, 0, 0, w, 24, Color( 100, 100, 100 ) )
		else
			draw.RoundedBox( 24/2, 0, 0, w, 24, Color( 255, 255, 255 ) )
		end
		draw.SimpleText( "MINS", "JukeBox.Font.12", w/2, h, Color( 200, 200, 200 ), 1, 4 )
	end
	
	parent.EditArea.StartTimeMinsEntry = vgui.Create( "DNumberWang", parent.EditArea.StartTimeMinsPanel )
	parent.EditArea.StartTimeMinsEntry:Dock( FILL )
	parent.EditArea.StartTimeMinsEntry:SetFont( "JukeBox.Font.18" )
	parent.EditArea.StartTimeMinsEntry:SetMin( 0 )
	parent.EditArea.StartTimeMinsEntry:SetMax( math.floor(JukeBox.Settings.MaxSongLength/60) )
	parent.EditArea.StartTimeMinsEntry:SetDisabled( true )
	parent.EditArea.StartTimeMinsEntry.Val = 0
	parent.EditArea.StartTimeMinsEntry.Issue1 = true
	parent.EditArea.StartTimeMinsEntry.Paint = function( self, w, h )
		if self:GetDisabled() then
			draw.RoundedBox( 24/2, 0, 0, w, 24, Color( 100, 100, 100 ) )
		else
			draw.RoundedBox( 24/2, 0, 0, w, 24, Color( 255, 255, 255 ) )
		end
		self:DrawTextEntryText( JukeBox.Colours.Base, Color( 30, 130, 255 ), JukeBox.Colours.Base)
	end
	parent.EditArea.StartTimeMinsEntry.Think = function( self )
		if self.Val != self:GetValue() then
			self:OnValueChanged( self )
		end
	end
	parent.EditArea.StartTimeMinsEntry.OnValueChanged = function( self )
		self.Val = self:GetValue()
		parent.EditArea.TimePanel.Checks()
		parent.EditArea.StartTimePanel.Checks()
		parent.EditArea.EndTimePanel.Checks()
	end
	
	parent.EditArea.StartTimeSecsPanel = vgui.Create( "DPanel", parent.EditArea.StartTimePanel )
	parent.EditArea.StartTimeSecsPanel:Dock( LEFT )
	parent.EditArea.StartTimeSecsPanel:DockPadding( 12, 0, 12, 12)
	parent.EditArea.StartTimeSecsPanel.Paint = function( self, w, h )
		if parent.EditArea.StartTimeSecsEntry:GetDisabled() then
			draw.RoundedBox( 24/2, 0, 0, w, 24, Color( 100, 100, 100 ) )
		else
			draw.RoundedBox( 24/2, 0, 0, w, 24, Color( 255, 255, 255 ) )
		end
		draw.SimpleText( "SECS", "JukeBox.Font.12", w/2, h, Color( 200, 200, 200 ), 1, 4 )
	end
	
	parent.EditArea.StartTimeSecsEntry = vgui.Create( "DNumberWang", parent.EditArea.StartTimeSecsPanel )
	parent.EditArea.StartTimeSecsEntry:Dock( FILL )
	parent.EditArea.StartTimeSecsEntry:SetFont( "JukeBox.Font.18" )
	parent.EditArea.StartTimeSecsEntry:SetMin( 0 )
	parent.EditArea.StartTimeSecsEntry:SetMax( 59 )
	parent.EditArea.StartTimeSecsEntry:SetDisabled( true )
	parent.EditArea.StartTimeSecsEntry.Val = 0
	parent.EditArea.StartTimeSecsEntry.Issue1 = true
	parent.EditArea.StartTimeSecsEntry.Paint = function( self, w, h )
		if self:GetDisabled() then
			draw.RoundedBox( 24/2, 0, 0, w, 24, Color( 100, 100, 100 ) )
		else
			draw.RoundedBox( 24/2, 0, 0, w, 24, Color( 255, 255, 255 ) )
		end
		self:DrawTextEntryText( JukeBox.Colours.Base, Color( 30, 130, 255 ), JukeBox.Colours.Base)
	end
	parent.EditArea.StartTimeSecsEntry.Think = function( self )
		if self.Val != self:GetValue() then
			self:OnValueChanged( self )
		end
	end
	parent.EditArea.StartTimeSecsEntry.OnValueChanged = function( self )
		self.Val = self:GetValue()
		parent.EditArea.TimePanel.Checks()
		parent.EditArea.StartTimePanel.Checks()
		parent.EditArea.EndTimePanel.Checks()
	end

	parent.EditArea.StartTimeEnable = vgui.Create( "DButton", parent.EditArea.StartTimePanel )
	parent.EditArea.StartTimeEnable:Dock( LEFT )
	parent.EditArea.StartTimeEnable:SetWide( 70 )
	parent.EditArea.StartTimeEnable:SetTall( 24 )
	parent.EditArea.StartTimeEnable.Enabled = false
	parent.EditArea.StartTimeEnable:DockMargin( 20, 0, 0, 12 )
	parent.EditArea.StartTimeEnable:SetText( "" )
	parent.EditArea.StartTimeEnable.DoClick = function( self )
		self.Enabled = !self.Enabled
		parent.EditArea.StartTimeSecsEntry:SetDisabled( !self.Enabled )
		parent.EditArea.StartTimeMinsEntry:SetDisabled( !self.Enabled )
	end
	parent.EditArea.StartTimeEnable.Paint = function( self, w, h )
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
	
	function parent.EditArea.StartTimePanel.Checks()
		if parent.EditArea.StartTimeSecsEntry:GetValue()+parent.EditArea.StartTimeMinsEntry:GetValue()*60 >= 0 then
			parent.EditArea.StartTimeSecsEntry.Issue1 = false
			parent.EditArea.StartTimeMinsEntry.Issue1  = false
			if ( parent.EditArea.StartTimeSecsEntry:GetValue()+parent.EditArea.StartTimeMinsEntry:GetValue()*60 >= parent.EditArea.TimeSecsEntry:GetValue()+parent.EditArea.TimeMinsEntry:GetValue()*60 ) then
				parent.EditArea.StartTimeSecsEntry.Issue2 = true
				parent.EditArea.StartTimeMinsEntry.Issue2 = true
			else
				parent.EditArea.StartTimeSecsEntry.Issue2 = false
				parent.EditArea.StartTimeMinsEntry.Issue2 = false
			end
		else
			parent.EditArea.StartTimeSecsEntry.Issue1 = true
			parent.EditArea.StartTimeMinsEntry.Issue1  = true
		end
	end
	
	--// END TIME \\--
	parent.EditArea.EndTimePanel = vgui.Create( "DPanel", parent.EditArea )
	parent.EditArea.EndTimePanel:Dock( TOP )
	parent.EditArea.EndTimePanel:SetTall( 36 )
	parent.EditArea.EndTimePanel:DockPadding( 138, 0, 12, 0 )
	parent.EditArea.EndTimePanel:DockMargin( 0, 0, 0, 4 )
	parent.EditArea.EndTimePanel.Paint = function( self, w, h )
		--draw.RoundedBox( h/2, 0, 0, w, h, Color( 255, 0, 255 ) )
		draw.SimpleText( "End time:", "JukeBox.Font.18", 5, 24/2, Color( 255, 255, 255 ), 0, 1 )
	end
	
	parent.EditArea.EndTimeMinsPanel = vgui.Create( "DPanel", parent.EditArea.EndTimePanel )
	parent.EditArea.EndTimeMinsPanel:Dock( LEFT )
	parent.EditArea.EndTimeMinsPanel:DockPadding( 12, 0, 12, 12)
	parent.EditArea.EndTimeMinsPanel:DockMargin( 0, 0, 12, 0 )
	parent.EditArea.EndTimeMinsPanel.Paint = function( self, w, h )
		if parent.EditArea.EndTimeMinsEntry:GetDisabled() then
			draw.RoundedBox( 24/2, 0, 0, w, 24, Color( 100, 100, 100 ) )
		else
			draw.RoundedBox( 24/2, 0, 0, w, 24, Color( 255, 255, 255 ) )
		end
		draw.SimpleText( "MINS", "JukeBox.Font.12", w/2, h, Color( 200, 200, 200 ), 1, 4 )
	end
	
	parent.EditArea.EndTimeMinsEntry = vgui.Create( "DNumberWang", parent.EditArea.EndTimeMinsPanel )
	parent.EditArea.EndTimeMinsEntry:Dock( FILL )
	parent.EditArea.EndTimeMinsEntry:SetFont( "JukeBox.Font.18" )
	parent.EditArea.EndTimeMinsEntry:SetMin( 0 )
	parent.EditArea.EndTimeMinsEntry:SetMax( math.floor(JukeBox.Settings.MaxSongLength/60) )
	parent.EditArea.EndTimeMinsEntry:SetDisabled( true )
	parent.EditArea.EndTimeMinsEntry.Val = 0
	parent.EditArea.EndTimeMinsEntry.Issue1 = true
	parent.EditArea.EndTimeMinsEntry.Paint = function( self, w, h )
		if self:GetDisabled() then
			draw.RoundedBox( 24/2, 0, 0, w, 24, Color( 100, 100, 100 ) )
		else
			draw.RoundedBox( 24/2, 0, 0, w, 24, Color( 255, 255, 255 ) )
		end
		self:DrawTextEntryText( JukeBox.Colours.Base, Color( 30, 130, 255 ), JukeBox.Colours.Base)
	end
	parent.EditArea.EndTimeMinsEntry.Think = function( self )
		if self.Val != self:GetValue() then
			self:OnValueChanged( self )
		end
	end
	parent.EditArea.EndTimeMinsEntry.OnValueChanged = function( self )
		if self.Override then return end
		self.Val = self:GetValue()
		parent.EditArea.EndTimePanel.Checks()
	end
	parent.EditArea.EndTimeMinsEntry.ChangeValue = function( value )
		parent.EditArea.EndTimeMinsEntry.Override = true
		parent.EditArea.EndTimeMinsEntry:SetValue( value )
		parent.EditArea.EndTimeMinsEntry.Override = false
	end
	
	parent.EditArea.EndTimeSecsPanel = vgui.Create( "DPanel", parent.EditArea.EndTimePanel )
	parent.EditArea.EndTimeSecsPanel:Dock( LEFT )
	parent.EditArea.EndTimeSecsPanel:DockPadding( 12, 0, 12, 12)
	parent.EditArea.EndTimeSecsPanel.Paint = function( self, w, h )
		if parent.EditArea.EndTimeSecsEntry:GetDisabled() then
			draw.RoundedBox( 24/2, 0, 0, w, 24, Color( 100, 100, 100 ) )
		else
			draw.RoundedBox( 24/2, 0, 0, w, 24, Color( 255, 255, 255 ) )
		end
		draw.SimpleText( "SECS", "JukeBox.Font.12", w/2, h, Color( 200, 200, 200 ), 1, 4 )
	end
	
	parent.EditArea.EndTimeSecsEntry = vgui.Create( "DNumberWang", parent.EditArea.EndTimeSecsPanel )
	parent.EditArea.EndTimeSecsEntry:Dock( FILL )
	parent.EditArea.EndTimeSecsEntry:SetFont( "JukeBox.Font.18" )
	parent.EditArea.EndTimeSecsEntry:SetMin( 0 )
	parent.EditArea.EndTimeSecsEntry:SetMax( 59 )
	parent.EditArea.EndTimeSecsEntry:SetDisabled( true )
	parent.EditArea.EndTimeSecsEntry.Val = 0
	parent.EditArea.EndTimeSecsEntry.Issue1 = true
	parent.EditArea.EndTimeSecsEntry.Override = false
	parent.EditArea.EndTimeSecsEntry.Paint = function( self, w, h )
		if self:GetDisabled() then
			draw.RoundedBox( 24/2, 0, 0, w, 24, Color( 100, 100, 100 ) )
		else
			draw.RoundedBox( 24/2, 0, 0, w, 24, Color( 255, 255, 255 ) )
		end
		self:DrawTextEntryText( JukeBox.Colours.Base, Color( 30, 130, 255 ), JukeBox.Colours.Base)
	end
	parent.EditArea.EndTimeSecsEntry.Think = function( self )
		if self.Val != self:GetValue() then
			self:OnValueChanged( self )
		end
	end
	parent.EditArea.EndTimeSecsEntry.OnValueChanged = function( self )
		if self.Override then return end
		self.Val = self:GetValue()
		parent.EditArea.EndTimePanel.Checks()
	end
	parent.EditArea.EndTimeSecsEntry.ChangeValue = function( value )
		parent.EditArea.EndTimeSecsEntry.Override = true
		parent.EditArea.EndTimeSecsEntry:SetValue( value )
		parent.EditArea.EndTimeSecsEntry.Override = false
	end
	
	parent.EditArea.EndTimeEnable = vgui.Create( "DButton", parent.EditArea.EndTimePanel )
	parent.EditArea.EndTimeEnable:Dock( LEFT )
	parent.EditArea.EndTimeEnable:SetWide( 70 )
	parent.EditArea.EndTimeEnable:SetTall( 24 )
	parent.EditArea.EndTimeEnable.Enabled = false
	parent.EditArea.EndTimeEnable:DockMargin( 20, 0, 0, 12 )
	parent.EditArea.EndTimeEnable:SetText( "" )
	parent.EditArea.EndTimeEnable.DoClick = function( self )
		self.Enabled = !self.Enabled
		parent.EditArea.EndTimeSecsEntry:SetDisabled( !self.Enabled )
		parent.EditArea.EndTimeMinsEntry:SetDisabled( !self.Enabled )
	end
	parent.EditArea.EndTimeEnable.Paint = function( self, w, h )
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
	
	function parent.EditArea.EndTimePanel.Checks()
		if not parent.EditArea.EndTimeEnable.Enabled then
			parent.EditArea.EndTimeSecsEntry.ChangeValue( parent.EditArea.TimeSecsEntry:GetValue() )
			parent.EditArea.EndTimeMinsEntry.ChangeValue( parent.EditArea.TimeMinsEntry:GetValue() )
		end
		if parent.EditArea.EndTimeSecsEntry:GetValue()+parent.EditArea.EndTimeMinsEntry:GetValue()*60 > 0 then
			parent.EditArea.EndTimeSecsEntry.Issue1 = false
			parent.EditArea.EndTimeMinsEntry.Issue1  = false
			if ( parent.EditArea.EndTimeSecsEntry:GetValue()+parent.EditArea.EndTimeMinsEntry:GetValue()*60 > parent.EditArea.TimeSecsEntry:GetValue()+parent.EditArea.TimeMinsEntry:GetValue()*60) then
				parent.EditArea.EndTimeSecsEntry.Issue2 = true
				parent.EditArea.EndTimeMinsEntry.Issue2 = true
			else
				parent.EditArea.EndTimeSecsEntry.Issue2 = false
				parent.EditArea.EndTimeMinsEntry.Issue2 = false
			end
		else
			parent.EditArea.EndTimeSecsEntry.Issue1 = true
			parent.EditArea.EndTimeMinsEntry.Issue1  = true
		end
	end
	
	--// BEHIND THE SCENES \\--
	function parent.EditArea.SetValues( info )
		parent.EditArea.NameEntry:SetValue( info.name )
		parent.EditArea.ArtistEntry:SetValue( info.artist )
		parent.EditArea.URLEntry:SetValue( info.id )
		parent.EditArea.TimeMinsEntry:SetValue( math.floor( info.length/60 ) )
		parent.EditArea.TimeSecsEntry:SetValue( info.length%60 )
		if info.starttime then
			if not parent.EditArea.StartTimeEnable.Enabled then
				parent.EditArea.StartTimeEnable:DoClick()
			end
			parent.EditArea.StartTimeMinsEntry:SetValue( math.floor( info.starttime/60 ) )
			parent.EditArea.StartTimeSecsEntry:SetValue( info.starttime%60 )
		else
			if parent.EditArea.StartTimeEnable.Enabled then
				parent.EditArea.StartTimeEnable:DoClick()
			end
			parent.EditArea.StartTimeMinsEntry:SetValue( 0 )
			parent.EditArea.StartTimeSecsEntry:SetValue( 0 )
		end
		if info.endtime then
			if not parent.EditArea.EndTimeEnable.Enabled then
				parent.EditArea.EndTimeEnable:DoClick()
			end
			parent.EditArea.EndTimeMinsEntry.ChangeValue( math.floor( info.endtime/60 ) )
			parent.EditArea.EndTimeSecsEntry.ChangeValue( info.endtime%60 )
		else
			if parent.EditArea.EndTimeEnable.Enabled then
				parent.EditArea.EndTimeEnable:DoClick()
			end
			parent.EditArea.EndTimePanel.Checks()
		end
	end
	
	parent.EditArea.ActionButtons = vgui.Create( "DPanel", parent.EditArea )
	parent.EditArea.ActionButtons:Dock( BOTTOM )
	parent.EditArea.ActionButtons:SetTall( 30 )
	parent.EditArea.ActionButtons.Paint = function( self, w, h )
		
	end
	
	parent.EditArea.ActionButtons.Accept = vgui.Create( "DButton", parent.EditArea.ActionButtons )
	parent.EditArea.ActionButtons.Accept:Dock( LEFT )
	parent.EditArea.ActionButtons.Accept:DockMargin( 0, 0, 10, 0 )
	parent.EditArea.ActionButtons.Accept:SetWide( 125 )
	parent.EditArea.ActionButtons.Accept:SetText( "" )
	parent.EditArea.ActionButtons.Accept.DoClick = function( self )
		JukeBox.VGUI.Pages.AdminRequests:CheckFields( parent )
	end
	parent.EditArea.ActionButtons.Accept.Paint = function( self, w, h )
		if JukeBox.VGUI.VGUI:GetHovered( self ) then
			draw.RoundedBox( h/2-1, 0, 0, w, h, JukeBox.Colours.Accept )
		else
			draw.RoundedBox( h/2-1, 0, 0, w, h, JukeBox.Colours.Light )
		end
		JukeBox.VGUI.VGUI:DrawEmblem( h*0.75, h/2, 16, "jukebox/tick.png", Color( 255, 255, 255 ), 0 )
		draw.SimpleText( "Add Song", "JukeBox.Font.20", h+10, h/2-2, Color( 255, 255, 255 ), 0, 1 )
	end

	parent.EditArea.ActionButtons.Delete = vgui.Create( "DButton", parent.EditArea.ActionButtons )
	parent.EditArea.ActionButtons.Delete:Dock( LEFT )
	parent.EditArea.ActionButtons.Delete:SetWide( 140 )
	parent.EditArea.ActionButtons.Delete:SetText( "" )
	parent.EditArea.ActionButtons.Delete.DoClick = function( self )
		if not parent.EditArea.URLEntry.Error1 or not parent.EditArea.URLEntry.Error2 then
			JukeBox.VGUI.Pages.AdminRequests:DenyPopup( parent )
		else
			JukeBox.VGUI.VGUI:MakeNotification( "No valid request seems to be selected!", JukeBox.Colours.Issue, "jukebox/warning.png", "ADMINREQUEST", true )
		end
	end
	parent.EditArea.ActionButtons.Delete.Paint = function( self, w, h )
		if JukeBox.VGUI.VGUI:GetHovered( self ) then
			draw.RoundedBox( h/2-1, 0, 0, w, h, JukeBox.Colours.Issue )
		else
			draw.RoundedBox( h/2-1, 0, 0, w, h, JukeBox.Colours.Light )
		end
		JukeBox.VGUI.VGUI:DrawEmblem( h*0.75, h/2, 16, "jukebox/cross.png", Color( 255, 255, 255 ), 0 )
		draw.SimpleText( "Delete Song", "JukeBox.Font.20", h+10, h/2-2, Color( 255, 255, 255 ), 0, 1 )
	end
end

function JukeBox.VGUI.Pages.AdminRequests:CreateSongCard( parent, info )
	local card = vgui.Create( "DPanel", parent )
	card:SetTall( 40 )
	card:Dock( TOP )
	card:DockMargin( 15, 0, 20, 0 )
	card.Chosen = false
	function card:SetChosen( bool )
		card.Chosen = bool
	end
	card.Paint = function( self, w, h )
		if JukeBox.VGUI.VGUI:GetHovered( self ) then
			draw.RoundedBox( 0, 0, 0, w, h, JukeBox.Colours.Base )
		elseif self.Chosen then
			draw.RoundedBox( 0, 0, 0, w, h, Color( 255, 255, 255, 5 ) )
		end
		draw.SimpleText( info.name, "JukeBox.Font.20", 10, h/2, Color( 255, 255, 255 ), 0, 1 )
		draw.SimpleText( info.artist, "JukeBox.Font.20", w/2.5, h/2, Color( 255, 255, 255 ), 0, 1 )
		local time =  string.FormattedTime( info.length )
		draw.SimpleText( time.h!=0 and Format("%02i:%02i:%02i", time.h, time.m, time.s) or Format("%02i:%02i", time.m, time.s), "JukeBox.Font.20", w*0.75, h/2, Color( 255, 255, 255 ), 1, 1 )
		draw.RoundedBox( 0, 0, h-1, w, 1, JukeBox.Colours.Base )
	end
	
	card.EditButton = vgui.Create( "DButton", card )
	card.EditButton:Dock( RIGHT )
	card.EditButton:DockMargin( 0, 5, 10, 5 )
	card.EditButton:SetWide( 110 )
	card.EditButton:SetText( "" )
	card.EditButton.DoClick = function()
		parent.EditArea.SetValues( info )
		JukeBox.VGUI.Pages.AdminRequests:SetSongCard( parent, card )
	end
	card.EditButton.Paint = function( self, w, h )
		if JukeBox.VGUI.VGUI:GetHovered( self ) then
			draw.RoundedBox( h/2+1, 0, 0, w, h, JukeBox.Colours.Definition )
		else
			draw.RoundedBox( h/2+1, 0, 0, w, h, JukeBox.Colours.Light )
		end
		draw.SimpleText( "View/Edit", "JukeBox.Font.20", w/2, h/2-2, Color( 255, 255, 255 ), 1, 1 )
	end
	
	card.PlayerButton = vgui.Create( "DButton", card )
	card.PlayerButton:Dock( RIGHT )
	card.PlayerButton:DockMargin( 0, 5, 10, 5 )
	card.PlayerButton:SetWide( 30 )
	card.PlayerButton:SetText( "" )
	card.PlayerButton.DoClick = function()
		JukeBox.VGUI.Pages.AdminRequests:ShowRequesterInfo( parent, info.PlayerName, info.PlayerSID )
	end
	card.PlayerButton.Paint = function( self, w, h )
		if JukeBox.VGUI.VGUI:GetHovered( self ) then
			draw.RoundedBox( h/2+1, 0, 0, w, h, JukeBox.Colours.Definition )
		else
			draw.RoundedBox( h/2+1, 0, 0, w, h, JukeBox.Colours.Light )
		end
		JukeBox.VGUI.VGUI:DrawEmblem( h/2, h/2, 16, "jukebox/list.png", Color( 255, 255, 255 ), 0 )
	end
	
	parent.Scroll:AddItem( card )
end

function JukeBox.VGUI.Pages.AdminRequests:ShowRequesterInfo( parent, name, steamid )
	if not name then name = "" end
	if not steamid then steamid = "" end
	local text = "Information about the requester:\n\nSteam Name : "..name.."\nSteamID       : "..steamid.."\n\nIf this is blank, the request was made before an update."
	
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
		draw.SimpleText( "JukeBox - Requester Info", "JukeBox.Font.18", w/2, h/2, Color( 255, 255, 255 ), 1, 1 )
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

function JukeBox.VGUI.Pages.AdminRequests:GetEnteredData( parent )
	local data = {}
	data.name = parent.EditArea.NameEntry:GetValue()
	data.artist = parent.EditArea.ArtistEntry:GetValue()
	data.id = parent.EditArea.URLEntry:GetValue()
	data.length = parent.EditArea.TimeMinsEntry:GetValue()*60+parent.EditArea.TimeSecsEntry:GetValue()
	if parent.EditArea.StartTimeEnable.Enabled then
		data.starttime = parent.EditArea.StartTimeMinsEntry:GetValue()*60+parent.EditArea.StartTimeSecsEntry:GetValue()
	end
	if parent.EditArea.EndTimeEnable.Enabled then
		data.endtime = parent.EditArea.EndTimeMinsEntry:GetValue()*60+parent.EditArea.EndTimeSecsEntry:GetValue()
	end
	
	return data
end

function JukeBox.VGUI.Pages.AdminRequests:ClearFields( parent )
	parent.EditArea.NameEntry:SetValue( "" )
	parent.EditArea.ArtistEntry:SetValue( "" )
	parent.EditArea.URLEntry:SetValue( "" )
	parent.EditArea.TimeMinsEntry:SetValue( 0 )
	parent.EditArea.TimeSecsEntry:SetValue( 0 )
	parent.EditArea.StartTimeMinsEntry:SetValue( 0 )
	parent.EditArea.StartTimeSecsEntry:SetValue( 0 )
	parent.EditArea.EndTimeMinsEntry:SetValue( 0 )
	parent.EditArea.EndTimeSecsEntry:SetValue( 0 )
	if parent.EditArea.StartTimeEnable.Enabled then parent.EditArea.StartTimeEnable:DoClick() end
	if parent.EditArea.EndTimeEnable.Enabled then parent.EditArea.EndTimeEnable:DoClick() end
end

function JukeBox.VGUI.Pages.AdminRequests:CheckFields( parent )
	local errors = {}
	if parent.EditArea.NameEntry.Error1 then
		table.insert( errors, "Song Name" )
	end
	if parent.EditArea.ArtistEntry.Error1 then
		table.insert( errors, "Artist" )
	end
	if parent.EditArea.URLEntry.Error1 or parent.EditArea.URLEntry.Error2 then
		table.insert( errors, "YouTube URL" )
	end
	if parent.EditArea.TimeMinsEntry.Issue1 or parent.EditArea.TimeSecsEntry.Issue1 then
		table.insert( errors, "Length" )
	end
	if (!parent.EditArea.StartTimeMinsEntry:GetDisabled() or !parent.EditArea.StartTimeSecsEntry:GetDisabled())  and (parent.EditArea.StartTimeMinsEntry.Issue1 or parent.EditArea.StartTimeSecsEntry.Issue1 or parent.EditArea.StartTimeMinsEntry.Issue2 or parent.EditArea.StartTimeSecsEntry.Issue2) then
		table.insert( errors, "Start Time" )
	end
	if (!parent.EditArea.EndTimeMinsEntry:GetDisabled() or !parent.EditArea.EndTimeSecsEntry:GetDisabled())  and (parent.EditArea.EndTimeMinsEntry.Issue1 or parent.EditArea.EndTimeSecsEntry.Issue1 or parent.EditArea.EndTimeMinsEntry.Issue2 or parent.EditArea.EndTimeSecsEntry.Issue2) then
		table.insert( errors, "End Time" )
	end
	if table.Count( errors ) > 0 then
		local words = ""
		for k, v in pairs( errors ) do
			if k == 1 then
				words = words..v
			else
				words = words..", "..v
			end
		end
		JukeBox.VGUI.VGUI:MakeNotification( "There's an issue with the fields: "..words.."!", JukeBox.Colours.Issue, "jukebox/warning.png", "ADMINREQUEST", true )
	else
		JukeBox.VGUI.Pages.AdminRequests:AcceptPopup( parent )
	end
end

function JukeBox.VGUI.Pages.AdminRequests:AcceptPopup( parent )
	local text = "Are you sure you wish to accept this request?\nPlease make sure all data is correct before accepting."
	
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
		draw.SimpleText( "JukeBox - Accept Request", "JukeBox.Font.18", w/2, h/2, Color( 255, 255, 255 ), 1, 1 )
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
	popup.AcceptButton:SetWide( 125 )
	popup.AcceptButton:Dock( LEFT )
	popup.AcceptButton:SetVisible( true )
	popup.AcceptButton:DockMargin( 10, 0, 0, 0 )
	popup.AcceptButton:SetText( "" )
	popup.AcceptButton.Text = "Accept Request"
	popup.AcceptButton.DoClick = function()
		JukeBox.VGUI.Pages.AdminRequests:SendCurrentRequest( parent )
		bg:Remove()
	end
	popup.AcceptButton.Paint = function( self, w, h )
		if JukeBox.VGUI.VGUI:GetHovered( self ) then
			draw.RoundedBox( h/2-1, 0, 0, w, h, JukeBox.Colours.Accept )
		else
			draw.RoundedBox( h/2-1, 0, 0, w, h, JukeBox.Colours.Light )
		end
		JukeBox.VGUI.VGUI:DrawEmblem( h*0.75, h/2, 16, "jukebox/tick.png", Color( 255, 255, 255 ), 0 )
		draw.SimpleText( "Add Song", "JukeBox.Font.20", h+10, h/2-2, Color( 255, 255, 255 ), 0, 1 )
	end
	
	popup.CancelButton = vgui.Create( "DButton", popup.BottomBar )
	popup.CancelButton:SetWide( 100 )
	popup.CancelButton:Dock( RIGHT )
	popup.CancelButton:SetVisible( true )
	popup.CancelButton:DockMargin( 0, 0, 10, 0 )
	popup.CancelButton:SetText( "" )
	popup.CancelButton.Text = "Cancel"
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

function JukeBox.VGUI.Pages.AdminRequests:DenyPopup( parent )
	local text = "Are you sure you wish to delete this request?\nThe request will not be recoverable and will have to be re-submitted."
	
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
		draw.SimpleText( "JukeBox - Deleting Request", "JukeBox.Font.18", w/2, h/2, Color( 255, 255, 255 ), 1, 1 )
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
	popup.DeleteButton:SetWide( 135 )
	popup.DeleteButton:Dock( LEFT )
	popup.DeleteButton:SetVisible( true )
	popup.DeleteButton:DockMargin( 10, 0, 0, 0 )
	popup.DeleteButton:SetText( "" )
	popup.DeleteButton.DoClick = function()
		JukeBox.VGUI.Pages.AdminRequests:DeleteCurrentRequest( parent )
		bg:Remove()
	end
	popup.DeleteButton.Paint = function( self, w, h )
		if JukeBox.VGUI.VGUI:GetHovered( self ) then
			draw.RoundedBox( h/2-1, 0, 0, w, h, JukeBox.Colours.Issue )
		else
			draw.RoundedBox( h/2-1, 0, 0, w, h, JukeBox.Colours.Light )
		end
		JukeBox.VGUI.VGUI:DrawEmblem( h*0.75, h/2, 16, "jukebox/cross.png", Color( 255, 255, 255 ), 0 )
		draw.SimpleText( "Delete Song", "JukeBox.Font.20", h+10, h/2-2, Color( 255, 255, 255 ), 0, 1 )
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

function JukeBox.VGUI.Pages.AdminRequests:SendCurrentRequest( parent )
	local data = JukeBox.VGUI.Pages.AdminRequests:GetEnteredData( parent )
	JukeBox:AcceptRequest( data )
	JukeBox.VGUI.Pages.AdminRequests:ClearFields( parent )
	JukeBox.VGUI.VGUI:MakeNotification( "Request has been accepted!", JukeBox.Colours.Accept, "jukebox/tick.png", "ADMINREQUEST", true )
end

function JukeBox.VGUI.Pages.AdminRequests:DeleteCurrentRequest( parent )
	local data = JukeBox.VGUI.Pages.AdminRequests:GetEnteredData( parent )
	JukeBox:DenyRequest( data.id )
	JukeBox.VGUI.Pages.AdminRequests:ClearFields( parent )
	JukeBox.VGUI.VGUI:MakeNotification( "Request has been deleted!", JukeBox.Colours.Issue, "jukebox/tick.png", "ADMINREQUEST", true )
end

function JukeBox.VGUI.Pages.AdminRequests:CheckURL( parent, id )
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

function JukeBox.VGUI.Pages.AdminRequests:SetSongCard( parent, card )
	for k, v in pairs( parent.Scroll.pnlCanvas:GetChildren() ) do
		v:SetChosen( false )
	end
	card:SetChosen( true )
end

JukeBox.VGUI:RegisterPage( "ADMIN", "Requests", "Requests", "jukebox/admin.png", function( parent ) JukeBox.VGUI.Pages.AdminRequests:CreatePanel( parent ) end, true )