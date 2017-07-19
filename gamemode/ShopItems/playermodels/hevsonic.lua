ITEM.Name = 'Hev Sonic'
ITEM.Price = 22000
ITEM.Model = 'models/_tails_ models/characters/player/hevsonic/hevsonic.mdl'
ITEM.Desc = 'Tails from SEGA.'
ITEM.Grade = 'Exceedingly Rare'
ITEM.Level = 65
ITEM.Buyable = true;

function ITEM:OnEquip(ply, modifications)
	if not ply._OldModel then
		ply._OldModel = ply:GetModel()
	end
	
	timer.Simple(1, function() ply:SetModel(self.Model) end)
end

function ITEM:OnHolster(ply)
	if ply._OldModel then
		ply:SetModel(ply._OldModel)
	end
end

function ITEM:PlayerSetModel(ply)
	ply:SetModel(self.Model)
end

