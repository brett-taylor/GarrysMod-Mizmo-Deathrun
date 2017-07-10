DropWeaponSystem = {};

concommand.Add("deathrun_dropweapon", function( ply, cmd, args)
	if (ply:Alive() and ply:GetActiveWeapon() ~= nil and IsValid(ply:GetActiveWeapon())) then
		if (string.find(string.lower(ply:GetActiveWeapon():GetClass()), "bayonet") || string.find(string.lower(ply:GetActiveWeapon():GetClass()), "bowie") ||
			string.find(string.lower(ply:GetActiveWeapon():GetClass()), "butterfly") || string.find(string.lower(ply:GetActiveWeapon():GetClass()), "daggers") ||
			string.find(string.lower(ply:GetActiveWeapon():GetClass()), "falchion") || string.find(string.lower(ply:GetActiveWeapon():GetClass()), "flip") ||
			string.find(string.lower(ply:GetActiveWeapon():GetClass()), "gut") || string.find(string.lower(ply:GetActiveWeapon():GetClass()), "huntsman") ||
			string.find(string.lower(ply:GetActiveWeapon():GetClass()), "karambit") || string.find(string.lower(ply:GetActiveWeapon():GetClass()), "m9")) then
			
			ply:Notify("You can't drop your knife.", 2);
		else
			ply:DropWeapon(ply:GetActiveWeapon());
		end
	end
end)
