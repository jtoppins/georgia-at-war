--Airbases in play.
Airbases = {
    "Sochi-Adler",
    "Gudauta",
    "Mineralnye Vody",
    "Nalchik",
    "Mozdok",
    "Sukhumi-Babushara"
}

-- Russian IL-76MD spawns to capture airfields
MozdokTransportSpawn = Spawner("MozdokTransport")
MozdokHeloSpawn = Spawner("MozdokHeloTransport")
MozdokDefSpawn = Spawner("MozdokDefense")

NalchikTransportSpawn = Spawner("NalchikTransport")
NalchikHeloSpawn = Spawner("NalchikHeloTransport")
NalchikDefSpawn = Spawner("NalchikDefense")

VodyTransportSpawn = Spawner("VodyTransport")
VodyHeloSpawn = Spawner("VodyHeloTransport")
VodyDefSpawn = Spawner("VodyDefense")

SochiTransportSpawn = Spawner("SochiTransport")
SochiHeloSpawn = Spawner("SochiHeloTransport")
SochiDefSpawn = Spawner("SochiDefense")

GudautaTransportSpawn = Spawner("GudautaTransport")
GudautaHeloSpawn = Spawner("GudautaHeloTransport")
GudautaDefSpawn = Spawner("GudautaDefense")

SukhumiTransportSpawn = Spawner("SukhumiTransport")
SukhumiHeloSpawn = Spawner("SukhumiHeloTransport")
SukhumiDefSpawn = Spawner("SukhumiDefense")

RussianTheaterAirfieldDefSpawn = Spawner("Russia-Airfield-Def")

--Airbase -> Spawn Map.
AirbaseSpawns = {
    ["Mozdok"]={MozdokTransportSpawn, MozdokHeloSpawn, MozdokDefSpawn},
    ["Nalchik"]={NalchikTransportSpawn, NalchikHeloSpawn, NalchikDefSpawn},
    ["Mineralnye Vody"]={VodyTransportSpawn, VodyHeloSpawn, VodyDefSpawn},
    ["Gudauta"]={GudautaTransportSpawn, GudautaHeloSpawn, GudautaDefSpawn},
    ["Sochi-Adler"]={SochiTransportSpawn, SochiHeloSpawn, SochiDefSpawn},
    ["Sukhumi-Babushara"]={SukhumiTransportSpawn, SukhumiHeloSpawn, SukhumiDefSpawn}
}

-- Forward Logistics spawns
LogiFARPALPHASpawn = {logispawn, "HEMTT TFFT",
    {
        ['x'] = -90692,
        ['y'] = 551377
    },
    "LogiFARPAlpha"
}

LogiFARPBRAVOSpawn = {logispawn, "HEMTT TFFT",
    {
        ['x'] = -83517,
        ['y'] = 617694
    },
    "LogiFARPBravo"
}

LogiFARPCHARLIESpawn = {logispawn, "HEMTT TFFT",
    {
        ['x'] = -126126,
        ['y'] = 420423
    },
    "LogiFARPCharlie"
}

LogiFARPDELTASpawn = {logispawn, "HEMTT TFFT",
    {
        ['x'] = -98874,
        ['y'] = 808161
    },
    "LogiFARPDelta"
}

LogiVodySpawn = {logispawn, "HEMTT TFFT",
    {
        ['x'] = -77884,
        ['y'] = 761336
    },
    "LogiVody"
}

LogiAdlerSpawn = {logispawn, "HEMTT TFFT",
    {
        ['x'] = -166113,
        ['y'] = 462824
    },
    "LogiSochi"
}

LogiGudautaSpawn = {logispawn, "HEMTT TFFT",
    {
        ['x'] = -195671,
        ['y'] = 517492
    },
    "LogiGudauta"
}

-- Transport Spawns
NorthGeorgiaTransportSpawns = {
    ['Sochi-Adler'] = {Spawner("SochiXport"), Spawner("SochiXportHelo"), LogiAdlerSpawn},
    ['Gudauta'] = {Spawner("GudautaXport"), Spawner("GudautaXportHelo"), LogiGudautaSpawn},
    ['Sukhumi-Babushara'] = {Spawner("SukXport"), Spawner("SukXportHelo"), nil},
    ['Mineralnye Vody'] = {Spawner("VodyXport"), Spawner("VodyXportHelo"), LogiVodySpawn},
    ['Nalchik'] = {Spawner("NalchikXport"), Spawner("NalchikXportHelo"), nil},
    ['Mozdok'] = {Spawner("MozdokXport"), Spawner("MozdokXportHelo"), nil},
    ['Beslan'] = {Spawner("BeslanXport"), Spawner("BeslanXportHelo"), nil}
}

