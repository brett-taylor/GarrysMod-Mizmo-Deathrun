--// Names of the text documents to save in \\--
local textAllSongs 	= "JukeBox_AllSongs.txt"
local textQueue 	= "JukeBox_CurrentQueue.txt"
local textRequests 	= "JukeBox_Requests.txt"
local textCooldowns = "JukeBox_CoolDowns.txt"
local textExtra		= "JukeBox_ExtraData.txt"

--// Initial text document creation \\--
function JukeBox:CheckSaves()
	if not file.Exists( textAllSongs, "DATA" ) then
		file.Write( textAllSongs, "" )
	end
	if not file.Exists( textQueue, "DATA" ) then
		file.Write( textQueue, "" )
	end
	if not file.Exists( textCooldowns, "DATA" ) then
		file.Write( textCooldowns, "" )
	end
	if not file.Exists( textRequests, "DATA" ) then
		file.Write( textRequests, "" )
	end
	if not file.Exists( textExtra, "DATA" ) then
		file.Write( textExtra, "" )
	end
end

--// Gets all the saved data \\--
function JukeBox:GetSaveData()
	self:CheckSaves()
	
	if file.Read( textAllSongs, "DATA" ) != "" then
		local TableFromJSON = util.JSONToTable( file.Read( textAllSongs, "DATA" ) )
		for k, v in pairs( TableFromJSON ) do
			JukeBox.SongList[v.id] = v
		end
	end
	
	if file.Read( textQueue, "DATA" ) != "" then
		local TableFromJSON = util.JSONToTable( file.Read( textQueue, "DATA" ) )
		JukeBox.QueueList = TableFromJSON
		JukeBox:FixQueue()
		JukeBox:CheckQueue()
	end
	
	if file.Read( textRequests, "DATA" ) != "" then
		local TableFromJSON = util.JSONToTable( file.Read( textRequests, "DATA" ) )
		for k, v in pairs( TableFromJSON ) do
			table.insert( JukeBox.RequestsList, v )
		end
	end
end
hook.Add( "Initialize", "JukeBox_ServerStartUp", function() JukeBox:GetSaveData() end )

--// Save all songs list \\--
function JukeBox:SaveAllSongs()
	local TableToJSON = util.TableToJSON( self.SongList )
	file.Write( textAllSongs, TableToJSON )
end

--// Save current queue \\--
function JukeBox:SaveQueue()
	local TableToJSON = util.TableToJSON( self.QueueList )
	file.Write( textQueue, TableToJSON )
end

--// Save requests \\--
function JukeBox:SaveRequests()
	local TableToJSON = util.TableToJSON( self.RequestsList )
	file.Write( textRequests, TableToJSON )
end

--// Save current song+time \\--
function JukeBox:SavePlaying()
	local info
	if self.CurPlaying then
		info = { id = self.CurPlaying, time = self.CurPlayingEnd-self.CurPlayingStart }
	else
		info = { id = false, time = false }
	end
	local TableToJSON = util.TableToJSON( info )
	file.Write( textExtra, TableToJSON )
end