util.AddNetworkString("MizmoThirdPerson");
util.AddNetworkString("MizmoRequestThirdPersonSetting");
ThirdPersonSystemServer = {};

net.Receive("MizmoRequestThirdPersonSetting", function(len, ply)
	ThirdPersonSystemServer.SendSettingToPlayer(ply);
end)

function ThirdPersonSystemServer.CreateNecessarilyDatabaseTables(ply)
		if not (sql.TableExists("Mizmo_Settings")) then
		sql.Query("Create Table Mizmo_Settings (ID varchar(255), ThirdPersonOn varchar(255))");
	end
end

function ThirdPersonSystemServer.SendSettingToPlayer(ply)
	/*local result = sql.Query("Select ThirdPersonOn From Mizmo_Settings Where ID='" ..ply:SteamID().. "'");
	if (result ~= nil) then
		local thirdPersonOnResult = tonumber(result[1]["ThirdPersonOn"]);

		if (thirdPersonOnResult == 0 || thirdPersonOnResult == 1) then
			net.Start("MizmoThirdPerson");
				if (thirdPersonOnResult == 0) then
					net.WriteBool(false);
				else
					net.WriteBool(true);
				end
			net.Send(ply);
		end
	end*/
end