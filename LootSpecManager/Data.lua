
LTSM_DATA_VERSION = 3

LTSM_DATA = {}

---
-- "Do not change" option. Negative to not clash with actual spec IDs, which are all positive.
LTSM_DATA.SPEC_DONT_CARE = -1
---
-- "Current spec" option. Same as GetLootSpecialization returns for "current spec".
LTSM_DATA.SPEC_CURRENT_SPEC = 0

---
-- A list of instances/boss data.
-- {
--     [1] = {
--         name = instancename,
--         encounters = {
--             [1] = {
--                 name = bossname,
--                 id = encounterid
--             },
--             ...
--         }
--     },
--     ...
-- }
LTSM_DATA.INSTANCE_BOSSES = (function(...)
	--using a function to preserve order without explicitly specifying instance indices
	--this way, instances can be added or removed without altering the order of other instances
	local ret = {}
	for _, v in pairs({...}) do
		tinsert(ret, {
			name = v[1],
			encounters = v[2]
		})
	end
	return ret
end)(
	{"Ny'alotha, The Waking City", {
		[1] = {name = "Wrathion, the Black Emperor", id = 2329},
		[2] = {name = "Maut", id = 2327},
		[3] = {name = "The Prophet Skitra", id = 2334},
		[4] = {name = "Dark Inquisitor Xanesh", id = 2328},
		[5] = {name = "The Hivemind", id = 2333},
		[6] = {name = "Shad'har the Insatiable", id = 2335},
		[7] = {name = "Drest'agath", id = 2343},
		[8] = {name = "Il'gynoth, Corruption Reborn", id = 2345},
		[9] = {name = "Vexiona", id = 2336},
		[10] = {name = "Ra-den the Despoiled", id = 2331},
		[11] = {name = "Carapace of N'Zoth", id = 2337},
		[12] = {name = "N'Zoth the Corruptor", id = 2344}
	}},
	{"The Eternal Palace", {
		[1] = {name = "Abyssal Commander Sivara", id = 2298},
		[2] = {name = "Blackwater Behemoth", id = 2289},
		[3] = {name = "Radiance of Azshara", id = 2305},
		[4] = {name = "Lady Ashvane", id = 2304},
		[5] = {name = "Orgozoa", id = 2303},
		[6] = {name = "The Queen's Court", id = 2311},
		[7] = {name = "Za'qul, Harbinger of Ny'alotha", id = 2293},
		[8] = {name = "Queen Azshara", id = 2299}
	}},
	{"Crucible of Storms", {
		[1] = {name = "The Restless Cabal", id = 2269},
		[2] = {name = "Uu'nat, Harbinger of the Void", id = 2273}
	}},
	{"Battle of Dazar'alor", (function()
		local encounters = {
			[4] = {name = "Opulence", id = 2271},
			[5] = {name = "Conclave of the Chosen", id = 2268},
			[6] = {name = "King Rastakhan", id = 2272},
			[7] = {name = "High Tinker Mekkatorque", id = 2276},
			[8] = {name = "Stormwall Blockade", id = 2280},
			[9] = {name = "Lady Jaina Proudmoore", id = 2281}
		}
		if UnitFactionGroup("player") == "Alliance" then
			encounters[1] = {name = "Champion of the Light", id = 2265}
			encounters[2] = {name = "Jadefire Masters", id = 2266}
			encounters[3] = {name = "Grong, the Revenant", id = 2263}
		else
			encounters[1] = {name = "Champion of the Light", id = 2265}
			encounters[2] = {name = "Grong, the Jungle Lord", id = 2263}
			encounters[3] = {name = "Jadefire Masters", id = 2266}
		end
		return encounters
	end)()},
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
	{"Mechagon", {
		[1] = {name = "King Gobbamak", id = 2290},
		[2] = {name = "Gunker", id = 2292},
		[3] = {name = "Trixie & Naeno", id = 2312},
		[4] = {name = "HK-8 Aerial Oppression Unit", id = 2291},
		[5] = {name = "Tussle Tonks", id = 2257},
		[6] = {name = "K.U.-J.0.", id = 2258},
		[7] = {name = "Machinist's Garden", id = 2259},
		[8] = {name = "King Mechagon", id = 2260}
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

LTSM_DATA.DUNGEON_MAPS = (function(...)
	local ret = {}
	for _, v in pairs({...}) do
		ret[v[1]] = v[2]
		ret[v[2]] = v[1]
	end
	return ret
end)(
	{"Mechagon", 2097},
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

--[[
	encounters = encounter id -> spec id
	dungeons = primary map id -> spec id
	maps = map id -> primary map id
	default -> spec id
]]

function LTSM_DATA:check_version()
	local ltsm = LTSM

	--initial version had no version number
	if not ltsm.version then
		ltsm.encounters = ltsm.encounters or {}
		ltsm.settings = ltsm.settings or {}
		ltsm.mythicplus = ltsm.mythicplus or {}

		--first iteration had 2097 for both bosses
		ltsm.encounters[2098] = ltsm.encounters[2098] or ltsm.encounters[2097]

		ltsm.version = 1
	end
	if ltsm.version == 1 then
		local encounters = ltsm.encounters
		ltsm.encounters = {
			mythic = {},
			heroic = {},
			normal = {},
			lfr = {}
		}
		for k, v in pairs(encounters) do
			ltsm.encounters.mythic[k] = v
			ltsm.encounters.heroic[k] = v
			ltsm.encounters.normal[k] = v
			ltsm.encounters.lfr[k] = v
		end
		ltsm.current = "mythic"

		ltsm.version = 2
	end
	if ltsm.version == 2 then
		ltsm.default = LTSM_DATA.SPEC_DONT_CARE

		ltsm.version = LTSM_DATA_VERSION
	end
end
