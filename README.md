# Mizmo-Gaming Deathrun
A deathrun server for Garry's mod.
Based on the deathrun mode found [here](https://github.com/Arizard/deathrun) with a few changes.
Do whatever you want with this.

### Dependencies
Never tested in different environments - so there may be more:
- ULX

### Changes
This deathrun comes with many changes from the original to fit Mizmo-Gaming's needs. Points are explained in more details futher down the file.
- Refractored folder/code layout.
- Player Settings
- Unique Rounds System
- Cutscene system
- Selective Autojump
- Level System
- Notification System
- Custom Pointshop skin
- Roll The Dice
- HUD / Scoreboard
- Chat system
- There's more

### Setup
- Download the .zip of this repository
- Set the gamemode up like any regular Garry's Mod gamemode.

### Player Settings
Will automatically save and load data that is stored in the server's database. Very useful for quickly adding details about players that must be remembered across play sessions. Alot of our systems rely on this.
##### Player Settings Stored Data
Stored in gamemode/PlayerSettings/sh_PlayerSettingsEnums.lua. These are currently all the data that will be saved about players.
##### Player Settings Stored Data Example
You should be able to add your own very easy as you can always just follow the template given below:
```lua
PlayerSettings.Enums.IS_DEBUGGING = {
	Name = "IS_DEBUGGING";
	ID = 1;
	Default = 0;
	IsNetworked = true;
};
```
- 1st line: We declare the new data in this case called IS_DEBUGGING. This is the name we will refer to in our programming.
- 2nd line: The value Name is the name of the database column and how we access it through commands.
- 3rd line: This should be a unique ID. 
- 4th line: The starting value that it is set to for a new player. This can be a string or a number.
- 5th line: If the IsNetworked value is true then the player's client will be told about this setting.
##### Changing Player Settings Through gLua.
The following api call should be made:
```lua
player:SetSetting(PlayerSettingEnum.Name, NewValue);
```
- player - the player this will be enacted upon.
- PlayerSettingEnum - The setting that will be changed. NOTE: You should be using the name value of the setting.
- NewValue - the new value of this setting.

The following are examples used throughout the game:
- Turning thirdperson on
- Turning the player's chat colour to white.
- Turning off the player's autojump
```lua
callingPlayer:SetSetting(PlayerSettings.Enums.THIRD_PERSON.Name, 1);
ply:SetSetting(PlayerSettings.Enums.CHAT_COLOUR.Name, "255-255-255");
callingPlayer:SetSetting(PlayerSettings.Enums.AUTO_JUMP.Name, 0);
```

##### Changing Player Settings Through ULX.
It is possible to change player settings through a ULX command as well. The following syntax should:
- from the chat
```
!playersetting person_name player_setting_name_value new_value
```
- from the console
```
ulx playersetting person_name player_setting_name_value new_value
```
Examples:
- Turning on the player's autojump
- Setting the player's chat colour to green.
- Setting the player's experience to 5000 (level 15)
- Setting the player's HUD to pink.
```
!playersetting waisie AUTO_JUMP 1
!playersetting waisie CHAT_COLOUR "0-255-0"
!playersetting waisie EXPERIENCE 5000
!playersetting waisie HUD_COLOUR "255-150-150"
```

##### Getting current player setting values through gLua and ULX
Similar to the set settings ulx commands youu can get the current settings by doing the same command but without the new value.
```
!playersetting waisie AUTO_JUMP 
!playersetting waisie CHAT_COLOUR
!playersetting waisie EXPERIENCE
!playersetting waisie HUD_COLOUR
```

Through gLUA the following function should be called:
```lua
PlayerSettings.GetSetting(player, setting_name)
```

### Unique Round System
Mizmo-Gaming comes with a unique round system. There are currently three unique rounds in the game. You can add more really easily. Currently there are:
- No autojump rounds
    + In these rounds auto jump is off for everybody.
- Blind movement rounds
    + The faster the person moves the more blind they get. Players must stop to regain their vision.
- Traffic Light rounds
    - Like traffic lights found in some maps. When it is green the player can move. When it is red the player will be hurt if they move.

##### Adding a unique round:
0. Every time you see YOUR_UNIQUE_ROUND_NAME_HERE change it to what you are calling this type of unique round.
1. Go to gamemode/UniqueRounds/Specials and create a sv_YOUR_UNIQUE_ROUND_NAME_HERE.lua and if needed a cl_YOUR_UNIQUE_ROUND_NAME_HERE.lua
2. Then go to gamemode/UniqueRounds/ and open up sv_uniqueRounds.lua go to the bottom and add
```lua
include("Specials/sv_YOUR_UNIQUE_ROUND_NAME_HERE.lua");
```
3. If you DID NOT make a cl_YOUR_UNIQUE_ROUND_NAME_HERE.lua go to step 6:
4. Where you added the line in step 2 add the following line under it:
```lua
AddCSLuaFile("Specials/cl_YOUR_UNIQUE_ROUND_NAME_HERE.lua");
```
5. Open up cl_UniqueRounds.lua found in the same directory as step 2 and at the bottom add.
```lua
include("Specials/cl_YOUR_UNIQUE_ROUND_NAME_HERE.lua");
```
6. In sv_YOUR_UNIQUE_ROUND_HERE.lua add the following framework:
```lua
local UniqueRound = {};
UniqueRound.Name = "The name of your unique round";
UniqueRound.Help = "Explain the round here";

UniqueRound.OnRoundPrep = function()
	-- This is called when the round is preparing
end

UniqueRound.OnRoundStart = function()
-- This is called when the round is about to start
end

UniqueRound.OnRoundEnd = function()
-- This is called when the round is ending
end

UniqueRound.Think = function()
-- This is called every frame
end

UniqueRounds.AddType(UniqueRound.Name, UniqueRound.Help, UniqueRound.OnRoundPrep, UniqueRound.OnRoundStart, UniqueRound.OnRoundEnd, UniqueRound.Think);
```

You should look at the current 3 examples given to learn more.

### Cutscene System
![Picture](https://i.imgur.com/XTdHlB4.png)
The cutscene system is pretty advanced but is currently only used to show introduction cut scenes when a player first joins.

The following commands are avaliable in ulx related to the cutscene system:

##### Will add a node to the introduction cutscene:
Arguments:
should_teleport - True the camera will teleport to this node rather than move towards it. Will fade screen to black.
```
!addintroductionnode should_teleport
```

##### Will add a node to the given cutscene:
Arguments:
cutscene_name - The name of the cutscene
should_teleport - True the camera will teleport to this node rather than move towards it. Will fade screen to black.
```
!addcutscenenode cutscene_name should_teleport
```

##### Will save the introduction cut scene to the database.
```
!saveintroduction
```

##### Will save the given cut scene to the database.
Arguments:
cutscene_name - The name of the cutscene
```
!saveintroduction cutscene_name
```

##### Will save all cut scenes to the database.
```
!saveallcutscenes
```

Currently no way to run cutscenes through commands but through gLua it would be:
```lua
player:RunCutscene(name_of_cutscene)
CameraController.RunCutscene(player, name_of_cutscene);
```

### Selective Autojump
Autojump depends on the player's autojump setting being set to one. Autojump is also turned off if it is a unique round.

### Level System
Level system uses the player settings system EXPERIENCE. So you can use all the ULX commands related to player settings to change player's experience etc. Example:
```
!playersetting waisie EXPERIENCE 5000
!playersetting waisie EXPERIENCE
```

The level formula is:
```lua
player_level = math.floor(((player_experience^(1/2)) / 5) + 1);
```

Following api calls SERVER side:
- GetCurrentExp - Get the current exp of a player
- GetCurrentLevel - Get the current level of a player.
- AddExp - Adds the given amount to the player's exp
- SetExp - Sets the exp of a player to the given amount.
- RemoveExp - Removes the given amount from the player's exp

```lua
Experience.GetCurrentExp(player);
Experience.GetCurrentLevel(player);
Experience.AddExp(player, experience_to_add);
Experience.SetExp(player, experience_to_set_to);
Experience.RemoveExp(player, experience_to_remove);

player:AddExp(experience_to_add); 
player:SetExp(experience_to_set_to) ;
player:RemoveExp(experience_to_remove) ;
player:GetExp() ;
```

Following api calls CLIENT side:
- GetCurrentExp - Returns the current experience of the player
- GetCurrentLevel - Returns the current level of the player
- GetExpRequired - Returns the experience needed to the next level
```lua
Experience.GetCurrentExp(ply);
Experience.GetCurrentLevel(ply);
Experience.GetExpRequired(ply);

player:GetCurrentExp();
player:GetCurrentLevel();
player:GetExpRequired();
```

### Notification System
![Picture](https://i.imgur.com/gaUu466.png)
The notification system gives a way to send timed notifications to the user without cluttering the chatbox up.

##### Sending a notification to all the players currently connected.
Arguments:
text - what the notification will say.
seconds - how long the notification will appear for.
```lua
Notify.SendNotificationAll(text, seconds)
```

##### Sending a notification to a specific player
Arguments:
ply - the player that will recieve the notification.
text - what the notification will say.
seconds - how long the notification will appear for.
```lua
Notify.SendNotificationAll(ply, text, seconds)
```

### Custom Pointshop skin
Mizmo-Gaming comes with a custom pointshop skin.

##### Loading Screen
To combat the lag that some players would recieve when they open the pointshop for the first time. It has a one time loading screen to let Garrys Mod load all the resources.
![Picture](https://i.imgur.com/gZIWHGK.png)

##### Category Screen
![Picture](https://i.imgur.com/e7u4ZGA.png)

##### Item Screen
![Picture](https://i.imgur.com/db8YPz3.png)
![Picture](https://i.imgur.com/GPB5der.png)

### Roll The Dice
Mizmo-Gaming comes with a roll the dice system that currently comes with 10 different outcomes. It is a modular system where the user can just add new files that will be specific to that outcome only.

##### Adding a new outcome
1. Go to gamemode/RollTheDice/Outcomes
2. Create a new lua file
3. Copy the following framework:
```lua
local function message()
	-- The message that comes up in chat
	-- Two variables:
		-- namereplace - the player's name
		-- varreplace - the variable given by doit(ply)
    return "namereplace varreplace"
end

local function doit(ply)
	-- This is where you should write the actual outcome code.
	-- If your message() has a varreplace then this method should return what will be replaced there.
    return { some_var };
end

RollTheDice.AddRoll(message, doit);
```

### HUD / Scoreboard
Mizmo-Gaming comes with a custom HUD and scoreboard.
![Picture](https://i.imgur.com/vZJqiEH.png)
![Picture](https://i.imgur.com/2rJCaUm.png)

Note:
- The colour of the hud can be controlled via player settings: HUD_COLOUR
- The colour of the "Rank" on the scoreboard can be controlled via player settings: TAG_COLOUR 
- The text of the "Rank" on the scoreboard can be controlled via player setting: TAG_NAME

### Chat System
![Picture](https://i.imgur.com/ulj4ydX.png)
The chat system in Mizmo-Gaming is highly customisable.
It comes in the following format:
```
[tag_name, team_name] Player_name: what the player typed
```
Points: 
- The tag_name can be controlled via player setting: TAG_NAME
- The colour of the tag_name can be controlled via player setting: TAG_NAME
- The colour of the actual text the player wrote can be changed via player setting: CHAT_COLOUR
- You can use :colour: to change the text of your color. These can be chained up example:
```
:red: hello :blue: git :green: hub
```
- Extra colours can be added at gamemode/Util/sh_ChatColours.lua
