ctld.maximumDistanceLogistic = 300 -- max distance from vehicle to logistics to allow a loading or spawning operation
ctld.maximumMoveDistance = 200 -- max distance for troops to move from drop point if no enemy is nearby
ctld.minimumDeployDistance = 1 -- minimum distance from a friendly pickup zone where you can deploy a crate
ctld.crateWaitTime = 60 -- time in seconds to wait before you can spawn another crate
ctld.maximumHoverHeight = 20.0 -- Highest allowable height for crate hover
ctld.maxDistanceFromCrate = 15 -- Maximum distance from from crate for hover
ctld.hoverTime = 5 -- Time to hold hover above a crate for loading in seconds

ctld.pickupZones = {
  { "mklogizone", "green", -1, "no", 0 },
  { "kraspashlogizone", "green", -1, "no", 0 },
  { "krascenterlogizone", "green", -1, "no", 0 },
  { "krymsklogizone", "green", -1, "no", 0 },
  { "novologizone", "green", -1, "no", 0 },
  { "LogiFARPCharlie", "green", -1, "yes", 0 },
  { "LogiSochi", "green", -1, "yes", 0 },
  { "LogiGudauta", "green", -1, "yes", 0 },
  { "LogiMaykopSouth", "green", -1, "yes", 0 },
  { "LogiMaykopNorth", "green", -1, "yes", 0 },
  { "LogiFARPBravo", "green", -1, "yes", 0 },
  { "LogiVody", "green", -1, "yes", 0 },
  { "LogiFARPDelta", "green", -1, "yes", 0 },
  { "pickzone1", "green", -1, "yes", 0 },
  { "pickzone2", "green", -1, "yes", 0 },
  { "pickzone3", "green", -1, "yes", 0 },
  { "pickzone4", "green", -1, "yes", 0 },
  { "pickzone5", "green", -1, "yes", 0 },
  { "pickzone6", "green", -1, "yes", 0 },
  { "pickzone7", "green", -1, "yes", 0 },
  { "pickzone8", "green", -1, "yes", 0 },
  { "pickzone9", "none", 5, "yes", 1 }, -- limits pickup zone 9 to 5 groups of soldiers or vehicles, only red can pick up
  { "pickzone10", "none", 10, "yes", 2 },  -- limits pickup zone 10 to 10 groups of soldiers or vehicles, only blue can pick up

  { "pickzone11", "blue", 20, "no", 2 },  -- limits pickup zone 11 to 20 groups of soldiers or vehicles, only blue can pick up. Zone starts inactive!
  { "pickzone12", "red", 20, "no", 1 },  -- limits pickup zone 11 to 20 groups of soldiers or vehicles, only blue can pick up. Zone starts inactive!
  { "pickzone13", "none", -1, "yes", 0 },
  { "pickzone14", "none", -1, "yes", 0 },
  { "pickzone15", "none", -1, "yes", 0 },
  { "pickzone16", "none", -1, "yes", 0 },
  { "pickzone17", "none", -1, "yes", 0 },
  { "pickzone18", "none", -1, "yes", 0 },
  { "pickzone19", "none", 5, "yes", 0 },
  { "pickzone20", "none", 10, "yes", 0, 1000 }, -- optional extra flag number to store the current number of groups available in

  { "USA Carrier", "blue", 10, "yes", 0, 1001 }, -- instead of a Zone Name you can also use the UNIT NAME of a ship
}

ctld.wpZones = {
  { "wpzone1", "none","yes", 2 },
  { "wpzone2", "none","yes", 2 },
  { "wpzone3", "none","yes", 2 },
  { "wpzone4", "none","yes", 2 },
  { "wpzone5", "none","yes", 2 },
  { "wpzone6", "none","yes", 2 },
  { "wpzone7", "none","yes", 2 },
  { "wpzone8", "none","yes", 2 },
  { "wpzone9", "none","yes", 1 },
  { "wpzone10", "none","no", 0 }, -- Both sides as its set to 0
}

