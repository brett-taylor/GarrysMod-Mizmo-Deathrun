local PANEL = {};

function PANEL:Init()
	self:MoveToFront();
	self:MakePopup();

	self.Background = vgui.Create("DPanel", self);
	function self.Background:Paint(w, h)
		surface.SetDrawColor(Colours.Gold);
		surface.DrawRect(0, 0, w, h);

		surface.SetDrawColor(Colours.GreyDark);
		surface.DrawRect(2, 2, w - 4, h - 4);
	end

	self.CloseButton = vgui.Create("DMizmoButton", self.Background);
	self.CloseButton:SetText("X");
	self.CloseButton:SetTextSmall();
	self.CloseButton:DisableOutline();
	self.CloseButton:SetColour(Colours.GreyDark);
	self.CloseButton:SetTextOutlineColourHovered(Colours.Gold);
	self.CloseButton.OnClicked = function()
		self:Remove();
		self.Background:Remove();
	end

	self.ItemIcon = vgui.Create("DMizmoShopItemIcon", self.Background);
	self.ItemIcon:SetPos(10, 10);

	self.Name = vgui.Create("DLabel", self.Background);
	self.Name:SetFont("MizmoGaming-Button-Medium");
	self.Name:SetText("M9 Bayonet Slaugther");

	self.Bar = vgui.Create("DPanel", self.Background);

	self.Desc = vgui.Create("DLabel", self.Background);
	self.Desc:SetFont("MizmoGaming-Button-Small");
	self.Desc:SetText("This is the M-9 bayonet. Originally intended to be mounted on a rifle, \nit is also well suited to close-quarters combat.");
	self.Desc:SetAutoStretchVertical(true);
	self.Desc:SizeToContents();

	self.CrateButtons = {};

	self.CrateHeader = vgui.Create("DLabel", self.Background);
	self.CrateHeader:SetFont("MizmoGaming-Button-Small");
	self.CrateHeader:SetText("Crates this item is found in:");

	self.CrateHolder = vgui.Create("DPanel", self.Background);
	function self.CrateHolder:Paint(w, h)
	end

	self.BuyButton = vgui.Create("DMizmoButton", self.Background);
	self.BuyButton:SetText("Buy M9 Bayonet Slaugther")
	self.BuyButton:SetOutlineColour(Color(10, 10, 10));
	self.BuyButton:SetOutlineColouredHovered(Colours.Gold);
	self.BuyButton:SetTextOutlineColourHovered(Color(10, 10, 10));

	self:SetData(PS.Items["afro"]);

	self:InvalidateLayout();
end

function PANEL:InvalidateLayout()
	self:SetSize(ScrW(), ScrH());

	if (self.Background ~= nil) then
		self.Background:SetSize(600, 250);
		self.Background:Center();
	end	

	if (self.CloseButton ~= nil) then
		self.CloseButton:SetSize(25, 25);
		self.CloseButton:SetPos(self.CloseButton:GetParent():GetWide() - 30, 7);
	end

	if (self.Name ~= nil) then
		self.Name:SetSize(400, 50);
		self.Name:SetPos(170, 25);
	end

	if (self.Bar ~= nil) then
		self.Bar:SetSize(400, 3);
		self.Bar:SetPos(170, 75);
	end

	if (self.Desc ~= nil) then
		self.Desc:SetSize(400, 30);
		self.Desc:SetPos(170, 80);
	end

	if (self.CrateHeader ~= nil) then
		self.CrateHeader:SetSize(170, 15);
		self.CrateHeader:SetPos(10, 120);
	end

	if (self.CrateHolder ~= nil) then
		self.CrateHolder:SetPos(10, 140);
		self.CrateHolder:SetSize(170, 100);
	end

	if (self.BuyButton ~= nil) then
		self.BuyButton:SetSize(400, 85);
		self.BuyButton:SetPos(190, 140);
	end
end

function PANEL:Paint(w, h)
	surface.SetDrawColor(ColorAlpha(Colours.GreyDark, 150));
	surface.DrawRect(0, 0, w, h);
end

function PANEL:AddCrate(name)
	self.CrateButtons[#self.CrateButtons + 1] = vgui.Create("DMizmoButton", self.CrateHolder);
	self.CrateButtons[#self.CrateButtons]:SetPos(0, (#self.CrateButtons - 1) * 20 + (#self.CrateButtons - 1) * 2);
	self.CrateButtons[#self.CrateButtons]:SetSize(170, 20);
	self.CrateButtons[#self.CrateButtons]:SetTextSmall();
	self.CrateButtons[#self.CrateButtons]:DisableOutline();
	self.CrateButtons[#self.CrateButtons]:DisableTextOutline();
	self.CrateButtons[#self.CrateButtons]:SetText(name);
end

function PANEL:SetData(data)
	self.ItemIcon:SetData(data);
	self.Name:SetText(data.Name);
	self.Desc:SetText(data.Desc or "Definition not set.");
	self.BuyButton:SetText("Buy "..data.Name)

	local crates = data.Crates or {};
	if (table.Count(crates) == 0) then
		self.CrateHeader:SetText("This item is not in any crates.");
		self:AddCrate("Go To All Crates");
	else
		for i = 1, table.Count(crates) do
			self:AddCrate("test");
		end
	end
end

vgui.Register("DMizmoShopItemData", PANEL);

concommand.Add("test", function()
	vgui.Create("DMizmoShopItemData");
end)