--// Variables (I actually forgot these...) \\--
JukeBox.SongList = {}
JukeBox.QueueList = {}
JukeBox.RequestsList = {}

JukeBox.CurPlaying = false
JukeBox.CurPlayingStart = false
JukeBox.CurPlayingEnd = false

JukeBox.PlayersTunedIn = 0
JukeBox.VoteSkips = 0
JukeBox.HasVoteSkipped = false

JukeBox.PlayerQueuedSongs = 0
JukeBox.PlayerCooldownEnd = false

--// Con-Vars \\--
--CreateClientConVar( "JukeBox_Enabled", 1, true, false )
--CreateClientConVar( "JukeBox_Volume", JukeBox.Settings.DefaultVolume, true, false )

--// Cookies (hopefully better than Client ConVars) \\--
local DefaultCookies = {
	["JukeBox_Enabled"] = JukeBox.Settings.DefaultEnabled,
	["JukeBox_Volume"] = JukeBox.Settings.DefaultVolume,
	["JukeBox_ChatStartSong"] = "true",
	["JukeBox_ChatQueueSong"] = "false",
	["JukeBox_ChatSkipSong"] = "true",
	["JukeBox_ChatVoteSkip"] = "true",
	["JukeBox_ChatAdminRequest"] = "false",
}
for k, v in pairs( DefaultCookies ) do
	if isstring( k ) then
		if cookie.GetString( k, "failure" ) == "failure" then
			cookie.Set( k, v )
		end
	else
		if cookie.GetNumber( k, 9001 ) == 9001 then
			cookie.Set( k, v )
		end
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

--[[ GENERAL FUNCTIONS ]]--
--// Chat print function \\--
function JukeBox:ChatAddText( text, code )
	if not code then return end
	if code == "JukeBox_ChatAdminRequest" then if !self:IsManager( LocalPlayer() ) then return end end
	if tobool( cookie.GetString( "JukeBox_Enabled", "false" ) ) then
		if tobool( cookie.GetString( code, "true" ) ) then
			chat.AddText( JukeBox.Colours.ChatBase, "[", JukeBox.Colours.ChatHighlight, "JukeBox", JukeBox.Colours.ChatBase, "] ", text )
		end
	else
		if code == "JukeBox_ChatStartSong" then
			chat.AddText( JukeBox.Colours.ChatBase, "[", JukeBox.Colours.ChatHighlight, "JukeBox", JukeBox.Colours.ChatBase, "] ", text )
			chat.AddText( JukeBox.Colours.ChatBase, "[", JukeBox.Colours.ChatHighlight, "JukeBox", JukeBox.Colours.ChatBase, "] ", "To listen to the JukeBox, type '"..JukeBox.Settings.ChatCommands[1].."' and press Play." )
		end
	end
end
net.Receive( "JukeBox_ChatMessage", function() JukeBox:ChatAddText( net.ReadString(), net.ReadString() ) end )

--// Vote to skip the current song \\--
function JukeBox:VoteSkip()
	if not tobool( cookie.GetString( "JukeBox_Enabled", "false" ) ) then
		JukeBox.VGUI.VGUI:MakeNotification( "You must be listening to vote to skip!", JukeBox.Colours.Issue, "JukeBox/error.png", "SKIP", true )
		return
	end
	if self.HasVoteSkipped then
		JukeBox.VGUI.VGUI:MakeNotification( "You have already voted to skip this song!", JukeBox.Colours.Issue, "JukeBox/error.png", "SKIP", true )
	elseif !JukeBox.CurPlaying then
		JukeBox.VGUI.VGUI:MakeNotification( "There is currently no song playing to skip!", JukeBox.Colours.Issue, "JukeBox/error.png", "SKIP", true )
	else
		net.Start( "JukeBox_VoteSkip" )
		net.WriteEntity( LocalPlayer() )
		net.SendToServer()
		self.HasVoteSkipped = true
		JukeBox.VGUI.VGUI:MakeNotification( "You have voted to skip the current song!", JukeBox.Colours.Accept, "JukeBox/tick.png", "SKIP", true )
	end
end

--// Vote to skip from chat \\--
function JukeBox:VoteSkipChat()
	if not tobool( cookie.GetString( "JukeBox_Enabled", "false" ) ) then
		chat.AddText( JukeBox.Colours.ChatBase, "[", JukeBox.Colours.ChatHighlight, "JukeBox", JukeBox.Colours.ChatBase, "] ", "You must be listening to vote to skip!")
		return
	end
	if self.HasVoteSkipped then
		chat.AddText( JukeBox.Colours.ChatBase, "[", JukeBox.Colours.ChatHighlight, "JukeBox", JukeBox.Colours.ChatBase, "] ", "You have already voted to skip this song!")
	elseif !JukeBox.CurPlaying then
		chat.AddText( JukeBox.Colours.ChatBase, "[", JukeBox.Colours.ChatHighlight, "JukeBox", JukeBox.Colours.ChatBase, "] ", "There is currently no song playing to skip!")
	else
		net.Start( "JukeBox_VoteSkip" )
		net.WriteEntity( LocalPlayer() )
		net.SendToServer()
		self.HasVoteSkipped = true
		chat.AddText( JukeBox.Colours.ChatBase, "[", JukeBox.Colours.ChatHighlight, "JukeBox", JukeBox.Colours.ChatBase, "] ", "You have voted to skip the current song!")
	end
