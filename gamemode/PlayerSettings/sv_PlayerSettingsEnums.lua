PlayerSettings = PlayerSettings or {};
PlayerSettings.Enums = {};

PlayerSettings.Enums.IS_DEBUGGING = {
	Name = "IS_DEBUGGING";
	ID = 1;
	Default = false;
};

PlayerSettings.Enums.THIRD_PERSON = {
	Name = "THIRD_PERSON";
	ID = 2;
	Default = true;
};

PlayerSettings.Enums.AUTO_JUMP = {
	Name = "AUTO_JUMP";
	ID = 3;
	Default = true;
};

for k, v in pairs(PlayerSettings.Enums) do
	PlayerSettings.Enums[v.ID] = v;
	PlayerSettings.Enums[k] = v;
end