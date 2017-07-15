JukeBox.SongList = {}
JukeBox.QueueList = {}
JukeBox.RequestsList = {}
JukeBox.CooldownsList = {}

JukeBox.CurPlaying = false
JukeBox.CurPlayingStart = false
JukeBox.CurPlayingEnd = false

JukeBox.VoteSkips = 0
JukeBox.PlayersTunedIn = {}

JukeBox.PlayerCooldowns = {}

util.AddNetworkString( "JukeBox_PlayNext" )
util.AddNetworkString( "JukeBox_PlayNextTime" )
util.AddNetworkString( "JukeBox_NoSong" )
util.AddNetworkString( "JukeBox_AllSongs" )
util.AddNetworkString( "JukeBox_Queue" )
util.AddNetworkString( "JukeBox_Requests" )
util.AddNetworkString( "JukeBox_QueueSong" )
util.AddNetworkString( "JukeBox_AddRequest" )
util.AddNetworkString( "JukeBox_AcceptRequest" )
util.AddNetworkString( "JukeBox_DenyRequest" )
util.AddNetworkString( "JukeBox_Popup" )
util.AddNetworkString( "JukeBox_Notification" )
util.AddNetworkString( "JukeBox_DeleteSong" )
util.AddNetworkString( "JukeBox_UpdateSong" )
util.AddNetworkString( "JukeBox_VoteSkip" )
util.AddNetworkString( "JukeBox_ForceSkip" )
util.AddNetworkString( "JukeBox_ChatMessage" )
util.AddNetworkString( "JukeBox_OpenMenu" )
util.AddNetworkString( "JukeBox_ReEnabled" )
util.AddNetworkString( "JukeBox_PlayersTunedIn" )
util.AddNetworkString( "JukeBox_DeleteQueuedSong" )
util.AddNetworkString( "JukeBox_VoteSkipChat" )

--// Materials download \\--
if JukeBox.Settings.UseWorkshop then
	resource.AddWorkshop( "496484635" )
else
	resource.AddFile( "materials/jukebox/admin.png" )
	resource.AddFile( "materials/jukebox/arrow.png" )
	resource.AddFile( "materials/jukebox/close.png" )
	resource.AddFile( "materials/jukebox/cross.png" )
	resource.AddFile( "materials/jukebox/edit.png" )
	resource.AddFile( "materials/jukebox/error.png" )
	resource.AddFile( "materials/jukebox/home.png" )
	resource.AddFile( "materials/jukebox/list.png" )
	resource.AddFile( "materials/jukebox/loading.png" )
	resource.AddFile( "materials/jukebox/music.png" )
	resource.AddFile( "materials/jukebox/options.png" )
	resource.AddFile( "materials/jukebox/play.png" )
	resource.AddFile( "materials/jukebox/search.png" )
	resource.AddFile( "materials/jukebox/settings.png" )
	resource.AddFile( "materials/jukebox/tick.png" )
	resource.AddFile( "materials/jukebox/volume.png" )
	resource.AddFile( "materials/jukebox/warning.png" )
end

--[[ POINT PAYMENT FUNCTIONS ]]--
function JukeBox:CanAfford( ply )
	if JukeBox.Settings.UsePointshop and PS then -- Hopefully check for PointShop
		if ply:PS_HasPoints( JukeBox.Settings.PointsCost ) then
			return true
		else
			return false
		end
	elseif JukeBox.Settings.UsePointshop2 and ply.PS2_Wallet then
		if ply.PS2_Wallet.points >= JukeBox.Settings.PointsCost then
			return true
		else
			return false
		end
	elseif JukeBox.Settings.UseDarkRPCash then
		local money = ply:getDarkRPVar( "money" )
		if money >= JukeBox.Settings.DarkRPCashCost then
			return true
		else
			return false
		end
	else
		return true
	end
end

