-- Setup an initial state object and provide functions for manipulating that state.

game_state = {
    -- represents airbases or farps that can be captured
    bases = {
        [name]  = {side = "<r|b|n>", security = "<h|m|l>", "??"},
        [nameN] = {side = "<r|b|n>", security = "<h|m|l>", "??"},
    },
    -- represents units and statics that do not normally move in a theater
    -- can be;
    --  strategic sams, c2s, ewrs, ammo dumps, fuel depots, theaters objectives, and
    --  defense units spawned to protect the assets
    assets = {
        [name] = {template, position, type, damage, defenses = {name1, nameN}, "??"},
        [nameN] = {template, position, type, damage, defenses = {name1, nameN}, "??"},
    },
    redfor = {
        stats = {
        },
    },
    blufor = {
        stats = {
        },
    },
}

game_state = {
    ["last_launched_time"] = 0,
    ["CurrentTheater"] = "Russian Theater",
    ["Theaters"] = {
        ["Russian Theater"] ={
            ["last_cap_spawn"] = 0,
            ["Airfields"] = {
                ["Novorossiysk"] = Airbase.getByName("Novorossiysk"):getCoalition(),
                ["Gelendzhik"] = Airbase.getByName("Gelendzhik"):getCoalition(),
                ["Krymsk"] = Airbase.getByName("Krymsk"):getCoalition(),
                ["Krasnodar-Center"] = Airbase.getByName("Krasnodar-Center"):getCoalition(),
                ["Krasnodar-Pashkovsky"] = Airbase.getByName("Krasnodar-Pashkovsky"):getCoalition(),
            },
            ["Primary"] = {
                ["Maykop-Khanskaya"] = false,
            },
            ["StrategicSAM"] = {},
            ["C2"] = {},
            ["EWR"] = {},
            ["CASTargets"] = {},
            ["StrikeTargets"] = {},
            ["TheaterObjectives"] = {},
            ["InterceptTargets"] = {},
            ["DestroyedStatics"] = {},
            ["OpforCAS"] = {},
            ["CAP"] = {},
            ["BAI"] = {},
            ["AWACS"] = {},
            ["Tanker"] = {},
            ["NavalStrike"] = {},
            ["CTLD_ASSETS"] = {},
            ['Convoys'] ={},
            ["FARPS"] = {
                ["SW Warehouse"] = Airbase.getByName("SW Warehouse"):getCoalition(),
                ["NW Warehouse"] = Airbase.getByName("NW Warehouse"):getCoalition(),
                ["SE Warehouse"] = Airbase.getByName("SE Warehouse"):getCoalition(),
                ["NE Warehouse"] = Airbase.getByName("NE Warehouse"):getCoalition(),
                ["MK Warehouse"] = Airbase.getByName("MK Warehouse"):getCoalition(),
            }
        }
    }
}

log("Game State INIT")
