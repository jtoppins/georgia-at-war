--[[
--  XAW - 'x' At War
--
--  A structure that holds globals that are used by the rest of the framework.
--  It is held in this seperate namespace to reduce name collision.
--]]

xaw = {
    options_path = lfs.writedir() .. "Scripts\\xaw-mission-options.json",
    start_state_path = lfs.writedir() .. "Scripts\\xaw-mission-start-state.json",
    run_state_path = lfs.writedir() .. "Scripts\\xaw-mission-state.json",
    game_options = {},
    game_state = {},
    mission = {}

    enum = {
        options = {
            init = {
                ["RANDOM"] = 0,
                ["STATIC"] = 1,
            },
        },
    },
}

io.open(lfs.writedir() .. "Scripts\\xaw-mission-state.json", 'r')