ctld.transportPilotNames = {
  "helicargo1",
  "helicargo2",
  "helicargo3",
  "helicargo4",
  "helicargo5",
  "helicargo6",
  "helicargo7",
  "helicargo8",
  "helicargo9",
  "helicargo10",

  "helicargo11",
  "helicargo12",
  "helicargo13",
  "helicargo14",
  "helicargo15",
  "helicargo16",
  "helicargo17",
  "helicargo18",
  "helicargo19",
  "helicargo20",

  "helicargo21",
  "helicargo22",
  "helicargo23",
  "helicargo24",
  "helicargo25",

  "helicargo26",
  "helicargo27",
  "helicargo28",
  "helicargo29",
  "helicargo30",
  "helicargo31",
  "helicargo32",
  "helicargo33",
  "helicargo34",
  "helicargo35",
  "helicargo36",
  "helicargo37",
  "helicargo38",
  "helicargo39",
  "helicargo40",
  "helicargo41",
  "helicargo42",
  "helicargo43",
  "helicargo44",
  "helicargo45",
  "helicargo46",
  "helicargo47",
  "helicargo48",
  "helicargo49",
  "helicargo50",
  "helicargo51",
  "helicargo52",
  "helicargo53",
  "helicargo54",
  "helicargo55",
  "helicargo56",
  "helicargo57",
  "helicargo58",
  "helicargo59",
  "helicargo60",

  "MEDEVAC #1",
  "MEDEVAC #2",
  "MEDEVAC #3",
  "MEDEVAC #4",
  "MEDEVAC #5",
  "MEDEVAC #6",
  "MEDEVAC #7",
  "MEDEVAC #8",
  "MEDEVAC #9",
  "MEDEVAC #10",
  "MEDEVAC #11",
  "MEDEVAC #12",
  "MEDEVAC #13",
  "MEDEVAC #14",
  "MEDEVAC #15",
  "MEDEVAC #16",

  "MEDEVAC RED #1",
  "MEDEVAC RED #2",
  "MEDEVAC RED #3",
  "MEDEVAC RED #4",
  "MEDEVAC RED #5",
  "MEDEVAC RED #6",
  "MEDEVAC RED #7",
  "MEDEVAC RED #8",
  "MEDEVAC RED #9",
  "MEDEVAC RED #10",
  "MEDEVAC RED #11",
  "MEDEVAC RED #12",
  "MEDEVAC RED #13",
  "MEDEVAC RED #14",
  "MEDEVAC RED #15",
  "MEDEVAC RED #16",
  "MEDEVAC RED #17",
  "MEDEVAC RED #18",
  "MEDEVAC RED #19",
  "MEDEVAC RED #20",
  "MEDEVAC RED #21",

  "MEDEVAC BLUE #1",
  "MEDEVAC BLUE #2",
  "MEDEVAC BLUE #3",
  "MEDEVAC BLUE #4",
  "MEDEVAC BLUE #5",
  "MEDEVAC BLUE #6",
  "MEDEVAC BLUE #7",
  "MEDEVAC BLUE #8",
  "MEDEVAC BLUE #9",
  "MEDEVAC BLUE #10",
  "MEDEVAC BLUE #11",
  "MEDEVAC BLUE #12",
  "MEDEVAC BLUE #13",
  "MEDEVAC BLUE #14",
  "MEDEVAC BLUE #15",
  "MEDEVAC BLUE #16",
  "MEDEVAC BLUE #17",
  "MEDEVAC BLUE #18",
  "MEDEVAC BLUE #19",
  "MEDEVAC BLUE #20",
  "MEDEVAC BLUE #21",

  -- *** AI transports names (different names only to ease identification in mission) ***

  -- Use any of the predefined names or set your own ones

  "transport1",
  "transport2",
  "transport3",
  "transport4",
  "transport5",
  "transport6",
  "transport7",
  "transport8",
  "transport9",
  "transport10",

  "transport11",
  "transport12",
  "transport13",
  "transport14",
  "transport15",
  "transport16",
  "transport17",
  "transport18",
  "transport19",
  "transport20",

  "transport21",
  "transport22",
  "transport23",
  "transport24",
  "transport25",
}

ctld.extractableGroups = {
  "extract1",
  "extract2",
  "extract3",
  "extract4",
  "extract5",
  "extract6",
  "extract7",
  "extract8",
  "extract9",
  "extract10",

  "extract11",
  "extract12",
  "extract13",
  "extract14",
  "extract15",
  "extract16",
  "extract17",
  "extract18",
  "extract19",
  "extract20",

  "extract21",
  "extract22",
  "extract23",
  "extract24",
  "extract25",
}

-- ************** Logistics UNITS FOR CRATE SPAWNING ******************

-- Use any of the predefined names or set your own ones
-- When a logistic unit is destroyed, you will no longer be able to spawn crates

ctld.logisticUnits = {
  "logistic1",
  "logistic2",
  "logistic3",
  "logistic4",
  "logistic5",
  "logistic6",
  "logistic7",
  "logistic8",
  "logistic9",
  "logistic10",
  "logistic11",
  "logistic12",
  "logistic13",
  "logistic14",
  "logistic15",
}

