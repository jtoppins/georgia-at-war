-- Transport Spawns
NorthGeorgiaTransportSpawns = {
    ["Novorossiysk"] = SPAWN:New("NovoroTransport"),
    ["Gelendzhik"] = SPAWN:New("GelenTransport"), 
    ["Krasnodar-Center"] = SPAWN:New("KDARTransport"),
    ["Krasnodar-East"] = SPAWN:New("KDAR2Transport"),
    ["Krymsk"] = SPAWN:New("KrymskTransport")
}

-- Support Spawn
TexacoSpawn = SPAWN:New("Texaco"):InitRepeatOnEngineShutDown():Spawn()
ShellSpawn = SPAWN:New("Shell"):InitRepeatOnEngineShutDown():Spawn()
OverlordSpawn = SPAWN:New("Overlord"):InitRepeatOnEngineShutDown():Spawn()

-- Local defense spawns.  Usually used after a transport spawn lands somewhere.
AirfieldDefense = SPAWN:New("AirfieldDefense")

-- Strategic REDFOR spawns
RussianTheaterSA10Spawn = SPAWN:New("SA10")
RussianTheaterSA6Spawn = SPAWN:New("SA6")
RussianTheaterEWRSpawn = SPAWN:New("EWR")
RussianTheaterC2Spawn = SPAWN:New("C2")

-- CAP Redfor spawns
RussianTheaterMig212ShipSpawn = SPAWN:New("Mig212ship")
RussianTheaterMig292ShipSpawn = SPAWN:New("Mig292ship")

-- Strike Target Spawns
RussianHeavyArtySpawn = SPAWN:New("HeavyArty")


-- OnSpawn Callbacks.  Add ourselves to the game state
RussianTheaterSA6Spawn:OnSpawnGroup(function(SpawnedGroup)
    AddRussianTheaterStrategicSAM(game_state, SpawnedGroup)
end)

RussianTheaterSA10Spawn:OnSpawnGroup(function(SpawnedGroup)
    AddRussianTheaterStrategicSAM(game_state, SpawnedGroup)
end)

RussianHeavyArtySpawn:OnSpawnGroup(function(SpawnedGroup)
    AddRussianTheaterBAITarget(game_state, SpawnedGroup)
end)

RussianTheaterEWRSpawn:OnSpawnGroup(function(SpawnedGroup)
    AddRussianTheaterEWR(game_state, SpawnedGroup)
end)

RussianTheaterC2Spawn:OnSpawnGroup(function(SpawnedGroup)
    AddRussianTheaterC2(game_state, SpawnedGroup)
end)

RussianTheaterMig212ShipSpawn:OnSpawnGroup(function(SpawnedGroup)
    AddRussianTheaterCAP(game_state, SpawnedGroup)
    local PatrolZone = ZONE:New( "NorthAIPatrolZone" )
    local AICapZone = AI_CAP_ZONE:New( PatrolZone, 500, 1000, 500, 600 )
    local EngageZone = ZONE:New("NorthAICAPZone")
    AICapZone:SetControllable(SpawnedGroup)
    AICapZone:SetEngageZone(EngageZone)
    AICapZone:__Start(1)
end)

for name,spawn in pairs(NorthGeorgiaTransportSpawns) do
    spawn:OnSpawnGroup(function(SpawnedGroup)
        SpawnedGroup:HandleEvent(EVENTS.Land)
        function SpawnedGroup:OnEventLand(EventData)
            local apV3 = POINT_VEC3:NewFromVec3(EventData.place:getPosition().p)
            apV3:SetX(apV3:GetX() + 300)
            AirfieldDefense:SpawnFromVec2(apV3:GetVec2())
            SpawnedGroup:Destroy()
        end
    end)
end

BASE:I("HOGGIT GAW - SPAWNS COMPLETE")
log("spawns.lua complete")