NorthGeorgiaFARPTransportSpawns = {
    ["FARP ALPHA"] = {Spawner("FARPAlphaXportHelo"), nil, LogiFARPALPHASpawn},
    ["FARP BRAVO"] = {Spawner("FARPBravoXportHelo"), nil, LogiFARPBRAVOSpawn},
    ["FARP CHARLIE"] = {Spawner("FARPCharlieXportHelo"),nil, LogiFARPCHARLIESpawn},
    ["FARP DELTA"] = {Spawner("FARPDeltaXportHelo"),nil, LogiFARPDELTASpawn},
}

VIPSpawns = { "VIPTransport" }

VIPSpawnZones = {
  {"VIPSpawn-Tuapse", "Tuapse"},
  {"VIPSpawn-Sochi", "Sochi"},
  {"VIPSpawn-Gudauta", "Gudauta"},
  {"VIPSpawn-Vody", "Vody"}
}
VIPDropoffZones = {
  "VIPDropOff-Maykop",
  "VIPDropOff-MaykopSouth",
  "VIPDropOff-MaykopNorth",
  "VIPDropOff-FARPAlpha",
  "VIPDropOff-FARPBravo",
  "VIPDropOff-FARPCharlie",
  "VIPDropOff-FARPDelta",
  "VIPDropOff-Gudauta",
  "VIPDropOff-Sochi",
  "VIPDropOff-Vody"
}

--Theater Objectives. Must be spawned once, and only where in the ME has them.
TuapseRefinery = TheaterObjectiveSpawner("Tuapse Refinery", "TuapseRefineryDef")
ChemSite = TheaterObjectiveSpawner("Chemical Factory", "CHEM SITE VEHICLES")
AmmoDump = TheaterObjectiveSpawner("Chemical Factory", "AMMO DUMP GROUND FORCES")

TheaterObjectives = {}
TheaterObjectives["Tuapse Refinery"] = TuapseRefinery
TheaterObjectives["Chemical Factory"] = ChemSite
TheaterObjectives["Ammunitions Depot"] = AmmoDump

-- FARP defenses
FARPALPHADEF = Spawner("FARP ALPHA DEF_1")
FARPBRAVODEF = Spawner("FARP BRAVO DEF_1")
FARPCHARLIEDEF = Spawner("FARP CHARLIE DEF_1")
FARPDELTADEF = Spawner("Russia-Airfield-Def")

-- FARP Support Groups
FSW = Spawner("FARP Support West")

-- Group spanws for easy randomization
local allcaps = {
    RussianTheaterMig212ShipSpawn, RussianTheaterSu272sShipSpawn, RussianTheaterMig292ShipSpawn, RussianTheaterJ11Spawn, RussianTheaterF5Spawn,
    RussianTheaterMig212ShipSpawnGROUND, RussianTheaterSu272sShipSpawnGROUND, RussianTheaterMig292ShipSpawnGROUND, RussianTheaterJ11SpawnGROUND, RussianTheaterF5SpawnGROUND
}
poopcaps = {RussianTheaterMig212ShipSpawn, RussianTheaterF5Spawn}
goodcaps = {RussianTheaterMig292ShipSpawn, RussianTheaterSu272sShipSpawn, RussianTheaterJ11Spawn}
poopcapsground = {RussianTheaterMig212ShipSpawnGROUND, RussianTheaterF5SpawnGROUND}
goodcapsground = {RussianTheaterMig292ShipSpawnGROUND, RussianTheaterSu272sShipSpawnGROUND, RussianTheaterJ11SpawnGROUND}
baispawns = {RussianHeavyArtySpawn, ArmorColumnSpawn, MechInfSpawn}

StrikeTargetSpawns = {
  AmmoDumpSpawn,
  CommsArraySpawn,
  PowerPlantSpawn
}

-- Airfield CAS Spawns
RussianTheaterCASSpawn = Spawner("Su25T-CASGroup")
RussianTheaterSOUTHCASSpawn = Spawner("Su25T-CASGroupSOUTH")
