ITEM.Name = 'Golden Freddy'
ITEM.Price = 25000
ITEM.Model = 'models/aileri/fnaf1/golden_freddy.mdl'
ITEM.Desc = "Golden Freddy from the Five Nights at Freddies franchise."
ITEM.Grade = 'Exceedingly Rare'
ITEM.Level = 40

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

