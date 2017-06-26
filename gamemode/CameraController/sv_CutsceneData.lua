CameraController.Data = {}

CameraController.Data.CutsceneData = {}
CameraController.Data.CutsceneData.Name = nil;
CameraController.Data.CutsceneData.Nodes = {};

CameraController.Data.CutsceneNode = {}
CameraController.Data.CutsceneNode.Position = nil;
CameraController.Data.CutsceneNode.Angle = nil;

function CameraController.Data.CreateNecessarilyDatabaseTables()
	if not (sql.TableExists("Mizmo_CutScene")) then
		sql.Query("Create Table Mizmo_CutScene (CutsceneName varchar(255), PositionX varchar(255), PositionY varchar(255), PositionZ varchar(255), AngleX varchar(255), AngleY varchar(255), AngleZ varchar(255))");
	end
end
CameraController.Data.CreateNecessarilyDatabaseTables();

function CameraController.Data.LoadCutSceneFromDatabase(nameOfCutscene)
	local result = sql.Query("Select CutsceneName, PositionX, PositionY, PositionZ, AngleX, AngleY, AngleZ From Mizmo_CutScene Where CutsceneName='" ..nameOfCutscene.. "'");
	if (result ~= nil) then
		local newCutsceneData = table.Copy(CameraController.Data.CutsceneData);
		newCutsceneData.Name = nameOfCutscene;

		for i=1, #result do
			resultElement = result[i];
			local newNode = table.Copy(CameraController.Data.CutsceneNode)
			newNode.Position = Vector(resultElement["PositionX"], resultElement["PositionY"], resultElement["PositionZ"]);
			newNode.Angle = Vector(resultElement["AngleX"], resultElement["AngleY"], resultElement["AngleZ"]);
			newCutsceneData.Nodes[i] = newNode;
		end

		return newCutsceneData;
	end
end

function CameraController.Data.AddNewCutscenePosition(cutsceneName, position, angle)
	if (cutsceneName == nil || position == nil || angle == nil) then
		return;
	end

	sql.Query(string.format(
		"Insert Into Mizmo_CutScene (CutsceneName, PositionX, PositionY, PositionZ, AngleX, AngleY, AngleZ) Values ('%s', '%s', '%s', '%s', '%s', '%s', '%s')", 
		cutsceneName, position.x, position.y, position.z, angle.x, angle.y, angle.z
	));
end