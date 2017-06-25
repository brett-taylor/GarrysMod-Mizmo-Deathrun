local CutsceneSystem = {}

-- "Cutscene State"
-- Player:RunCutscene(tableOfPositions)
-- Each row has posiiton and if it teleports.
-- if no teleport lerp camera from oldposition to new position.
-- If teleport fade screen to black teleport camera then unfade and go to next?
-- That stuff is client yea probably
-- Server would just handle sending a net message to the client with the table?
-- Shared file with the structure probably of.
/*
	local CutScene = {}
	CutScene[1] = {pos, true/false};
	CutScene[2] = {pos, true/false};
	CutScene[3] = {pos, true/false};
*/

-- Probably more of the introduction system?
-- System to add positions to datbaase w/ command
-- Server should probably handle lodaing those from database
-- Nice "Welcome To Mizmo-Gaming test in foreground"
-- Moving camera in backgorund
-- Flashing press enter to continue sort of thing?
-- Should also be the afk system?
-- Could maybe use this system (or part of the system with locking/lerping the camera) for the round warmup introducing deaths thing
