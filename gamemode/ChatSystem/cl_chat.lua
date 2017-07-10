ChatSystem = {};

function ChatSystem.DoChat(ply, strText, isTeam, isDead)
	local chatTable = {};
	table.insert(chatTable, Colours.White);
	table.insert(chatTable, "[");
	
	if (Util.PlayerHasTag(ply) == true) then
		table.insert(chatTable, Util.GetTagColour(ply));
		table.insert(chatTable, ply:GetNWString(PlayerSettings.Enums.TAG_NAME.Name));
	else
		table.insert(chatTable, Util.GetUserGroupInfo(ply:GetUserGroup()).Colour);
		table.insert(chatTable, Util.GetUserGroupInfo(ply:GetUserGroup()).Name);
	end

	table.insert(chatTable, Colours.White);
	table.insert(chatTable, ", ");

	if (ply:Alive() == true && ply:Team() == TEAM_DEATH) then
		table.insert(chatTable, Colours.Team.Death);
		table.insert(chatTable, "Death");
	elseif (ply:Alive() == true && ply:Team() == TEAM_RUNNER) then
		table.insert(chatTable, Colours.Team.Runner);
		table.insert(chatTable, "Runner");
	else
		table.insert(chatTable, Colours.Team.Ghost);
		table.insert(chatTable, "Dead");
	end

	table.insert(chatTable, Colours.White);
	table.insert(chatTable, "] ");

	if (ply:Alive() == true && ply:Team() == TEAM_DEATH) then
		table.insert(chatTable, Colours.Team.Death);
	elseif (ply:Alive() == true && ply:Team() == TEAM_RUNNER) then
		table.insert(chatTable, Colours.Team.Runner);
	else
		table.insert(chatTable, Colours.Team.Ghost);
	end
	table.insert(chatTable, ply:Nick());

	table.insert(chatTable, Colours.White);
	table.insert(chatTable, ": ");

	table.insert(chatTable, Colours.White);
	table.insert(chatTable, strText);

	chat.AddText(unpack(chatTable));
	return true;
end
hook.Add("OnPlayerChat", "MizmoChatSystemOnChat", ChatSystem.DoChat);