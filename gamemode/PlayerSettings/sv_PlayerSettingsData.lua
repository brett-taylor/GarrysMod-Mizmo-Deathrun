PlayerSettings.Data = {};

function PlayerSettings.Data.CreateTables()
	if not (sql.TableExists("Mizmo_Settings")) then
		sql.Query("Create Table Mizmo_Settings (SteamID varchar(255))");
	end
end
PlayerSettings.Data.CreateTables();

function PlayerSettings.Data.CheckColumnsExist()
	local sqlString = "";
	for i = 1, #PlayerSettings.Enums do
		sqlString = sqlString.."Alter Table Mizmo_Settings Add "..PlayerSettings.Enums[i].Name.." varchar(255); ";
	end

	sql.Query(sqlString);
end
PlayerSettings.Data.CheckColumnsExist();

function PlayerSettings.Data.GetValue(steamID, columnName)
	return sql.QueryValue("Select "..columnName.." From Mizmo_Settings Where SteamID='" ..steamID.. "'");
end

function PlayerSettings.Data.SetValue(steamID, columnName, newValue)
	sql.Query("Update Mizmo_Settings Set '"..columnName.."' = '"..newValue.."' Where SteamID='"..steamID.."'");
end