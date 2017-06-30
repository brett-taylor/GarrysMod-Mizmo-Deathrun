CameraController.Data = {}

CameraController.Data.CutsceneData = {}
CameraController.Data.CutsceneData.Name = nil;
CameraController.Data.CutsceneData.Nodes = {};

CameraController.Data.CutsceneNode = {}
CameraController.Data.CutsceneNode.Position = nil;
CameraController.Data.CutsceneNode.Angle = nil;
CameraController.Data.CutsceneNode.ShouldTeleport = 0;

function CameraController.Data.CreateNecessarilyDatabaseTables()
	if not (sql.TableExists("Mizmo_CutScene")) then
		sql.Query("Create Table Mizmo_CutScene (CutsceneName varchar(255), PositionX varchar(255), PositionY varchar(255), PositionZ varchar(255), AngleX varchar(255), AngleY varchar(255), AngleZ varchar(255), ShouldTeleport varchar(255))");
	end
end
CameraController.Data.CreateNecessarilyDatabaseTables();

function CameraController.Data.LoadCutSceneFromDatabase(nameOfCutscene)
	local result = sql.Query("Select CutsceneName, PositionX, PositionY, PositionZ, AngleX, AngleY, AngleZ, ShouldTeleport From Mizmo_CutScene Where CutsceneName='" ..nameOfCutscene.. "'");
	if (result ~= nil) then
		local newCutsceneData = table.Copy(CameraController.Data.CutsceneData);
		newCutsceneData.Name = nameOfCutscene;
		for i=1, #result do
			resultElement = result[i];
			local newNode = table.Copy(CameraController.Data.CutsceneNode)
			newNode.Position = Vector(resultElement["PositionX"], resultElement["PositionY"], resultElement["PositionZ"]);
			newNode.Angle = Angle(resultElement["AngleX"], resultElement["AngleY"], resultElement["AngleZ"]);
			newNode.ShouldTeleport = tonumber(resultElement["ShouldTeleport"]);
			newCutsceneData.Nodes[i] = newNode;
		end
		return newCutsceneData;
	end
end

function CameraController.Data.AddNewCutscenePosition(cutsceneName, position, angle, shouldTeleport)
	if (shouldTeleport == nil) then
		shouldTeleport = 0;
	end

	if (shouldTeleport == true) then
		shouldTeleport = 1;
	end

	if (shouldTeleport == false) then
		shouldTeleport = 0;
	end

	if (cutsceneName == nil || position == nil || angle == nil) then
		return;
	end

	sql.Query(string.format(
		"Insert Into Mizmo_CutScene (CutsceneName, PositionX, PositionY, PositionZ, AngleX, AngleY, AngleZ, ShouldTeleport) Values ('%s', '%s', '%s', '%s', '%s', '%s', '%s', '%s')", 
		cutsceneName, position.x, position.y, position.z, angle.x, angle.y, angle.z, shouldTeleport
	));
end

function CameraController.Data.SaveCutsceneDataToFile(cutsceneName)
	if (CameraController.Data.DoesCutsceneExist(cutsceneName) == false) then
		return;
	end

	file.CreateDir("Mizmo-Cutscene-Print/");
	local sqlStrings = CameraController.Data.GetCutsceneToSQL(cutsceneName);
	file.Delete("Mizmo-Cutscene-Print/"..cutsceneName..".txt");
	
	for i=1, #sqlStrings do
		file.Append("Mizmo-Cutscene-Print/"..cutsceneName..".txt", sqlStrings[i]);
	end
end

function CameraController.Data.GetCutsceneToSQL(cutsceneName)
	local sqlStrings = {};
	local result = sql.Query("Select CutsceneName, PositionX, PositionY, PositionZ, AngleX, AngleY, AngleZ, ShouldTeleport From Mizmo_CutScene Where CutsceneName='" ..cutsceneName.. "'");
	if (result ~= nil) then
		for i=1, #result do
			sqlStrings[i] = string.format(
				"Insert Into Mizmo_CutScene (CutsceneName, PositionX, PositionY, PositionZ, AngleX, AngleY, AngleZ, ShouldTeleport) Values ('%s', '%s', '%s', '%s', '%s', '%s', '%s', '%s')", 
				cutsceneName, result[i]["PositionX"], result[i]["PositionY"], result[i]["PositionZ"], result[i]["AngleX"], result[i]["AngleY"], result[i]["AngleZ"], result[i]["ShouldTeleport"]);

			sqlStrings[i] = sqlStrings[i].."; \n";
		end
		return sqlStrings;
	end
end

function CameraController.Data.DoesCutsceneExist(cutsceneName)
	local result = sql.Query("Select CutsceneName, PositionX, PositionY, PositionZ, AngleX, AngleY, AngleZ, ShouldTeleport From Mizmo_CutScene Where CutsceneName='" ..cutsceneName.. "'");

	if (result == nil) then
		return false;
	else
		return true;
	end
end

function CameraController.Data.SaveAllCutscenes()
	file.CreateDir("Mizmo-Cutscene-Print/");
	file.Delete("Mizmo-Cutscene-Print/AllCutscenesInformation.txt");

	local sqlStrings = {};
	local result = sql.Query("Select CutsceneName, PositionX, PositionY, PositionZ, AngleX, AngleY, AngleZ, ShouldTeleport From Mizmo_CutScene");

	if (result ~= nil) then
		for i=1, #result do
			sqlStrings[i] = string.format(
				"Insert Into Mizmo_CutScene (CutsceneName, PositionX, PositionY, PositionZ, AngleX, AngleY, AngleZ, ShouldTeleport) Values ('%s', '%s', '%s', '%s', '%s', '%s', '%s', '%s')", 
				result[i]["CutsceneName"], result[i]["PositionX"], result[i]["PositionY"], result[i]["PositionZ"], result[i]["AngleX"], result[i]["AngleY"], result[i]["AngleZ"], result[i]["ShouldTeleport"]);

			sqlStrings[i] = sqlStrings[i].."; \n";
		end
	end

	for i=1, #sqlStrings do
		file.Append("Mizmo-Cutscene-Print/AllCutscenesInformation.txt", sqlStrings[i]);
	end
end