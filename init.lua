--[[
TODO:

NOTES:
So I do not think we need to use the weird code loading schemes that people have
used like dofile or loadfile. I think we can use the ledgimate require(modname)
call by just modifying package.path, something like this should work:

-----
local addpath = lfs.writedir() .. "Scripts\\XAW\\?.lua;" ..
                lfs.writedir() .. "Scripts\\XAW\\?\\?.lua"
package.path = package.path .. ";" .. addpath
-----

This will add XAW to the end of module search path and should allow for the
following:

require("xawinit")

We will probably need to prefix our files so that do not collide with and DCS
files, as I am sure they didn't do any prefixing. If this works we do not
have to do odd/dumb namespacing things like mist and others do. A mission
designer could literally include the following in a doscript mission start
trigger.

----
local addpath = lfs.writedir() .. "Scripts\\XAW\\?.lua;" ..
                lfs.writedir() .. "Scripts\\XAW\\?\\?.lua"
package.path = package.path .. ";" .. addpath
local x = require("xawinit")
x.init()
----

I am pretty sure lfs.writedir() points to your "Saved Games/DCS" directory.

This works but requires the MissionScripting.lua file to be modified to
not sanatize lfs and overwrite 'require' to nil. This seems doable as
GAW already doesn't sanatize the scripting environment, for reasons I do
not know.
--]]

do
    --[[
    -- test and verify the server's environment supports the calls
    -- required by XAW framework
    --]]
    local assertmsg = "XAW requires DCS mission scripting environment to be" ..
                " modified, the file needing to be changed can be found at" ..
                " $DCS_ROOT\Scripts\MissionScripting.lua. Comment out the" ..
                " removal of lfs and io and the setting of 'require' to nil."
    if not lfs or not io or not require then
        assert(false, assertmsg)
    end

    local json    = require('xaw.libs.json')
    local mission = require('xaw.mission')
    local state   = require('xaw.state')
    local cmdr    = require('xaw.ai.commander')
    local cmd     = require('xaw.commands')
    local PQueue  = require('containers.pqueue')

    local xaw = {
        config_path_prefix = lfs.writedir() .. "xawconfig\\",
        options_path       = "mission-options.json",
        start_state        = "mission-start-state.json",
        saved_state        = "mission-state.json",
        game_options       = nil,
        gamestate          = nil,
        cmdq               = nil,
        cmdprocessor       = nil,
        redforcmdr         = nil,
    }

    -- prototype: void subsystemsinit(void)
    function xaw:subsystemsinit()
        -- TODO: do "init all subsystems" from flowchart
        self.cmdq           = PQueue()
        self.cmdprocessor   = cmd.CmdProcessor(self.cmdq)
        self.gamestate      = state.GameState()
        self.redforcmdr     = cmdr.Commander(coalition.side.RED)

        self.gamestate:setcmdq(self.cmdq)

        -- register state notification handlers
        self.redforcmdr:registerStateNotifications(self.gamestate)
    end

    -- prototype: void init(void)
    function xaw:init()
        self.game_options = mission.load_options()

        self:subsystemsinit()

        local statefile = io.open(self.config_path_prefix ..
                                    self.saved_state, 'r')
        local game_state = {}
        if statefile then
            game_state = mission.load_state(statefile)
            statefile:close()
            statefile = nil
        else
            game_state = mission.gen_state()
        end

        for name, data in pairs(game_state) do
            -- TODO: ?? need to decide on a game_state export format
            --      is it a flattend format, like:
            --  (1) game_state = {
            --          [name]  = {...data...},
            --          [nameN] = {...data...},
            --      }
            --
            --  -or-
            --
            --  (2) game_state = {
            --          ["facilities"] = {
            --              [name]  = {...data...},
            --              [nameN] = {...data...},
            --          },
            --          ["ground_groups"] = {
            --              [name]  = {...data...},
            --              [nameN] = {...data...},
            --          },
            --          ...
            --      }
            --
            --  Neither format explicitly talks about how to document what side
            --  something belongs to, though I am not sure that really matters
            --  as the country (defined by their template) will determine that.
            --  Using option 1 (the flat format) guarentees all names are unique
            --  which is a requirement of the engine anyway. This format doesn't
            --  necessarily need to dictate the storage format of the in-memory
            --  game_state either.
            local etype = 0
            if data.type == state.enum.types.FACILITY then
                etpye = event.enum.types.SPAWNFACILITY
            else
                assert(false, "problems")
            end
            data.name = name

            -- TODO: does it make sense to have a separate create function for
            -- specific events or should the event constructor validate the
            -- data or do we not care for creation and check in the event
            -- handler?  Checking in the event handler would make it difficult
            -- to know from where the event was generated.
            local e = event.Event(etpye, data)
            self.eventq:push(etype, e)
        end

        self.eventprocessor:start()
        self.redforcmdr:start()
    end

    return xaw
end
