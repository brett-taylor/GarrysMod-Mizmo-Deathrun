ITEM.Name = 'Bloody Prints'
ITEM.Price = 150
ITEM.Material = 'trails/bloodyprints.vmt'

function ITEM:OnEquip(ply, modifications)
	ply.bloodyprintsTrail = util.SpriteTrail(ply, 0, modifications.color, false, 15, 1, 4, 0.125, self.Material)
end

function ITEM:OnHolster(ply)
	SafeRemoveEntity(ply.bloodyprintsTrail)
end

function ITEM:Modify(modifications)
	PS:ShowColorChooser(self, modifications)
end

function ITEM:OnModify(ply, modifications)
	SafeRemoveEntity(ply.bloodyprintsTrail)
	self:OnEquip(ply, modifications)
end