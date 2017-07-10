ITEM.Name = 'Default T Knife' .. ' | ' .. 'Golden'
ITEM.Price = 20000
ITEM.Model = 'models/weapons/w_csgo_default_t.mdl'
ITEM.Skin = 1
ITEM.WeaponClass = 'csgo_default_t_golden'

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