ITEM.Name = 'Kappa Trail'
ITEM.Price = 3000
ITEM.Material = 'trails/kappa.vmt'
ITEM.Desc = 'A trail of Kappa123s'
ITEM.Grade = 'Classified'
ITEM.Buyable = true;

function ITEM:OnEquip(ply, modifications)
	ply.blood = util.SpriteTrail(ply, 0, modifications.color, false, 15, 1, 4, 0.125, self.Material)
end

function ITEM:OnHolster(ply)
	SafeRemoveEntity(ply.blood)
end

function ITEM:Modify(modifications)
	PS:ShowColorChooser(self, modifications)
end

function ITEM:OnModify(ply, modifications)
	SafeRemoveEntity(ply.blood)
	self:OnEquip(ply, modifications)
end