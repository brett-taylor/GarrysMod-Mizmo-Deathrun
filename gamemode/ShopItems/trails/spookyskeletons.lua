ITEM.Name = 'Spooky Skeletons'
ITEM.Price = 150
ITEM.Material = 'trails/spooky_skeletons.vmt'

function ITEM:OnEquip(ply, modifications)
	ply.sssTrail = util.SpriteTrail(ply, 0, modifications.color, false, 15, 1, 4, 0.125, self.Material)
end

function ITEM:OnHolster(ply)
	SafeRemoveEntity(ply.sssTrail)
end

function ITEM:Modify(modifications)
	PS:ShowColorChooser(self, modifications)
end

function ITEM:OnModify(ply, modifications)
	SafeRemoveEntity(ply.sssTrail)
	self:OnEquip(ply, modifications)
end