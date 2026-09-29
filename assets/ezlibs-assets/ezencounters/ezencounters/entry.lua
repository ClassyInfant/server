local package_prefix = "keristero"
local package_name = "ezencounters"

local mob_package_id = "com."..package_prefix..".mob."..package_name
local loaded_obstacles = {}
local ramdomize_test_scenario = include('random_scenario.lua')

local encounter_info = {
    -- If you need to add an mob do it here based on the character package name. 
    enemy_packages = {
        ShadowManPoN="com.OFC.char.EXEPoN-025-ShadowMan",
        GregarBeast="com.OFC.char.EXE6-051-GregarBeast1",
        ElementMan="com.OFC.char.EXE6-045-ElementMan1",
        BurnerMan="com.OFC.char.EXE4-038-BurnerMan1",
        Gobby="mob.realms.rey.navi.000.gobby",
        Yuki="com.alrysc.enemy.YukiEnemy",--V1,V2
        Yumeko="com.alrysc.enemy.YumekoEnemy",--V1,V2
        VolcanoMan="com.alrysc.enemy.VolcanoManEnemy",--V1,V2
        DreamMeraru="com.OFC.char.EXEPoN-018-DreamMeraru",
        DreamRapia="com.OFC.char.EXEPoN-018-DreamLapia",
        DreamBolt="com.OFC.char.EXEPoN-018-DreamBolt",
        DreamMoss="com.OFC.char.EXEPoN-018-DreamMoss",
        Sparky="com.OFC.char.EXEPoN-014-Yura",
        Yurayura="com.OFC.char.EXEPoN-014-Yurayura",
        Yurarion="com.OFC.char.EXEPoN-014-Yurarion",
        Dharma="com.OFC.char.EXEPoN-011-Dharma",
        Dharga="com.OFC.char.EXEPoN-011-Dharga",
        Dhardara="com.OFC.char.EXEPoN-011-Dhardara",
        KillPlant="com.OFC.char.EXEPoN-010-KillPlant",
        KillWeed="com.OFC.char.EXEPoN-010-KillWeed",
        KillFlower="com.OFC.char.EXEPoN-010-KillFlower",
        Beetank="com.OFC.char.EXEPoN-007-Kabutank", --V1,V2,V3,SP
        SwapLight="hoov.enemy.swaplight",
        QuickMan="com.louise.enemy.Quickman", --V1,V2,V3,SP, NM
        HeelNavi="com.louise.enemy.HeelNavi", --V1,V2,V3,SP
        CircusMan="com.louise.enemy.CircusMan", -- V1 (1), EX (5), SP (4), NM (8)
        RayCannon="com.alrysc.enemy.RayCannon_enemy", --custom ranks based on integer, 0 = SP
        ShadeMan="com.Dawn.Enemy.Shademan", --V1,EX,SP
        Kogasa="com.alrysc.enemy.KogasaEnemy", --V1,V2,V3
        Juraigon="com.alrysc.enemy.juraigonVirus", --V1,V2,V3
        CutMan="com.louise.enemy.Cutman", --V1, EX, SP, NM
        AirMan="com.louise_enemy_AirManV1",--v1,v2,SP
        SwordyEl="mob.realms.rey.virus.009.swordy", -- 1-9
        StarMan="com.OFC.char.EXE45-036-StarMan1", --V1,V2,V3,SP
        Alpha="com.OFC.char.EXE3-061-Proto", --V1, SP
        Bark="com.louise.enemy.Bark", --V1
        Basher="com.EXE3.Basher.Enemy",--V1
        BigBrute="com.keristero.char.BigBrute",
        Bladia2="com.EXE5.Bladia.Enemy2", --Bladia2
        Bladia3="com.EXE5.Bladia.Enemy3", --Bladia3
        Bladia4="com.EXE5.Bladia.Enemy4", --Bladia4
        Bladia5="com.EXE5.Bladia.Enemy5", --Bladia5
        Bladia6="com.EXE5.Bladia.Enemy6", --Bladia6
        Bladia="com.EXE5.Bladia.Enemy1", --Bladia
        BlastMan="com.Thor.enemy.BlastMan_V1", -- V1 (1), EX (5), SP (4), RV (??)
        BombCorn="com.louise.enemy.Corn.BombCorn",--V1,SP,R1,R2
        Boomer="com.louise.enemy.Boomer",
        Breaker="com.louise.enemy.Breaker",
        Bugtank="com.louise.enemy.Bugtank",
        Bunny="com.louise.enemy.Bunny", --First Version, Spawn @ V1
        Cacter="com.discord.Konstinople#7692.enemy.cacter",
        Cactikil="com.discord.Konstinople#7692.enemy.cactikil",
        Cactroll="com.discord.Konstinople#7692.enemy.cactroll",
        Canodumb="com.discord.Konstinople#7692.enemy.canodumb",
        Canosmart="com.dawn.enemy.canosmart",
        Catack="com.Dawn.Requested.Enemy.Catack",--V1,V2,V3,SP
        Champy="com.keristero.char.Champy",
        ChefVirus="com.alrysc.enemy.ChefVirusEnemy",
        Chimpy="com.keristero.char.Chimpy",
        Chumpy="com.keristero.char.Chumpy",
        CirCrush="com.louise.enemy.CirCrush",
        CirKill="com.louise.enemy.CirKill",--V1,R1,R2,SP,NM
        CirSmash="com.louise.enemy.CirSmash",
        ColdHead="com.louise.enemy.ColdHead",
        ColdHead="com.louise.enemy.ColdHead",
        Cragger="com.louise.enemy.Cragger",--V1,V2,V3,R1,R2,SP,NM
        DarkMech="com.HNST_SGNL.enemy.DarkMech",--V1,V2,V3,SP,R1,R2
        DarkMega="com.Dawn.Enemy.DarkRock", --V1
        DarkMegaNM="com.Dawn.Enemy.DarkRockNM", --NM
        DemonEye="com.louise.enemy.DemonEye",--V1
        Dominerd="com.louise.enemy.Dominerd",--V1,V2,V3,SP,NM
        Doomer="com.louise.enemy.Doomer",
        DthFire="com.louise.enemy.DthFire",--V1,R1,R2,SP,NM
        Elemperor="com.louise.enemy.Elemperor",--V1,V2,V3,R1,R2,SP,NM
        FighterPlane="com.Dawn.Viruses.Enemy.FighterPlane",--V1,V2,V3,SP
        FireManPoN="com.OFC.char.EXEPoN-022-FireMan", --V1,V2,V3,SP
        Fishy="com.louise.enemy.Fishy",--V1,V2,V3,SP
        Flashy="com.louise.enemy.Flashy",--V1,V2,V3,R1,R2,SP,NM
        Forte="com.OFC.char.EXE4-047-Forte1", --V1, SP, NM
        FulFire="com.louise.enemy.FulFire",--V1,R1,R2,SP,NM
        GigaCorn="com.louise.enemy.Corn.GigaCorn",--V1
        Gloomer="com.louise.enemy.Gloomer",
        Gunner="com.OFC.char.EXE6-023-Gunner",
        GutsManPoN="com.OFC.char.EXEPoN-026-GutsMan", --V1,V2,V3,SP,NM
        HardHead="com.louise.enemy.HardHead",
        HatMan="com.alrysc.enemy.HatManEnemy", --V1,V2,V3,SP
        HauntedCandle="com.louise.enemy.HauntedCandle",--V1,V2,V3,SP,R1,R2
        Hecatia="com.alrysc.enemy.HecatiaEnemy",
        HotHead="com.louise.enemy.HotHead",
        IceManPoN="com.OFC.char.EXEPoN-023-IceMan",--V1,V2,V3,SP
        JammingMan="com.alrysc.enemy.JammingManEnemy", --V1,V2,V3,SP
        JokerEye="com.louise.enemy.JokerEye",--V1
        KillerEye="com.louise.enemy.KillerEye",--V1,SP,R1,R2
        Lark="com.louise.enemy.Lark",--V1,R1,R2,SP,NM
        MegaBunny="com.louise.enemy.MegaBunny", --Third Version, Spawn @ V1
        MegaCorn="com.louise.enemy.Corn.MegaCorn",--V1
        MetFire="com.louise.enemy.MetFire",--V1,R1,R2,SP,NM
        Metrid="com.EXE3.Metrid.Enemy",--V1,V2,V3,SP
        Mettaur="com.OFC.char.EXE6-001-Metall",
        Noir="com.OctoChris.enemy.Noir",
        OldBurner="com.louise.enemy.OldBurner", --Third Version, Spawn @ V1
        OldHeater="com.louise.enemy.OldHeater", --Second Version, Spawn @ V1
        OldStove="com.louise.enemy.OldStove", --First Version, Spawn @ V1/SP/R1/R2/NM
        Piranha="com.louise.enemy.Piranha",
        Powie3="com.discord.Konstinople#7692.enemy.powie3",
        Powie="com.discord.Konstinople#7692.enemy.powie",
        ProtomanPoN="com.OFC.char.EXEPoN-028-Blues", --V1,V2,V3,SP
        Puffy="com.louise.enemy.Puffy",
        Quaker="com.louise.enemy.Quaker",
        RareChampy="com.keristero.char.RareChampy",
        Ratty="com.Dawn.BN3.Enemy.Ratty",--V1,V2,V3,SP
        Roll="com.OFC.char.EXEPoN-027-Roll", --V1
        Scuttle="com.louise.enemy.Scuttle",--V1
        Scuttler="com.louise.enemy.Scuttler",--V1
        Scuttlest="com.louise.enemy.Scuttlest",--V1,SP
        Scuttzer="com.louise.enemy.Scuttzer",--V1
        Scutz="com.louise.enemy.Scutz",--V1
        Shaker="com.louise.enemy.Shaker",
        Shrimpy="com.louise.enemy.Shrimpy",
        Skarab="com.louise.enemy.Skarab",--V1,SP,R1,R2,NM
        Skarry="com.louise.enemy.Skarry",--V1
        Skelly="com.louise.enemy.Skelly",--V1
        Spikey="com.Dawn.char.Spikey",--V1,V2,V3,SP
        Swordy="com.louise.enemy.Swordy",--V1,V2,V3,SP,NM
        Tark="com.louise.enemy.Tark",--V1
        TuffBunny="com.louise.enemy.TuffBunny", --Second Version, Spawn @ V1
        VacuumFan="com.louise.enemy.VacuumFan", --V1/V2/V3/SP
        Volcano="com.louise.enemy.Volcano",--V1,V2,V3,R1,R2,SP,NM
        Volgear="com.louise.char.Volgear",--V1,V2,V3,SP
        WindBox="com.louise.enemy.WindBox", --V1/V2/V3/SP/NM
        WoodmanPoN="com.OFC.char.EXEPoN-024-WoodMan", --V1,V2,V3,SP
        Yort="com.louise.enemy.Yort",--V1,V2,V3,R1,R2,SP,NM
        Zomon="com.OFC.char.EXE5-013-Zaemon",
    },
    obstacles = {
        RockCube="obstacles/rock_cube.lua",
        Rock="obstacles/rock.lua",
        Coffin="obstacles/coffin.lua",
        BlastCube="obstacles/blast_cube.lua",
        IceCube="obstacles/ice_cube.lua",
        MysteryData="obstacles/mystery.lua",
    },
    tile_states = {
        0,--normal
        1,--cracked
        2,--broken
        11,--up
        12,--down
        9,--left
        10,--right
        7,--empty
        4,--grass
        17,--hidden
        8,--holy
        3,--ice
        5,--lava
        6,--poison
        13,--volcano
        14,--sea
        15,--sand
        16,--metal
    },
    enemy_ranks = {
        0,--v1
        1,--v2
        2,--v3
        3,--sp
        4,--ex
        5,--rare1
        6,--rare2
        7--nightmare
    },
    field_tiles_default = {
        {1,1,1,1,1,1},
        {1,1,1,1,1,1},
        {1,1,1,1,1,1}
    },
    field_teams_default = {
        {2,2,2,1,1,1},
        {2,2,2,1,1,1},
        {2,2,2,1,1,1}
    }
}

