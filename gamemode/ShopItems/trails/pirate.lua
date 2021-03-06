ITEM.Name = 'Pirates'
ITEM.Price = 400;
ITEM.Material = 'trails/pirateship.vmt'
ITEM.Grade = 'Classified'
ITEM.Buyable = true;

function ITEM:OnEquip(ply, modifications)
	ply.PiratesTrail = util.SpriteTrail(ply, 0, modifications.color, false, 15, 1, 4, 0.125, self.Material)
end

function ITEM:OnHolster(ply)
	SafeRemoveEntity(ply.PiratesTrail)
end

function ITEM:Modify(modifications)
	PS:ShowColorChooser(self, modifications)
end

function ITEM:OnModify(ply, modifications)
	SafeRemoveEntity(ply.PiratesTrail)
	self:OnEquip(ply, modifications)
end