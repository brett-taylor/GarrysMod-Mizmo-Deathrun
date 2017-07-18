ITEM.Name = 'Darth Vader'
ITEM.Price = 12000
ITEM.Model = 'models/player/b4p/b4p_vader.mdl'
ITEM.Desc = "I am your father."
ITEM.Grade = 'Covert'
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

