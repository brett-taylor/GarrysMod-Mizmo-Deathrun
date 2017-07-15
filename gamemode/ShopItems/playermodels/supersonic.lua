ITEM.Name = 'Super Sonic'
ITEM.Price = 30000
ITEM.Model = 'models/_tails_ models/characters/sonic heroes/super_sonic/sonic.mdl'
ITEM.Desc = 'Super Sonic from SEGA.'
ITEM.Grade = 'Exceedingly Rare'
ITEM.Level = 45

function ITEM:OnEquip(ply, modifications)
	if not ply._OldModel then
		ply._OldModel = ply:GetModel()
	end
	
	timer.Simple(1, function() ply:SetModel(self.Model) end)
end

function ITEM:OnHolster(ply)
	if ply._OldModel then
		ply:SetModel(ply._OldModel)
	end
end

function ITEM:PlayerSetModel(ply)
	ply:SetModel(self.Model)
end

