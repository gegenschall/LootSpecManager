
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
  {"Sepulcher of the First Ones", {
    [1] = {name = "Vigilant Guardian", id = 2512},
    [2] = {name = "Dausegne, the Fallen Oracle", id = 2540},
    [3] = {name = "Prototype Pantheon", id = 2544},
    [4] = {name = "Lihuvim, Principal Architect", id = 2539},
    [5] = {name = "Skolex, the Insatiable Ravener", id = 2542},
    [6] = {name = "Artificer Xy'mox", id = 2553},
    [7] = {name = "Halondrus the Reclaimer", id = 2529},
    [8] = {name = "Anduin Wrynn", id = 2546},
    [9] = {name = "Lords of Dread", id = 2543},
    [10] = {name = "Rygelon", id = 2549},
    [11] = {name = "The Jailer", id = 2537},
  }},
  {"Sanctum of Domination", {
    [1] = {name = "The Tarragrue", id = 2423},
    [2] = {name = "Eye of the Jailer", id = 2433},
    [3] = {name = "The Nine", id = 2429},
    [4] = {name = "Remnant of Ner'zhul", id = 2432},
    [5] = {name = "Soulrender Dormazain", id = 2434},
    [6] = {name = "Painsmith Raznal", id = 2430},
    [7] = {name = "Guardian of the First Ones", id = 2436},
    [8] = {name = "Fatescribe Roh-Kalo", id = 2431},
    [9] = {name = "Kel'Thuzad", id = 2422},
    [10] = {name = "Sylvanas Windrunner", id = 2435},
  }},
  {"Castle Nathria", {
    [1] = {name = "Shriekwing", id = 2398},
    [2] = {name = "Huntsman Altimor", id = 2418},
    [3] = {name = "Hungering Destroyer", id = 2383},
    [4] = {name = "Artificer Xy'Mox", id = 2405},
    [5] = {name = "Sun King's Salvation", id = 2402},
    [6] = {name = "Lady Inerva Darkvein", id = 2406},
    [7] = {name = "The Council of Blood", id = 2412},
    [8] = {name = "Sludgefist", id = 2399},
    [9] = {name = "Stone Legion Generals", id = 2417},
    [10] = {name = "Sire Denathrius", id = 2407},
  }},
  {"Tazavesh, the Veiled Market", {
    [1] = {name = "Zo'phex", id = 2425},
    [2] = {name = "The Menagerie", id = 2425},
    [3] = {name = "Mailroom Mayhem", id = 2424},
    [4] = {name = "Myza's Oasis", id = 2440},
    [5] = {name = "So'azmi", id = 2437},
    [6] = {name = "Hylbrande", id = 2426},
    [7] = {name = "Timecap'n Hooktail", id = 2419},
    [8] = {name = "So'leah", id = 2442},
  }},
  {"The Necrotic Wake", {
    [1] = {name = "Blightbone", id = 2387},
    [2] = {name = "Amarth, The Harvester", id = 2388},
    [3] = {name = "Surgeon Stitchflesh", id = 2389},
    [4] = {name = "Nalthor the Rimebinder", id = 2390},
  }},
  {"Plaguefall", {
    [1] = {name = "Globgrog", id = 2382},
    [2] = {name = "Doctor Ickus", id = 2384},
    [3] = {name = "Domina Venomblade", id = 2385},
    [4] = {name = "Margrave Stradama", id = 2386},
  }},
  {"Mists of Tirna Scithe", {
    [1] = {name = "Ingra Maloch", id = 2397},
    [2] = {name = "Mistcaller", id = 2392},
    [3] = {name = "Tred'ova", id = 2393},
  }},
  {"Halls of Atonement", {
    [1] = {name = "Halkias, the Sin-Stained Goliath", id = 2401},
    [2] = {name = "Echelon", id = 2380},
    [3] = {name = "High Adjudicator Aleez", id = 2403},
    [4] = {name = "Lord Chamberlain", id = 2381},
  }},
  {"Theater of Pain", {
    [1] = {name = "An Affront of Challengers", id = 2391},
    [2] = {name = "Gorechop", id = 2365},
    [3] = {name = "Xav the Unfallen", id = 2366},
    [4] = {name = "Kul'tharok", id = 2364},
    [5] = {name = "Mordretha, the Endless Empress", id = 2404},
  }},
  {"De Other Side", {
    [1] = {name = "Hakkar the Soulflayer", id = 2395},
    [2] = {name = "The Manastorms", id = 2394},
    [3] = {name = "Dealer Xy'exa", id = 2400},
    [4] = {name = "Mueh'zala", id = 2396},
  }},
  {"Spires of Ascension", {
    [1] = {name = "Kin-Tara", id = 2357},
    [2] = {name = "Ventunax", id = 2356},
    [3] = {name = "Oryphrion", id = 2358},
    [4] = {name = "Devos, Paragon of Doubt", id = 2359},
  }},
  {"Sanguine Depths", {
    [1] = {name = "Kryxis the Voracious", id = 2360},
    [2] = {name = "Executor Tarvold", id = 2361},
    [3] = {name = "Grand Proctor Beryllia", id = 2362},
    [4] = {name = "General Kaal", id = 2363},
  }},
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
  }},
    {"Karazhan", {
    [1] = {name = "Opera Hall", id = 1957},
    [2] = {name = "Maiden of Virtue", id = 1954},
    [3] = {name = "Attumen the Huntsman", id = 1960},
    [4] = {name = "Moroes", id = 1961},
    [5] = {name = "The Curator", id = 1964},
    [6] = {name = "Shade of Medivh", id = 1965},
    [7] = {name = "Mana Devourer", id = 1959},
    [8] = {name = "Viz'aduum the Watcher", id = 2017}
  }},
      {"Iron Docks", {
    [1] = {name = "Fleshrender Nok'gar", id = 1749},
    [2] = {name = "Grimrail Enforcers", id = 1748},
    [3] = {name = "Oshir", id = 1750},
    [4] = {name = "Skulloc, Son of Gruul", id = 1754}
  }},
      {"Grimrail Depot", {
    [1] = {name = "Rocketspark and Borka", id = 1715},
    [2] = {name = "Nitrogg Thundertower", id = 1732},
    [3] = {name = "Skylord Tovra", id = 1736}
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
  -- Shadowlands
  {"Tazavesh, the Veiled Market", 2441},
  {"The Necrotic Wake", 2286},
  {"Plaguefall", 2289},
  {"Mists of Tirna Scithe", 2290},
  {"Halls of Atonement", 2287},
  {"Theater of Pain", 2293},
  {"De Other Side", 2291},
  {"Spires of Ascension", 2285},
  {"Sanguine Depths", 2284},
  -- Battle for Azeroth
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
  {"Waycrest Manor", 1862},
  -- Legion
  {"Karazhan", 1651},
  -- Warlords
  {"Iron Docks", 1195},
  {"Grimrail Depot", 1208}
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
