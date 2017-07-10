ITEM.Name = 'Deck Suits'
ITEM.Price = 500
ITEM.Material = 'trails/suit.vmt'

function ITEM:OnEquip(ply, modifications)
	ply.DeckTrail = util.SpriteTrail(ply, 0, modifications.color, false, 15, 1, 4, 0.125, self.Material)
end

function ITEM:OnHolster(ply)
	SafeRemoveEntity(ply.DeckTrail)
end

function ITEM:Modify(modifications)
	PS:ShowColorChooser(self, modifications)
end

function ITEM:OnModify(ply, modifications)
	SafeRemoveEntity(ply.DeckTrail)
	self:OnEquip(ply, modifications)
end