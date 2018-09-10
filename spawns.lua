-- Objective Names
objective_names = {
    "Archangel", "Yersanlaz", "Blackjack", "Wildcard", "Crackpipe", "Bullhorn", "Outlaw", "Eclipse","Joker", "Anthill",
    "Firefly", "Rambo", "Rocky", "Dredd", "Smokey", "Vulture", "Parrot","Ender", "Sanchez", "Freeman", "Charlotte", "Orlando",
    "Tiger", "Moocow", "Turkey", "Scarecrow", "Lancer", "Subaru", "Tucker", "Blazer", "Pikachu", "Bulbasaur", "Grimm", "Aurora", "Grumpy", "Sleepy",
    "Pete", "Bijou", "Momo",
    --Patreon
    "Eiger", "Snax", "Asteroid", "Sephton", "Blacklist", "Boot", "Maria", 
    "Cheeki Breeki", "Husky", "Carrack", "Vegabond", "Jar Jar", "Plowshare", "Primrose"
}

objective_idx = 1

getCallsign = function()
    local callsign = objective_names[objective_idx]
    objective_idx = objective_idx + 1
    if objective_idx > #objective_names then objective_idx = 1 end
    return callsign
end

-- Replace the spawn stuff
Spawner = function(grpName)
    local CallBack = {}
    return {
        Spawn = function(self)
            log("Spawning grp " .. grpName)
            local grp = mist.getGroupData(grpName)
            grp.clone=true
            added_grp = mist.dynAdd(grp)
            if CallBack.func then
                if not CallBack.args then CallBack.args = {} end
                mist.scheduleFunction(CallBack.func, {grpName, unpack(CallBack.args)}, timer.getTime() + 1)
            end
        end,
        SpawnInZone = function(self, zoneName)
            log("Spawning grp: " .. grpName .. " in Zone " .. zoneName)
            local _point = mist.getRandomPointInZone(zoneName)
            mist.teleportToPoint({
                groupName=grpName,
                point=_point,
                action="clone"
            })
            if CallBack.func then
                if not CallBack.args then CallBack.args = {} end
                mist.scheduleFunction(CallBack.func, {grpName, unpack(CallBack.args)}, timer.getTime() + 1)
            end
        end,
        OnSpawnGroup = function(self, f, args)
            CallBack.func = f
            CallBack.args = args
        end
    }
end



local attack_message_lock = 0

buildHitEvent = function(group, callsign)
    for i,unit in ipairs(group:GetUnits()) do
        unit:HandleEvent(EVENTS.Hit)
        function unit:OnEventHit(EventData)
            if EventData.IniPlayerName then
                local etime = timer.getAbsTime() + env.mission.start_time
                if etime > attack_message_lock + 5 then
                    local output = EventData.IniGroupName 
                    output = output .. " (" .. EventData.IniPlayerName .. ")"
                    output = output .. " is attacking " .. EventData.TgtTypeName .. " at objective " .. callsign
                    MESSAGE:New(output, 10):ToAll()
                    attack_message_lock = etime
                end
            end
        end
    end
end

buildCheckSAMEvent = function(group, callsign)
    log("Iterating sam events")
    for i,unit in ipairs(group:GetUnits()) do
        unit:HandleEvent(EVENTS.Dead)
        function unit:OnEventDead(EventData)
            local radars = 0
            local launchers = 0
            for i,inner_unit in ipairs(group:GetUnits()) do
                local type_name = inner_unit:GetTypeName()
                if type_name == "Kub 2P25 ln" then launchers = launchers + 1 end
                if type_name == "Kub 1S91 str" then radars = radars + 1 end
                if type_name == "S-300PS 64H6E sr" then radars = radars + 1 end
                if type_name == "S-300PS 40B6MD sr" then radars = radars + 1 end
                if type_name == "S-300PS 40B6M tr" then radars = radars + 1 end
                if type_name == "S-300PS 5P85C ln" then launchers = launchers + 1 end
                if type_name == "S-300PS 5P85D ln" then launchers = launchers + 1 end
            end

            if radars == 0 or launchers == 0 then
                game_state['Theaters']['Russian Theater']['StrategicSAM'][group:GetName()] = nil
                MESSAGE:New("SAM " .. callsign .. " has been destroyed!"):ToAll()
            end
        end
    end
    log("Done Iterating sam events")
