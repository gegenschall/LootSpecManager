local AddonName, Private = ...

local AceAddon = LibStub("AceAddon-3.0")
local AceDB = LibStub("AceDB-3.0")
local AceConfig = LibStub("AceConfig-3.0")
local AceDBOptions = LibStub("AceDBOptions-3.0")
local AceConfigDialog = LibStub("AceConfigDialog-3.0")

local LootSpecManager = AceAddon:NewAddon(AddonName, "AceConsole-3.0", "AceHook-3.0", "AceEvent-3.0")

Private.LootSpecManager = LootSpecManager

local defaultSettings = {
    profile = {
        version = LootSpecManager.SETTINGS_VERSION,
        encounter = {},
        instance = {}
    }
}

function LootSpecManager:SetLootSpecForEncounter(encounterId, difficultyId, lootSpecId)
    print("set", encounterId, difficultyId, lootSpecId)
    local encounters = self.savedVariables.profile.encounter[difficultyId] or {}

    encounters[encounterId] = lootSpecId

    self.savedVariables.profile.encounter[difficultyId] = encounters
end

function LootSpecManager:GetLootSpecForEncounter(encounterId, difficultyId)
    local encounters = self.savedVariables.profile.encounter[difficultyId] or {}

    return encounters[encounterId] or LootSpecManager.CURRENT_LOOT_SPEC
end

function LootSpecManager:GetLootSpecForMap(mapId, difficultyId)
    local instances = self.savedVariables.profile.instance[difficultyId] or {}

    return instances[mapId] or LootSpecManager.CURRENT_LOOT_SPEC
end

function LootSpecManager:SetLootSpecForMap(mapId, difficultyId, lootSpecId)
    local instances = self.savedVariables.profile.instance[difficultyId] or {}

    instances[mapId] = lootSpecId

    self.savedVariables.profile.instance[difficultyId] = instances
end

function LootSpecManager:Migrate()
    if LootSpecManager.Compat:ShouldMigrateData() then
        LootSpecManager:Print('Found LootSpecManager v1 data. Migrating...')

        local raidMappings = self.Compat:TransformEncounterMappings()

        self.savedVariables.profile.encounter = raidMappings

        self.Compat:SetMigratedFlag(true)
    end
end

function LootSpecManager:ResetMigration()
    self.Compat:SetMigratedFlag(false)
end

function LootSpecManager:OnInitialize()
    LootSpecManager:Print('Initializing Addon')

    -- Initialize savedVariables, use defaults and use default profile named by character
    self.savedVariables = AceDB:New(AddonName, defaultSettings)

    -- Hook up profiles into options
    LootSpecManager.Options.args.profile = AceDBOptions:GetOptionsTable(self.savedVariables)
    AceConfigDialog:AddToBlizOptions(AddonName);

    -- Initialize slash command options
    AceConfig:RegisterOptionsTable(AddonName, LootSpecManager.Options, {"ltsm"})
end

function LootSpecManager:OnAddonLoaded(_, addonName)
    if addonName == "Blizzard_EncounterJournal" then
        LootSpecManager:HookScript(EncounterJournal, "OnShow", "HookEncounterJournalShow")
        LootSpecManager:SecureHook("EncounterJournal_DisplayInstance", "HookDisplayInstance")
        LootSpecManager:SecureHook("EncounterJournal_DisplayEncounter", "HookDisplayEncounter")
    end
end

function LootSpecManager:OnEncounterStart(_, encounterId, encounterName, difficultyId)
    -- This will trigger on bosskills in M+ dungeons and then erroneously overwrite loot spec
    -- We also don't want to do anything when legacy loot is enabled
    -- if C_ChallengeMode.IsChallengeModeActive() or C_Loot.IsLegacyLootModeEnabled() then
    if C_ChallengeMode.IsChallengeModeActive() then
        return
    end

    local requestedLootSpec = self:GetLootSpecForEncounter(encounterId, difficultyId)

    if requestedLootSpec == LootSpecManager.CURRENT_LOOT_SPEC then
        return
    end

    SetLootSpecialization(requestedLootSpec)
    local _, specializationName = GetSpecializationInfoByID(requestedLootSpec)

    LootSpecManager:Printf('%s engaged, loot spec changed to %s', encounterName, specializationName)
end

function LootSpecManager:OnMythicPlusStart(_, mapId)
    local requestedLootSpec = self:GetLootSpecForMap(mapId)

    if requestedLootSpec == LootSpecManager.CURRENT_LOOT_SPEC then
        return
    end

    SetLootSpecialization(requestedLootSpec)
    local _, specializationName = GetSpecializationInfoByID(requestedLootSpec)
    local _, mapName = C_Map.GetMapInfo(mapId)

    LootSpecManager:Printf('M+ dungeon %s started, loot spec changed to %s', mapName, specializationName)
end

function LootSpecManager:HookDisplayEncounter(encounterJournalId)
    local currentDifficulty = EJ_GetDifficulty()
    local _, _, _, _, _, _, encounterId = EJ_GetEncounterInfo(encounterJournalId)

    self.Gui:UpdateEncounterLootSpecDropdown(encounterId, currentDifficulty)
end

function LootSpecManager:HookDisplayInstance(instanceId)
    if EJ_InstanceIsRaid() then
        self.Gui:HideLootSpecDropDown()
        return
    end

    local difficultyId = EJ_GetDifficulty()
    local _, _, _, _, _, _, _, _, _, mapId = EJ_GetInstanceInfo(instanceId)

    self.Gui:UpdateInstanceLootSpecDropdown(mapId, difficultyId)
end

function LootSpecManager:HookEncounterJournalShow()
    self.Gui:CreateLootSpecDropdown()
end

LootSpecManager:RegisterEvent("ADDON_LOADED", "OnAddonLoaded")
LootSpecManager:RegisterEvent("ENCOUNTER_START", "OnEncounterStart")
LootSpecManager:RegisterEvent("CHALLENGE_MODE_START", "OnMythicPlusStart")
-- LootSpecManager:RegisterEvent("CHALLENGE_MODE_COMPLETED", "OnMythicPlusCompleted")
