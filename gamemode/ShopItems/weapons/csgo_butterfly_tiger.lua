ITEM.Name = 'Butterfly Knife' .. ' | ' .. 'Tiger Tooth'
ITEM.Price = 20000
ITEM.Model = 'models/weapons/w_csgo_butterfly.mdl'
ITEM.Skin = 9
ITEM.WeaponClass = 'csgo_butterfly_tiger'
ITEM.Grade = 'Exceedingly Rare'
ITEM.Buyable = false;

function ITEM:OnEquip(ply)
	ply:Give(self.WeaponClass)
	ply:StripWeapon("weapon_crowbar");
end

function ITEM:OnBuy(ply)
	ply:Give(self.WeaponClass)
	ply:SelectWeapon(self.WeaponClass)
end

function ITEM:OnSell(ply)
	ply:StripWeapon(self.WeaponClass)
	ply:Give("weapon_crowbar")
end

function ITEM:OnHolster(ply)
	ply:StripWeapon(self.WeaponClass)
	ply:Give("weapon_crowbar")
end