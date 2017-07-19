ITEM.Name = 'Plokoon'
ITEM.Price = 7000
ITEM.Model = 'models/kriegsyntax/sw_752/plokoon_est.mdl'
ITEM.Desc = 'Who even is this.'
ITEM.Grade = 'Classified'
ITEM.Level = 38
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

