local statefile = io.open(lfs.writedir() .. "Scripts\\GAW\\state.json", 'r')

-- Enable slotblock
trigger.action.setUserFlag("SSB",100)
if statefile then
    local ab_logi_slots = {
        [AIRBASE.Caucasus.Novorossiysk] = NovoLogiSpawn,
        [AIRBASE.Caucasus.Gelendzhik] = nil,
        [AIRBASE.Caucasus.Krymsk] = KryLogiSpawn,
        [AIRBASE.Caucasus.Krasnodar_Center] = KrasCenterLogiSpawn,
        [AIRBASE.Caucasus.Krasnodar_Pashkovsky] = nil,
    }

    MESSAGE:New("Found a statefile.  Processing it instead of starting a new game", 40):ToAll()
    local state = statefile:read("*all")
    statefile:close()
    local saved_game_state = json:decode(state)
    for name, coalition in pairs(saved_game_state["Theaters"]["Russian Theater"]["Airfields"]) do
        local flagval = 100
        local ab = AIRBASE:FindByName(name)
        local apV3 = POINT_VEC3:NewFromVec3(ab:GetPositionVec3())
        apV3:SetX(apV3:GetX() + math.random(100, 200))
        apV3:SetY(apV3:GetY() + math.random(100, 200))
        game_state["Theaters"]["Russian Theater"]["Airfields"][name] = coalition

        if coalition == 1 then
            AirbaseSpawns[name][2]:Spawn()
            flagval = 100
        elseif coalition == 2 then
            AirfieldDefense:SpawnFromVec2(apV3:GetVec2())
            apV3:SetX(apV3:GetX() + math.random(100, 200))
            apV3:SetY(apV3:GetY() + math.random(100, 200))
            FSW:SpawnFromVec2(apV3:GetVec2())
            FSE:SpawnFromVec2(apV3:GetVec2())
            flagval = 0

            if ab_logi_slots[name] then
                activateLogi(ab_logi_slots[name])
            end
        end

        for i,grp in ipairs(abslots[name]) do
            trigger.action.setUserFlag(grp, flagval)     
        end
    end

    for name, coalition in pairs(saved_game_state["Theaters"]["Russian Theater"]["FARPS"]) do
        local flagval = 100
        local ab = AIRBASE:FindByName(name)
        local apV3 = POINT_VEC3:NewFromVec3(ab:GetPositionVec3())
        apV3:SetX(apV3:GetX() + math.random(100, 200))
        apV3:SetY(apV3:GetY() + math.random(100, 200))
        local spawns = {NWFARPDEF, SWFARPDEF, NEFARPDEF, SEFARPDEF}
        game_state["Theaters"]["Russian Theater"]["FARPS"][name] = coalition

        if coalition == 1 then
            spawns[math.random(4)]:SpawnFromVec2(apV3:GetVec2())
            flagval = 100
        elseif coalition == 2 then
            AirfieldDefense:SpawnFromVec2(apV3:GetVec2())
            apV3:SetX(apV3:GetX() + math.random(-100, 200))
            apV3:SetY(apV3:GetY() + math.random(-100, 200))
            FSW:SpawnFromVec2(apV3:GetVec2())
            FSE:SpawnFromVec2(apV3:GetVec2())
            flagval = 0
        end

        for i,grp in ipairs(abslots[name]) do
            trigger.action.setUserFlag(grp, flagval)     
        end
    end

    for name, data in pairs(saved_game_state["Theaters"]["Russian Theater"]["StrategicSAM"]) do
        local spawn
        if data.spawn_name == "SA6" then spawn = RussianTheaterSA6Spawn[1] end
        if data.spawn_name == "SA10" then spawn = RussianTheaterSA10Spawn[1] end
        spawn:SpawnFromVec2({['x'] = data['position'][1], ['y'] = data['position'][2]})
    end

    for name, data in pairs(saved_game_state["Theaters"]["Russian Theater"]["NavalStrike"]) do
        local spawn
        if data.spawn_name == "Oil Platform" then
            spawn = PlatformGroupSpawn[1]
            local static = spawn:SpawnFromPointVec2(
            POINT_VEC2:NewFromVec2({
                ['x'] = data['position'][1],
                ['y'] = data['position'][2]
            }), 0)

            AddNavalStrike("Russian Theater")(STATIC:FindByName(static:getName()), "Oil Platform", data['callsign'])
        else
            if data.spawn_name == 'Tanker' then spawn = TankerGroupSpawn[1] end
            if data.spawn_name == 'Cargo' then spawn = CargoGroupSpawn[1] end
            if data.spawn_name == 'Naval Strike Group' then spawn = RusNavySpawn[1] end
            spawn:SpawnFromVec2({['x'] = data['position'][1], ['y'] = data['position'][2]})
        end
    end

    for name, data in pairs(saved_game_state["Theaters"]["Russian Theater"]["C2"]) do
        RussianTheaterC2Spawn[1]:SpawnFromVec2({['x'] = data['position'][1], ['y'] = data['position'][2]})
    end

    for name, data in pairs(saved_game_state["Theaters"]["Russian Theater"]["EWR"]) do
        RussianTheaterEWRSpawn[1]:SpawnFromVec2({['x'] = data['position'][1], ['y'] = data['position'][2]})
    end

    for name, data in pairs(saved_game_state["Theaters"]["Russian Theater"]["StrikeTargets"]) do        
        local spawn
        if data['spawn_name'] == 'Ammo Dump' then spawn = AmmoDumpSpawn[1] end
        if data['spawn_name'] == 'Comms Array' then spawn = CommsArraySpawn[1] end
        if data['spawn_name'] == 'Power Plant' then spawn = PowerPlantSpawn[1] end
        local static = spawn:SpawnFromPointVec2(
            POINT_VEC2:NewFromVec2({
                ['x'] = data['position'][1],
                ['y'] = data['position'][2]
            }), 0)
        AddRussianTheaterStrikeTarget(STATIC:FindByName(static:getName()), data['spawn_name'], data['callsign'])
    end

    for name, data in pairs(saved_game_state["Theaters"]["Russian Theater"]["BAI"]) do
        log(data.callsign)
        local spawn
        if data['spawn_name'] == "ARTILLERY" then spawn = RussianHeavyArtySpawn[1] end
        if data['spawn_name'] == "ARMOR COLUMN" then spawn = ArmorColumnSpawn[1] end
        if data['spawn_name'] == "MECH INF" then spawn = MechInfSpawn[1] end
        spawn:SpawnFromVec2({['x'] = data['position'][1], ['y'] = data['position'][2]})
    end

    for idx, data in ipairs(saved_game_state["Theaters"]["Russian Theater"]["CTLD_ASSETS"]) do
        if data.name == 'hawk' then
            hawkspawn:SpawnFromVec2(data.pos)
        end

        if data.name == 'avenger' then
            avengerspawn:SpawnFromVec2(data.pos)
        end

        if data.name == 'ammo' then
            ammospawn:SpawnFromVec2(data.pos)
        end
    end

