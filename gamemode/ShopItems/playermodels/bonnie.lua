ITEM.Name = 'Bonnie'
ITEM.Price = 20000
ITEM.Model = 'models/aileri/fnaf1/bonnie.mdl'
ITEM.Desc = "Bonnie from the Five Nights at Freddies franchise."
ITEM.Grade = 'Covert'
ITEM.Level = 60
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

