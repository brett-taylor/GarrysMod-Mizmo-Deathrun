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
		sql.Query("Alter Table Mizmo_Settings Add "..PlayerSettings.Enums[i].Name.." varchar(255);");
	end
end
PlayerSettings.Data.CheckColumnsExist();

function PlayerSettings.Data.GetValue(steamID, columnName)
	return sql.QueryValue("Select "..columnName.." From Mizmo_Settings Where SteamID='" ..steamID.. "'");
end

function PlayerSettings.Data.SetValue(steamID, columnName, newValue)
	sql.Query("Update Mizmo_Settings Set '"..columnName.."' = '"..newValue.."' Where SteamID='"..steamID.."'");
end

function PlayerSettings.Data.CheckValue(steamID, columnName)
	local result = PlayerSettings.Data.GetValue(steamID, columnName);
	if (result == "NULL") then
		PlayerSettings.Data.SetValue(steamID, columnName, PlayerSettings.Enums[columnName].Default);
	end
end

function PlayerSettings.Data.CheckPlayerRow(steamID)
	local result = sql.Query("select 1 from Mizmo_Settings where SteamID = '"..steamID.."'");
	if (result == nil) then
		PlayerSettings.Data.CreatePlayer(steamID);
	end
end

function PlayerSettings.Data.CreatePlayer(steamID)
	local fieldNames = "SteamID, ";
	local valueNames = "'"..steamID.."', '";

	for i = 1, #PlayerSettings.Enums do
			fieldNames = fieldNames..PlayerSettings.Enums[i].Name;
			valueNames = valueNames..PlayerSettings.Enums[i].Default;

		if (i ~= #PlayerSettings.Enums) then
			fieldNames = fieldNames..", ";
			valueNames = valueNames.."', '";
		else
			valueNames = valueNames.."'";
		end
	end

	sql.Query(string.format("Insert into Mizmo_Settings (%s) Values (%s);", fieldNames, valueNames));
end