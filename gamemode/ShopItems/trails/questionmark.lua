ITEM.Name = 'Ask A Question'
ITEM.Price = 500
ITEM.Material = 'trails/question.vmt'

function ITEM:OnEquip(ply, modifications)
	ply.QMTrail = util.SpriteTrail(ply, 0, modifications.color, false, 15, 1, 4, 0.125, self.Material)
end

function ITEM:OnHolster(ply)
	SafeRemoveEntity(ply.QMTrail)
end

function ITEM:Modify(modifications)
	PS:ShowColorChooser(self, modifications)
end

function ITEM:OnModify(ply, modifications)
	SafeRemoveEntity(ply.QMTrail)
	self:OnEquip(ply, modifications)
end