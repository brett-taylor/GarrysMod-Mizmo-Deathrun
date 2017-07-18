ITEM.Name = 'Purple Guy'
ITEM.Price = 700
ITEM.Model = 'models/player/quentindylanp/purpleguy_dark.mdl'
ITEM.Desc = "Purple guy from the Five Night's at Freddy's series."
ITEM.Grade = 'Mil-spec'
ITEM.Level = 12

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

