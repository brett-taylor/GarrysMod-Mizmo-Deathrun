ITEM.Name = 'Morgan Freeman'
ITEM.Price = 700
ITEM.Model = 'models/rottweiler/morganfreeman.mdl'
ITEM.Desc = 'I can smell you.'
ITEM.Grade = 'Mil-spec'
ITEM.Level = 5

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

