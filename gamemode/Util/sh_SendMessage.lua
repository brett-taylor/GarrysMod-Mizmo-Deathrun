if SERVER then
	util.AddNetworkString("MizmoChatMessage");
	util.AddNetworkString("MizmoChatMessageTable");
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


	function Util.SendMessageTable(tbl)
		net.Start("MizmoChatMessageTable");
			net.WriteTable(tbl);
		net.Broadcast();
	end

	function Util.SendMessagePlayerTable(ply, tbl)
		net.Start("MizmoChatMessageTable");
			net.WriteTable(tbl);
		net.Send(ply);
	end
end

if CLIENT then
	net.Receive("MizmoChatMessage", function()
		chat.AddText(Colours.Gold, "[Mizmo-Gaming] ", Colours.TextWhite, net.ReadString());
	end)

	net.Receive("MizmoChatMessageTable", function()
		chat.AddText(unpack(net.ReadTable()));
	end)
end