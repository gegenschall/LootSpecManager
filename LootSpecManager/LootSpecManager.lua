local ltsm

LTSM_API = {}

---
-- Mapping from the ENCOUNTER_START difficulty parameter to difficulty table names.
LTSM_API.difficulties = {
  [17] = "lfr",
  [1] = "normal", --dungeons
  [14] = "normal", --raids
  [2] = "heroic", --dungeons
  [15] = "heroic", --raids
  [23] = "mythic", --dungeons
  [16] = "mythic", --raids
}

---
-- Mapping from difficulty table names to the ENCOUNTER_START difficulty parameter.
LTSM_API.reverse_difficulties = {
  lfr = 17,
  normal = 1,
  heroic = 2,
  mythic = 23
}

---
-- Retrieves the loot spec setting for a specific encounter and difficulty.
-- @param encounter Encounter ID from ENCOUNTER_START.
-- @param difficulty (optional) Difficulty parameter from ENCOUNTER_START.
-- @return Spec ID for the encounter and difficulty. Returns SPEC_DONT_CARE if the setting doesn't exist.
function LTSM_API:get_spec_for_encounter(encounter, difficulty)
  difficulty = self.difficulties[difficulty]
  local table = ltsm.encounters[difficulty]
  if table == nil then
    return LTSM_DATA.SPEC_DONT_CARE
  end
  local spec = table[encounter]
  if spec == nil then
    spec = LTSM_DATA.SPEC_DONT_CARE
  end
  return spec
end

---
-- Sets the active table used for settings management.
-- All settings changes will occur in this table.
-- @param difficulty A difficulty table name.
function LTSM_API:set_active_settings_difficulty(difficulty)
  if ltsm.encounters[difficulty] == nil then
    error("Difficulty table doesn't exist: " .. difficulty)
  end
  ltsm.current = difficulty
  LTSM_GUI:refresh()
end

---
-- Sets the spec setting for an encounter in the current difficulty table.
-- @param encounter Encounter ID from ENCOUNTER_START.
-- @param spec Spec ID to set the encounter setting to.
function LTSM_API:set_spec_setting(encounter, spec)
  ltsm.encounters[ltsm.current][encounter] = spec
end

---
-- Retrieves the default loot spec setting.
-- @return Default loot spec ID.
function LTSM_API:get_default_spec()
  return ltsm.default
end

---
-- Sets the default loot spec setting.
-- @param spec Spec ID to set the default to.
function LTSM_API:set_default_spec(spec)
  ltsm.default = spec
end

---
-- Retrieves the spec setting for a M+ dungeon.
-- @param map Primary map ID from LTSM_DATA.
-- @return Spec ID for the end-of-key box.
function LTSM_API:get_mythicplus_spec(map)
  return ltsm.mythicplus[map] or LTSM_DATA.SPEC_DONT_CARE
end

---
-- Sets the spec setting for a M+ dungeon.
-- @param map Primary map ID from LTSM_DATA.
-- @param spec Spec ID for the end-of-key box.
function LTSM_API:set_mythicplus_spec(map, spec)
  ltsm.mythicplus[map] = spec
end

---
-- Copies settings from one difficulty table to another.
-- @param from Difficulty table name to copy from.
-- @param to Difficulty table name to copy to.
function LTSM_API:copy_settings(from_name, to_name)
  local from = ltsm.encounters[from_name]
  if from == nil then
    error("Difficulty table doesn't exist: " .. from_name)
  end

  if from_name == to_name then
    print(("[LTSM] Not bothering to copy settings from %s to %s"):format(from_name, to_name))
    return
  end

  print(("[LTSM] Copying settings from %s to %s"):format(from_name, to_name))
  ltsm.encounters[to_name] = {}
  local to = ltsm.encounters[to_name]
  for k, v in pairs(from) do
    to[k] = v
  end
end

-- END API --

local function set_spec(spec)
  if spec == LTSM_DATA.SPEC_DONT_CARE then
    return false
  end
  SetLootSpecialization(spec)
  return true
end

local events = {}

function events:PLAYER_LOGIN()
  LTSM = LTSM or {}
  ltsm = LTSM
  LTSM_DATA:check_version()
  LTSM_GUI:init()
end

function events:ENCOUNTER_START(id, _, difficulty)
  if C_ChallengeMode.GetActiveKeystoneInfo() ~= 0 then
    return
  end
  if set_spec(LTSM_API:get_spec_for_encounter(id, difficulty)) then
    print(("[LTSM] Boss pulled. Spec changed."):format(id))
  end
end

function events:ENCOUNTER_END()
  if C_ChallengeMode.GetActiveKeystoneInfo() ~= 0 then
    return
  end
  set_spec(LTSM_API:get_default_spec())
end

local next_azerite_is_mp_box = false

function events:CHALLENGE_MODE_COMPLETED()
  local map = C_ChallengeMode.GetCompletionInfo()
  if set_spec(LTSM_API:get_mythicplus_spec(map)) then
    print("[LTSM] M+ finished. Spec changed. Looting the box will change it back to the default spec.")
  end
  next_azerite_is_mp_box = true
end

function events:AZERITE_ITEM_EXPERIENCE_CHANGED()
  if next_azerite_is_mp_box then
    print("[LTSM] M+ box looted. Swapping to the default spec.")
    next_azerite_is_mp_box = false
    set_spec(LTSM_API:get_default_spec())
  end
end

local frame = CreateFrame("Frame");
frame:SetScript("OnEvent", function(self, event, ...)
  return events[event](self, ...)
end)
for k, _ in pairs(events) do
  frame:RegisterEvent(k)
end

SLASH_LOOTSPECMANAGER1 = "/ltsm"
SlashCmdList["LOOTSPECMANAGER"] = function()
  LTSM_GUI.frame:Show()
end
