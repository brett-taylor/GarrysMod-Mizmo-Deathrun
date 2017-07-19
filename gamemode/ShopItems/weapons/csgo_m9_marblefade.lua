ITEM.Name = 'M9 Bayonet Knife' .. ' | ' .. 'Marble Fade'
ITEM.Price = 20000
ITEM.Model = 'models/weapons/w_csgo_m9.mdl'
ITEM.Skin = 13
ITEM.WeaponClass = 'csgo_m9_marblefade'
ITEM.Grade = 'Exceedingly Rare'

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