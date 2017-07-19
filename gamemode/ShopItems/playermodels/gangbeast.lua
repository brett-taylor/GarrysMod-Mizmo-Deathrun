ITEM.Name = 'Gang Beast'
ITEM.Price = 8000
ITEM.Model = 'models/risenshine/gang_beast.mdl'
ITEM.Desc = 'Gang Beast character'
ITEM.Grade = 'Classified'
ITEM.Level = 40
ITEM.Buyable = true;

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

