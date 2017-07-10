ITEM.Name = 'Spooky Red'
ITEM.Price = 150
ITEM.Material = 'trails/spookyerd.vmt'

function ITEM:OnEquip(ply, modifications)
	ply.RedFaceTrail = util.SpriteTrail(ply, 0, modifications.color, false, 15, 1, 4, 0.125, self.Material)
end

function ITEM:OnHolster(ply)
	SafeRemoveEntity(ply.RedFaceTrail)
end

function ITEM:Modify(modifications)
	PS:ShowColorChooser(self, modifications)
end

function ITEM:OnModify(ply, modifications)
	SafeRemoveEntity(ply.RedFaceTrail)
	self:OnEquip(ply, modifications)
end