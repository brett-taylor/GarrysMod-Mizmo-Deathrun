ITEM.Name = 'LOL Trail'
ITEM.Price = 300
ITEM.Material = 'trails/lol.vmt'
ITEM.Desc = 'A trail of LOLs.'
ITEM.Grade = 'Consumer'
ITEM.Buyable = true;

function ITEM:OnEquip(ply, modifications)
	ply.LolTrail = util.SpriteTrail(ply, 0, modifications.color, false, 15, 1, 4, 0.125, self.Material)
end

function ITEM:OnHolster(ply)
	SafeRemoveEntity(ply.LolTrail)
end

function ITEM:Modify(modifications)
	PS:ShowColorChooser(self, modifications)
end

function ITEM:OnModify(ply, modifications)
	SafeRemoveEntity(ply.LolTrail)
	self:OnEquip(ply, modifications)
end
