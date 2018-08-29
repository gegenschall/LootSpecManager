
local LTSM_DATA_VERSION = 1

local pairs = pairs
local ipairs = ipairs
local unpack = unpack
local tinsert = tinsert
local UnitClass = UnitClass
local CreateFrame = CreateFrame
local SetLootSpecialization = SetLootSpecialization
local GetSpecializationInfoByID = GetSpecializationInfoByID
local GetNumSpecializationsForClassID = GetNumSpecializationsForClassID
local GetSpecializationInfoForClassID = GetSpecializationInfoForClassID

--using LTSM as the acronym instead of LSM because LSM = LibSharedMedia
local ltsm

--negative to not clash with actual spec ids. "do not change"
local SPEC_DONT_CARE = -1
--"current spec" ingame is 0, as per http://wowprogramming.com/docs/api/GetLootSpecialization.html
local SPEC_CURRENT_SPEC = 0

--[[
instances = {
	[1] = {
		name = instancename,
		encounters = {
			[1] = {
				name = bossname,
				id = encounterid
			},
			...
		}
	},
	...
}
]]
local instances = {}
(function(...)
	--there isn't much transformation happening here, but the instance indices aren't hardcoded so new instances are easier to add
	for _, v in ipairs({...}) do
		tinsert(instances, {
			name = v[1],
			encounters = v[2]
		})
	end
end)(
	{"Uldir", {
		[1] = {name = "Taloc", id = 2144},
		[2] = {name = "MOTHER", id = 2141},
		[3] = {name = "Fetid Devourer", id = 2128},
		[4] = {name = "Zek'voz, Herald of N'zoth", id = 2136},
		[5] = {name = "Vectis", id = 2134},
		[6] = {name = "Zul, Reborn", id = 2145},
		[7] = {name = "Mythrax the Unraveler", id = 2135},
		[8] = {name = "G'huun", id = 2122}
	}},
	{"Atal'Dazar", {
		[1] = {name = "Priestess Alun'za", id = 2084},
		[2] = {name = "Vol'kaal", id = 2085},
		[3] = {name = "Rezan", id = 2086},
		[4] = {name = "Yazma", id = 2087}
	}},
	{"Freehold", {
		[1] = {name = "Skycap'n Kragg", id = 2093},
		[2] = {name = "Council o' Captains", id = 2094},
		[3] = {name = "Ring of Booty", id = 2095},
		[4] = {name = "Harlan Sweete", id = 2096}
	}},
	{"Kings' Rest", {
		[1] = {name = "The Golden Serpent", id = 2139},
		[2] = {name = "Mchimba the Embalmer", id = 2142},
		[3] = {name = "The Council of Tribes", id = 2140},
		[4] = {name = "Dazar, The First King", id = 2143}
	}},
	{"Shrine of the Storm", {
		[1] = {name = "Aqu'sirr", id = 2130},
		[2] = {name = "Tidesage Council", id = 2131},
		[3] = {name = "Lord Stormsong", id = 2132},
		[4] = {name = "Vol'zith the Whisperer", id = 2133}
	}},
	{"Siege of Boralus", (function()
		local encounters = {
			[2] = {name = "Dread Captain Lockwood", id = 2109},
			[3] = {name = "Hadal Darkfathom", id = 2099},
			[4] = {name = "Viq'Goth", id = 2100}
		}
		if UnitFactionGroup("player") == "Alliance" then
			encounters[1] = {name = "Chopper Redhook", id = 2098}
		else
			encounters[1] = {name = "Sergeant Bainbridge", id = 2097}
		end
		return encounters
	end)()},
	{"Temple of Sethraliss", {
		[1] = {name = "Adderis and Aspix", id = 2124},
		[2] = {name = "Merektha", id = 2125},
		[3] = {name = "Galvazzt", id = 2126},
		[4] = {name = "Avatar of Sethraliss", id = 2127}
	}},
	{"The MOTHERLODE!!", {
		[1] = {name = "Coin-Operated Crowd Pummeler", id = 2105},
		[2] = {name = "Azerokk", id = 2106},
		[3] = {name = "Rixxa Fluxflame", id = 2107},
		[4] = {name = "Mogul Razdunk", id = 2108},
	}},
	{"The Underrot", {
		[1] = {name = "Elder Leaxa", id = 2111},
		[2] = {name = "Cragmaw the Infested", id = 2118},
		[3] = {name = "Sporecaller Zancha", id = 2112},
		[4] = {name = "Unbound Abomination", id = 2123}
	}},
	{"Tol Dagor", {
		[1] = {name = "The Sand Queen", id = 2101},
		[2] = {name = "Jes Howlis", id = 2102},
		[3] = {name = "Knight Captain Valyri", id = 2103},
		[4] = {name = "Overseer Korgus", id = 2104}
	}},
	{"Waycrest Manor", {
		[1] = {name = "Heartsbane Triad", id = 2113},
		[2] = {name = "Soulbound Goliath", id = 2114},
		[3] = {name = "Raal the Gluttonous", id = 2115},
		[4] = {name = "Lord and Lady Waycrest", id = 2116},
		[5] = {name = "Gorak Tul", id = 2117}
	}}
)

