do
    xaw.base = {}

    function xaw.base.def_spawn_callback(grpname)
    end

    function xaw.base.init(name, data)
        -- setup which side the base belongs to
        -- spawn any local defense for each base and track the spawning of this defense
        -- setup any slot blocking
        local spwnobj = Spawner(data.def.tplname)
    end
end
