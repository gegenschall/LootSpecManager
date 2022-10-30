local AddonName, Private = ...

local LootSpecManager = Private.LootSpecManager

LootSpecManager.Options = {
    name = AddonName,
    handler = LootSpecManager,
    type = 'group',
    args = {
        migrate = {
            name = "Migrate from v1",
            desc = "Try to migrate from addon v1. Unsupported and buggy!",
            type = "execute",
            func = "Migration",
            guiHidden = true
        },
        resetMigration = {
            name = "Reset Migration State",
            desc = "Reset the v1 migration state, reload to restart migration.",
            type = "execute",
            func = "ResetMigration",
            guiHidden = true
        }
    }
}