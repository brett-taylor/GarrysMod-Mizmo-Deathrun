util.AddNetworkString("MizmoUpdateClaimedButtonsTable")

ButtonClaimingServer = {};
ButtonClaimingServer.Buttons = {};
ButtonClaimingServer.ClaimingRadius = 75;

ButtonClaimingServer.ButtonData = {};
ButtonClaimingServer.ButtonData.Claimed = false;
ButtonClaimingServer.ButtonData.ClaimedPlayer = "null";
ButtonClaimingServer.ButtonData.Position = nil;

function ButtonClaimingServer.UpdateButtonClaims()
	net.Start("MizmoUpdateClaimedButtonsTable");
		net.WriteTable(ButtonClaimingServer.Buttons);
	net.Broadcast();
end

function ButtonClaimingServer.CheckButtonClaims()
	local buttonEntites = ents.FindByClass("func_button");
	local players = {};
	local buttonsChanged = false;

	for k, v in ipairs(player.GetAllPlaying()) do
		if (v:Alive() and v:Team() == TEAM_DEATH) then
			table.insert(players, v);
		end
	end

	for k, v in ipairs(buttonEntites) do
		if (ButtonClaimingServer.Buttons[v:MapCreationID()] == nil) then
			local buttonData = table.Copy(ButtonClaimingServer.ButtonData);
			buttonData.Position = v:GetPos() + v:OBBCenter();

			ButtonClaimingServer.Buttons[v:MapCreationID()] = buttonData;
		else
			local position = ButtonClaimingServer.Buttons[v:MapCreationID()].Position;
			local closestDistance = 10000000;
			local closestPlayer = nil;
			local currentClaimedPlayer = nil;
			local currentClaimPlayerDistance = 99999;

			for _, ply in ipairs(players) do
				local distance = ply:EyePos():Distance(position);
				if (distance < closestDistance) then
					closestDistance = distance;
					closestPlayer = ply;
				end
			end

			for _, ply in ipairs(team.GetPlayers(TEAM_DEATH)) do
				if (ply:SteamID() == ButtonClaimingServer.Buttons[ v:MapCreationID() ].ClaimedPlayer) then
					currentClaimedPlayer = ply;
				end
			end

			if (currentClaimedPlayer) then
				currentClaimPlayerDistance = currentClaimedPlayer:EyePos():Distance(position);
			end

			if (closestDistance < ButtonClaimingServer.ClaimingRadius and ButtonClaimingServer.Buttons[v:MapCreationID()].Claimed == false) then
				ButtonClaimingServer.Buttons[v:MapCreationID()].Claimed = true;
				ButtonClaimingServer.Buttons[v:MapCreationID()].ClaimedPlayer = closestPlayer:SteamID();
				buttonsChanged = true;
			elseif ((currentClaimPlayerDistance > ButtonClaimingServer.ClaimingRadius) and ButtonClaimingServer.Buttons[v:MapCreationID()].Claimed == true) then
				ButtonClaimingServer.Buttons[v:MapCreationID()].Claimed = false;
				ButtonClaimingServer.Buttons[v:MapCreationID()].ClaimedPlayer = "null";
				buttonsChanged = true;
			end
		end
	end

	if (buttonsChanged) then
		ButtonClaimingServer.UpdateButtonClaims();
	end
end
timer.Create("CheckButtonClaims", 0.35, 0, ButtonClaimingServer.CheckButtonClaims);

function ButtonClaimingServer.PlayerCanUseButton(ply, ent)
	if not (ply:Alive() or ply:Team() == TEAM_SPECTATOR or ply:GetObserverMode() ~= OBS_MODE_NONE) then
		return false;
	end

	local mid = ent:MapCreationID();
	local sid = ply:SteamID();

	if (ply:Team() == TEAM_RUNNER) then 
		if (ent:GetSaveTable().m_toggle_state == 1 and not ent:GetSaveTable().m_bLocked and ply:KeyPressed(IN_USE)) then
			hook.Call("DeathrunButtonActivated", nil, ply, ent);
		end

		ent.User = ply;
		return;
	end 

	if not (ButtonClaimingServer.Buttons[mid]) then 
		if (ent:GetSaveTable().m_toggle_state == 1 and not ent:GetSaveTable().m_bLocked and ply:KeyPressed(IN_USE)) then
			hook.Call("DeathrunButtonActivated", nil, ply, ent);
		end

		ent.User = ply;
		return;
	end

	if (ButtonClaimingServer.Buttons[ mid ].ClaimedPlayer == sid or ButtonClaimingServer.Buttons[ mid ].Claimed == false) then
		if (ent:GetSaveTable().m_toggle_state == 1 and not ent:GetSaveTable().m_bLocked and ply:KeyPressed(IN_USE)) then
			hook.Call("DeathrunButtonActivated", nil, ply, ent);
		end

		ent.User = ply;
		return;
	else
		return false;
	end
end
hook.Add("PlayerUse", "MizmoCanPlayerUseButton", ButtonClaimingServer.PlayerCanUseButton);
