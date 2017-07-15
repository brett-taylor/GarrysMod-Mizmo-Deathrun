ITEM.Name = 'Mr. Meeseeks'
ITEM.Price = 12000
ITEM.Model = 'models/player/meeseeks/meeseeks.mdl'
ITEM.Desc = "HEYY I'M MR. MEESEEKS LOOK AT ME"
ITEM.Grade = 'Classified'
ITEM.Level = 20

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

