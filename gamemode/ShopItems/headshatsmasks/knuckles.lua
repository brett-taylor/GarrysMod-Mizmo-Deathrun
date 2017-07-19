ITEM.Name = 'Knuckles Head'
ITEM.Price = 3000
ITEM.Model = 'models/logan_mccloud_models/ova_props/knuckles_ova_hat.mdl'
ITEM.Desc = 'Heh... ready for the junk pile.'
ITEM.Grade = 'Classified'

function ITEM:OnEquip(ply, modifications)
	ply:PS_AddClientsideModel(self.ID)
end

function ITEM:OnHolster(ply)
	ply:PS_RemoveClientsideModel(self.ID)
end

function ITEM:ModifyClientsideModel(ply, model, pos, ang)
	model:SetModelScale(0.8, 0);
	ang:RotateAroundAxis(ang:Up(), 90);
	pos = pos - (ang:Up() * 25);
	
	return model, pos, ang
end
