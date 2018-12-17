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
	return caps
end

local utility_cap = function()
	--[[
	-- CAP Goal/Limits
	--   min: ??; max: ??
	--
	-- Parameters that affect number of CAPs available, where and when
	-- they spawn;
	--   effects maximum available local a/c
	--   * # ammo dumps
	--   * # airports
	--
	--   effects commander response time
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
	-- 
	--]]
end

-- Main game loop, decision making about spawns happen here.
russian_commander = function()
    -- Russian Theater Decision Making
    log("Russian commander is thinking...")
    local bluePlanes = mist.makeUnitTable({'[blue][plane]'})
    local bluePlaneCount = 0
    for i,v in pairs(bluePlanes) do
        if Unit.getByName(v) then bluePlaneCount = bluePlaneCount + 1 end
    end
    local time = timer.getAbsTime() + env.mission.start_time
    local c2s = game_state["Theaters"]["Russian Theater"]["C2"]
    local caps = game_state["Theaters"]["Russian Theater"]["CAP"]
    local castargets = game_state["Theaters"]["Russian Theater"]["CASTargets"]
    local baitargets = game_state["Theaters"]["Russian Theater"]["BAI"]
    local ewrs = game_state["Theaters"]["Russian Theater"]["EWR"]
    local striketargets = game_state["Theaters"]["Russian Theater"]["StrikeTargets"]
    local last_cap_spawn = game_state["Theaters"]["Russian Theater"]["last_cap_spawn"]
    local random_cap = 0
    local adcap_chance = 0.4
    local aliveAWACs = 0
    local aliveEWRs = 0
    local aliveAmmoDumps = 0
    local aliveCommsArrays = 0
    local alivec2s = 0
    local alive_caps = 0
    local max_caps = 3
    local nominal_c2s = 4
    local nominal_awacs = 1
    local nominal_ammodumps = 3
    local nominal_commsarrays = 3
    local nominal_ewrs = 2
    local p_spawn_mig31s = 0.95
    local p_attack_airbase = 0.2
    local p_spawn_airbase_cap = 0.7

    max_caps = max_caps_for_player_count(bluePlaneCount)
    log("There are " .. bluePlaneCount .. " blue planes in the mission, so we'll spawn a max of " .. max_caps .. " groups of enemy CAP")

    local alive_bai_targets = 0

    local max_bai = 5

    -- Get the number of C2s in existance, and cleanup the state for dead ones.
    -- We'll make some further determiniation of what happens based on this
    alivec2s = array_size(c2s)
    log("Russian commander has " .. alivec2s .. " command posts available...")
    
    
    -- Get the number of EWRs in existence, as we use this for determination of spawn rates
    aliveEWRs = array_size(ewrs)
    log("Russian commanbder has " .. aliveEWRs .. " EWRs available...")
    
    for group_name, group_table in pairs(striketargets) do
      if group_table['spawn_name'] == 'AmmoDump' then aliveAmmoDumps = aliveAmmoDumps + 1 end
      if group_table['spawn_name'] == 'CommsArray' then aliveCommsArrays = aliveCommsArrays + 1 end
    end
    
    log("Russian commander has " .. aliveAmmoDumps .. " Ammo Dumps available...")
    log("Russian commander has " .. aliveCommsArrays .. " Comms Arrays available...")

    -- Get alive caps and cleanup state
    for i=#caps, 1, -1 do
        local cap = Group.getByName(caps[i])
        if cap and isAlive(cap) then
            if allOnGround(cap) then
                cap:destroy()
                log("Found inactive cap, removing")
                table.remove(caps, i)
            else
                alive_caps = alive_caps + 1
            end
        else
            table.remove(caps, i)
        end
    end


    log("The Russian commander has " .. alive_caps .. " flights alive")
    -- Get Alive BAI Targets
    alive_bai_targets = array_size(baitargets)
    log("The Russian commander has " .. alive_bai_targets .. " ground squads alive.")

    --if alivec2s == 0 then log('Russian commander whispers "BLYAT!" and runs for the hills before he ends up in a gulag.'); return nil end

    -- Setup some decision parameters based on how many tactical resources are alive
    p_attack_airbase = 0.1 + 0.1*(aliveAmmoDumps/nominal_ammodumps) + 0.1*(alivec2s/nominal_c2s)
    p_spawn_mig31s = 0.65 + 0.1*(aliveEWRs/nominal_ewrs) + 0.1*(alivec2s/nominal_c2s)
    p_spawn_airbase_cap = 0.5 + 0.2*(aliveAmmoDumps/nominal_ammodumps) + 0.1*(1-(aliveCommsArrays/nominal_commsarrays))
    
    if alivec2s == 3 then random_cap = 30 end
    if alivec2s == 2 then random_cap = 60; adcap_chance = 0.4 end
    if alivec2s == 1 then random_cap = 120 adcap_chance = 0.8 end
    local command_delay = math.random(10, random_cap)
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

    if alive_bai_targets < max_bai then
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
        for i,g in ipairs(enemy_interceptors) do
            if allOnGround(g) then
                Group.getByName(g):destroy()
            end

            if not isAlive(g) then
                enemy_interceptors = {}
            end
        end

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
