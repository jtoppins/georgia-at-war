do
	local xaw  = require('xaw')
	local json = require('xaw.libs.json')

	local mission = {}

	-- prototype: table load_options(void)
	function mission.load_options()
		--[[
		options can be defined from any or all of the following locations:
	        1 global var xaw_mission_options - assumes lua encoded
		    2 global var xaw_mission_options_path - assumes json encoded
		    3 xaw.options_path - assumes json encoded

		The options locations will be read in reverse order as listed above, options
		listed in later objects will override options noted by earlier objects.
		No locations need to be defined and the compiled in defaults will be used.
		--]]
		local options = {}
		options.init = xaw.enum.options.init.RANDOM
		return options
	end

	-- prototype: table load_state(FileObject)
	function mission.load_state(statefile)
		return json:decode(statefile:read("*all"))
	end

	-- prototype: void save_state(FileObject)
	function mission.save_state(statefile)
		statefile:write(json:encode(xaw.game_state:export()))
	end

	-- prototype: table gen_state(InitState)
	function mission.gen_state(initstate)
		--[[
		game_options.init = "static | random"

		if == static we expect an initial game state to be either defined in
		        a global mission_start_state or xaw.game_options.mission_start_state_path
		        or xaw.start_state_path file.
		        If none of these exist it is an assert.
		        Otherwise we load the state just like an interum state with
		            xaw.state.load_saved()

		if == random we expect an orbat style config file to be either defined in
		        a global mission_start_state or xaw.game_options.mission_start_state_path
		        or xaw.start_state_path file.
		        If none exists it is an assert.
		        Otherwise we must generate an inital game state from the ORBAT and
		            then set game state with xaw.state.set()
		--]]

		local new_state = {
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

		local new_stats = {
		    c2    = {
		        alive = 0,
		        nominal = 0,
		        tbl   = game_state["Theaters"]["Russian Theater"]["C2"],
		    },
		    ewr = {
		        alive = 0,
		        nominal = 0,
		        tbl   = game_state["Theaters"]["Russian Theater"]["EWR"],
		    },
		    awacs = {
		        alive = 0,
		        nominal = 0,
		        tbl   = game_state["Theaters"]["Russian Theater"]["AWACS"],
		    },
		    bai = {
		        alive = 0,
		        nominal = 0,
		        tbl = game_state["Theaters"]["Russian Theater"]["BAI"],
		    },
		    ammo = {
		        alive = 0,
		        nominal = 0,
		        tbl   = game_state["Theaters"]["Russian Theater"]["StrikeTargets"],
		        subtype = "AmmoDump",
		    },
		    comms = {
		        alive = 0,
		        nominal = 0,
		        tbl   = game_state["Theaters"]["Russian Theater"]["StrikeTargets"],
		        subtype = "CommsArray",
		    },
		    caps = {
		        alive = 0,
		        nominal = 0,
		        tbl = game_state["Theaters"]["Russian Theater"]["CAP"],
		    },
		    bases = {
		        alive = 0,
		        nominal = 0,
		        tbl = game_state["Theaters"]["Russian Theater"]["Bases"],
		    },
		}

		for name, data in pairs(xaw.mission.init.bases) do
		    game_state["Bases"][name] = Airbase.getByName(name):getCoalition()
		end

		-- Populate the world and gameplay environment.
		trigger.action.outText("No state file detected.  Creating new situation", 10)
		for i=1, 4 do
		    local zone_index = math.random(23)
		    local zone = "NorthSA6Zone"
		    RussianTheaterSA6Spawn[1]:SpawnInZone(zone .. zone_index)
		end

		for i=1, 3 do
		    if i < 3 then
		        local zone_index = math.random(8)
		        local zone = "NorthSA10Zone"
		        RussianTheaterSA10Spawn[1]:SpawnInZone(zone .. zone_index)
		    end

		    local zone_index = math.random(8)
		    local zone = "NorthSA10Zone"
		    RussianTheaterEWRSpawn[1]:SpawnInZone(zone .. zone_index)

		    local zone_index = math.random(8)
		    local zone = "NorthSA10Zone"
		    RussianTheaterC2Spawn[1]:SpawnInZone(zone .. zone_index)
		end

		SpawnStrikeTarget = function()
			local zone_index = math.random(10)
			local zone = "NorthStatic" .. zone_index
			local spawn = randomFromList(StrikeTargetSpawns)
			local vec2 = mist.getRandomPointInZone(zone)
			return spawn:Spawn({vec2.x, vec2.y})
		end

		-- similar way to generate strike targets
		-- p1
		for i=1, 10 do
		    local zone_index = math.random(18)
		    local zone = "NorthStatic" .. zone_index
		    local StaticSpawns = {AmmoDumpSpawn, PowerPlantSpawn, CommsArraySpawn}
		    local spawn_index = math.random(3)
		    local vec2 = mist.getRandomPointInZone(zone)
		    local id = StaticSpawns[spawn_index]:Spawn({vec2.x, vec2.y})
		end

		-- p2
		for i=1, 5 do
		    SpawnStrikeTarget()
		end

		-- spawn in initial defense assets
		AirbaseSpawns["Nalchik"][1]:Spawn()
		FARPALPHADEF:Spawn()
		FARPBRAVODEF:Spawn()
		FARPCHARLIEDEF:Spawn()
		FARPDELTADEF:Spawn()

		AirbaseSpawns["Krasnodar-Pashkovsky"][1]:Spawn()
		NWFARPDEF:Spawn()
		SWFARPDEF:Spawn()
		NEFARPDEF:Spawn()
		SEFARPDEF:Spawn()
		MKFARPDEF:Spawn()

		-- Make Sukhumi Red
		AirbaseSpawns['Sukhumi-Babushara'][3]:Spawn()

		-- theater objectives in phase2 are apparently statics that spawn in specific
		-- places
		for _,spawn in pairs(TheaterObjectives) do
		  spawn:Spawn()
		end

		return state
	end


--[[
-- update list of active CTLD AA sites in the global game state
function enumerateCTLD()
    local CTLDstate = {}
    log("Enumerating CTLD")
    for _groupname, _groupdetails in pairs(ctld.completeAASystems) do
        local CTLDsite = {}
        for k,v in pairs(_groupdetails) do
            CTLDsite[v['unit'] ] = v['point']
        end
        CTLDstate[_groupname] = CTLDsite
    end
    game_state["Theaters"]["Russian Theater"]["Hawks"] = CTLDstate
    log("Done Enumerating CTLD")
end

ctld.addCallback(function(_args)
    if _args.action and _args.action == "unpack" then
        local name
        local groupname = _args.spawnedGroup:getName()
        if string.match(groupname, "Hawk") then
            name = "hawk"
        elseif string.match(groupname, "Avenger") then
            name = "avenger"
        elseif string.match(groupname, "M 818") then
            name = 'ammo'
        elseif string.match(groupname, "Gepard") then
            name = 'gepard'
        elseif string.match(groupname, "MLRS") then
            name = 'mlrs'
        elseif string.match(groupname, "Hummer") then
            name = 'jtac'
        end

        table.insert(game_state["Theaters"]["Russian Theater"]["CTLD_ASSETS"], {
            name=name,
            pos=GetCoordinate(Group.getByName(groupname))
        })

        enumerateCTLD()
        write_state()
    end
end)
--]]

	return mission
end
