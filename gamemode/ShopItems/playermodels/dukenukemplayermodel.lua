ITEM.Name = 'Duke Nukem'
ITEM.Price = 30000
ITEM.Model = 'models/jessev92/player/misc/dukenukem.mdl'
ITEM.Desc = 'I came here to kick ass and chew gum.'
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