end

buildCheckEWREvent = function(group, callsign)
    log("Iterating EWR event")
    for i,unit in ipairs(group:GetUnits()) do
        unit:HandleEvent(EVENTS.Dead)
        function unit:OnEventDead(EventData)
            local radars = 0
            for i,inner_unit in ipairs(group:GetUnits()) do
                if inner_unit:GetTypeName() == "1L13 EWR" then radars = radars + 1 end
            end

            if radars == 0 then
                game_state['Theaters']['Russian Theater']['EWR'][group:GetName()] = nil
                MESSAGE:New("EWR " .. callsign .. " has been destroyed!"):ToAll()
            end
        end
    end
    log("Done Iterating EWR event")
end

buildCheckC2Event = function(group, callsign)
    log("Iterating c2 event")
    for i,unit in ipairs(group:GetUnits()) do
        unit:HandleEvent(EVENTS.Dead)
        function unit:OnEventDead(EventData)
            local cps = 0
            for i,inner_unit in ipairs(group:GetUnits()) do
                if inner_unit:GetTypeName() == "SKP-11" then cps = cps + 1 end
            end

            if cps == 0 then
                game_state['Theaters']['Russian Theater']['C2'][group:GetName()] = nil
                MESSAGE:New("C2 " .. callsign .. " has been destroyed!"):ToAll()
            end
        end
    end
    log("Done Iterating c2 event")
end

function respawnHAWKFromState(_points)
    log("Spawning hawk from state")
    -- spawn HAWK crates around center point
    ctld.spawnCrateAtPoint("blue",551, _points["Hawk pcp"])
    ctld.spawnCrateAtPoint("blue",540, _points["Hawk ln"])
    ctld.spawnCrateAtPoint("blue",545, _points["Hawk sr"])
    ctld.spawnCrateAtPoint("blue",550, _points["Hawk tr"])

    -- spawn a helper unit that will "build" the site
    local _SpawnObject = SPAWN:New( "NE FARP HELO" )
    local _SpawnGroup = _SpawnObject:SpawnFromVec2({x=_points["Hawk pcp"]["x"], y=_points["Hawk pcp"]["z"]})
    local _unit=_SpawnGroup:GetDCSUnit(1)

    -- enumerate nearby crates
    local _crates = ctld.getCratesAndDistance(_unit)
    local _crate = ctld.getClosestCrate(_unit, _crates)
    local terlaaTemplate = ctld.getAATemplate(_crate.details.unit)

    ctld.unpackAASystem(_unit, _crate, _crates, terlaaTemplate)
    _SpawnGroup:Destroy()
    log("Done Spawning hawk from state")
end

log("Creating player placed spawns")
-- player placed spawns
hawkspawn = Spawner('hawk')
avengerspawn = Spawner('avenger')
ammospawn = Spawner('ammo')
jtacspawn = Spawner('HMMWV - JTAC')
gepardspawn = Spawner('gepard')
mlrsspawn = Spawner('mlrs')
log("Done Creating player placed spawns")

--local logispawn = SPAWNSTATIC:NewFromStatic("logistic3", country.id.USA)
local logispawn = {
    type = "HEMTT TFFT",
    country = "USA",
    category = "Ground vehicles"
}

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

-- Transport Spawns
NorthGeorgiaTransportSpawns = {
    [AIRBASE.Caucasus.Novorossiysk] = {Spawner("NovoroTransport"), Spawner("NovoroTransportHelo"), NovoLogiSpawn},
    [AIRBASE.Caucasus.Gelendzhik] = {Spawner("GelenTransport"), Spawner("GelenTransportHelo"), nil}, 
    [AIRBASE.Caucasus.Krasnodar_Center] = {Spawner("KDARTransport"), Spawner("KrasCenterTransportHelo"), KrasCenterLogiSpawn},
    [AIRBASE.Caucasus.Krasnodar_Pashkovsky] = {Spawner("KDAR2Transport"), Spawner("KrasPashTransportHelo"), nil},
    [AIRBASE.Caucasus.Krymsk] = {Spawner("KrymskTransport"), Spawner("KrymskTransportHelo"), KryLogiSpawn}
}

