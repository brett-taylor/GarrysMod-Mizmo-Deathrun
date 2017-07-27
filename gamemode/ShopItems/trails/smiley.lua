ITEM.Name = 'Steam Smiley'
ITEM.Price = 300
ITEM.Material = 'trails/smiley.vmt'
ITEM.Desc = 'A trail of smiles.'
ITEM.Grade = 'Consumer'
ITEM.Buyable = true;

function ITEM:OnEquip(ply, modifications)
	ply.SteamSmileyTrail = util.SpriteTrail(ply, 0, modifications.color, false, 15, 1, 4, 0.125, self.Material)
end

function ITEM:OnHolster(ply)
	SafeRemoveEntity(ply.SteamSmileyTrail)
end

function ITEM:Modify(modifications)
	PS:ShowColorChooser(self, modifications)
end

function ITEM:OnModify(ply, modifications)
	SafeRemoveEntity(ply.SteamSmileyTrail)
	self:OnEquip(ply, modifications)
end