ITEM.Name = 'Canadian Flag'
ITEM.Price = 150
ITEM.Material = 'trails/canada.vmt'
ITEM.Grade = 'Consumer'
ITEM.Buyable = true;

function ITEM:OnEquip(ply, modifications)
	ply.CanadianFlagTrail = util.SpriteTrail(ply, 0, modifications.color, false, 15, 1, 4, 0.125, self.Material)
end

function ITEM:OnHolster(ply)
	SafeRemoveEntity(ply.CanadianFlagTrail)
end

function ITEM:Modify(modifications)
	PS:ShowColorChooser(self, modifications)
end

function ITEM:OnModify(ply, modifications)
	SafeRemoveEntity(ply.CanadianFlagTrail)
	self:OnEquip(ply, modifications)
end