local PANEL = {};

function PANEL:Init()
	self.ShouldPaintOnData = false;

	self.Background = vgui.Create("DPanel", self);
	self.Background.Paint = function(s, w, h)
		surface.SetDrawColor(Colours.Grey);
		surface.DrawRect(0, 0, w, h);

		if (self.ShouldPaintOnData == true) then
			draw.RoundedBox(2, 5, 150, w - 10, 2, self.Colour);

			surface.SetDrawColor(Colours.GreyDark);
			surface.DrawRect(5, 160, w - 10, 135);

			draw.SimpleText("This Item Does Not Appear In Any Crate.", "MizmoGaming-Button-Small", w / 2, 217, Colours.White, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER);
		end
	end

	self.CloseButton = vgui.Create("DMizmoButton", self.Background);
	self.CloseButton:SetTextSmall();
	self.CloseButton:SetText("Close");
	self.CloseButton:DisableOutline();
	self.CloseButton:DisableTextOutline();
	self.CloseButton.OnClicked = function()
		self:Remove();
	end

	self:InvalidateLayout();
end

function PANEL:SetData(item)
	PS.ShopMenu.LastItemDataOpened = item;
	self.Data = item;
	self.Colour = Util.GetItemColour(self.Data.Grade);

	self.ItemIcon = vgui.Create("DMizmoItem", self.Background);
	self.ItemIcon:SetData(item);
	self.ItemIcon:DoItemPopup();
	self.ItemIcon:SetRadius(62);
	
	self.Title = vgui.Create("DLabel", self.Background)
	self.Title:SetText(self.Data.Name);
	self.Title:SetTextColor(self.Colour);
	self.Title:SetFont("MizmoGaming-Button-Medium");

	self.Desc = vgui.Create("DLabel", self.Background)
	self.Desc:SetText(self.Data.Desc or "Undefined.");
	self.Desc:SetTextColor(Colours.White);
	self.Desc:SetFont("MizmoGaming-Button-Small");
	self.Desc:SetWrap(true);

	if (LocalPlayer():PS_HasItem(self.Data.ID) == true) then
		self.SellButton = vgui.Create("DMizmoShopFunctionButton", self.Background);
		self.SellButton:Settext("Sell");
		self.SellButton:SetAccentColour(self.Colour);
		self.SellButton:SetMaterial("sell");
		self.SellButton.OnClicked = function()
			self:CancelClicks(self.SellButton);
		end
		self.SellButton.Execute = function()
			LocalPlayer():PS_SellItem(self.Data.ID);
			timer.Simple(0.25, function() 
				PS.ShopMenu:OpenInventoryTab(PS.ShopMenu.LastItemDataOpened.CategoryID)
				self:Remove();
			end);
		end

		if (LocalPlayer():PS_HasItemEquipped(self.Data.ID) == true) then
			self.HolsterButton = vgui.Create("DMizmoShopFunctionButton", self.Background);
			self.HolsterButton:Settext("Holster");
			self.HolsterButton:SetAccentColour(self.Colour);
			self.HolsterButton:SetMaterial("holster");
			self.HolsterButton.OnClicked = function()
				self:CancelClicks(self.HolsterButton);
			end
			self.HolsterButton.Execute = function()
				LocalPlayer():PS_HolsterItem(self.Data.ID);
				timer.Simple(0.25, function() 
					PS.ShopMenu:OpenInventoryTab(PS.ShopMenu.LastItemDataOpened.CategoryID) 
					self:Remove();
				end);
			end
		else
			self.EquipButton = vgui.Create("DMizmoShopFunctionButton", self.Background);
			self.EquipButton:Settext("Equip");
			self.EquipButton:SetAccentColour(self.Colour);
			self.EquipButton:SetMaterial("equip");
			self.EquipButton.OnClicked = function()
				self:CancelClicks(self.EquipButton);
			end
			self.EquipButton.Execute = function()
				LocalPlayer():PS_EquipItem(self.Data.ID);
				timer.Simple(0.25, function() 
					PS.ShopMenu:OpenInventoryTab(PS.ShopMenu.LastItemDataOpened.CategoryID) 
					self:Remove();
				end);
			end
		end

		if (self.Data.Modify) then
			self.ModifyButton = vgui.Create("DMizmoShopFunctionButton", self.Background);
			self.ModifyButton:Settext("Modify");
			self.ModifyButton:SetAccentColour(self.Colour);
			self.ModifyButton:SetMaterial("modify");
			self.ModifyButton:NoWait();
			self.ModifyButton.OnClicked = function()
				self:CancelClicks(self.ModifyButton);
			end
			self.ModifyButton.Execute = function()
				PS.Items[self.Data.ID]:Modify(LocalPlayer().PS_Items[self.Data.ID].Modifiers)
			end
		end
	else
		self.BuyButton = vgui.Create("DMizmoShopFunctionButton", self.Background);
		self.BuyButton:Settext("Buy");
		self.BuyButton:SetAccentColour(self.Colour);
		self.BuyButton:SetMaterial("buy");
		self.BuyButton.OnClicked = function()
			self:CancelClicks(self.BuyButton);
		end
		self.BuyButton.Execute = function()
			LocalPlayer():PS_BuyItem(self.Data.ID);
			timer.Simple(0.25, function() 
				PS.ShopMenu:OpenShopTab(PS.ShopMenu.LastItemDataOpened.CategoryID) 
				self:Remove();
			end);
		end
	end

	self:InvalidateLayout();
	self.ShouldPaintOnData = true;