ctld.spawnableCrates = {
  -- name of the sub menu on F10 for spawning crates
  ["Artillery"] = {
    { weight = 2400, desc = "M270 MLRS", unit = "MLRS", side = 2, cratesRequired = 2 },
    { weight = 100, desc = "2B11 Mortar", unit = "2B11 mortar" },
    { weight = 250, desc = "SPH 2S19 Msta", unit = "SAU Msta", side = 1, cratesRequired = 3 },
    { weight = 255, desc = "M-109 Howitzer", unit = "M-109", side = 2, cratesRequired = 3 },
  },
  ["Base Building"] = {
    { weight = 800, desc = "FOB Crate - Small", unit = "FOB-SMALL" }, -- Builds a FOB! - requires 3 * ctld.cratesRequiredForFOB
  },
  ["Ground Forces"] = {
    --crates you can spawn
    -- weight in KG
    -- Desc is the description on the F10 MENU
    -- unit is the model name of the unit to spawn
    -- cratesRequired - if set requires that many crates of the same type within 100m of each other in order build the unit
    -- side is optional but 2 is BLUE and 1 is RED
    -- dont use that option with the HAWK Crates
    { weight = 500, desc = "HMMWV - TOW", unit = "M1045 HMMWV TOW", side = 2 },
    { weight = 505, desc = "HMMWV - MG", unit = "M1043 HMMWV Armament", side = 2 },
    { weight = 510, desc = "BTR-D", unit = "BTR_D", side = 1 },
    { weight = 515, desc = "BRDM-2", unit = "BRDM-2", side = 1 },

    { weight = 520, desc = "HMMWV - JTAC", unit = "Hummer", side = 2, }, -- used as jtac and unarmed, not on the crate list if JTAC is disabled
    { weight = 525, desc = "SKP-11 - JTAC", unit = "SKP-11", side = 1, }, -- used as jtac and unarmed, not on the crate list if JTAC is disabled

    { weight = 252, desc = "Ural-375 Ammo Truck", unit = "Ural-375", side = 1, cratesRequired = 2 },
    { weight = 253, desc = "M-818 Ammo Truck", unit = "M 818", side = 2 },
  },
  ["AA Crates"] = {
    { weight = 1000, desc = "Gepard AAA", unit = "Gepard", side = 2, cratesRequired = 2 },
    -- HAWK System
    { weight = 540, desc = "HAWK Launcher", unit = "Hawk ln", side = 2},
    { weight = 545, desc = "HAWK Search Radar", unit = "Hawk sr", side = 2 },
    { weight = 550, desc = "HAWK Track Radar", unit = "Hawk tr", side = 2 },
    { weight = 551, desc = "HAWK PCP", unit = "Hawk pcp" , side = 2 }, -- Remove this if on 1.2
    { weight = 552, desc = "HAWK Repair", unit = "HAWK Repair" , side = 2 },
    -- End of HAWK

    -- KUB SYSTEM
    { weight = 560, desc = "KUB Launcher", unit = "Kub 2P25 ln", side = 1},
    { weight = 565, desc = "KUB Radar", unit = "Kub 1S91 str", side = 1 },
    { weight = 570, desc = "KUB Repair", unit = "KUB Repair", side = 1},
    -- End of KUB

    -- BUK System
    --        { weight = 575, desc = "BUK Launcher", unit = "SA-11 Buk LN 9A310M1"},
    --        { weight = 580, desc = "BUK Search Radar", unit = "SA-11 Buk SR 9S18M1"},
    --        { weight = 585, desc = "BUK CC Radar", unit = "SA-11 Buk CC 9S470M1"},
    --        { weight = 590, desc = "BUK Repair", unit = "BUK Repair"},
    -- END of BUK

    { weight = 595, desc = "Early Warning Radar", unit = "1L13 EWR", side = 1 }, -- cant be used by BLUE coalition

    { weight = 405, desc = "Strela-1 9P31", unit = "Strela-1 9P31", side = 1, cratesRequired = 3 },
    { weight = 400, desc = "M1097 Avenger", unit = "M1097 Avenger", side = 2, cratesRequired = 1 },

  },
}

-- if the unit is on this list, it will be made into a JTAC when deployed
ctld.jtacUnitTypes = {
  "SKP", "Hummer" -- there are some wierd encoding issues so if you write SKP-11 it wont match as the - sign is encoded differently...
}
