ChatSystem = {};

function ChatSystem.DoChat(ply, strText, isTeam, isDead)
	if (IsValid(ply) == false) then
		return false;
	end

	local chatTable = {};
	local prefix = ChatSystem.AddPrefix(ply);
	local colouredString = ChatSystem.AddChatColours(ply, strText);
	chatTable = table.Add(chatTable, prefix);
	chatTable = table.Add(chatTable, colouredString);
	chat.AddText(unpack(chatTable));
	return true;
end
hook.Add("OnPlayerChat", "MizmoChatSystemOnChat", ChatSystem.DoChat);

function ChatSystem.AddPrefix(ply)
	local prefix = {};

	table.insert(prefix, Colours.White);
	table.insert(prefix, "[");
	
	if (Util.PlayerHasTag(ply) == true) then
		table.insert(prefix, Util.GetTagColour(ply));
		table.insert(prefix, ply:GetNWString(PlayerSettings.Enums.TAG_NAME.Name));
	else
		table.insert(prefix, Util.GetUserGroupInfo(ply:GetUserGroup()).Colour);
		table.insert(prefix, Util.GetUserGroupInfo(ply:GetUserGroup()).Name);
	end

	table.insert(prefix, Colours.White);
	table.insert(prefix, ", ");

	if (ply:Alive() == true && ply:Team() == TEAM_DEATH) then
		table.insert(prefix, Colours.Team.Death);
		table.insert(prefix, "Death");
	elseif (ply:Alive() == true && ply:Team() == TEAM_RUNNER) then
		table.insert(prefix, Colours.Team.Runner);
		table.insert(prefix, "Runner");
	else
		table.insert(prefix, Colours.Team.Ghost);
		table.insert(prefix, "Dead");
	end

	table.insert(prefix, Colours.White);
	table.insert(prefix, "] ");

	if (ply:Alive() == true && ply:Team() == TEAM_DEATH) then
		table.insert(prefix, Colours.Team.Death);
	elseif (ply:Alive() == true && ply:Team() == TEAM_RUNNER) then
		table.insert(prefix, Colours.Team.Runner);
	else
		table.insert(prefix, Colours.Team.Ghost);
	end
	table.insert(prefix, ply:Nick());

	table.insert(prefix, Colours.White);
	table.insert(prefix, ": ");

	table.insert(prefix, Util.GetChatColour(ply));

	return prefix;
end

function ChatSystem.AddChatColours(ply, text)
	if (string.find(ply:Nick():lower(), "[mg]") == nil) then
		return string.Explode(":", text);
	end

	local chatTable = {};
	local stringTable = string.Explode(":", text);

	for i, txt in pairs (stringTable) do
		txt = string.Trim(txt, " ");
		if (Util.ChatColours[txt:lower()] ~= nil) then
			table.insert(chatTable, Util.ChatColours[txt:lower()]);
		else
			table.insert(chatTable, txt);
			if (i ~= 1) then
				table.insert(chatTable, " ");
			end
		end
	end

	return chatTable;
end