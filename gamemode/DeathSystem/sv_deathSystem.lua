util.AddNetworkString( "PlayerDied" )

function SendDeathData(ply, inf, att)
	if IsValid(ply) then
		net.Start("PlayerDied")
		net.WriteEntity(ply)
		net.Broadcast()
	end

end

hook.Add("PlayerDeath", "OnPlayerDeath", SendDeathData)