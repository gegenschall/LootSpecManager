local _, Private = ...

local LootSpecManager = Private.LootSpecManager

local Gui = {}
LootSpecManager.Gui = Gui

local function AddDropDownOption(name, specId, callback)
    local info = UIDropDownMenu_CreateInfo()
    info.func = callback
    info.text = name
    info.value = specId
    info.arg1 = specId
    UIDropDownMenu_AddButton(info)
end

local function LootSpecDropdownInit()
    AddDropDownOption(
        LootSpecManager.CURRENT_LOOT_SPEC_NAME,
        LootSpecManager.CURRENT_LOOT_SPEC,
        function ()
            Gui:OnLootSpecDropdownItemClick(LootSpecManager.CURRENT_LOOT_SPEC)
        end)

	for i = 1, GetNumSpecializations() do
        local specId, name = GetSpecializationInfo(i)
        AddDropDownOption(name, specId, function ()
            Gui:OnLootSpecDropdownItemClick(specId)
        end)
    end
end

function Gui:OnLootSpecDropdownItemClick(specId)
    if self.isEncounter then
        LootSpecManager:SetLootSpecForEncounter(self.encounterId, self.difficultyId, specId)
        Gui:UpdateEncounterLootSpecDropdown(self.encounterId, self.difficultyId)
    else
        LootSpecManager:SetLootSpecForMap(self.mapId, self.difficultyId, specId)
        Gui:UpdateInstanceLootSpecDropdown(self.mapId, self.difficultyId)
    end
end

function Gui:CreateLootSpecDropdown()
    self.button = CreateFrame(
        "DropDownToggleButton", 
        "$parentLootSpec", 
        EncounterJournalEncounterFrameInfo, 
        "EJButtonTemplate"
    )

    self.button:SetPoint("RIGHT", EncounterJournalEncounterFrameInfoResetButton, "LEFT", 16, 0)
    self.button:SetWidth(18)
    self.button:SetHeight(26)
    self.button:SetFrameLevel(10)

    self.dropdownMenu = CreateFrame("Frame", "$parentSpecDD", self.button, "UIDropDownMenuTemplate")
    
    UIDropDownMenu_Initialize(self.dropdownMenu, LootSpecDropdownInit, "MENU");

    self.button:SetScript("OnMouseDown", function ()
        ToggleDropDownMenu(1, nil, self.dropdownMenu, self.button, 0, 0)
    end)
end

function Gui:UpdateEncounterLootSpecDropdown(encounterId, difficultyId)
    local lootSpecForEncounter = LootSpecManager:GetLootSpecForEncounter(encounterId, difficultyId)

    self.isEncounter = true
    self.encounterId = encounterId
    self.difficultyId = difficultyId

    local specName = LootSpecManager.CURRENT_LOOT_SPEC_NAME
    if lootSpecForEncounter > 0 then
        _, specName = GetSpecializationInfoByID(lootSpecForEncounter)
    end

    self.button:SetText(specName)
    UIDropDownMenu_SetSelectedValue(self.dropdownMenu, lootSpecForEncounter)

    self.button:Show()
end

function Gui:UpdateInstanceLootSpecDropdown(mapId, difficultyId)
    local lootSpecForInstance = LootSpecManager:GetLootSpecForMap(mapId, difficultyId)

    self.isEncounter = false
    self.mapId = mapId
    self.difficultyId = difficultyId

    local specName = LootSpecManager.CURRENT_LOOT_SPEC_NAME
    if lootSpecForInstance > 0 then
        _, specName = GetSpecializationInfoByID(lootSpecForInstance)
    end

    self.button:SetText(specName)
    UIDropDownMenu_SetSelectedValue(self.dropdownMenu, lootSpecForInstance)

    self.button:Show()
end

function Gui:HideLootSpecDropDown()
    self.button:Hide()
end
