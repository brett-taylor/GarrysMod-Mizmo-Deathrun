ITEM.Name = 'Mario'
ITEM.Price = 15000
ITEM.Model = 'models/sinful/mariob.mdl'
ITEM.Desc = "It's a mee."
ITEM.Grade = 'Classified'
ITEM.Level = 55

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

