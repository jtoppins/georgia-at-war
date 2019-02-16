-- Setup an initial state object and provide functions for manipulating that state.
--[[
game_state = {
    -- represents airbases or farps that can be captured
    bases = {
        [name]  = {side = "<r|b|n>", security = "<h|m|l>", "??"},
        [nameN] = {side = "<r|b|n>", security = "<h|m|l>", "??"},
    },
    -- represents units and statics that do not normally move in a theater
    -- can be;
    --  strategic sams, c2s, ewrs, ammo dumps, fuel depots, theaters objectives, and
    --  defense units spawned to protect the assets
    assets = {
        [name] = {template, position, type, damage, defenses = {name1, nameN}, "??"},
        [nameN] = {template, position, type, damage, defenses = {name1, nameN}, "??"},
    },
    redfor = {
        stats = {
        },
    },
    blufor = {
        stats = {
        },
    },
}

GameState class

If an asset exists in one of the following lists, it is assumed to
have been spawned into the world.

types of assets:
* facilities
    static or group representing some strategic or tactical asset, some
        are capturable
    - can have associated defense groups
        a list of group names used to index into the ground_groups list below
    - belongs to a particular colation
    - has various types; airbase, farp, ammo dumps, hq positions, comms relays,
        ewrs, theater SAM, etc
    - is the facility dead or alive
    - template name; the mission group used as a template for spawning this group
        not used for airbase or farp types
    - can be captured {true, false}
    - spawn method; how the object is to be spawned
* ground_groups
    represents a ground group
    - has various types; sam, shorad, armor, ifv, infantry, mounted infantry,
        logistics
    - is mobile
    - damaged; (not implemented yet)
    - template name; the mission group uses as a template for spawning this group
    - belongs to a particular colation
* air_groups
    represents an air group
    - has various types: AWACS, fighter, bomber, attack
* stats
    tracks stats for various asset types
    - original
    - nominal
    - alive

hidden lists managed by the state class:
    basemap; points to airbases and farps


current assets used in GAW:
* airbase
* farp
* C2
* theater objectives
* strike tgts (ammo dumps, comms, power plant)
* SAMs
* ewr
* convoy
* cas targets
* bai
* tanker
* AWACS (blue & redfor)
* interceptors
* CAP
* vip
* naval strikes

the above can be grouped into:
* base:     airbase, farp
    attrs: coalition, def-groups, type, tplname, capturable
* facility: C2, theater objective, strike tgt, SAM, ewr
    attrs: coalition, def-groups, type, healthtbl, status, tplname, spawnmethod,
           mobile
* ground: convoy, cas tgt, bai
    attrs: coalition, def-groups, type, healthtbl, status, tplname, spawnmethod,
           mobile
* air:    AAR tanker, AWACS, interceptor, CAP, strike a/c
    (the air entries should represent missions otherwise we do not need
     to track individual units/groups but instead if the )
* naval:  naval strikes
    attrs: coalition, def-groups, type, healthtbl, status, tplname, spawnmethod,
           mobile

vip ?

--]]

do
    state = {}

    local GameState = {
        __call = function(cls)
            local pt = {}
            pt.dirty         = false
            pt.init          = true
            pt.facilities    = {}
            pt.groups        = {}
            pt.stats         = {}
            pt.notifiers = {}

            local gstbl = setmetatable(pt, cls)
            cls.__index = cls
            return gstbl
        end,
    }

    function GameState:_dirtySet()
        self.dirty = true
    end

    function GameState:dirtyClear()
        self.dirty = false
    end

    function GameState:initClear()
        self.init = false
    end

    --[[
    state notifications:
    add
    remove
    initcomplete
    --]]

    function GameState:facilityAdd(name, attrs)
    end

    function GameState:facilityRemove(name)
    end

    function GameState:ggroupAdd(name, attrs)
    end

    function GameState:ggroupRemove(name)
    end

    function GameState:_statsAliveInc(atype, subtype)
    end

    function GameState:_statsAliveDec(atype, subtype)
    end

    function GameState:statsGet()
        -- return a read-only copy of the current stats
    end

    function GameState:statsSetNominal(atype, subtype, val)
    end

    function GameState:statsSetOriginal(atype, subtype, val)
    end

    function GameState:export()
        -- export a copy of the game state in a
        -- flat table representation
        self:dirtyClear()
    end

    state.GameState = GameState


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

    return state
end
