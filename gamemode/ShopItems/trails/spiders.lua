ITEM.Name = 'Spooky Spiders'
ITEM.Price = 150
ITEM.Material = 'trails/spiders.vmt'

function ITEM:OnEquip(ply, modifications)
	ply.SpookySpidersTrail = util.SpriteTrail(ply, 0, modifications.color, false, 15, 1, 4, 0.125, self.Material)
end

function ITEM:OnHolster(ply)
	SafeRemoveEntity(ply.SpookySpidersTrail)
end

function ITEM:Modify(modifications)
	PS:ShowColorChooser(self, modifications)
end

function ITEM:OnModify(ply, modifications)
	SafeRemoveEntity(ply.SpookySpidersTrail)
	self:OnEquip(ply, modifications)
end