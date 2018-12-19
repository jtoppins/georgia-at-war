local clamp = function(x, min, max)
    local v = x
    if x < min then
        v = min
    elseif x > max then
        v = max
    end
    return v
end

local get_player_count = function()
    local bluePlanes = mist.makeUnitTable({'[blue][plane]'})
    local bluePlaneCount = 0
    for i,v in pairs(bluePlanes) do
        if Unit.getByName(v) then bluePlaneCount = bluePlaneCount + 1 end
    end
end

local array_size = function(o)
	local num = 0
	for i, j in pairs(o) do
		num = num + 1
	end
	return num
end

local max_caps_for_player_count = function(x)
	local caps = 0

	if x < 13 then
		caps = 1
	elseif x >= 13 and x < 18 then
		caps = 2
	elseif x >= 18 and x < 28 then
		caps = 3
	else
		caps = 4
	end

    log("There are " .. x .. " blue planes in the mission, so we'll spawn a max of " ..
        caps .. " groups of enemy CAP")
	return caps
end

c2_utility = function(c2)
    return math.pow(c2.alive/c2.nominal, 2)
end


local get_objective_stats = function()
    local stats = {
        c2 = {
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
            nominal = 3,
            tbl   = game_state["Theaters"]["Russian Theater"]["StrikeTargets"],
            subtype = "CommsArray",
        },
        caps = {
            alive = 0,
            nominal = 0,
            tbl = game_state["Theaters"]["Russian Theater"]["CAP"],
        },
        airports = {
            alive = 0,
            nominal = 3,
            tbl = nil, -- TODO
        },
    }

    -- Get Alive BAI Targets
    stats.bai.alive = array_size(stats.bai.tbl)
    log("The Russian commander has " .. stats.bai.alive .. " ground squads alive.")

    -- Get the number of EWRs in existence, as we use this for determination of spawn rates
    stats.ewr.alive = array_size(stats.ewr.tbl)
    log("Russian commanbder has " .. stats.ewr.alive .. " EWRs available...")

    -- Get the number of C2s in existance, and cleanup the state for dead ones.
    -- We'll make some further determiniation of what happens based on this
    stats.c2.alive = array_size(stats.c2.tbl)
    log("Russian commander has " .. stats.c2.alive .. " command posts available...")

    for group_name, group_table in pairs(stats.ammo.tbl) do
      if group_table['spawn_name'] == stats.ammo.subtype then stats.ammo.alive = stats.ammo.alive + 1 end
      if group_table['spawn_name'] == stats.comms.subtype then stats.comms.alive = stats.comms.alive + 1 end
    end
    log("Russian commander has " .. stats.ammo.alive .. " Ammo Dumps available...")
    log("Russian commander has " .. stats.comms.alive .. " Comms Arrays available...")

    stats.caps.nominal = max_caps_for_player_count(get_player_count())
    stats.caps.alive = #stats.caps.tbl
    log("The Russian commander has " .. stats.caps.alive .. " flights alive")
    return stats
end

command_delay = function(c2)
    local delay_max = 600 * .7
    local delay_min = 20

    return clamp(delay_min + delay_max * (1 - 1), delay_min, delay_max)
end

