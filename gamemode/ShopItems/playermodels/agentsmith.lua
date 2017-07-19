ITEM.Name = 'Agent Smith'
ITEM.Price = 1800
ITEM.Model = 'models/player/smith.mdl'
ITEM.Desc = 'Agent Smith from The Matrix.'
ITEM.Grade = 'Restricted'
ITEM.Level = 20
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

