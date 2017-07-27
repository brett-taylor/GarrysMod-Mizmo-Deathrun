ITEM.Name = 'Male Trail'
ITEM.Price = 1500
ITEM.Material = 'trails/maletrail.vmt'
ITEM.Desc = 'Maleeeee Traiiil.'
ITEM.Grade = 'Restricted'
ITEM.Buyable = true;

function ITEM:OnEquip(ply, modifications)
	ply.MaleTrail = util.SpriteTrail(ply, 0, modifications.color, false, 15, 1, 4, 0.125, self.Material)
end

function ITEM:OnHolster(ply)
	SafeRemoveEntity(ply.MaleTrail)
end

function ITEM:Modify(modifications)
	PS:ShowColorChooser(self, modifications)
end

function ITEM:OnModify(ply, modifications)
	SafeRemoveEntity(ply.MaleTrail)
	self:OnEquip(ply, modifications)
end