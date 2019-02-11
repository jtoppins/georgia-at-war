--[[
TODO:

NOTES:
So I do not think we need to use the weird code loading schemes that people have
used like dofile or loadfile. I think we can use the ledgimate require(modname)
call by just modifying package.path, something like this should work:

-----
local addpath = lfs.writedir() .. "Scripts\\XAW\\?.lua;" ..
                lfs.writedir() .. "Scripts\\XAW\\?\\?.lua"
package.path = package.path .. ";" .. addpath
-----

This will add XAW to the end of module search path and should allow for the
following:

require("xawinit")

We will probably need to prefix our files so that do not collide with and DCS
files, as I am sure they didn't do any prefixing. If this works we do not
have to do odd/dumb namespacing things like mist and others do. A mission
designer could literally include the following in a doscript mission start
trigger.

----
local addpath = lfs.writedir() .. "Scripts\\XAW\\?.lua;" ..
                lfs.writedir() .. "Scripts\\XAW\\?\\?.lua"
package.path = package.path .. ";" .. addpath
local x = require("xawinit")
x.init()
----

I am pretty sure lfs.writedir() points to your "Saved Games/DCS" directory.

This works but requires the MissionScripting.lua file to be modified to
not sanatize lfs and overwrite 'require' to nil. This seems doable as
GAW already doesn't sanatize the scripting environment, for reasons I do
not know.
--]]


-- table load_options(void)
function xaw.init.load_options()
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

function xaw.state.set(partialstate)
    --[[
    check some basic fields that are expected to exist,
        it is an assert if the table passed fails the basic checking
    fill out the rest of the game_state table and set
    --]]
    xaw.game_state = partialstate
end

function xaw.mission.gen_state()
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

function xaw.mission.load_saved(statefile)
    return json:decode(statefile:read("*all"))
end

function xaw.mission.init()
    xaw.mission.load_options()

    -- TODO: do "init all subsystems" from flowchart

    local statefile = io.open(xaw.run_state_path, 'r')
    local game_state = {}
    if statefile then
        game_state = xaw.mission.load_saved_state(statefile)
        statefile:close()
        statefile = nil
    else
        game_state = xaw.mission.gen_state()
    end

    for name, data in pairs(game_state) do
        -- TODO: ?? need to decide on a game_state export format
        --      is it a flattend format, like:
        --  (1) game_state = {
        --          [name]  = {...data...},
        --          [nameN] = {...data...},
        --      }
        --
        --  -or-
        --
        --  (2) game_state = {
        --          ["facilities"] = {
        --              [name]  = {...data...},
        --              [nameN] = {...data...},
        --          },
        --          ["ground_groups"] = {
        --              [name]  = {...data...},
        --              [nameN] = {...data...},
        --          },
        --          ...
        --      }
        --
        --  Neither format explicitly talks about how to document what side
        --  something belongs to, though I am not sure that really matters
        --  as the country (defined by their template) will determine that.
        --  Using option 1 (the flat format) guarentees all names are unique
        --  which is a requirement of the engine anyway. This format doesn't
        --  necessarily need to dictate the storage format of the in-memory
        --  game_state either.
        local etype = 0
        if data.type == xaw.state.enum.type.FACILITY then
            etpye = xaw.event.enums.types.SPAWNFACILITY
        else
            assert(false, "problems")
        end
        data.name = name

        local e = xaw.event.Event(etpye, data)
        globaleventqueue:push(etype, e)
    end

    eventprocessor:start()
    redforcmdr:start()
end


