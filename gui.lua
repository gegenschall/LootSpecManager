
local tinsert = table.insert

LTSM_GUI = {}

--{{id, icon}, ...}
local function get_spec_icons()
	local _, _, classid = UnitClass("player")
	local specs = {}
	for k = 1, GetNumSpecializationsForClassID(classid) do
		local id, _, _, icon = GetSpecializationInfoForClassID(classid, k)
		if not id then
			break
		end
		tinsert(specs, {
			id = id,
			icon = icon
		})
	end
	return specs
end

local function clamp(n, min, max)
	if n < min then
		return min
	end
	if n > max then
		return max
	end
	return n
end

local function set_class_icon(frame, classname)
	frame:SetTexture("Interface\\GLUES\\CHARACTERCREATE\\UI-CHARACTERCREATE-CLASSES")
	frame:SetTexCoord(unpack(CLASS_ICON_TCOORDS[classname]))
end

local ROW_VERTICAL_SPACING = 30

local function create_header(parent, title, y)
	local frame = CreateFrame("Frame", nil, parent)
	frame:SetSize(parent:GetWidth(), ROW_VERTICAL_SPACING)
	frame:SetPoint("TOPLEFT", parent, "TOPLEFT", 5, y)
	frame.text = frame:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge")
	frame.text:SetText(title)
	frame.text:SetTextColor(0.9, 0.1, 0.1, 1)
	frame.text:SetAllPoints()
	frame.text:SetJustifyH("LEFT")
	frame.text:SetJustifyV("CENTER")
end

local function create_subheader(parent, title, y)
	local frame = CreateFrame("Frame", nil, parent)
	frame:SetSize(parent:GetWidth() - 30, ROW_VERTICAL_SPACING)
	frame:SetPoint("TOPLEFT", parent, "TOPLEFT", 35, y)
	frame.text = frame:CreateFontString(nil, "ARTWORK", "GameFontNormal")
	frame.text:SetText(title)
	frame.text:SetAllPoints()
	frame.text:SetJustifyH("LEFT")
	frame.text:SetJustifyV("CENTER")
	return frame
end

