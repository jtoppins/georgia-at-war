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

do
    local event = {}

    local etypes = {}
    etypes.SAVESTATE     = 0
    etypes.SPAWNFACILITY = 10
    -- etypes.SPAWNFACDEF   = 14
    etypes.SPAWNGROUP    = 18
    etypes.AIMODIFY      = 20
    --etypes.DCSTAKEOFF    = 50
    --etypes.DCSLAND       = 51
    --etypes.DCSHIT        = 52
    --etypes.DCSDEATH      = 53
    etypes.DESTROY       = 70
    -- TODO not a complete list

    event.enum = {}
    event.enum.types = etypes

    local Event = {
        __call = function(cls, etype, data)
            -- TODO: validate event type and data for the given type
            local pt = {}
            pt.type = etype
            pt.data = data

            local event = setmetatable(pt, cls)
            cls.__index = cls
            return event
        end,
    }

    -- prototype: void setCallback(func, ctx)
    function Event:setCallback(func, ctx)
        if "function" ~= type(func) then
            assert(false,
                   "func must be of type 'function', actual type was: "..
                   type(func))
            return
        end
        self.callback = func
        self.ctx      = ctx
    end

    event.Event = Event

    --[[
    -- not sure if we need this
    function event.createEvent(type, data)
    end
    --]]

    local EventProcessor = {
        __call = function(cls, xaw)
            local pt     = {}
            pt.notifiers = {}
            pt.xaw       = xaw
            pt.stopped   = true
            pt.schedtime = 2

            local proc = setmetatable(pt, cls)
            cls.__index = cls
            return proc
        end
    }

    -- prototype: void _handleEvent(cls, time)
    function EventProcessor._handleEvent(cls, time)
        -- this function is run on a periodically scheduled basis at 2Hz
        -- it processes on event at a time
        -- see "Start event processor" process from the flowchart

        if cls.xaw.gamestate.init and cls.xaw.eventq:empty() then
            cls.xaw.gamestate:initClear()
        end

        if not cls.xaw.eventq:empty() then
            local e = cls.xaw.eventq:pop()
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
            cls.xaw.eventq:push(t, e)
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

    return event
end