NorthGeorgiaFARPTransportSpawns = {
    ["NW"] = Spawner("NW FARP HELO"),
    ["NE"] = Spawner("NE FARP HELO"), 
    ["SW"] = Spawner("SW FARP HELO"),
    ["SE"] = Spawner("SE FARP HELO"),
    ["MK"] = Spawner("MK FARP HELO"),
}

-- Support Spawn
TexacoSpawn = SPAWN:New("Texaco"):InitDelayOff():InitRepeatOnEngineShutDown():InitLimit(1,0)
ShellSpawn = SPAWN:New("Shell"):InitDelayOff():InitRepeatOnEngineShutDown():InitLimit(1,0)
OverlordSpawn = SPAWN:New("AWACS Overlord"):InitDelayOff():InitRepeatOnEngineShutDown():InitLimit(1,0)
--F16Spawn = SPAWN:New("F16CAP"):InitRepeatOnEngineShutDown():InitLimit(2, 0):SpawnScheduled(900):Spawn()
--MirageSpawn = SPAWN:New("MirageCAP"):InitRepeatOnEngineShutDown():InitLimit(2, 0):SpawnScheduled(900):Spawn()
-- Local defense spawns.  Usually used after a transport spawn lands somewhere.
AirfieldDefense = Spawner("AirfieldDefense")

-- Strategic REDFOR spawns
RussianTheaterSA10Spawn = { Spawner("SA10"), "SA10" }
RussianTheaterSA6Spawn = { Spawner("SA6"), "SA6" }
RussianTheaterEWRSpawn = { Spawner("EWR"), "EWR" }
RussianTheaterC2Spawn = { Spawner("C2"), "C2" }
RussianTheaterAirfieldDefSpawn = Spawner("Russia-Airfield-Def")
RussianTheaterAWACSSpawn = SPAWN:New("A50"):InitDelayOff():InitRepeatOnEngineShutDown():InitLimit(1,0)

-- REDFOR specific airfield defense spawns
DefKrasPash = Spawner("Red Airfield Defense Kras-Pash 1")
DefKrasCenter = Spawner("Red Airfield Defense Kras-Center 1")
DefKrymsk = Spawner("Red Airfield Defense Krymsk 1")
DefNovo = Spawner("Red Airfield Defense Novo 1")
DefGlensPenis = Spawner("Red Airfield Defense GlensDick 1")

-- CAP Redfor spawns
RussianTheaterMig212ShipSpawn = Spawner("Mig21-2ship")
RussianTheaterMig292ShipSpawn = Spawner("Mig29-2ship")
RussianTheaterSu272sShipSpawn = Spawner("Su27-2ship")
RussianTheaterF5Spawn = Spawner("f52ship")
RussianTheaterJ11Spawn = Spawner("j112ship")
RussianTheaterMig312ShipSpawn = SPAWN:New("Mig31-2ship"):InitLimit(2, 0)
RussianTheaterAWACSPatrol = SPAWN:New("SU27-RUSAWACS Patrol"):InitRepeatOnEngineShutDown():InitLimit(2, 0):SpawnScheduled(600)

-- Strike Target Spawns
RussianHeavyArtySpawn = { Spawner("ARTILLERY"), "ARTILLERY" }
ArmorColumnSpawn = { Spawner("ARMOR COLUMN"), "ARMOR COLUMN" }
MechInfSpawn = { Spawner("MECH INF"), "MECH INF" }
AmmoDumpSpawn = { SPAWNSTATIC:NewFromStatic("Ammo Dump", country.id.RUSSIA), "Ammo Dump" }
CommsArraySpawn = { SPAWNSTATIC:NewFromStatic("Comms Array", country.id.RUSSIA), "Comms Array" }
PowerPlantSpawn = { SPAWNSTATIC:NewFromStatic("Power Plant", country.id.RUSSIA), "Power Plant" }

-- Naval Strike target Spawns
--PlatformGroupSpawn = {SPAWNSTATIC:NewFromStatic("Oil Platform", country.id.RUSSIA), "Oil Platform"}

-- Airfield CAS Spawns
RussianTheaterCASSpawn = SPAWN:New("Su25T-CASGroup"):InitRepeatOnLanding():InitLimit(4, 0)
--RussianTheatreCASEscort = SPAWN:New("Su27CASEscort")