function JukeBox:TakeAmount( ply )
	if JukeBox.Settings.UsePointshop and PS then
		ply:PS_TakePoints( JukeBox.Settings.PointsCost )
	elseif JukeBox.Settings.UsePointshop2 and ply.PS2_Wallet then
		ply:PS2_AddStandardPoints( -JukeBox.Settings.PointsCost )
	elseif JukeBox.Settings.UseDarkRPCash then
		ply:addMoney( -JukeBox.Settings.DarkRPCashCost )
	end
end

--[[ ADMIN FUNCTIONS ]]--
function JukeBox:IsManager( ply )
	local hasULXRank = false
	if JukeBox.Settings.UseULXRanks then
		for k, v in pairs( JukeBox.Settings.ULXRanksList ) do
			if ply:IsUserGroup( v ) then
				hasULXRank = true
			end
		end
	end
	return ply:IsSuperAdmin() or table.HasValue( JukeBox.Settings.SteamIDList, ply:SteamID() ) or hasULXRank
end

--[[ GENERAL OPERATING FUNCTIONS ]]--
--// Finds values in tables \\--
function JukeBox:CheckInTable( thetable, thevalue )
	for k, v in pairs( thetable ) do
		if v.id then
			if v.id == thevalue then
				return true, k
			end
		end
	end
end

--// Added for an update to prevent compatibility issues \\--
function JukeBox:FixQueue()
	for k, v in pairs( JukeBox.QueueList ) do
		if JukeBox.SongList[v] then -- Old Format, need to convert
			song = { 
				id = v, 
				PlayerName = "",
				PlayerSID = "",
			}
			JukeBox.QueueList[k] = song
		end
	end
end

