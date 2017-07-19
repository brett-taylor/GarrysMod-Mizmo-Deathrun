local meta = FindMetaTable("Player");
if (Util == nil) then
	Util = {};
end

Util.Groups = {};
Util.Groups["superadmin"] = {};
Util.Groups["superadmin"].Name = "Owner";
Util.Groups["superadmin"].Colour = Colours.Superadmin;

Util.Groups["head_admin"] = {};
Util.Groups["head_admin"].Name = "Head-Admin";
Util.Groups["head_admin"].Colour = Colours.HAdmin;

Util.Groups["admin"] = {};
Util.Groups["admin"].Name = "Admin";
Util.Groups["admin"].Colour = Colours.Admin;

Util.Groups["moderator"] = {};
Util.Groups["moderator"].Name = "Mod";
Util.Groups["moderator"].Colour = Colours.Moderator;

Util.Groups["donator"] = {};
Util.Groups["donator"].Name = "Donator";
Util.Groups["donator"].Colour = Colours.Donator;

Util.Groups["user"] = {};
Util.Groups["user"].Name = "User";
Util.Groups["user"].Colour = Colours.User;

function Util.GetUserGroupInfo(group)
	local result = Util.Groups[group];
	
	if (result == nil) then
		result = Util.Groups["user"];
	end

	return result;
end

function Util.IsModerator(ply)
    return (ply:IsAdmin() || ply:GetUserGroup() == "moderator");
end
 
function meta:IsModerator()
    return Util.IsModerator(self);
end

function Util.IsDonator(ply)
    return (ply:GetUserGroup() == "donator" || ply:IsAdmin());
end
 
function meta:IsDonator()
    return Util.IsDonator(self);
end

function Util.IsVeteran(ply)
	if SERVER then
	    return (string.lower(ply:GetSetting(PlayerSettings.Enums.TAG_NAME)) == "donator" || ply:IsDonator());
	else
	    return (string.lower(ply:GetNWString(PlayerSettings.Enums.TAG_NAME)) == "donator" || ply:IsDonator());
	end
end
 
function meta:IsVeteran()
    return Util.IsVeteran(self);
end