local _cap = function(stats)
	--[[
    -- [spawn list] = get_cap(stats)
    --
	-- CAP Goal/Limits
	--   min: ??; max: ??
	--
	-- Parameters that affect number of CAPs available, where and when
	-- they spawn;
	--   effects maximum available local a/c
	--   * # ammo dumps
	--   * # airports
	--
	--   effects overall commander response time
	--   * # C2 sites
	--   * # ewrs (early warning radars)
	--   * # AWACS
	--
	--   effects availability and frequency of off-theater a/c
	--   * # comms arrays
	--
	-- CAP spawn options:
	--  in-theater, off-theater
	--
	-- Actions available:
    --   * spawn advanced cap in-theater
    --   * spawn crappy cap in-theater
    --   * spawn advanced cap off-theater
    --   * spawn crappy cap off-theater
    --
    -- Force Protection Desire - desire to launch more CAP a/c
    --      U = f(players, alive caps)
    --  * in-theater adv, U = f(ammo, airports, alive caps)
    --  * in-theater poo, U = f(airports, alive caps)
    --  * off-theater adv, U = f(ammo, comms, alive caps)
    --  * off-theater poo, U = f(ammo, comms, alive caps)
    -- Intel Desire - desire to launch an AWACS, U = f(c2s, ewrs, awacs)
    --
	--]]

    local adcap_chance = 0.4
    local nominal_c2s = 4
    local nominal_awacs = 1
    local nominal_ammodumps = 3
    local nominal_commsarrays = 3
    local nominal_ewrs = 2
    local p_spawn_mig31s = 0.95
    local p_attack_airbase = 0.2
    local p_spawn_airbase_cap = 0.7

    -- Setup some decision parameters based on how many tactical resources are alive
    p_attack_airbase = 0.1 + 0.1*(aliveAmmoDumps/nominal_ammodumps) + 0.1*(alivec2s/nominal_c2s)
    p_spawn_mig31s = 0.65 + 0.1*(aliveEWRs/nominal_ewrs) + 0.1*(alivec2s/nominal_c2s)
    p_spawn_airbase_cap = 0.5 + 0.2*(aliveAmmoDumps/nominal_ammodumps) + 0.1*(1-(aliveCommsArrays/nominal_commsarrays))

    log("The Russian commander has a command delay of " .. command_delay .. " and a " .. (adcap_chance * 100) .. "% chance of getting decent planes...")

    if alive_caps < max_caps then
        log("The Russian commander is going to request " .. (max_caps - alive_caps) .. " additional CAP units.")
        for i = alive_caps + 1, max_caps do
            mist.scheduleFunction(function()
                if math.random() < adcap_chance then
                    -- Spawn fancy planes, 70% chance they come from airbase, otherwise they come from "off theater"
                    if math.random() < p_spawn_airbase_cap then
                        local capspawn = goodcapsground[math.random(#goodcapsground)]
                        capspawn:Spawn()
                        log("The Russian commander is getting a fancy plane from his local airbase")
                    else
                        local capspawn = goodcaps[math.random(#goodcaps)]
                        capspawn:Spawn()
                        log("The Russian commander is getting a fancy plane from a southern theater.")
                    end
                else
                    -- Spawn same ol crap
                    if math.random() < p_spawn_airbase_cap then
                        local capspawn = poopcapsground[math.random(#poopcapsground)]
                        capspawn:Spawn()
                        log("The Russian commander is getting a poopy plane from his local airbase")
                    else
                        local capspawn = poopcaps[math.random(#poopcaps)]
                        capspawn:Spawn()
                        log("The Russian commander is getting a poopy plane from a southern theater, thanks Ivan you piece of...")
                    end
                end
            end, {}, timer.getTime() + command_delay)
        end
    end


end

-- Main game loop, decision making about spawns happen here.
russian_commander = function()
    -- Russian Theater Decision Making
    log("Russian commander is thinking...")

    local time = timer.getAbsTime() + env.mission.start_time
    local objstats = get_objective_stats()
    local cmd_delay = command_delay(objstats.c2)

    if objstats.bai.alive < objstats.bai.max then
        log("The Russian Commander is going to request " .. (max_bai - alive_bai_targets) .. " additional strategic ground units")
        for i = alive_bai_targets + 1, max_bai do
            mist.scheduleFunction(function()
                local baispawn = baispawns[math.random(#baispawns)][1]
                local zone_index = math.random(13)
                local zone = "NorthCAS" .. zone_index
                baispawn:SpawnInZone(zone)
            end, {}, timer.getTime() + command_delay)
        end
    end

    log("Checking interceptors...")
    if math.random() < p_spawn_mig31s then
        if #enemy_interceptors == 0 then
            RussianTheaterMig312ShipSpawn:Spawn()
        end
    end
    log("The commander has " .. #enemy_interceptors .. " alive")


    for i,target in ipairs(AttackableAirbases(Airbases)) do
        log("The Russian commander has decided to strike " .. target .. " airbase")
        if not AirfieldIsDefended("DefenseZone" .. target) then
            if math.random() < p_attack_airbase then
                log(target .. " appears undefended! Muahaha!")
                local spawn = SpawnForTargetAirbase(target)
                spawn:Spawn()
            end
        end
    end

    --VIP Spawn Chance
    local VIPChance = 0.1
    if math.random() >= (1 - VIPChance) then
      log("Spawning russian VIP transport")
      SpawnVIPTransport()
    end

end

log("commander.lua complete")