function JukeBox:PlayerTuneIn( ply, tunein )
	if tunein then
		table.insert( self.PlayersTunedIn, ply:SteamID() )
	else
		table.RemoveByValue( self.PlayersTunedIn, ply:SteamID() )
	end
	net.Start( "JukeBox_PlayersTunedIn" )
		net.WriteString( tostring( #self.PlayersTunedIn ) )
	net.Broadcast()
end
net.Receive( "JukeBox_PlayersTunedIn", function( len, ply ) JukeBox:PlayerTuneIn( net.ReadEntity(), net.ReadBool() ) end )

--// Adds a song to the queue \\--
function JukeBox:QueueSong( id, ply )
	local song = { 
		id = id, 
		PlayerName = ply:Nick(),
		PlayerSID = ply:SteamID(),
	}
	table.insert( self.QueueList, song )
	self:ChatAddText( "Song Queued: "..self.SongList[id].artist.." - "..self.SongList[id].name, "JukeBox_ChatQueueSong" )
	self:UpdateQueue()
end

--// Player cooldowns checker \\--
function JukeBox:CheckPlayerCooldown( ply )
	local id = ply:SteamID()
	if JukeBox.Settings.UsePlayerCooldowns then
		if self.PlayerCooldowns[id] then
			if self.PlayerCooldowns[id].IsBlocked then
				if self.PlayerCooldowns[id].Expires < CurTime() then
					self.PlayerCooldowns[id].Expires = CurTime()+JukeBox.Settings.PlayerCooldownsTime
					self.PlayerCooldowns[id].QueuedSongs = 0
					self.PlayerCooldowns[id].IsBlocked = false
					return false
				else
					return true
				end
			else
				return false
			end
		else
			return false
		end
	else
		return false
	end
end

--// Set player cooldown info \\--
function JukeBox:AddPlayerCooldown( ply )
	if not JukeBox.Settings.UsePlayerCooldowns then return end
	local id = ply:SteamID()
	if not self.PlayerCooldowns[id] then
		self.PlayerCooldowns[id] = {
			IsBlocked = false,
			QueuedSongs = 0,
			Expires = CurTime()+JukeBox.Settings.PlayerCooldownsTime,
		}
	end
	self.PlayerCooldowns[id].QueuedSongs = self.PlayerCooldowns[id].QueuedSongs + 1
	if (self.PlayerCooldowns[id].QueuedSongs >= JukeBox.Settings.PlayerCooldownsLimit) then
		self.PlayerCooldowns[id].IsBlocked = true
	end
end

--// Deal with incoming queue requests \\--
function JukeBox:ReceiveQueueSong()
	local id = net.ReadString()
	local ply = net.ReadEntity()
	if not self.SongList[id] then return end
	if self.CurPlaying == id then
		self:SendNotification( ply, "The requested song is already playing!", JukeBox.Colours.Issue, "JukeBox/warning.png", "ALLSONGS", true )
		return
	elseif self:CheckInTable( self.QueueList, id ) then
		self:SendNotification( ply, "The requested song is already in the song Queue!", JukeBox.Colours.Issue, "JukeBox/warning.png", "ALLSONGS", true )
		return
	elseif self:CheckCooldown( id ) then
		self:SendNotification( ply, "The requested song was recently played!", JukeBox.Colours.Issue, "JukeBox/warning.png", "ALLSONGS", true )
		return
	elseif self:CheckPlayerCooldown( ply ) then
		self:SendNotification( ply, "You have queue'd too many songs! This resets in "..math.Round(self.PlayerCooldowns[ply:SteamID()].Expires-CurTime()).." seconds!", JukeBox.Colours.Issue, "JukeBox/warning.png", "ALLSONGS", true )
		return
	end
	if JukeBox.Settings.UsePointshop then
		if not self:CanAfford( ply ) then
			self:SendNotification( ply, "You can't afford to add a song to the Queue ("..JukeBox.Settings.PointsCost.." points needed)!", JukeBox.Colours.Warning, "JukeBox/warning.png", "ALLSONGS", true )
		else
			self:QueueSong( id, ply )
			self:TakeAmount( ply )
			self:AddPlayerCooldown( ply )
			self:SendNotification( ply, self.SongList[id].artist.." - "..self.SongList[id].name.." has been added to the Queue!", JukeBox.Colours.Accept, "JukeBox/tick.png", "ALLSONGS", true )
			self:CheckStatus()
		end
	elseif JukeBox.Settings.UsePointshop2 then
		if not self:CanAfford( ply ) then
			self:SendNotification( ply, "You can't afford to add a song to the Queue ("..JukeBox.Settings.PointsCost.." points needed)!", JukeBox.Colours.Warning, "JukeBox/warning.png", "ALLSONGS", true )
		else
			self:QueueSong( id, ply )
			self:TakeAmount( ply )
			self:AddPlayerCooldown( ply )
			self:SendNotification( ply, self.SongList[id].artist.." - "..self.SongList[id].name.." has been added to the Queue!", JukeBox.Colours.Accept, "JukeBox/tick.png", "ALLSONGS", true )
			self:CheckStatus()
		end
	elseif JukeBox.Settings.UseDarkRPCash then
		if not self:CanAfford( ply ) then
			self:SendNotification( ply, "You can't afford to add a song to the Queue ($"..JukeBox.Settings.DarkRPCashCost.." DarkRP cash needed)!", JukeBox.Colours.Warning, "JukeBox/warning.png", "ALLSONGS", true )
		else
			self:QueueSong( id, ply )
			self:TakeAmount( ply )
			self:AddPlayerCooldown( ply )
			self:SendNotification( ply, self.SongList[id].artist.." - "..self.SongList[id].name.." has been added to the Queue!", JukeBox.Colours.Accept, "JukeBox/tick.png", "ALLSONGS", true )
			self:CheckStatus()
		end
	else
		self:QueueSong( id, ply )
		self:TakeAmount( ply )
		self:AddPlayerCooldown( ply )
		self:SendNotification( ply, self.SongList[id].artist.." - "..self.SongList[id].name.." has been added to the Queue!", JukeBox.Colours.Accept, "JukeBox/tick.png", "ALLSONGS", true )
		self:CheckStatus()
	end
end
net.Receive( "JukeBox_QueueSong", function() JukeBox:ReceiveQueueSong() end )

--// Check if anything's playing \\--
function JukeBox:CheckStatus()
	if self.CurPlaying == false then
		self:CheckQueue()
	end
end

--// Checks the queue for the next song \\--
function JukeBox:CheckQueue()
	self:AddCooldown( self.CurPlaying )
	self.CurPlaying = false
	self.CurPlayingStart = false
	self.CurPlayingEnd = false
	self.VoteSkips = 0
	net.Start( "JukeBox_VoteSkip" )
	net.WriteString( tostring(self.VoteSkips) )
	net.Broadcast()
	if self.QueueList[1] then
		if not self.SongList[self.QueueList[1].id] then
			self:RemoveTopQueue()
			self:CheckQueue()
		else
			self:StartNextSong()
		end
	else
		self:NoSong()
	end
end

--// Sends the next song to clients \\--						
function JukeBox:StartNextSong()
	net.Start( "JukeBox_PlayNext" )
		net.WriteString( self.QueueList[1].id )
	net.Broadcast()
	self.CurPlaying = self.QueueList[1].id
	self:TimeNext()
	self:RemoveTopQueue()
	self:ChatAddText( "Now playing: "..self.SongList[self.CurPlaying].artist.." - "..self.SongList[self.CurPlaying].name, "JukeBox_ChatStartSong" )
end

--// Deals with song cool-downs \\--
function JukeBox:AddCooldown( id )
	if JukeBox.Settings.UseCooldowns then
		self.CooldownsList[id] = CurTime()+JukeBox.Settings.CooldownAmount
	end
end

--// Checks if the song has a cooldown \\--
function JukeBox:CheckCooldown( id )
	if JukeBox.Settings.UseCooldowns then
		if self.CooldownsList[id] then
			if self.CooldownsList[id] > CurTime() then
				return true
			else
				return false
			end
		else
			return false
		end
	else
		return false
	end
end

--// Counts down to the end of the song \\--
function JukeBox:TimeNext()
	self.CurPlayingStart = CurTime()
	if self.SongList[self.CurPlaying].starttime and !self.SongList[self.CurPlaying].endtime then --| Only startTime
		self.CurPlayingEnd = CurTime()+self.SongList[self.CurPlaying].length-self.SongList[self.CurPlaying].starttime
	elseif !self.SongList[self.CurPlaying].starttime and self.SongList[self.CurPlaying].endtime then --| Only endTime
		self.CurPlayingEnd = CurTime()+self.SongList[self.CurPlaying].length-(self.SongList[self.CurPlaying].length-self.SongList[self.CurPlaying].endtime)
	elseif self.SongList[self.CurPlaying].starttime and self.SongList[self.CurPlaying].endtime then --| Both startTime and endTime
		self.CurPlayingEnd = CurTime()+self.SongList[self.CurPlaying].length-self.SongList[self.CurPlaying].starttime-(self.SongList[self.CurPlaying].length-self.SongList[self.CurPlaying].endtime)
	else --| There isn't one
		self.CurPlayingEnd = CurTime()+self.SongList[self.CurPlaying].length
	end
	timer.Create( "JukeBox_PlayingTimer", (self.CurPlayingEnd-self.CurPlayingStart)+self.Settings.LagCompensationTime, 0, function()
		self:CheckQueue()
	end)
end

function JukeBox:PlayNextWithTimes( playID )
	if not self.SongList[playID] then return end
	if self.SongList[playID].starttime and !self.SongList[playID].endtime then --| Only startTime
		self:PlayVideoFromTime( playID, self.SongList[playID].starttime )
		self.CurPlaying = playID
		self.CurPlayingStart = CurTime()
		self.CurPlayingEnd = CurTime()+self.SongList[playID].length-self.SongList[playID].starttime
	elseif !self.SongList[playID].starttime and self.SongList[playID].endtime then --| Only endTime
		self:PlayVideoUntilTime( playID, self.SongList[playID].endtime )
		self.CurPlaying = playID
		self.CurPlayingStart = CurTime()
		self.CurPlayingEnd = CurTime()+self.SongList[playID].length-self.SongList[playID].endtime
	elseif self.SongList[playID].starttime and self.SongList[playID].endtime then --| Both startTime and endTime
		self:PlayVideoWithTimes( playID, self.SongList[playID].starttime, self.SongList[playID].endtime )
		self.CurPlaying = playID
		self.CurPlayingStart = CurTime()
		self.CurPlayingEnd = CurTime()+self.SongList[playID].length-self.SongList[playID].starttime-self.SongList[playID].endtime
	else --| Something went wrong
		chat.AddText( "Fuck" )
		
	end
end

--// Used for saving song time for server changelevel \\--
function JukeBox:GetTimeStamp()
	if not self.CurPlaying then return 0 end
	return math.floor( CurTime()-self.CurPlayingStart )
end

--// Removes top value of the queue \\--
function JukeBox:RemoveTopQueue()
	table.remove( self.QueueList, 1 )
	self:UpdateQueue()
end

--// Tells clients there's no song to play \\--
function JukeBox:NoSong()
	net.Start( "JukeBox_NoSong" )
	net.Broadcast()
end

--// Update the all songs list \\--
function JukeBox:UpdateAllSongs()
	self:SaveAllSongs()
	net.Start( "JukeBox_AllSongs" )
		net.WriteTable( JukeBox.SongList )
	net.Broadcast()
end

--// Update the queue for all \\--
function JukeBox:UpdateQueue()
	self:SaveQueue()
	net.Start( "JukeBox_Queue" )
		net.WriteTable( self.QueueList )
	net.Broadcast()
end

--// Update the requests for all \\--
function JukeBox:UpdateRequests()
	self:SaveRequests()
	net.Start( "JukeBox_Requests" )
		net.WriteTable( self.RequestsList )
	net.Broadcast()
end

--// Sends all data to newly-connected players \\--
function JukeBox:SendAll( ply )
	if not ply then ply = net.ReadEntity() end
	net.Start( "JukeBox_AllSongs" )
		net.WriteTable( JukeBox.SongList )
	net.Send( ply )
	net.Start( "JukeBox_Queue" )
		net.WriteTable( JukeBox.QueueList )
	net.Send( ply )
	net.Start( "JukeBox_Requests" )
		net.WriteTable( JukeBox.RequestsList )
	net.Send( ply )
	net.Start( "JukeBox_PlayersTunedIn" )
		net.WriteString( tostring( #self.PlayersTunedIn ) )
	net.Send( ply )
	if self.CurPlaying != false then
		local timestamp = self:GetTimeStamp()
		net.Start( "JukeBox_PlayNextTime" )
			net.WriteString( self.CurPlaying )
			net.WriteString( timestamp )
		net.Send( ply )
	else
		net.Start( "JukeBox_NoSong" )
		net.Send( ply )
	end
end

--// If the user re-enables the JukeBox \\--
function JukeBox:PlayReEnabled()
	local ply = net.ReadEntity()
	if self.CurPlaying != false then
		local timestamp = self:GetTimeStamp()
		net.Start( "JukeBox_PlayNextTime" )
			net.WriteString( self.CurPlaying )
			net.WriteString( timestamp )
		net.Send( ply )
	else
		net.Start( "JukeBox_NoSong" )
		net.Send( ply )
	end
end
net.Receive( "JukeBox_ReEnabled", function() JukeBox:PlayReEnabled() end )

--// Handles the vote skips \\--
function JukeBox:VoteSkip()
	self.VoteSkips = JukeBox.VoteSkips+1
	self:ChatAddText( "Votes to skip current song: "..self.VoteSkips.."/"..math.ceil(#self.PlayersTunedIn*JukeBox.Settings.VoteSkipPercent), "JukeBox_ChatVoteSkip" )
	if self.VoteSkips >= math.ceil(#self.PlayersTunedIn*JukeBox.Settings.VoteSkipPercent) then
		self.VoteSkips = 0
		self:ChatAddText( "The current song has been skipped.", "JukeBox_ChatSkipSong" )
		self:CheckQueue()
	else
		net.Start( "JukeBox_VoteSkip" )
		net.WriteString( tostring(self.VoteSkips) )
		net.Broadcast()
	end
end
net.Receive( "JukeBox_VoteSkip", function() JukeBox:VoteSkip() end )

--// Handles the force skips \\--
function JukeBox:ForceSkip()
	local ply = net.ReadEntity()
	if not self:IsManager( ply ) then return end
	self:ChatAddText( "The current song has been Force skipped by a Manager.", "JukeBox_ChatSkipSong" )
	self.VoteSkips = 0
	self:CheckQueue()
end
net.Receive( "JukeBox_ForceSkip", function() JukeBox:ForceSkip() end )

--[[ VGUI TO PLAYER FUNCTIONS ]]--
--// Create a popup on the player \\--
function JukeBox:SendPopup( ply, header, body )
	net.Start( "JukeBox_Popup" )
		net.WriteString( header )
		net.WriteString( body )
	net.Send( ply )
end

--// Creates a notification on the player \\--
function JukeBox:SendNotification( ply, text, colour, mat, id, killID )
	net.Start( "JukeBox_Notification" )
		net.WriteTable( {
			text = text,
			colour = colour,
			mat = mat,
			id = id,
			killID = killID,
			} )
	net.Send( ply )
end

--[[ REQUEST FUNCTIONS ]]--
--// Adds a song to all songs list \\--
function JukeBox:AddSongToAll( data )
	self.SongList[data.id] = data
	self:SaveAllSongs()
	self:UpdateAllSongs()
end

--// Adds a request to the list zz--
function JukeBox:AddRequest()
	local request = net.ReadTable()
	local ply = net.ReadEntity()
	if self:CheckInTable( self.RequestsList, request.id ) then
		self:SendPopup( ply, "Error", "There was an issue when sending your request:\nThe requested YouTube URL is already in the Requests list!\n\nThe request was not sent." )
		return
	end
	if self:CheckInTable( self.SongList, request.id ) then
		self:SendPopup( ply, "Error", "There was an issue when sending your request:\nThe requested YouTube URL is already in the All Songs list!\n\nThe request was not sent." )
		return
	end
	if JukeBox.Settings.AutoAcceptRequests then
		self:AddSongToAll( request )
		self:SendNotification( ply, "The song was added to the All Songs list!", JukeBox.Colours.Accept, "JukeBox/tick.png", "REQUEST", true )
	else
		request.PlayerName = ply:Nick()
		request.PlayerSID = ply:SteamID()
		table.insert( self.RequestsList, request )
		self:ChatAddText( "A new request has been submitted.", "JukeBox_ChatAdminRequest" )
		self:UpdateRequests()
		self:SaveRequests()
	end
end
net.Receive( "JukeBox_AddRequest", function() JukeBox:AddRequest() end )

--// Updates song info \\--
function JukeBox:UpdateSong()
	local song = net.ReadTable()
	local ply = net.ReadEntity()
	if not self:IsManager( ply ) then return end
	JukeBox.SongList[song.id] = song
	self:UpdateAllSongs()
	self:SaveAllSongs()
end
net.Receive( "JukeBox_UpdateSong", function() JukeBox:UpdateSong() end )

--// Deletes a song \\--
function JukeBox:DeleteSong()
	local song = net.ReadString()
	local ply = net.ReadEntity()
	if not self:IsManager( ply ) then return end
	
	if self:CheckInTable( self.QueueList, song ) then
		table.RemoveByValue( self.QueueList, song )
		self:UpdateAllSongs()
		self:UpdateQueue()
	end
	if self.CurPlaying == song then
		self:ChatAddText( "The current song has been automatically skipped as it was deleted by a Manager.", "JukeBox_ChatSkipSong" )
		self:CheckQueue()
	end
	JukeBox.SongList[song] = nil
	self:UpdateAllSongs()
	self:SaveAllSongs()
end
net.Receive( "JukeBox_DeleteSong", function() JukeBox:DeleteSong() end )

--// Deletes a queued song \\--
function JukeBox:DeleteQueuedSong()
	local song = net.ReadString()
	local ply = net.ReadEntity()
	if not self:IsManager( ply ) then return end
	local _, pos = self:CheckInTable( self.QueueList, song )
	table.remove( self.QueueList, pos )
	self:SendNotification( ply, "The song was removed from the Queue!", JukeBox.Colours.Accept, "JukeBox/tick.png", "QUEUEREMOVE", true )
	self:UpdateQueue()
	self:SaveQueue()
end
net.Receive( "JukeBox_DeleteQueuedSong", function() JukeBox:DeleteQueuedSong() end )

--// Adds a request to the all songs list \\--
function JukeBox:AcceptRequest()
	local request = net.ReadTable()
	local ply = net.ReadEntity()
	if not self:IsManager( ply ) then return end
	if self:CheckInTable( self.SongList, request.id ) then
		self:SendPopup( ply, "Error", "There was an issue when accepting your request:\nThe requested YouTube URL is already in the All Songs list!\n\nThe request was not added (recommended to remove)." )
		return
	end
	self:SendNotification( ply, "The song was added to the All Songs list!", JukeBox.Colours.Accept, "JukeBox/tick.png", "ADMINREQUEST", true )
	self:AddSongToAll( request )
	self:RemoveRequest( request.id )
end
net.Receive( "JukeBox_AcceptRequest", function() JukeBox:AcceptRequest() end )

--// Removes request from list \\--
function JukeBox:RemoveRequest( id )
	for k, v in pairs( JukeBox.RequestsList ) do
		if v.id then
			if v.id == id then
				table.remove( JukeBox.RequestsList, k )
				self:SaveRequests()
				self:UpdateRequests()
			end
		end
	end
end
net.Receive( "JukeBox_DenyRequest", function()
	local id = net.ReadString()
	local ply = net.ReadEntity()
	if not JukeBox:IsManager( ply ) then return end
	JukeBox:RemoveRequest( id )
end )

--// Chat add text client function \\--
function JukeBox:ChatAddText( text, code )
	net.Start( "JukeBox_ChatMessage" )
		net.WriteString( text )
		net.WriteString( code )
	net.Broadcast()
end

--[[ PRINT FUNCTION FOR DEBUG ]]--
function JukeBox:Print( text, override )
	if override then
		MsgC( Color(211, 84, 0), "\nJukeBox ", Color( 160, 230, 230 ), "[SERVER]", Color(243, 156, 18), " - "..text )
	elseif self.DevMode then
		MsgC( Color(211, 84, 0), "\nJukeBox ", Color( 160, 230, 230 ), "[SERVER]", Color(41, 128, 185), "[DEV]", Color(243, 156, 18), " - "..text )
	end	
end

--// Chat command \\--
hook.Add( "PlayerSay", "JukeBox.VGUI.ChatHook", function( ply, message )
	if table.HasValue( JukeBox.Settings.ChatCommands, message ) then
		net.Start( "JukeBox_OpenMenu" )
		net.Send( ply )
		return false
	elseif table.HasValue( JukeBox.Settings.SkipCommands, message ) then
		net.Start( "JukeBox_VoteSkipChat" )
		net.Send( ply )
		return false
	end
end )

hook.Add( "PlayerInitialSpawn", "JukeBox_ReceiveWant", function( ply )
	timer.Simple( 1, function()
		JukeBox:SendAll( ply )
	end)
end )

hook.Add( "PlayerDisconnected", "JukeBox_TunedInUpdate", function( ply )
	if table.HasValue( JukeBox.PlayersTunedIn, ply:SteamID() ) then
		table.RemoveByValue( JukeBox.PlayersTunedIn, ply:SteamID() )
		net.Start( "JukeBox_PlayersTunedIn" )
			net.WriteString( tostring( #JukeBox.PlayersTunedIn ) )
		net.Broadcast()
	end
end)