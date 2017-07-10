if (Util == nil) then
	Util = {};
end

Util.Groups = {};
Util.Groups["superadmin"] = {};
Util.Groups["superadmin"].Name = "Owner";
Util.Groups["superadmin"].Colour = Colours.Superadmin;

Util.Groups["admin"] = {};
Util.Groups["admin"].Name = "Admin";
Util.Groups["admin"].Colour = Colours.Admin;

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