end
net.Receive( "JukeBox_VoteSkipChat", function() JukeBox:VoteSkipChat() end )

--// Force skip for admins \\--
function JukeBox:ForceSkip()
	if JukeBox:IsManager( LocalPlayer() ) then
		if !JukeBox.CurPlaying then
			JukeBox.VGUI.VGUI:MakeNotification( "There is currently no song playing to skip!", JukeBox.Colours.Issue, "JukeBox/error.png", "SKIP", true )
		else
			net.Start( "JukeBox_ForceSkip" )
			net.WriteEntity( LocalPlayer() )
			net.SendToServer()
		end
	end
end

function JukeBox:UpdateTunedIn()
	local count = tonumber( net.ReadString() )
	self.PlayersTunedIn = count
end
net.Receive( "JukeBox_PlayersTunedIn", function() JukeBox:UpdateTunedIn() end )

function JukeBox:IsTunedIn( bool )
	net.Start( "JukeBox_PlayersTunedIn" )
		net.WriteEntity( LocalPlayer() )
		net.WriteBool( bool )
	net.SendToServer()
end

--// Update vote skips info \\--
function JukeBox:VoteSkipUpdate()
	local amount = tonumber( net.ReadString() )
	self.VoteSkips = amount
end
net.Receive( "JukeBox_VoteSkip", function() JukeBox:VoteSkipUpdate() end )

--// Reset vote skips \\--
function JukeBox:ResetVoteSkips()
	self.VoteSkips = 0
	self.HasVoteSkipped = false
end

--[[ SONG START FUNCTIONS ]]--
--// Play next song \\--
function JukeBox:PlayNext()
	local playID = net.ReadString()
	if not self.SongList[playID] then return end
	if self.SongList[playID].starttime or self.SongList[playID].endtime then
		self:PlayNextWithTimes( playID )
		self:ResetVoteSkips()
	else
		self:PlayVideo( playID )
		self:ResetVoteSkips()
		self.CurPlaying = playID
		self.CurPlayingStart = CurTime()
		self.CurPlayingEnd = CurTime()+self.SongList[playID].length
	end
end
net.Receive( "JukeBox_PlayNext", function() JukeBox:PlayNext() end )

--// Ask for current song time \\--
function JukeBox:PlayReEnabled()
	net.Start( "JukeBox_ReEnabled" )
		net.WriteEntity( LocalPlayer() )
	net.SendToServer()
end

--// Play next song function extended \\--
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
		self.CurPlayingEnd = CurTime()+self.SongList[playID].length-(self.SongList[self.CurPlaying].length-self.SongList[self.CurPlaying].endtime)
	elseif self.SongList[playID].starttime and self.SongList[playID].endtime then --| Both startTime and endTime
		self:PlayVideoWithTimes( playID, self.SongList[playID].starttime, self.SongList[playID].endtime )
		self.CurPlaying = playID
		self.CurPlayingStart = CurTime()
		self.CurPlayingEnd = CurTime()+self.SongList[playID].length-self.SongList[playID].starttime-(self.SongList[self.CurPlaying].length-self.SongList[self.CurPlaying].endtime)
	else --| Something went wrong
		print( "JukeBox Issue" )
	end
end

--// Play next from time \\--
function JukeBox:PlayNextTime()
	local playID = net.ReadString()
	local playTime = tostring( net.ReadString() )
	local resetVoteSkip = net.ReadBool()
	if not self.SongList[playID] then return end
	if self.SongList[playID].starttime then
		playTime = playTime + self.SongList[playID].starttime
	end
	self:PlayVideoFromTime( playID, playTime )
	self.CurPlaying = playID
	self.CurPlayingStart = CurTime()-playTime
	self.CurPlayingEnd = CurTime()-playTime+self.SongList[playID].length
end
net.Receive( "JukeBox_PlayNextTime", function() JukeBox:PlayNextTime() end )

--// Set everything to nothing \\--
function JukeBox:NoSong()
	self:StopVideo()
	self:ResetVoteSkips()
	self.CurPlaying = false
	self.CurPlayingStart = false
	self.CurPlayingEnd = false
end
net.Receive( "JukeBox_NoSong", function() JukeBox:NoSong() end )

--// Receive all songs \\--
function JukeBox:ReceiveAllSongs()
	local allSongs = net.ReadTable()
	self.SongList = allSongs
	hook.Call( "JukeBox_AllSongsUpdated" )
