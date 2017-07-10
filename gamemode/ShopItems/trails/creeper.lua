ITEM.Name = 'Side Creeper'
ITEM.Price = 500
ITEM.Material = 'trails/creeper.vmt'

function ITEM:OnEquip(ply, modifications)
	ply.CreeperTrail = util.SpriteTrail(ply, 0, modifications.color, false, 15, 1, 4, 0.125, self.Material)
end

function ITEM:OnHolster(ply)
	SafeRemoveEntity(ply.CreeperTrail)
end

function ITEM:Modify(modifications)
	PS:ShowColorChooser(self, modifications)
end

function ITEM:OnModify(ply, modifications)
	SafeRemoveEntity(ply.CreeperTrail)
	self:OnEquip(ply, modifications)
end