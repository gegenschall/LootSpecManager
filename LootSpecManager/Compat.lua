local _, Private = ...

local LootSpecManager = Private.LootSpecManager

local Compat = {}
LootSpecManager.Compat = Compat

local RAID_DIFFICULTY_NAME_TO_ID = {
    lfr = 17,
    normal = 14,
    heroic = 15,
    mythic = 16
}

function Compat:ShouldMigrateData()
    return self:GetVersion() ~= nil and not LTSM.migrated
end

function Compat:GetVersion()
    return LTSM.version
end

function Compat:SetMigratedFlag(state)
    LTSM.migrated = state
end

function Compat:GetMappingsForRaidByDifficulty(difficultyString)
    return LTSM.encounters[difficultyString]
end

function Compat:TransformEncounterMappings()
    local mappings = {}

    for difficultyString, difficultyId in pairs(RAID_DIFFICULTY_NAME_TO_ID) do
        local oldMappings = self:GetMappingsForRaidByDifficulty(difficultyString)

        for encounterId, lootSpec in pairs(oldMappings) do
            EJ_SelectEncounter(encounterId)
            local n = EJ_GetEncounterInfo(encounterId)
            print(encounterId, n)
        end

        mappings[difficultyId] = oldMappings
    end

    return mappings
end