end

function PANEL:InvalidateLayout()
	self:SetSize(ScrW(), ScrH());

	if (self.Background) then
		self.Background:SetSize(600, 300);
		self.Background:Center();
	end

	if (self.CloseButton ~= nil) then
		self.CloseButton:SetSize(70, 30);
		self.CloseButton:SetPos(self.Background:GetWide() - 70, 0);
	end

	if (self.ItemIcon ~= nil) then
		self.ItemIcon:SetPos(5, 5);
		self.ItemIcon:SetSize(130, 130);
	end

	if (self.Title ~= nil) then
		self.Title:SetSize(450, 30);
		self.Title:SizeToContentsY();
		self.Title:SetPos(150, 20);
	end

	if (self.Desc ~= nil) then
		self.Desc:SetSize(440, 50);
		self.Desc:SetPos(150, self.Title:GetTall() + 10);
	end

	if (self.BuyButton ~= nil) then
		self.BuyButton:SetPos(530, 85);
	end

	if (self.SellButton ~= nil) then
		self.SellButton:SetPos(530, 85);
	end

	if (self.HolsterButton ~= nil) then
		self.HolsterButton:SetPos(465, 85);
	end

	if (self.EquipButton ~= nil) then
		self.EquipButton:SetPos(465, 85);
	end

	if (self.ModifyButton ~= nil) then
		self.ModifyButton:SetPos(400, 85);
	end
end

function PANEL:CancelClicks(but)
	if (self.SellButton ~= nil && self.SellButton ~= but) then
		self.SellButton:CancelClick();
	end

	if (self.HolsterButton ~= nil && self.HolsterButton ~= but) then
		self.HolsterButton:CancelClick();
	end

	if (self.EquipButton ~= nil && self.EquipButton ~= but) then
		self.EquipButton:CancelClick();
	end

	if (self.ModifyButton ~= nil && self.ModifyButton ~= but) then
		self.ModifyButton:CancelClick();
	end

	if (self.BuyButton ~= nil && self.BuyButton ~= but) then
		self.BuyButton:CancelClick();
	end
end

function PANEL:Paint(w, h)
	surface.SetDrawColor(ColorAlpha(Colours.GreyDark, 200));
	surface.DrawRect(0, 0, w, h);
end

vgui.Register("DMizmoShopItemData", PANEL, "DPanel");