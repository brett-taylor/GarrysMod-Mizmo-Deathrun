local meta = FindMetaTable( "Player" );

function meta:RunCutscene(name)
	CameraController.RunCutscene(self, name);
end