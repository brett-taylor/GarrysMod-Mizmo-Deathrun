ITEM.Name = 'Musical Sheet'
ITEM.Price = 150
ITEM.Material = 'trails/whitemusic.vmt'

function ITEM:OnEquip(ply, modifications)
	ply.MusicSheet = util.SpriteTrail(ply, 0, modifications.color, false, 15, 1, 4, 0.125, self.Material)
end

function ITEM:OnHolster(ply)
	SafeRemoveEntity(ply.MusicSheet)
end

function ITEM:Modify(modifications)
	PS:ShowColorChooser(self, modifications)
end

function ITEM:OnModify(ply, modifications)
	SafeRemoveEntity(ply.MusicSheet)
	self:OnEquip(ply, modifications)
end