ITEM.Name = 'Falchion Knife' .. ' | ' .. 'Forest DDPAT'
ITEM.Price = 20000
ITEM.Model = 'models/weapons/w_csgo_falchion.mdl'
ITEM.Skin = 5
ITEM.WeaponClass = 'csgo_falchion_ddpat'

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