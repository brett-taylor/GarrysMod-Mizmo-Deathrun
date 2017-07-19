ITEM.Name = 'Melon Head'
ITEM.Price = 600
ITEM.Model = 'models/props_junk/watermelon01.mdl'
ITEM.Attachment = 'eyes'
ITEM.Desc = 'Watermeloooon'
ITEM.Grade = 'Mil-Spec'
ITEM.Buyable = true;

function ITEM:OnEquip(ply, modifications)
	ply:PS_AddClientsideModel(self.ID)
end

function ITEM:OnHolster(ply)
	ply:PS_RemoveClientsideModel(self.ID)
end

function ITEM:ModifyClientsideModel(ply, model, pos, ang)
	pos = pos + (ang:Forward() * -2)
	
	return model, pos, ang
end
