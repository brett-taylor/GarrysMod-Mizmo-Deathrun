util.AddNetworkString("MizmoSendNotification");
Notify = {};

function Notify.SendNotification(ply, text, seconds)
	net.Start("MizmoSendNotification");
		net.WriteString(text);
		net.WriteFloat(tonumber(seconds));
	net.Send(ply);
end

local meta = FindMetaTable("Player");
function meta:Notify(text, seconds)
	Notify.SendNotification(self, text, seconds);
end

concommand.Add("test", function()
	player.GetAll()[1]:Notify("Some random test value", 5);
end);