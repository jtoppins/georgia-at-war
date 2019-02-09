-- Setup an initial state object and provide functions for manipulating that state.
--[[
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
--]]

function gaw.init.gameState()
    local game_state = {
        ["last_launched_time"] = 0,
        ["last_cap_spawn"] = 0,
        ["Bases"] = {},
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
    }

    local game_stats = {
        c2    = {
            alive = 0,
            nominal = 3,
            tbl   = game_state["Theaters"]["Russian Theater"]["C2"],
        },
        ewr = {
            alive = 0,
            nominal = 3,
            tbl   = game_state["Theaters"]["Russian Theater"]["EWR"],
        },
        awacs = {
            alive = 0,
            nominal = 1,
            tbl   = game_state["Theaters"]["Russian Theater"]["AWACS"],
        },
        bai = {
            alive = 0,
            nominal = 5,
            tbl = game_state["Theaters"]["Russian Theater"]["BAI"],
        },
        ammo = {
            alive = 0,
            nominal = 3,
            tbl   = game_state["Theaters"]["Russian Theater"]["StrikeTargets"],
            subtype = "AmmoDump",
        },
        comms = {
            alive = 0,
            nominal = 2,
            tbl   = game_state["Theaters"]["Russian Theater"]["StrikeTargets"],
            subtype = "CommsArray",
        },
        caps = {
            alive = 0,
            nominal = 7,
            tbl = game_state["Theaters"]["Russian Theater"]["CAP"],
        },
        bases = {
            alive = 0,
            nominal = 3,
            tbl = game_state["Theaters"]["Russian Theater"]["Bases"],
        },
    }
    local game = {}
    game.state = game_state
    game.stats = game_stats

    for name, data in pairs(gaw.mission.init.bases) do
        game_state["Bases"][name] = Airbase.getByName(name):getCoalition()
    end

    return game
end
