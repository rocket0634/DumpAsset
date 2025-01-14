--[[
    init.lua
    Created: 02/08/2023 20:34:57
    Description: Autogenerated script file for the map moonlit_end.
]]--
-- Commonly included lua functions and data
require 'common'

-- Package name
local moonlit_end = {}

-- Local, localized strings table
-- Use this to display the named strings you added in the strings files for the map!
-- Ex:
--      local localizedstring = MapStrings['SomeStringName']
local MapStrings = {}

-------------------------------
-- Map Callbacks
-------------------------------
---moonlit_end.Init
--Engine callback function
function moonlit_end.Init(map)

  --This will fill the localized strings table automatically based on the locale the game is 
  -- currently in. You can use the MapStrings table after this line!
  MapStrings = COMMON.AutoLoadLocalizedStrings()

end

---moonlit_end.Enter
--Engine callback function
function moonlit_end.Enter(map)
  if SV.moonlit_end.ExpositionComplete then
    moonlit_end.PrepareReturnVisit()
  end
  
  UI:WaitShowTitle(GAME:GetCurrentGround().Name:ToLocal(), 20)
  GAME:WaitFrames(30)
  UI:WaitHideTitle(20)
  GAME:FadeIn(20)

end


--------------------------------------------------
-- Map Setup Functions
--------------------------------------------------
function moonlit_end.PrepareReturnVisit()
  GROUND:Hide("Cutscene_Trigger")
  GROUND:Hide("Cresselia")
end

-------------------------------
-- Entities Callbacks
-------------------------------

function moonlit_end.Cutscene_Trigger_Touch(obj, activator)
  DEBUG.EnableDbgCoro() --Enable debugging this coroutine
  local cresselia = CH('Cresselia')
  
  
  GAME:CutsceneMode(true)
  -- move camera up a little more: center at 196, 264
  GAME:MoveCamera(204, 192, 60, false)
  
  UI:WaitShowDialogue(STRINGS:Format(MapStrings['Expo_Cutscene_Line_001']))
  
  local mon_id = RogueEssence.Dungeon.MonsterID("cresselia", 0, "normal", Gender.Genderless)
  local player = _DATA.Save.ActiveTeam:CreatePlayer(_DATA.Save.Rand, mon_id, 30, "", 0)
  player.MetAt = _ZONE.CurrentGround:GetColoredName()
  player.MetLoc = RogueEssence.Dungeon.ZoneLoc(_ZONE.CurrentZoneID, _ZONE.CurrentMapID)
  _DATA.Save.ActiveTeam.Assembly:Add(player)
  SOUND:PlayFanfare("Fanfare/JoinTeam")
  _DATA.Save:RegisterMonster(mon_id.Species)
  _DATA.Save:RogueUnlockMonster(mon_id.Species)

  UI:ResetSpeaker()
  UI:WaitShowDialogue(STRINGS:Format(RogueEssence.StringKey("MSG_RECRUIT"):ToLocal(), cresselia:GetDisplayName(), _DATA.Save.ActiveTeam.Name))
  
  SV.moonlit_end.ExpositionComplete = true
  
  SOUND:FadeOutBGM()
  GAME:FadeOut(false, 30)
  GAME:CutsceneMode(false)
  GAME:WaitFrames(90)

  COMMON.EndDungeonDay(RogueEssence.Data.GameProgress.ResultType.Cleared, 'guildmaster_island', -1, 3, 2)
end

function moonlit_end.South_Exit_Touch(obj, activator)
  DEBUG.EnableDbgCoro() --Enable debugging this coroutine
  -- ask to complete the dungeon and go back
  UI:ResetSpeaker()
  UI:ChoiceMenuYesNo(STRINGS:FormatKey("DLG_ASK_EXIT_DUNGEON"), false)
  UI:WaitForChoice()
  ch = UI:ChoiceResult()
  if ch then
    SOUND:FadeOutBGM()
    GAME:FadeOut(false, 30)
    GAME:WaitFrames(120)
    
    COMMON.EndDungeonDay(RogueEssence.Data.GameProgress.ResultType.Cleared, 'guildmaster_island', -1, 3, 2)
  end
end


return moonlit_end

