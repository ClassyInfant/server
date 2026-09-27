local ezmemory = require('scripts/ezlibs-scripts/ezmemory')



local give_result_awards = function (player_id,encounter_info,stats)
    -- stats = { health: number, score: number, time: number, ran: bool, emotion: number, turns: number, npcs: { id: String, health: number }[] }
    -- set the player emotion if they left the battle with full sync (1)
    if stats.emotion == 1 then
        Net.set_player_emotion(player_id, stats.emotion)
    else
        Net.set_player_emotion(player_id, 0)
    end
    -- set the player health to whatever they finished the battle with
    Net.set_player_health(player_id,stats.health)
    if stats.health == 0 then
         Net.transfer_player(player_id, "Transport", true, 24, 6, 2, "Down")
         return
    end
    if stats.ran then
        return -- no rewards for wimps
    end

end

local encounter1 = {
    name="Encounter1",
    path="/server/assets/ezlibs-assets/ezencounters/ezencounters.zip",
    weight=10,
    enemies={
        {name="Bunny",rank=1},
        {name="TuffBunny",rank=2},
    },
    obstacles={
    },
    positions={
        {0,0,0,1,0,0},
        {0,0,0,0,2,0},
        {0,0,0,0,0,1},
    },
    obstacle_positions={
        {0,0,0,0,0,0},
        {0,0,0,0,0,0},
        {0,0,0,0,0,0},
    },
    player_positions={
        {0,0,0,0,0,0},
        {0,1,0,0,0,0},
        {0,0,0,0,0,0},
    },
    tiles={
        {1,1,18,18,1,1},
        {1,18,1,1,18,1},
        {18,1,1,1,1,18},
    },
    teams={
        {2,2,2,1,1,1},
        {2,2,2,1,1,1},
        {2,2,2,1,1,1},
    },

    results_callback = give_result_awards --function (player_id,encounter_info,stats)
}

local encounter2 = {
    name="Encounter2",
    path="/server/assets/ezlibs-assets/ezencounters/ezencounters.zip",
    weight=10,
    enemies={
        {name="Catack",rank=1},
    },
    obstacles={
    },
    positions={
        {0,0,0,0,0,1},
        {0,0,0,0,1,0},
        {0,0,0,0,0,1},
    },
    obstacle_positions={
        {0,0,0,0,0,0},
        {0,0,0,0,0,0},
        {0,0,0,0,0,0},
    },
    player_positions={
        {0,0,0,0,0,0},
        {0,1,0,0,0,0},
        {0,0,0,0,0,0},
    },
    tiles={
        {1,1,1,1,1,1},
        {18,18,18,18,18,18},
        {1,1,1,1,1,1},
    },
    teams={
        {2,2,2,1,1,1},
        {2,2,2,1,1,1},
        {2,2,2,1,1,1},
    },
    results_callback = give_result_awards --function (player_id,encounter_info,stats)
}

local encounter3 = {
    name="Encounter3",
    path="/server/assets/ezlibs-assets/ezencounters/ezencounters.zip",
    weight=10,
    enemies={
        {name="KillerEye",rank=1},
        {name="Bunny",rank=1},
    },
    obstacles={
    },
    positions={
        {0,0,0,0,1,0},
        {0,0,0,2,0,0},
        {0,0,0,0,0,2},
    },
    obstacle_positions={
        {0,0,0,0,0,0},
        {0,0,0,0,0,0},
        {0,0,0,0,0,0},
    },
    player_positions={
        {0,0,0,0,0,0},
        {0,1,0,0,0,0},
        {0,0,0,0,0,0},
    },
    tiles={
        {1,1,1,1,18,1},
        {18,18,18,18,18,18},
        {1,18,1,1,1,1},
    },
    teams={
        {2,2,2,1,1,1},
        {2,2,2,1,1,1},
        {2,2,2,1,1,1},
    },
    results_callback = give_result_awards --function (player_id,encounter_info,stats)
}


return {
    minimum_steps_before_encounter=50,
    encounter_chance_per_step=0.1,
    encounters={encounter1, encounter2, encounter3}
}