else
    -- Populate the world and gameplay environment.
    for i=1, 4 do
        local zone_index = math.random(23)
        local zone = ZONE:New("NorthSA6Zone" .. zone_index)
        RussianTheaterSA6Spawn[1]:SpawnInZone(zone, true)
    end

    for i=1, 3 do
        if i < 3 then
            local zone_index = math.random(8)
            local zone = ZONE:New("NorthSA10Zone" .. zone_index)
            RussianTheaterSA10Spawn[1]:SpawnInZone(zone, true)
        end

        local zone_index = math.random(8)
        local zone = ZONE:New("NorthSA10Zone" .. zone_index)
        RussianTheaterEWRSpawn[1]:SpawnInZone(zone, true)

        local zone_index = math.random(8)
        local zone = ZONE:New("NorthSA10Zone" .. zone_index)
        RussianTheaterC2Spawn[1]:SpawnInZone(zone, true)
    end

    for i=1, 10 do
        local zone_index = math.random(18)
        local zone = ZONE:New("NorthStatic" .. zone_index)
        local StaticSpawns = {AmmoDumpSpawn, PowerPlantSpawn, CommsArraySpawn}
        local spawn_index = math.random(3)
        local static = StaticSpawns[spawn_index][1]:SpawnFromPointVec2(zone:GetRandomPointVec2(), 0)
        local callsign = getCallsign()
        AddRussianTheaterStrikeTarget(STATIC:FindByName(static:getName()), StaticSpawns[spawn_index][2], callsign)
    end

    -- Spawn the Sea of Azov navy
    RusNavySpawn[1]:Spawn()
    for i=1, 4 do
        local zone_index = math.random(2)
        local zone = ZONE:New("Naval" .. zone_index)
        local spawn_index = math.random(2)
        local spawn = navalstrikespawns[spawn_index]
        spawn[1]:SpawnInZone(zone, true)

        -- Spawn a oil platform as well
        local static = PlatformGroupSpawn[1]:SpawnFromPointVec2(zone:GetRandomPointVec2(), 0)
        local callsign = getCallsign()
        AddNavalStrike("Russian Theater")(STATIC:FindByName(static:getName()), "Oil Platform", callsign)
    end

    AirbaseSpawns[AIRBASE.Caucasus.Krasnodar_Pashkovsky][1]:Spawn()
    NWFARPDEF:Spawn()
    SWFARPDEF:Spawn()
    NEFARPDEF:Spawn()
    SEFARPDEF:Spawn()

    -- Disable slots
    trigger.action.setUserFlag("Novoro Huey 1",100)
    trigger.action.setUserFlag("Novoro Huey 2",100)
    trigger.action.setUserFlag("Novoro Mi-8 1",100)
    trigger.action.setUserFlag("Novoro Mi-8 2",100)

    trigger.action.setUserFlag("Krymsk Huey 1",100)
    trigger.action.setUserFlag("Krymsk Huey 2",100)
    trigger.action.setUserFlag("Krymsk Mi-8 1",100)
    trigger.action.setUserFlag("Krymsk Mi-8 2",100)

    trigger.action.setUserFlag("Krymsk Gazelle M",100)
    trigger.action.setUserFlag("Krymsk Gazelle L",100)

    trigger.action.setUserFlag("Krasnador Huey 1",100)
    trigger.action.setUserFlag("Krasnador Huey 2",100)
    trigger.action.setUserFlag("Kras Mi-8 1",100)
    trigger.action.setUserFlag("Kras Mi-8 2",100)

    -- FARPS
    trigger.action.setUserFlag("SWFARP Huey 1",100)
    trigger.action.setUserFlag("SWFARP Huey 2",100)
    trigger.action.setUserFlag("SWFARP Mi-8 2",100)
    trigger.action.setUserFlag("SWFARP Mi-8 2",100)

    trigger.action.setUserFlag("SEFARP Gazelle M",100)
    trigger.action.setUserFlag("SEFARP Gazelle L",100)

    trigger.action.setUserFlag("NWFARP Huey 1",100)
    trigger.action.setUserFlag("NWFARP Huey 2",100)
    trigger.action.setUserFlag("SWFARP Mi-8 2",100)
    trigger.action.setUserFlag("SWFARP Mi-8 2",100)

    trigger.action.setUserFlag("NEFARP Huey 1",100)
    trigger.action.setUserFlag("NEFARP Huey 2",100)
    trigger.action.setUserFlag("SWFARP Mi-8 2",100)
    trigger.action.setUserFlag("SWFARP Mi-8 2",100)

    trigger.action.setUserFlag("SEFARP Huey 1",100)
    trigger.action.setUserFlag("SEFARP Huey 2",100)
    trigger.action.setUserFlag("SWFARP Mi-8 2",100)
    trigger.action.setUserFlag("SWFARP Mi-8 2",100)

    trigger.action.setUserFlag("NWFARP KA50",100)
    trigger.action.setUserFlag("SEFARP KA50",100)
end

-- Kick off the commanders
SCHEDULER:New(nil, function()
    log("Starting Russian Commander, Comrade")
    --pcall(russian_commander)
    russian_commander()
end, {}, 10, 400)

-- Kick off the supports
RussianTheaterAWACSSpawn:Spawn()
OverlordSpawn:Spawn()
RUSTankerSpawn:Spawn()
TexacoSpawn:Spawn()
ShellSpawn:Spawn()

SCHEDULER:New(nil, function() 
    local state = TheaterUpdate("Russian Theater")
    MESSAGE:New(state, 45):ToAll()
end, {}, 120, 900)

buildHitEvent(GROUP:FindByName("FARP DEFENSE #003"), "NE FARP")
buildHitEvent(GROUP:FindByName("FARP DEFENSE"), "NW FARP")
buildHitEvent(GROUP:FindByName("FARP DEFENSE #002"), "SE FARP")
buildHitEvent(GROUP:FindByName("FARP DEFENSE #001"), "SW FARP")

BASE:I("HOGGIT GAW - INIT COMPLETE")
log("init.lua complete")