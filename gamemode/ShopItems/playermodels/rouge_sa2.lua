ITEM.Name = 'Rouge (SA2)'
ITEM.Price = 22000
ITEM.Model = 'models/_tails_ models/characters/sonic heroes/rouge_sa2/rouge_sa2.mdl'
ITEM.Desc = 'Rouge from Sonic Adventures 2.'
ITEM.Grade = 'Exceedingly Rare'
ITEM.Level = 35

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

