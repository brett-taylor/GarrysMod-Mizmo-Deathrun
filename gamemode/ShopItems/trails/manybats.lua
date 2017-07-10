ITEM.Name = 'Bats Out Of Hell'
ITEM.Price = 150
ITEM.Material = 'trails/many_bats.vmt'

function ITEM:OnEquip(ply, modifications)
	ply.ManyBatsTrail = util.SpriteTrail(ply, 0, modifications.color, false, 15, 1, 4, 0.125, self.Material)
end

function ITEM:OnHolster(ply)
	SafeRemoveEntity(ply.ManyBatsTrail)
end

function ITEM:Modify(modifications)
	PS:ShowColorChooser(self, modifications)
end

function ITEM:OnModify(ply, modifications)
	SafeRemoveEntity(ply.ManyBatsTrail)
	self:OnEquip(ply, modifications)
end