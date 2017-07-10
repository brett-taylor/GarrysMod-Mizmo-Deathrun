ITEM.Name = 'Rampant Rabbits'
ITEM.Price = 150
ITEM.Material = 'trails/rabbit.vmt'

function ITEM:OnEquip(ply, modifications)
	ply.RRTrail = util.SpriteTrail(ply, 0, modifications.color, false, 15, 1, 4, 0.125, self.Material)
end

function ITEM:OnHolster(ply)
	SafeRemoveEntity(ply.RRTrail)
end

function ITEM:Modify(modifications)
	PS:ShowColorChooser(self, modifications)
end

function ITEM:OnModify(ply, modifications)
	SafeRemoveEntity(ply.RRTrail)
	self:OnEquip(ply, modifications)
end