-- FARP defenses
NWFARPDEF = Spawner("FARP DEFENSE")
SWFARPDEF = Spawner("FARP DEFENSE #001")
NEFARPDEF = Spawner("FARP DEFENSE #003")
SEFARPDEF = Spawner("FARP DEFENSE #002")
MKFARPDEF = Spawner("FARP DEFENSE #004")

-- FARP Support Groups
FSW = Spawner("FARP Support West")

-- Convoy spawns
--convoy_spawns = {{SPAWN:New('Convoy1'):InitLimit(15, 0), 'Convoy1'}, {SPAWN:New('Convoy2'):InitLimit(15, 0), 'Convoy2'}}

-- Group spanws for easy randomization
local allcaps = {RussianTheaterMig212ShipSpawn, RussianTheaterSu272sShipSpawn, RussianTheaterMig292ShipSpawn, RussianTheaterJ11Spawn, RussianTheaterF5Spawn}
poopcaps = {RussianTheaterMig212ShipSpawn, RussianTheaterF5Spawn}
goodcaps = {RussianTheaterMig292ShipSpawn, RussianTheaterSu272sShipSpawn, RussianTheaterJ11Spawn}
baispawns = {RussianHeavyArtySpawn, ArmorColumnSpawn, MechInfSpawn}

function activateLogi(spawn)
    if spawn then
        local statictable = mist.utils.deepCopy(logispawn)
        statictable.x = spawn[3].x
        statictable.y = spawn[3].y
        local static = mist.dynAddStatic(statictable)
        table.insert(ctld.logisticUnits, static.name)
        ctld.activatePickupZone(spawn[4])
    end
end

-- OnSpawn Callbacks.  Add ourselves to the game state
--for i,spawn_tbl in ipairs(convoy_spawns) do
--    spawn_tbl[1]:OnSpawnGroup(function(SpawnedGroup)
--        local cs = getCallsign()
--        log("Giving new convoy callsign: " .. cs)
--        AddConvoy(SpawnedGroup, spawn_tbl[2],cs)
--    end)
--end

RussianTheaterAWACSSpawn:OnSpawnGroup(function(SpawnedGroup)
    RussianTheaterAWACSPatrol:Spawn()
end)

--local sammenu = MENU_MISSION:New("DESTROY SAMS")
RussianTheaterSA6Spawn[1]:OnSpawnGroup(function(SpawnedGroup)
    local callsign = getCallsign()
    --MENU_MISSION_COMMAND:New("DESTROY " .. callsign, sammenu, function()
    --    SpawnedGroup:Destroy()
    --end)
    AddRussianTheaterStrategicSAM(SpawnedGroup, "SA6", callsign)
    buildHitEvent(SpawnedGroup, callsign)
    buildCheckSAMEvent(SpawnedGroup, callsign)
end)

RussianTheaterSA10Spawn[1]:OnSpawnGroup(function(SpawnedGroup)
    local callsign = getCallsign()
    --MENU_MISSION_COMMAND:New("DESTROY " .. callsign, sammenu, function()
    --    SpawnedGroup:Destroy()
    --end)
    AddRussianTheaterStrategicSAM(SpawnedGroup, "SA10", callsign)
    buildHitEvent(SpawnedGroup, callsign)
    buildCheckSAMEvent(SpawnedGroup, callsign)
end)

--local ewrmenu = MENU_MISSION:New("DESTROY EWRS")
RussianTheaterEWRSpawn[1]:OnSpawnGroup(function(SpawnedGroup)
    local callsign = getCallsign()
    --MENU_MISSION_COMMAND:New("DESTROY " .. callsign, ewrmenu, function()
    --    SpawnedGroup:Destroy()
    --end)
    AddRussianTheaterEWR(SpawnedGroup, "EWR", callsign)
    buildHitEvent(SpawnedGroup, callsign)
    buildCheckEWREvent(SpawnedGroup, callsign)
end)