function get_enum_value_by_index(mapping_table,p_index)
    for i, value in ipairs(mapping_table) do
        if tonumber(i) == tonumber(p_index) then
            return value
        end
    end
    print("[ezencounters] WARNING invalid input data, no index",p_index)
end

function package_requires_scripts()
    for mob_alias, package in pairs(encounter_info.enemy_packages) do
        --print('[ezencounters] requiring '..package)
        Engine.requires_character(package)
    end
end

function get_package_id(alias) 
    return encounter_info.enemy_packages[alias]
end

function package_init(package) 
    package:declare_package_id(mob_package_id)
    package:set_name(package_name)
    package:set_description("Initiate custom battles from the server!")
    package:set_preview_texture_path(_modpath.."preview.png")
end

function package_build(mob,data) 
    --First a work around to not crash the server, include the obstacle scripts here rather than in global scope
    for obstacle_alias, script_path in pairs(encounter_info.obstacles) do
        --print('[ezencounters] including '..script_path)
        loaded_obstacles[obstacle_alias] = include(script_path)
    end
    --work around end

    --TESTING, uncomment to set up custom arrangements of enemies for testing
    --[[local data = {
        enemies = {
            {name="Mettaur",rank=1},
        },
        positions = {
            {0,0,0,0,0,1},
            {0,0,0,0,1,0},
            {0,0,0,1,0,0}
        },
    }]]
    --

    local field = mob:get_field()
    --can setup music, and field here
    if not data then
        --test data here
        local flip_field = false
        data = ramdomize_test_scenario(encounter_info,flip_field)
    end
    --print('building package with data!')
    --load tile states from  data
    if not data.tiles then
        data.tiles = encounter_info.field_tiles_default
    end
    for y, x_table in ipairs(data.tiles) do
        for x, tile_state_index in ipairs(x_table) do
            local tile = field:tile_at(x,y)
            local tile_state = get_enum_value_by_index(encounter_info.tile_states,tile_state_index)
            tile:set_state(tile_state)
        end
    end

    --load tile teams from  data
    if not data.teams then
        data.teams = encounter_info.field_teams_default
    end
    for y, x_table in ipairs(data.teams) do
        for x, team_index in ipairs(x_table) do
            local tile = field:tile_at(x,y)
            tile:set_team(team_index,false)
        end
    end

    --load enemies from data
    if not data.enemies then
        print('[ezencounters] WARNING no enemies listed for encounter')
        return
    end
    spawners = {}
    for index, enemy_info in ipairs(data.enemies) do
        local enemy_rank = get_enum_value_by_index(encounter_info.enemy_ranks,enemy_info.rank)
        print("trying to make spawner for ",enemy_info.name,enemy_rank)
        spawners[index] = mob:create_spawner(get_package_id(enemy_info.name),enemy_rank)
    end

    --spawn enemies at positions
    if not data.positions then
        print('[ezencounters] WARNING no enemy spawn positions')
        return
    end
    for y, x_table in ipairs(data.positions) do
        for x, spawner_id in ipairs(x_table) do
            if spawner_id ~= 0 then
                local spawner = spawners[spawner_id]
                local enemy_info = data.enemies[spawner_id]
                local mutator = spawner:spawn_at(x, y)
                mutator:mutate(function (character)
                    if enemy_info.nickname ~= nil then
                        character:set_name(enemy_info.nickname)
                    end
                    if enemy_info.max_hp ~= nil then
                        --character:mod_max_hp(enemy_info.max_hp) it dont work
                    end
                    if enemy_info.starting_hp ~= nil then
                        character:set_health(enemy_info.starting_hp)
                    end
                end)
            end
        end
    end

    if data.player_positions then
        for y, x_table in ipairs(data.player_positions) do
            for x, player_id in ipairs(x_table) do
                if player_id ~= 0 then
                    mob:spawn_player( player_id, x, y )
                end
            end
        end
    end

    if data.freedom_mission then
        local turns = 3
        local can_flip = true
        if data.freedom_mission.turns ~= nil then
            turns = data.freedom_mission.turns
        end
        if data.freedom_mission.player_can_flip ~= nil then
            can_flip = data.freedom_mission.player_can_flip
        end
        mob:enable_freedom_mission(turns,can_flip)
    end

    if data.music then
        local loop_start = 0
        local loop_end = 0
        if data.music.loop_start then
            loop_start = data.music.loop_start
        end
        if data.music.loop_end then
            loop_end = data.music.loop_end
        end
        mob:stream_music(_folderpath.."/music/"..data.music.path,loop_start,loop_end)
    end

    if data.obstacle_positions then
        for y, x_table in ipairs(data.obstacle_positions) do
            for x, obstacle_id in ipairs(x_table) do
                if obstacle_id ~= 0 then
                    local obstacle_info = data.obstacles[obstacle_id]
                    local create_obstacle_func = loaded_obstacles[obstacle_info.name]
                    local new_obstacle = create_obstacle_func()
                    --print('spawning obstacle '..obstacle_info.name..' at '..x..','..y)
                    field:spawn(new_obstacle,x,y)
                end
            end
        end
    end

end