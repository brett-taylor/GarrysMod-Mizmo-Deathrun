PlayerSettings = {};
PlayerSettings.Enums = {};

PlayerSettings.Enums.IS_DEBUGGING = {
	Name = "IS_DEBUGGING";
	ID = 1;
	Default = 0;
	IsNetworked = true;
};

PlayerSettings.Enums.THIRD_PERSON = {
	Name = "THIRD_PERSON";
	ID = 2;
	Default = 1;
	IsNetworked = true;
};

PlayerSettings.Enums.AUTO_JUMP = {
	Name = "AUTO_JUMP";
	ID = 3;
	Default = 1;
	IsNetworked = true;
};

PlayerSettings.Enums.EXPERIENCE = {
	Name = "EXPERIENCE";
	ID = 4;
	Default = 1;
	IsNetworked = true;
};

PlayerSettings.Enums.PLAY_TIME = {
	Name = "PLAY_TIME";
	ID = 5;
	Default = 1;
	IsNetworked = true;
};

for k, v in pairs(PlayerSettings.Enums) do
	PlayerSettings.Enums[v.ID] = v;
	PlayerSettings.Enums[k] = v;
end