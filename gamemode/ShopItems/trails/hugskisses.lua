ITEM.Name = 'Hearts and Kisses'
ITEM.Price = 150
ITEM.Material = 'trails/heartk.vmt'

function ITEM:OnEquip(ply, modifications)
	ply.HAKTrail = util.SpriteTrail(ply, 0, modifications.color, false, 15, 1, 4, 0.125, self.Material)
end

function ITEM:OnHolster(ply)
	SafeRemoveEntity(ply.HAKTrail)
end

function ITEM:Modify(modifications)
	PS:ShowColorChooser(self, modifications)
end

function ITEM:OnModify(ply, modifications)
	SafeRemoveEntity(ply.HAKTrail)
	self:OnEquip(ply, modifications)
end