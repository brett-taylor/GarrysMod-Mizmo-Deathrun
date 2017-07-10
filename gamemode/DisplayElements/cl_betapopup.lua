BetaPopup = {};

function BetaPopup.Create()
	local DermaPanel = vgui.Create("DFrame");
	DermaPanel:SetSize(300, 150);
	DermaPanel:Center();
	DermaPanel:SetTitle("My new Derma frame");
	DermaPanel:MakePopup()

	DermaPanel.Paint = function(self, w, h)
		draw.RoundedBox(0, 0, 0, w, h, Colours.Grey);
	end

	local DLabel = vgui.Create( "DLabel", DermaPanel )
	DLabel:SetContentAlignment(5);
	DLabel:Dock(FILL);
	DLabel:SetText("Welcome to www.Mizmo-Gaming.co.uk \nThe server is still in development and missing alot of features \nwe plan to implement.");
end
--hook.Add("InitPostEntity", "MizmoCreateBetaPopup", BetaPopup.Create());