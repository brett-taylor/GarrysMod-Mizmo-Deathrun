function AutoHop( ply, data )
	if CLIENT then
		LocalPlayer().AutoJumpEnabled = intToBool( GetConVar("deathrun_autojump"):GetInt() )
	end

	if lp and ply ~= lp() then return end
	if (tonumber(ply:GetNWString(PlayerSettings.Enums.AUTO_JUMP.Name)) == 0 && tonumber(ply:GetNWString(PlayerSettings.Enums.ENHANCED_AUTOJUMP.Name)) == 0) then return end


	if (tonumber(ply:GetNWString(PlayerSettings.Enums.ENHANCED_AUTOJUMP.Name)) == 0) then
		if CLIENT then
			if (AutoJumpClient.Enabled == false && AutoJumpClient.UniqueRoundNoJump == false && ply:Team() == TEAM_RUNNER) then
				return;
			end

			if (AutoJumpClient.UniqueRoundNoJump == true && ply:Team() == TEAM_RUNNER) then
				return;
			end
		end

		if SERVER then
			if (AutoJumpServer.Enabled == false && AutoJumpServer.UniqueRoundNoJump == false && ply:Team() == TEAM_RUNNER) then
				return;
			end

			if (AutoJumpServer.UniqueRoundNoJump == true && ply:Team() == TEAM_RUNNER) then
				return;
			end
		end
	elseif (tonumber(ply:GetNWString(PlayerSettings.Enums.ENHANCED_AUTOJUMP.Name)) == 1) then
		if CLIENT then
			if (AutoJumpClient.EnabledEnhanced == false && AutoJumpClient.UniqueRoundNoJump == false && ply:Team() == TEAM_RUNNER) then
				return;
			end

			if (AutoJumpClient.UniqueRoundNoJump == true && ply:Team() == TEAM_RUNNER) then
				return;
			end
		end

		if SERVER then
			if (AutoJumpServer.EnabledEnhanced == false && AutoJumpServer.UniqueRoundNoJump == false && ply:Team() == TEAM_RUNNER) then
				return;
			end

			if (AutoJumpServer.UniqueRoundNoJump == true && ply:Team() == TEAM_RUNNER) then
				return;
			end
		end
	end
	
	local ButtonData = data:GetButtons()
	if bit.band( ButtonData, IN_JUMP ) > 0 then
		if ply:WaterLevel() < 2 and ply:GetMoveType() ~= MOVETYPE_LADDER and not ply:IsOnGround() then
			data:SetButtons( bit.band( ButtonData, bit.bnot( IN_JUMP ) ) )
		end
	end
end
hook.Add( "SetupMove", "AutoHop", AutoHop )