--[[
mythicplus = {
	dungeonname = mapid,
	mapid = dungeonname,
	...
}
dungeonname and mapid will never clash, so a 2 way table is safe
]]
local mythicplus = {}
(function(...)
	for _, v in pairs({...}) do
		mythicplus[v[1]] = v[2]
		mythicplus[v[2]] = v[1]
	end
end)(
	{"Atal'Dazar", 1763},
	{"Freehold", 1754},
	{"Kings' Rest", 1762},
	{"Siege of Boralus", 1822},
	{"Shrine of the Storm", 1864},
	{"Temple of Sethraliss", 1877},
	{"The MOTHERLODE!!", 1594},
	{"The Underrot", 1841},
	{"Tol Dagor", 1771},
	{"Waycrest Manor", 1862}
)

local settings_frame = CreateFrame("Frame", "LTSM_Frame", UIParent, "ButtonFrameTemplate")

function build_settings_frame()
	local _, classname, classid = UnitClass("player")

	--{id, icon}
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

	local f = settings_frame
	if ltsm.settings.x and ltsm.settings.y then
		f:SetPoint("BOTTOMLEFT", ltsm.settings.x, ltsm.settings.y)
	else
		f:SetPoint("CENTER")
	end
	f:SetSize(400, 600)
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

	f.portrait:SetTexture("Interface\\GLUES\\CHARACTERCREATE\\UI-CHARACTERCREATE-CLASSES")
	f.portrait:SetTexCoord(unpack(CLASS_ICON_TCOORDS[classname]))

	local ninstances = #instances
	local nencounters = 0
	for _, instance in ipairs(instances) do
		nencounters = nencounters + 1
		if mythicplus[instance.name] then
			nencounters = nencounters + 1
		end
	end

	local function clamp(n, min, max)
		if n < min then
			n = min
		elseif n > max then
			n = max
		end
		return n
	end

	local scrollframe = CreateFrame("ScrollFrame", nil, LTSM_Frame)
	scrollframe:SetPoint("TOPLEFT", f, "TOPLEFT", 7, -63)
	scrollframe:SetPoint("BOTTOMRIGHT", f, "BOTTOMRIGHT", -9, 28)
	scrollframe:SetScript("OnMouseWheel", function(self, delta)
		local scroll = clamp(self:GetVerticalScroll() - delta * (ninstances + nencounters) * 2, self.scrollbar:GetMinMaxValues())
		self:SetVerticalScroll(scroll)
		self.scrollbar:SetValue(scroll)
	end)

	local INSTANCE_SPACING = 30
	local ENCOUNTER_SPACING = 25

	local total_size = INSTANCE_SPACING * ninstances * 2 + ENCOUNTER_SPACING * nencounters * 2

	local scrollbar = CreateFrame("Slider", nil, scrollframe, "UIPanelScrollBarTemplate")
	scrollbar:SetPoint("TOPLEFT", scrollframe, "TOPRIGHT", -16, -16)
	scrollbar:SetPoint("BOTTOMLEFT", scrollframe, "BOTTOMRIGHT", -16, 16)
	scrollbar:SetMinMaxValues(1, total_size)
	scrollbar:SetValueStep(1)
	scrollbar.scrollStep = 1
	scrollbar:SetValue(0)
	scrollbar:SetWidth(16)
	scrollbar:SetScript("OnValueChanged", function(self, value)
		self:GetParent():SetVerticalScroll(value)
	end)
	scrollframe.scrollbar = scrollbar

	local content = CreateFrame("Frame", nil, scrollframe)
	content:SetSize(scrollframe:GetWidth() - scrollbar:GetWidth(), total_size)
	scrollframe.content = content

	local BOSS_INDENT = 30

	local y = -5

	local current_radio_group

	local function start_radio_group()
		current_radio_group = {}
	end

	local function make_checkbox(x, y, encounter, spec)
		local checkbox = CreateFrame("CheckButton", nil, content, "UICheckButtonTemplate")
		checkbox.encounter = encounter
		checkbox.spec = spec
		checkbox.group = current_radio_group
		checkbox:SetPoint("TOPRIGHT", content, "TOPRIGHT", x, y)
		checkbox:RegisterForClicks("AnyUp")
		checkbox:SetScript("OnClick", function(self)
			for _, v in pairs(self.group) do
				if v ~= self then
					v:SetChecked(false)
				end
			end
			ltsm.encounters[self.encounter] = self.spec
		end)
		tinsert(current_radio_group, checkbox)
		return checkbox
	end

	local function make_mp_checkbox(x, y, id, spec)
		local checkbox = CreateFrame("CheckButton", nil, content, "UICheckButtonTemplate")
		checkbox.dungeon = id
		checkbox.spec = spec
		checkbox.group = current_radio_group
		checkbox:SetPoint("TOPRIGHT", content, "TOPRIGHT", x, y)
		checkbox:RegisterForClicks("AnyUp")
		checkbox:SetScript("OnClick", function(self)
			for _, v in pairs(self.group) do
				if v ~= self then
					v:SetChecked(false)
				end
			end
			ltsm.mythicplus[self.dungeon] = self.spec
		end)
		tinsert(current_radio_group, checkbox)
		return checkbox
	end

	local function make_spec_display(x, y, icon)
		local frame = CreateFrame("Frame", nil, content)
		frame:SetSize(INSTANCE_SPACING, INSTANCE_SPACING)
		frame:SetPoint("TOPRIGHT", content, "TOPRIGHT", x, y)
		frame.texture = frame:CreateTexture(nil, "ARTWORK", nil)
		frame.texture:SetTexture(icon)
		frame.texture:SetAllPoints(frame)
		return frame
	end

	for _, instance in ipairs(instances) do
		local instancename = CreateFrame("Frame", nil, content)
		instancename:SetSize(content:GetWidth(), INSTANCE_SPACING)
		instancename:SetPoint("TOPLEFT", content, "TOPLEFT", 5, y)
		instancename.text = instancename:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge")
		instancename.text:SetText(instance.name)
		instancename.text:SetTextColor(0.9, 0.1, 0.1, 1)
		instancename.text:SetAllPoints()
		instancename.text:SetJustifyH("LEFT")
		instancename.text:SetJustifyV("CENTER")

		make_spec_display(-2, y, "Interface\\ICONS\\INV_Misc_QuestionMark")
		make_spec_display(-2 - INSTANCE_SPACING, y, "Interface\\GLUES\\CHARACTERCREATE\\UI-CHARACTERCREATE-CLASSES").texture:SetTexCoord(unpack(CLASS_ICON_TCOORDS[classname]))
		for x, spec in ipairs(specs) do
			make_spec_display(-2 - (#specs - x + 2) * INSTANCE_SPACING, y, spec.icon)
		end

		y = y - INSTANCE_SPACING

		for _, boss in ipairs(instance.encounters) do
			local bossname = CreateFrame("Frame", nil, content)
			bossname:SetSize(content:GetWidth() - BOSS_INDENT, ENCOUNTER_SPACING)
			bossname:SetPoint("TOPLEFT", content, "TOPLEFT", 5 + BOSS_INDENT, y)
			bossname.text = bossname:CreateFontString(nil, "ARTWORK", "GameFontNormal")
			bossname.text:SetText(boss.name)
			bossname.text:SetAllPoints()
			bossname.text:SetJustifyH("LEFT")
			bossname.text:SetJustifyV("CENTER")

			start_radio_group()
			local checkboxes = {}
			checkboxes[SPEC_DONT_CARE] = make_checkbox(-2, y, boss.id, SPEC_DONT_CARE)
			checkboxes[SPEC_CURRENT_SPEC] = make_checkbox(-2 - INSTANCE_SPACING, y, boss.id, SPEC_CURRENT_SPEC)
			for x, spec in ipairs(specs) do
				checkboxes[spec.id] = make_checkbox(-2 - (#specs - x + 2) * INSTANCE_SPACING, y, boss.id, spec.id)
			end
			if not ltsm.encounters[boss.id] then
				ltsm.encounters[boss.id] = SPEC_DONT_CARE
			end
			checkboxes[ltsm.encounters[boss.id]]:SetChecked(true)

			y = y - ENCOUNTER_SPACING
		end

		local mpid = mythicplus[instance.name]
		if mpid then
			local mplabel = CreateFrame("Frame", nil, content)
			mplabel:SetSize(content:GetWidth() - BOSS_INDENT, ENCOUNTER_SPACING)
			mplabel:SetPoint("TOPLEFT", content, "TOPLEFT", 5 + BOSS_INDENT, y)
			mplabel.text = mplabel:CreateFontString(nil, "ARTWORK", "GameFontNormal")
			mplabel.text:SetText("Mythic+")
			mplabel.text:SetTextColor(0.9, 0.9, 0.9, 1)
			mplabel.text:SetAllPoints()
			mplabel.text:SetJustifyH("LEFT")
			mplabel.text:SetJustifyV("CENTER")

			start_radio_group()
			local checkboxes = {}
			checkboxes[SPEC_DONT_CARE] = make_mp_checkbox(-2, y, mpid, SPEC_DONT_CARE)
			checkboxes[SPEC_CURRENT_SPEC] = make_mp_checkbox(-2 - INSTANCE_SPACING, y, mpid, SPEC_CURRENT_SPEC)
			for x, spec in ipairs(specs) do
				checkboxes[spec.id] = make_mp_checkbox(-2 - (#specs - x + 2) * INSTANCE_SPACING, y, mpid, spec.id)
			end
			if not ltsm.mythicplus[mpid] then
				ltsm.mythicplus[mpid] = SPEC_DONT_CARE
			end
			checkboxes[ltsm.mythicplus[mpid]]:SetChecked(true)

			y = y - ENCOUNTER_SPACING
		end

		y = y - 10
	end

	scrollframe:SetScrollChild(content)

	f:Hide()
end

local events = {}

function events:PLAYER_LOGIN()
	LTSM = LTSM or {}
	ltsm = LTSM
	--{encounterid = specid, ...}
	ltsm.encounters = ltsm.encounters or {}
	--{mapid = specid, ...}
	ltsm.mythicplus = ltsm.mythicplus or {}
	--frame settings - x/y
	ltsm.settings = ltsm.settings or {}
	if not ltsm.version then
		--first iteration had 2097 for both bosses
		ltsm.encounters[2098] = ltsm.encounters[2098] or ltsm.encounters[2097]

		ltsm.version = LTSM_DATA_VERSION
	end
	build_settings_frame()
end

local function set_spec(spec)
	if not spec then
		return
	end
	if spec ~= SPEC_DONT_CARE then
		SetLootSpecialization(spec)
		if spec == SPEC_CURRENT_SPEC then
			print("[LTSM] Setting loot spec to current spec.")
		else
			local _, name = GetSpecializationInfoByID(spec)
			print(("[LTSM] Settings loot spec to %s."):format(name))
		end
	end
end

function events:ENCOUNTER_START(id)
	set_spec(ltsm.encounters[id])
end

function events:ENCOUNTER_END(id)

end

--http://www.wowinterface.com/forums/showthread.php?t=54866
function events:CHALLENGE_MODE_COMPLETED()
	local map = C_ChallengeMode.GetCompletionInfo()
	print("[LTSM] Finished key " .. map .. ". If your loot spec is not properly set right now, please inform the author (include the number at the start of this output).")
	set_spec(ltsm.mythicplus[map])
end

local frame = CreateFrame("Frame")
frame:SetScript("OnEvent", function(self, event, ...)
	return events[event](self, ...)
end)
for k, _ in pairs(events) do
	frame:RegisterEvent(k)
end

SLASH_LOOTSPECMANAGER1 = "/ltsm"
SlashCmdList["LOOTSPECMANAGER"] = function(msg)
	settings_frame:Show()
end
