--Airbases in play.
-- use to be called "AirbaseSpawns"
Airbases = {
    ["Gelendzhik"]           = {
        spwndef     = Spawner("Red Airfield Defense GlensDick 1"),
        spwntranspo = Spawner("GelenRussiaTransport"),
        spwnhelo    = Spawner("GelenHeloTransport"),
    },
    ["Krasnodar-Pashkovsky"] = {
        spwndef     = Spawner("Red Airfield Defense Kras-Pash 1"),
        spwntranspo = Spawner("KrasPashRussiaTransport"),
        spwnhelo    = Spawner("KrasPashHeloTransport"),
    },
    ["Krasnodar-Center"]     = {
        spwndef     = Spawner("Red Airfield Defense Kras-Center 1"),
        spwntranspo = Spawner("KrasCenterRussiaTransport"),
        spwnhelo    = Spawner("KrasCenterHeloTransport"),
    },
    ["Novorossiysk"]         = {
        spwndef     = Spawner("Red Airfield Defense Novo 1"),
        spwntranspo = Spawner("NovoroRussiaTransport"),
        spwnhelo    = Spawner("NovoroHeloTransport"),
    },
    ["Krymsk"]               = {
        spwndef     = Spawner("Red Airfield Defense Krymsk 1"),
        spwntranspo = Spawner("KrymskRussiaTransport"),
        spwnhelo    = Spawner("KrymskHeloTransport"),
    },
}

RussianTheaterAirfieldDefSpawn = Spawner("Russia-Airfield-Def")

-- Forward Logistics spawns
NovoLogiSpawn = {logispawn, "HEMTT TFFT",
    {
        ['x'] = -39857.5703125,
        ['y'] = 279000.5
    },
    "novologizone"
}

KryLogiSpawn = {logispawn, "HEMTT TFFT",
    {
        ['x'] = -5951.622558,
        ['y'] = 293862.25
    },
    "krymsklogizone"
}

KrasCenterLogiSpawn = {logispawn, "HEMTT TFFT",
    {
        ['x'] = 11981.98046875,
        ['y'] = 364532.65625
    },
    "krascenterlogizone"
}

KrasPashLogiSpawn = {logispawn, "HEMTT TFFT",
    {
        ['x'] = 8229.2353515625,
        ['y'] = 386831.65625
    },
    "kraspashlogizone"
}

MaykopLogiSpawn = {logispawn, "HEMTT TFFT",
    {
        ['x'] = -26322.15625,
        ['y'] = 421495.96875
    },
    "mklogizone"
}

SEFARPLogiSpawn = {logispawn, "HEMTT TFFT",
    {
        ['x'] = -26322.15625,
        ['y'] = 421495.96875
    },
    "sefarplogizone"
}

-- Transport Spawns
NorthGeorgiaTransportSpawns = {
    ['Novorossiysk'] = {Spawner("NovoroTransport"), Spawner("NovoroTransportHelo"), NovoLogiSpawn},
    ['Gelendzhik'] = {Spawner("GelenTransport"), Spawner("GelenTransportHelo"), nil},
    ['Krasnodar-Center'] = {Spawner("KDARTransport"), Spawner("KrasCenterTransportHelo"), KrasCenterLogiSpawn},
    ['Krasnodar_Pashkovsky'] = {Spawner("KDAR2Transport"), Spawner("KrasPashTransportHelo"), nil},
    ['Krymsk'] = {Spawner("KrymskTransport"), Spawner("KrymskTransportHelo"), KryLogiSpawn}
}

NorthGeorgiaFARPTransportSpawns = {
    ["NW"] = {Spawner("NW FARP HELO"), nil, nil},
    ["NE"] = {Spawner("NE FARP HELO"), nil, nil},
    ["SW"] = {Spawner("SW FARP HELO"),nil, nil},
    ["SE"] = {Spawner("SE FARP HELO"),nil, SEFARPLogiSpawn},
    ["MK"] = {Spawner("MK FARP HELO"), nil, MaykopLogiSpawn}
}

-- Airfield CAS Spawns
RussianTheaterCASSpawn = Spawner("Su25T-CASGroup")

-- FARP defenses
NWFARPDEF = Spawner("FARP DEFENSE")
SWFARPDEF = Spawner("FARP DEFENSE #001")
NEFARPDEF = Spawner("FARP DEFENSE #003")
SEFARPDEF = Spawner("FARP DEFENSE #002")
MKFARPDEF = Spawner("FARP DEFENSE #004")

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
