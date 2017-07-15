ITEM.Name = 'Agent 47'
ITEM.Price = 1800
ITEM.Model = 'models/player/agent_47.mdl'
ITEM.Desc = 'Agent 47 from the Hitman franchise.'
ITEM.Grade = 'Restricted'
ITEM.Level = 8

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

