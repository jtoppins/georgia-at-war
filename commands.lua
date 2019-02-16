--[[

Note:
  The way we are using these they are really not 'events' it is more of a command
  queue and Commands.


Event class
    - type
    - data
    - [optional] callback
    - [optional] callback ctx

event types and priorities:
0 = save game state
10 = spawn (facility)
14 = spawn (facility defense)
18 = spawn (group)
20 = modify AI behaviour
50 = DCS events (hit, death, land, takeoff, etc.)
70 = destroy group or unit
--]]

require('io')

do
    local cmds = {}

    local prio = {}
    prio.SAVESTATE     = 0
    prio.SPAWNFACILITY = 10
    prio.SPAWNGROUP    = 14
    prio.AIMODIFY      = 20
    prio.DESTROY       = 70
    prio.NONE          = 1000
    -- TODO not a complete list

    cmds.enum = {}
    cmds.enum.priority = prio

    local Command = {
        class    = "Command",
        priority = prio.NONE,
        __call = function(cls, data)
            cls.data = data or nil
            local cmd = setmetatable({}, cls)
            cls.__index = cls
            return cmd
        end,
    }

    -- prototype: void setCallback(func, ctx)
    function Command:setCallback(func, ctx)
        if "function" ~= type(func) then
            assert(false,
                   "func must be of type 'function', actual type was: "..
                   type(func))
            return
        end
        self.callback = func
        self.ctx      = ctx
    end

    function Command:_runcb()
        if not self.callback then
            return
        end
        self.callback(ctx, self)
    end

    function Command:exec()
        assert(false, "base command class should not be used")
    end
    cmds.Command = Command


    local SaveStateCmd = Command()
    SaveStateCmd.priority = prio.SAVESTATE
    function SaveStateCmd:exec()
        -- the data member in this case is a pointer to the
        -- xaw object
        local statefile = io.open(data.config_path_prefix ..
                                  data.saved_state, 'w')
        mission.save_state(statefile, data.gamestate)
        statefile:close()
        self:_runcb()
    end
    cmds.SaveStateCmd = SaveStateCmd


    local SpawnFacilityCmd = Command()
    SpawnFacilityCmd.priority = prio.SPAWNFACILITY
    function SpawnFacilityCmd:exec()
        -- the data member in this case is a pointer to a
        -- facility object
        -- {
        --    name = ,   -- name of facility group/static
        --    kind = ,   -- kind of facility; SAM, C2, etc
        --    coalition = ,
        --    status = ,
        --    tplname = ,
        --    spawnmethod = ,
        --    mobile = ,
        --    known = ,
        --    units   = {
        --    },
        -- }

StaticSpawner = function(groupName, numberInGroup, groupOffsets)
  local CallBack = {}
  return {
    Spawn = function(self, firstPos)
      local names = {}
      for i=1,numberInGroup do
        local groupData = mist.getGroupData(groupName .. i)
        groupData.units[1].x = firstPos[1] + groupOffsets[i][1]
        groupData.units[1].y = firstPos[2] + groupOffsets[i][2]
        groupData.clone = true
        table.insert(names, mist.dynAddStatic(groupData).name)
      end

      return names
    end,
  }
end

        self:_runcb()
    end
    cmds.SpawnFacilityCmd = SpawnFacilityCmd

    local SpawnGroupCmd = Command()
    SpawnGroupCmd.priority = prio.SPAWNGROUP
    function SpawnGroupCmd:exec()
        -- the data member in this case is a pointer to a
        -- group object
        -- {
        --    name = ,   -- name of group
        --    kind = ,   -- kind of group
        --    coalition = , -- the side the unit belongs to
        --    status = ,    -- general status of group
        --    tplname = ,   -- optional, miz group to use as the spawn template
        --                  --   if doesn't exist units and route is required
        --    point = ,     -- the point where the unit should be spawned
        --    mobile = ,    -- if this unit can be moved
        --    known = ,     -- if this unit is known to the other side
        --    units = {},   -- optional units table
        --    route = {},   -- optional route table
        -- }

        self:_runcb()
    end
    cmds.SpawnGroupCmd = SpawnGroupCmd



    local CmdProcessor = {
        __call = function(cls, xaw)
            local pt     = {}
            pt.xaw       = xaw
            pt.stopped   = true
            pt.schedtime = 2

            local proc = setmetatable(pt, cls)
            cls.__index = cls
            return proc
        end
    }

    -- prototype: void _runCmd(cls, time)
    function CmdProcessor._runCmd(cls, time)
        -- this function is run on a periodically scheduled basis at 2Hz
        -- it processes one command at a time
        -- see "Start event processor" process from the flowchart

        if cls.xaw.gamestate.init and cls.xaw.cmdq:empty() then
            cls.xaw.gamestate:initClear()
        end

        if not cls.xaw.cmdq:empty() then
            local e = cls.xaw.cmdq:pop()
            e:exec()
            for name, notify in pairs(cls.notifiers[e.type]) do
                notify(e)
            end
        end

        if cls.xaw.gamestate.dirty and
            --[[ time since last save > 2 mins ]] then
            -- create save state event
            local t = event.enum.types.SAVESTATE
            local e = event.Event(t, xaw.gamestate)
            cls.xaw.cmdq:push(t, e)
        end

        return cls:reschedule(time)
    end

    function EventProcessor:reschedule(time)
        if self.stopped then
            return nil
        end
        return time + self.schedtime
    end

    -- prototype: void registerNotifier(type, handler)
    function EventProcessor:registerNotifier(t, handler)
        assert(type(handler) == 'function', "handler must be a function")
        if not self.notifiers[t] then
            self.notifiers[t] = {}
        end
        table.insert(self.notifiers[t], handler)
    end

    -- prototype: void unregisterNotifier(type, handler)
    function EventProcessor:unregisterNotifier(t, handler)
        assert(type(handler) == 'function', "handler must be a function")
        for id, data in pairs(self.notifiers[t]) do
            if data == handler then
                table.remove(self.notfiers[t], id)
            end
        end
    end

    -- prototype: void start(void)
    function EventProcessor:start()
        self.stopped = false
        timer.scheduleFunction(self._handleEvent, self,
                               timer.getTime() + self.schedtime)
    end

    -- prototype: void stop(void)
    function EventProcessor:stop()
        self.stopped = true
    end

    event.EventProcessor = EventProcessor

    return cmds
end
