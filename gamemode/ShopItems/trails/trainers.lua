ITEM.Name = 'Trainers'
ITEM.Price = 500
ITEM.Material = 'trails/trains.vmt'

function ITEM:OnEquip(ply, modifications)
	ply.TrainTrail = util.SpriteTrail(ply, 0, modifications.color, false, 15, 1, 4, 0.125, self.Material)
end

function ITEM:OnHolster(ply)
	SafeRemoveEntity(ply.TrainTrail)
end

function ITEM:Modify(modifications)
	PS:ShowColorChooser(self, modifications)
end

function ITEM:OnModify(ply, modifications)
	SafeRemoveEntity(ply.TrainTrail)
	self:OnEquip(ply, modifications)
end