ITEM.Name = 'Daft Punk - Gold'
ITEM.Price = 5000
ITEM.Model = 'models/player/daftpunk/daft_gold.mdl'
ITEM.Desc = "Around the world. Around the world. Around the world. Around the world. Around the world."
ITEM.Grade = 'Classified'
ITEM.Level = 30
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

