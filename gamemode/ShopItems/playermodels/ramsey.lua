ITEM.Name = 'Ramsey Bolton'
ITEM.Price = 5000
ITEM.Model = 'models/models/ramsay/ramsay.mdl'
ITEM.Desc = 'THIS ISN’T HAPPENING TO YOU FOR A REASON. WELL, ONE REASON: I ENJOY IT! IF YOU THINK THIS HAS A HAPPY ENDING, YOU HAVEN’T BEEN PAYING ATTENTION.'
ITEM.Grade = 'Classified'
ITEM.Level = 30

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

