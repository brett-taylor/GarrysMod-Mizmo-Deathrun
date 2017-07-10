ITEM.Name = 'Snowflakes'
ITEM.Price = 500
ITEM.Material = 'trails/snowflake.vmt'

function ITEM:OnEquip(ply, modifications)
	ply.SnowTrail = util.SpriteTrail(ply, 0, modifications.color, false, 15, 1, 4, 0.125, self.Material)
end

function ITEM:OnHolster(ply)
	SafeRemoveEntity(ply.SnowTrail)
end

function ITEM:Modify(modifications)
	PS:ShowColorChooser(self, modifications)
end

function ITEM:OnModify(ply, modifications)
	SafeRemoveEntity(ply.SnowTrail)
	self:OnEquip(ply, modifications)
end