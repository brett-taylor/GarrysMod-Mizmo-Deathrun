if SERVER then
	util.AddNetworkString("MizmoChatMessage");
	if (Util == nil) then
		Util = {};
	end

	function Util.SendMessage(msg)
		net.Start("MizmoChatMessage");
			net.WriteString(msg);
		net.Broadcast();
	end

	function Util.SendMessagePlayer(ply, msg)
		net.Start("MizmoChatMessage");
			net.WriteString(msg);
		net.Send(ply);
	end
end

if CLIENT then
	net.Receive("MizmoChatMessage", function()
		chat.AddText(Colours.Gold, "[Mizmo-Gaming] ", Colours.TextWhite, net.ReadString());
	end)
end