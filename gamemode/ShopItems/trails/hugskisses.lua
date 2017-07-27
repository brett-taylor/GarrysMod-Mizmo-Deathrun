ITEM.Name = 'Hearts and Kisses'
ITEM.Price = 150
ITEM.Material = 'trails/heartk.vmt'
ITEM.Grade = 'Consumer'
ITEM.Buyable = true;

function ITEM:OnEquip(ply, modifications)
	ply.HeartsAndKissesTrail = util.SpriteTrail(ply, 0, modifications.color, false, 15, 1, 4, 0.125, self.Material)
end

function ITEM:OnHolster(ply)
	SafeRemoveEntity(ply.HeartsAndKissesTrail)
end

function ITEM:Modify(modifications)
	PS:ShowColorChooser(self, modifications)
end

function ITEM:OnModify(ply, modifications)
	SafeRemoveEntity(ply.HeartsAndKissesTrail)
	self:OnEquip(ply, modifications)
end