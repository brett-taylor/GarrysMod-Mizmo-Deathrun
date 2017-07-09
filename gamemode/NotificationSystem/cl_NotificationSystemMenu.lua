NotificationSystemMenu = {};
NotificationSystemMenu.BaseParent = nil;
NotificationSystemMenu.Grid = nil;

 function NotificationSystemMenu.CreateParent()
	NotificationSystemMenu.BaseParent = vgui.Create("DFrame");
	NotificationSystemMenu.BaseParent:SetPos(ScrW() - 270, 200);
	NotificationSystemMenu.BaseParent:SetSize(270, ScrH() - 200);
	NotificationSystemMenu.BaseParent:SetTitle("");
	NotificationSystemMenu.BaseParent:SetVisible(true);
	NotificationSystemMenu.BaseParent:SetDraggable(false);
	NotificationSystemMenu.BaseParent:ShowCloseButton(false);
	NotificationSystemMenu.BaseParent.Paint = function(self, w, h)
	end

	local Scroll = vgui.Create("DScrollPanel", NotificationSystemMenu.BaseParent)
	Scroll:SetSize(Scroll:GetParent():GetWide(), Scroll:GetParent():GetTall());
	Scroll:SetPos(0, 0);

	NotificationSystemMenu.Grid = vgui.Create("DIconLayout", Scroll);
	NotificationSystemMenu.Grid:SetSize(Scroll:GetWide() - 10, Scroll:GetTall());
	NotificationSystemMenu.Grid:SetPos(5, 0);
	NotificationSystemMenu.Grid:SetSpaceY(5);
end
NotificationSystemMenu.CreateParent();

function NotificationSystemMenu.Notify(string, seconds)
	NotificationSystemMenu.Grid:Add(MizmoAlert.GenerateNotification(NotificationSystemMenu.Grid, string, seconds));
end

net.Receive("MizmoSendNotification", function()
	NotificationSystemMenu.Grid:Add(MizmoAlert.GenerateNotification(NotificationSystemMenu.Grid, net.ReadString(), net.ReadFloat()));
end)