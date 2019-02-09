-- table load_options(void)
function XAW.state.load_options()
    --[[
    options can be defined from any or all of the following locations:
        1 global var xaw_mission_options - assumes lua encoded
        2 global var xaw_mission_options_path - assumes json encoded
        3 XAW.options_path - assumes json encoded

    The options locations will be read in reverse order as listed above, options
    listed in later objects will override options noted by earlier objects.
    No locations need to be defined and the compiled in defaults will be used.
    --]]
    local options = {}
    options.init = XAW.enum.options.init.RANDOM
    return options
end

function XAW.state.set_game(partialstate)
    --[[
    check some basic fields that are expected to exist, it is an assert
        if the table passed fails the basic checking
    fill out the rest of the game_state table and set
    --]]
end

function XAW.state.gen_start()
    --[[
    game_options.init = "static | random"

    if == static we expect an initial game state to be either defined in
            a global mission_start_state or XAW.game_options.mission_start_state_path
            or XAW.start_state_path file.
            If none of these exist it is an assert.
            Otherwise we load the state just like an interum state with
                XAW.state.load_saved()

    if == random we expect an orbat style config file to be either defined in
            a global mission_start_state or XAW.game_options.mission_start_state_path
            or XAW.start_state_path file.
            If none exists it is an assert.
            Otherwise we must generate an inital game state from the ORBAT and
                then set game state with XAW.state.set_game()
    --]]
    if t then
    end
end

function XAW.state.load_saved(statefile)
    XAW.state.set_game(json:decode(statefile:read("*all")))
end

function XAW.state.init()
    XAW.state.load_options()

    local statefile = io.open(XAW.run_state_path, 'r')
    if statefile then
        XAW.state.load_saved(statefile)
        statefile:close()
    else
        XAW.state.gen_start()
    end

--[[
things that need to be setup regardless from where the state comes from

Foreach Airbase and FARP participating in scenario:
    - setup which side the base belongs to
    - spawn any local defense for each base
    - setup any slot blocking
end

Foreach Asset in scenario:
    - spawn asset
    - spawn any associated air defense assets
end
--]]

end
