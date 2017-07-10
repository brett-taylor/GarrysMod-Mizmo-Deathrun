util.AddNetworkString("MizmoSendNotification");
Notify = {};

function Notify.SendNotificationAll(text, seconds)
	net.Start("MizmoSendNotification");
		net.WriteString(text);
		net.WriteFloat(tonumber(seconds));
	net.Broadcast();
end

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