end
net.Receive( "JukeBox_AllSongs", function() JukeBox:ReceiveAllSongs() end )

--// Receive song queue \\--
function JukeBox:ReceiveQueue()
	local queue = net.ReadTable()
	self.QueueList = queue
	hook.Call( "JukeBox_QueueUpdated" )
end
net.Receive( "JukeBox_Queue", function() JukeBox:ReceiveQueue() end )

--// Receive requests \\--
function JukeBox:ReceiveRequests()
	local requests = net.ReadTable()
	self.RequestsList = requests
	hook.Call( "JukeBox_RequestsUpdated" )
end
net.Receive( "JukeBox_Requests", function() JukeBox:ReceiveRequests() end )

--// Add song to queue \\--
function JukeBox:QueueSong( id )
	net.Start( "JukeBox_QueueSong" )
		net.WriteString( id )
		net.WriteEntity( LocalPlayer() )
	net.SendToServer()
end

--// Function to remove song from Queue \\--
function JukeBox:DeleteQueuedSong( id )
	net.Start( "JukeBox_DeleteQueuedSong" )
		net.WriteString( id )
		net.WriteEntity( LocalPlayer() )
	net.SendToServer()
end

--// Updates song info \\--
function JukeBox:UpdateSong( data )
	net.Start( "JukeBox_UpdateSong" )
		net.WriteTable( data )
		net.WriteEntity( LocalPlayer() )
	net.SendToServer()
end

--// Deletes a song \\--
function JukeBox:DeleteSong( id )
	net.Start( "JukeBox_DeleteSong" )
		net.WriteString( id )
		net.WriteEntity( LocalPlayer() )
	net.SendToServer()
end

--[[ REQUEST FUNCTIONS ]]--
--// Send request \\--
function JukeBox:AddRequest( data )
	net.Start( "JukeBox_AddRequest" )
		net.WriteTable( data )
		net.WriteEntity( LocalPlayer() )
	net.SendToServer()
end

--// Accept request \\--
function JukeBox:AcceptRequest( data )
	net.Start( "JukeBox_AcceptRequest" )
		net.WriteTable( data )
		net.WriteEntity( LocalPlayer() )
	net.SendToServer()
end

--// Deny request \\--
function JukeBox:DenyRequest( id )
	net.Start( "JukeBox_DenyRequest" )
		net.WriteString( id )
		net.WriteEntity( LocalPlayer() )
	net.SendToServer()
end

--[[ VGUI FUNCTIONS ]]--
--// CREATING A POPUP \\--
function JukeBox:CreatePopup()
	self.VGUI:CreatePopup( net.ReadString(), net.ReadString() )
	JukeBox.VGUI.VGUI:MakeNotification( "Request was not sent, the YouTube URL is already in use!", JukeBox.Colours.Issue, "JukeBox/warning.png", "REQUEST", true )
end
net.Receive( "JukeBox_Popup", function() JukeBox:CreatePopup() end )

--// Create a notification \\--
function JukeBox:CreateNotification()
	local info = net.ReadTable()
	if not ValidPanel( JukeBox.VGUI.VGUI ) then return end
	JukeBox.VGUI.VGUI:MakeNotification( info.text, info.colour, info.mat, info.id, info.killID )
end
net.Receive( "JukeBox_Notification", function() JukeBox:CreateNotification() end )

--// Start-up Hook \\--
hook.Add( "InitPostEntity", "JukeBox_ClientTuneInSend", function() 
	JukeBox:IsTunedIn( tobool( cookie.GetString( "JukeBox_Enabled", "false" ) ) )
	JukeBox:SetVolume( cookie.GetNumber( "JukeBox_Volume", 25 ) ) -- This is a backup in case the page didn't load quick enough
end)

--// Is Alive Hook \\--
if not JukeBox.Settings.PlayWhileAlive then
	hook.Add( "Think", "JukeBox_ClientAlive", function()
		JukeBox.PlayerAlive = JukeBox.PlayerAlive or false
		local ply = LocalPlayer()
		if not ply:Alive() and not JukeBox.PlayerAlive then
			JukeBox:PlayReEnabled()
			JukeBox.PlayerAlive = true
		elseif ply:Alive() and JukeBox.PlayerAlive then
			JukeBox:StopVideo()
			JukeBox.PlayerAlive = false
		end
	end )
end

--[[ PRINT FUNCTION FOR DEBUG ]]--
function JukeBox:Print( text, override )
	if override then
		MsgC( Color(211, 84, 0), "\nJukeBox ", Color( 160, 230, 230 ), "[SERVER]", Color(243, 156, 18), " - "..text )
	elseif self.DevMode then
		MsgC( Color(211, 84, 0), "\nJukeBox ", Color( 160, 230, 230 ), "[SERVER]", Color(41, 128, 185), "[DEV]", Color(243, 156, 18), " - "..text )
	end	
end