local function create_spec_row(parent, classname, specs, y)
	function make_spec_display(icon, x)
		local frame = CreateFrame("Frame", nil, parent)
		frame:SetSize(ROW_VERTICAL_SPACING, ROW_VERTICAL_SPACING)
		frame:SetPoint("TOPRIGHT", parent, "TOPRIGHT", x, y)
		frame.texture = frame:CreateTexture(nil, "ARTWORK", nil)
		frame.texture:SetTexture(icon)
		frame.texture:SetAllPoints(frame)
		return frame
	end

	make_spec_display("Interface\\ICONS\\INV_Misc_QuestionMark", -2)
	set_class_icon(make_spec_display(nil, -2 - ROW_VERTICAL_SPACING).texture, classname)
	for x, spec in ipairs(specs) do
		make_spec_display(spec.icon, -2 - (#specs - x + 2) * ROW_VERTICAL_SPACING)
	end
end

local current_radio_group = nil
local function start_radio_group()
	current_radio_group = {}
end

local function radio_group_disable_all(self)
	for _, v in pairs(self.group) do
		if v ~= self then
			v:SetChecked(false)
		end
	end
end

local function create_encounter_checkbox(parent, x, y, encounter, spec)
	local checkbox = CreateFrame("CheckButton", ("ltsm-cb-%d-%d"):format(encounter, spec), parent, "UICheckButtonTemplate")
	checkbox.group = current_radio_group
	checkbox:SetPoint("TOPRIGHT", parent, "TOPRIGHT", x, y)
	checkbox:RegisterForClicks("AnyUp")
	checkbox:SetScript("OnClick", function(self)
		radio_group_disable_all(self)
		LTSM_API:set_spec_setting(encounter, spec)
	end)
	tinsert(current_radio_group, checkbox)
	return checkbox
end

local function create_mythicplus_checkbox(parent, x, y, map, spec)
	local checkbox = CreateFrame("CheckButton", ("ltsm-mpcb-%d-%d"):format(map, spec), parent, "UICheckButtonTemplate")
	checkbox.group = current_radio_group
	checkbox:SetPoint("TOPRIGHT", parent, "TOPRIGHT", x, y)
	checkbox:RegisterForClicks("AnyUp")
	checkbox:SetScript("OnClick", function(self)
		radio_group_disable_all(self)
		LTSM_API:set_mythicplus_spec(map, spec)
	end)
	tinsert(current_radio_group, checkbox)
	return checkbox
end

local function create_default_checkbox(parent, x, y, spec)
	local checkbox = CreateFrame("CheckButton", ("ltsm-dcb-%d"):format(spec), parent, "UICheckButtonTemplate")
	checkbox.group = current_radio_group
	checkbox:SetPoint("TOPRIGHT", parent, "TOPRIGHT", x, y)
	checkbox:RegisterForClicks("AnyUp")
	checkbox:SetScript("OnClick", function(self)
		radio_group_disable_all(self)
		LTSM_API:set_default_spec(spec)
	end)
	tinsert(current_radio_group, checkbox)
	return checkbox
end

local SPEC_ICONS = nil

function LTSM_GUI:init()
	local ltsm = LTSM

	self.frame = CreateFrame("Frame", "LTSM_Frame", UIParent, "ButtonFrameTemplate")
	local f = self.frame
	if ltsm.settings.x and ltsm.settings.y then
		f:SetPoint("BOTTOMLEFT", ltsm.settings.x, ltsm.settings.y)
	else
		f:SetPoint("CENTER")
	end
	f:SetSize(450, 600)
	f:SetToplevel(true)
	f:SetClampedToScreen(true)
	f:EnableMouse(true)
	f:SetMovable(true)
	f:SetScript("OnMouseDown", f.StartMoving)
	local function stop_moving(self)
		self:StopMovingOrSizing()
		ltsm.settings.x = self:GetLeft()
		ltsm.settings.y = self:GetBottom()
	end
	f:SetScript("OnMouseUp", stop_moving)
	f:SetScript("OnHide", stop_moving)
	f.TitleText:SetText("LootSpecManager")
	tinsert(UISpecialFrames, "LTSM_Frame")
	f:SetDontSavePosition(false)

	local _, CLASS_NAME, _ = UnitClass("player")
	set_class_icon(f.portrait, CLASS_NAME)

	local ROWS = (function()
		local rows = 0
		for _, instance in ipairs(LTSM_DATA.INSTANCE_BOSSES) do
			--instance header row
			rows = rows + 1
			for _, boss in ipairs(instance.encounters) do
				--individual boss row
				rows = rows + 1
			end
			if LTSM_DATA.DUNGEON_MAPS[instance.name] then
				--this is a dungeon, so add a row for m+
				rows = rows + 1
			end
		end
		--1 extra for default
		return rows + 1
	end)()
	local TOTAL_SIZE = ROWS * ROW_VERTICAL_SPACING

	local scrollframe = CreateFrame("ScrollFrame", nil, f)
	scrollframe:SetPoint("TOPLEFT", f, "TOPLEFT", 7, -63)
	scrollframe:SetPoint("BOTTOMRIGHT", f, "BOTTOMRIGHT", -9, 28)
	scrollframe:SetScript("OnMouseWheel", function(self, delta)
		local scroll = clamp(self:GetVerticalScroll() - delta * ROW_VERTICAL_SPACING * 2, self.scrollbar:GetMinMaxValues())
		self:SetVerticalScroll(scroll)
		self.scrollbar:SetValue(scroll)
	end)

	local scrollbar = CreateFrame("Slider", nil, scrollframe, "UIPanelScrollBarTemplate")
	scrollbar:SetPoint("TOPLEFT", scrollframe, "TOPRIGHT", -16, -16)
	scrollbar:SetPoint("BOTTOMLEFT", scrollframe, "BOTTOMRIGHT", -16, 16)
	scrollbar:SetMinMaxValues(1, TOTAL_SIZE)
	scrollbar.scrollStep = ROW_VERTICAL_SPACING * 2
	scrollbar:SetValueStep(scrollbar.scrollStep)
	scrollbar:SetValue(0)
	scrollbar:SetWidth(16)
	scrollbar:SetScript("OnValueChanged", function(self, value)
		self:GetParent():SetVerticalScroll(value)
	end)
	scrollframe.scrollbar = scrollbar

	local content = CreateFrame("Frame", nil, scrollframe)
	content:SetSize(scrollframe:GetWidth() - scrollbar:GetWidth(), TOTAL_SIZE)
	scrollframe:SetScrollChild(content)

	local y = -5
	SPEC_ICONS = get_spec_icons()

	create_header(content, "Default", y)
	create_spec_row(content, CLASS_NAME, SPEC_ICONS, y)
	y = y - ROW_VERTICAL_SPACING

	start_radio_group()
	create_default_checkbox(content, -2, y, LTSM_DATA.SPEC_DONT_CARE)
	create_default_checkbox(content, -2 - ROW_VERTICAL_SPACING, y, LTSM_DATA.SPEC_CURRENT_SPEC)
	for x, spec in pairs(SPEC_ICONS) do
		create_default_checkbox(content, -2 - (#SPEC_ICONS - x + 2) * ROW_VERTICAL_SPACING, y, spec.id)
	end
	y = y - ROW_VERTICAL_SPACING

	for _, instance in ipairs(LTSM_DATA.INSTANCE_BOSSES) do
		create_header(content, instance.name, y)
		create_spec_row(content, CLASS_NAME, SPEC_ICONS, y)
		y = y - ROW_VERTICAL_SPACING

		for _, boss in ipairs(instance.encounters) do
			create_subheader(content, boss.name, y)

			start_radio_group()
			create_encounter_checkbox(content, -2, y, boss.id, LTSM_DATA.SPEC_DONT_CARE)
			create_encounter_checkbox(content, -2 - ROW_VERTICAL_SPACING, y, boss.id, LTSM_DATA.SPEC_CURRENT_SPEC)
			for x, spec in pairs(SPEC_ICONS) do
				create_encounter_checkbox(content, -2 - (#SPEC_ICONS - x + 2) * ROW_VERTICAL_SPACING, y, boss.id, spec.id)
			end

			y = y - ROW_VERTICAL_SPACING
		end

		local dungeon_map = LTSM_DATA.DUNGEON_MAPS[instance.name]
		if dungeon_map then
			local subheader = create_subheader(content, "Mythic+", y)
			subheader.text:SetTextColor(0.9, 0.9, 0.9, 1)

			start_radio_group()
			create_mythicplus_checkbox(content, -2, y, dungeon_map, LTSM_DATA.SPEC_DONT_CARE)
			create_mythicplus_checkbox(content, -2 - ROW_VERTICAL_SPACING, y, dungeon_map, LTSM_DATA.SPEC_CURRENT_SPEC)
			for x, spec in pairs(SPEC_ICONS) do
				create_mythicplus_checkbox(content, -2 - (#SPEC_ICONS - x + 2) * ROW_VERTICAL_SPACING, y, dungeon_map, spec.id)
			end

			y = y - ROW_VERTICAL_SPACING
		end

		y = y - 10
	end

	local dropdown = CreateFrame("Frame", nil, f, "UIDropDownMenuTemplate")
	dropdown:SetSize(100, 50)
	dropdown:SetPoint("TOPLEFT", f, "TOPLEFT", 64, -32)
	UIDropDownMenu_Initialize(dropdown, function()
		local function callback(self)
			LTSM_API:set_active_settings_difficulty(self.value)
			UIDropDownMenu_SetSelectedValue(dropdown, self.value)
		end

		local function make_button(info, value, text)
			info.text = text
			info.value = value
			info.func = callback
			info.checked = false
			info.isNotRadio = false
			UIDropDownMenu_AddButton(info)
		end

		local info = UIDropDownMenu_CreateInfo()
		make_button(info, "mythic", "Mythic")
		make_button(info, "heroic", "Heroic")
		make_button(info, "normal", "Normal")
		make_button(info, "lfr", "LFR")
	end)
	UIDropDownMenu_SetSelectedValue(dropdown, ltsm.current)

	self:refresh()
	f:Hide()
end

function LTSM_GUI:refresh()
	for encounter, spec in pairs(LTSM.encounters[LTSM.current]) do
		local checkbox = _G[("ltsm-cb-%d-%d"):format(encounter, spec)]
		if checkbox then
			radio_group_disable_all(checkbox)
			checkbox:SetChecked(true)
		end
	end

	for _, instance in ipairs(LTSM_DATA.INSTANCE_BOSSES) do
		local dungeon_map = LTSM_DATA.DUNGEON_MAPS[instance.name]
		if dungeon_map then
			local checkbox = _G[("ltsm-mpcb-%d-%d"):format(dungeon_map, LTSM_API:get_mythicplus_spec(dungeon_map))]
			if checkbox then
				radio_group_disable_all(checkbox)
				checkbox:SetChecked(true)
			end
		end
	end

	local checkbox = _G[("ltsm-dcb-%d"):format(LTSM_API:get_default_spec())]
	if checkbox then
		radio_group_disable_all(checkbox)
		checkbox:SetChecked(true)
	end
end
