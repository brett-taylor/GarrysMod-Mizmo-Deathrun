ITEM.Name = 'Soviet Union Flag'
ITEM.Price = 150
ITEM.Material = 'mizmo-gaming-downloads/trails/mizmo_soviet_union.vmt'
ITEM.Grade = 'Covert'
ITEM.Buyable = true;

function ITEM:OnEquip(ply, modifications)
	ply.SovietUnionTrail = util.SpriteTrail(ply, 0, modifications.color, false, 15, 1, 4, 0.125, self.Material)
end

function ITEM:OnHolster(ply)
	SafeRemoveEntity(ply.SovietUnionTrail)
end

function ITEM:Modify(modifications)
	PS:ShowColorChooser(self, modifications)
end

function ITEM:OnModify(ply, modifications)
	SafeRemoveEntity(ply.SovietUnionTrail)
	self:OnEquip(ply, modifications)
end