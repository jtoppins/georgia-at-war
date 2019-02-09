--Airbases in play.
Airbases = {
    ["Gelendzhik"]           = {
        spwndefence = nil,
        spwntranspo = Spawner("GelenRussiaTransport"),
        spwnhelo    = Spawner("GelenHeloTransport"),
    },
    ["Krasnodar-Pashkovsky"] = {
        spwndefence = nil,
        spwntranspo = Spawner("KrasPashRussiaTransport"),
        spwnhelo    = Spawner("KrasPashHeloTransport"),
    },
    ["Krasnodar-Center"]     = {
        spwndefence = nil,
        spwntranspo = Spawner("KrasCenterRussiaTransport"),
        spwnhelo    = Spawner("KrasCenterHeloTransport"),
    },
    ["Novorossiysk"]         = {
        spwndefence = nil,
        spwntranspo = Spawner("NovoroRussiaTransport"),
        spwnhelo    = Spawner("NovoroHeloTransport"),
    },
    ["Krymsk"]               = {
        spwndefence = nil,
        spwntranspo = Spawner("KrymskRussiaTransport"),
        spwnhelo    = Spawner("KrymskHeloTransport"),
    },
}

RussianTheaterAirfieldDefSpawn = Spawner("Russia-Airfield-Def")

AirbaseSpawns = {
  ["Gelendzhik"]={GelenTransportSpawn, GelenHeloSpawn, DefGlensPenis},
  ["Krasnodar-Pashkovsky"]={KrasnodarPashkovskyTransportSpawn, KrasnodarPashkovskyHeloSpawn, DefKrasPash},
  ["Krasnodar-Center"]={KrasnodarCenterTransportSpawn, KrasnodarCenterHeloSpawn, DefKrasCenter},
  ["Novorossiysk"]={NovoroTransportSpawn, NovoroHeloSpawn, DefNovo},
  ["Krymsk"]={KrymskTransportSpawn, KrymskHeloSpawn, DefKrymsk}
}

-- REDFOR specific airfield defense spawns
DefGlensPenis = Spawner("Red Airfield Defense GlensDick 1")
DefKrasPash = Spawner("Red Airfield Defense Kras-Pash 1")
DefKrasCenter = Spawner("Red Airfield Defense Kras-Center 1")
DefKrymsk = Spawner("Red Airfield Defense Krymsk 1")
DefNovo = Spawner("Red Airfield Defense Novo 1")

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