--local c2menu = MENU_MISSION:New("DESTROY C2S")
RussianTheaterC2Spawn[1]:OnSpawnGroup(function(SpawnedGroup)
    local callsign = getCallsign()
    --MENU_MISSION_COMMAND:New("DESTROY " .. callsign, c2menu, function()
    --    SpawnedGroup:Destroy()
    --end)
    AddRussianTheaterC2(SpawnedGroup, "C2", callsign)
    buildHitEvent(SpawnedGroup, callsign)
    buildCheckC2Event(SpawnedGroup, callsign)
end)

RussianTheaterAWACSSpawn:OnSpawnGroup(function(SpawnedGroup)
    AddRussianTheaterAWACSTarget(SpawnedGroup)
end)

SpawnOPFORCas = function(spawn)
    --log("===== CAS Spawn begin")
    local casGroup = spawn:Spawn()
end

--local baimenu = MENU_MISSION:New("DESTROY BAIS")
for i,v in ipairs(baispawns) do
    v[1]:OnSpawnGroup(function(SpawnedGroup)
        local callsign = getCallsign()
        --MENU_MISSION_COMMAND:New("DESTROY " .. callsign, baimenu, function()
        --    SpawnedGroup:Destroy()
        --end)
        AddRussianTheaterBAITarget(SpawnedGroup, v[2], callsign)
    end)
end

--local capsmenu = MENU_MISSION:New("DESTROY CAPS")
for i,v in ipairs(allcaps) do
    v:OnSpawnGroup(function(SpawnedGroup)
       -- MENU_MISSION_COMMAND:New("DESTROY " .. SpawnedGroup:GetName(), capsmenu, function()
        --    SpawnedGroup:Destroy()
        --end)
        AddRussianTheaterCAP(SpawnedGroup)
    end)
end

for name,spawn in pairs(NorthGeorgiaTransportSpawns) do
    for i=1,2 do
        spawn[i]:OnSpawnGroup(function(SpawnedGroup)
            SpawnedGroup:HandleEvent(EVENTS.Land)
            function SpawnedGroup:OnEventLand(EventData)
                local apV3
                if i == 1 then
                    apV3 = POINT_VEC3:NewFromVec3(EventData.place:getPosition().p)
                    apV3:SetX(apV3:GetX() + math.random(400, 600))
                    apV3:SetY(apV3:GetY() + math.random(200))
                    trigger.action.outSoundForCoalition(2, abcapsound)
                elseif i == 2 then
                    apV3 = POINT_VEC3:NewFromVec3(EventData.IniGroup:GetPositionVec3())
                    apV3:SetX(apV3:GetX() + math.random(50,100))
                    apV3:SetY(apV3:GetY() + math.random(50))
                    trigger.action.outSoundForCoalition(2, farpcapsound)
                end
                activateLogi(spawn[3])
                local air_def_grp = AirfieldDefense:SpawnFromVec2(apV3:GetVec2())
                apV3:SetX(apV3:GetX() + math.random(-50, 50))
                apV3:SetY(apV3:GetY() + math.random(-50, 50))
                FSW:SpawnFromVec2(apV3:GetVec2())
                SCHEDULER:New(nil, SpawnedGroup.Destroy, {SpawnedGroup}, 120)
            end
        end)
    end
end

for name,spawn in pairs(NorthGeorgiaFARPTransportSpawns) do
    spawn:OnSpawnGroup(function(SpawnedGroup)
        SpawnedGroup:HandleEvent(EVENTS.Land)
        function SpawnedGroup:OnEventLand(EventData)
            local apV3 = POINT_VEC3:NewFromVec3(EventData.IniGroup:GetPositionVec3())
            apV3:SetX(apV3:GetX() + math.random(-50, 50))
            apV3:SetY(apV3:GetY() + math.random(-50, 50))
            AirfieldDefense:SpawnFromVec2(apV3:GetVec2())

            apV3:SetX(apV3:GetX() + math.random(-50, 50))
            apV3:SetY(apV3:GetY() + math.random(-50, 50))
            FSW:SpawnFromVec2(apV3:GetVec2())
            SCHEDULER:New(nil, SpawnedGroup.Destroy, {SpawnedGroup}, 120)

            if string.match(SpawnedGroup:GetName(), "MK FARP") then
                activateLogi(MaykopLogiSpawn)
            end 
        end
    end)
end

BASE:I("HOGGIT GAW - SPAWNS COMPLETE")
log("spawns.lua complete")
