ITEM.Name = 'Bat Trail'
ITEM.Price = 150
ITEM.Material = 'trails/bat_trail.vmt'

function ITEM:OnEquip(ply, modifications)
	ply.BatTTrail = util.SpriteTrail(ply, 0, modifications.color, false, 15, 1, 4, 0.125, self.Material)
end

function ITEM:OnHolster(ply)
	SafeRemoveEntity(ply.BatTTrail)
end

function ITEM:Modify(modifications)
	PS:ShowColorChooser(self, modifications)
end

function ITEM:OnModify(ply, modifications)
	SafeRemoveEntity(ply.BatTTrail)
	self:OnEquip(ply, modifications)
end
