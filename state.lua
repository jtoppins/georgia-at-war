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

--]]

do
    xaw.state = {}

    local GameState = {
        __call = function(cls)
            local pt = {}
            pt.dirty         = false
            pt.init          = true
            pt.facilities    = {}
            pt.ground_groups = {}
            pt.stats         = {}

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
    end

    xaw.state.GameState = GameState
end
