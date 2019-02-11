--[[

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
    xaw.event = {}

    local etypes = {}
    etypes.SAVESTATE     = 0
    etypes.SPAWNFACILITY = 10
    etypes.SPAWNFACDEF   = 14
    etypes.SPAWNGROUP    = 18
    etypes.AIMODIFY      = 20
    etypes.DCSTAKEOFF    = 50
    etypes.DCSLAND       = 51
    etypes.DCSHIT        = 52
    etypes.DCSDEATH      = 53
    etypes.DESTROY       = 70
    -- TODO not a complete list

    xaw.event.enums.types = etypes

    local Event = {
        __call = function(cls, etype, data)
            -- TODO: validate event type
            local pt = {}
            pt.type = etype
            pt.data = data

            local event = setmetatable(pt, cls)
            cls.__index = cls
            return event
        end,
    }

    function Event:callbackSet(ctx, func)
        if "function" ~= type(func) then
            assert(false,
                   "func must be of type 'function', actual type was: "..
                   type(func))
            return
        end
        self.callback = func
        self.ctx      = ctx
    end

    xaw.event.Event = Event

    local EventProcessor = {
        __call = function(cls)
            local pt = {}
            pt.handlers = {}

            local proc = setmetatable(pt, cls)
            cls.__index = cls
            return proc
        end
    }

    function EventProcessor:_handleEvent()
        -- this function is run on a periodically scheduled basis at 2Hz
        -- it processes on event at a time
        -- see "Start event processor" process from the flowchart
    end

    function EventProcessor:registerHandler(type, handler)
    end

    --[[
    -- not sure if we need this
    function EventProcessor:createEvent(type, data)
    end
    --]]

    function EventProcessor:start(pq)
        -- pq is a reference to the priority queue that holds the events
        -- needing to be processed
        -- this function starts the periodic process of empyting the event queue
        -- see "Start event processor" process from the flowchart
        --
        -- since this process can start and stop we will need to store
        -- the id returned by mist.scheduled function so re can stop it
        -- later
        --
        -- if we use the MSE timer.scheduleFunction() we will need to have
        -- _handleEvent() accept a time and use a state variable in the class
        -- itself to top the execution of the function.
    end

    function EventProcessor:stop()
    end

    xaw.event.EventProcessor = EventProcessor
end
