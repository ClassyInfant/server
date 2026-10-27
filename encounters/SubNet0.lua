local ezmemory = require('scripts/ezlibs-scripts/ezmemory')
local ezquests = require('scripts/ezlibs-scripts/ezquests')
local ezexplosions = require('scripts/ezlibs-scripts/ezexplosions')
local rewards = require('encounters/rewards')

function await(v) return Async.await(v) end

local give_result_awards = function (player_id,encounter_info,stats,rewards)
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
        Net.set_player_health(player_id,1)
         Net.transfer_player(player_id, "default", true, 15, 15, 0, "Down")
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
        {name="Mettaur",rank=4},
        {name="Mettaur",rank=3},
    },
    obstacles={
    },
    positions={
        {0,0,0,0,0,2},
        {0,0,0,0,1,0},
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
        {1,1,14,14,1,1},
        {1,1,14,14,1,1},
        {1,1,14,14,1,1},
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
        {name="OldHeater",rank=1},
    },
    obstacles={
    },
    positions={
        {0,0,0,0,1,0},
        {0,0,0,1,0,0},
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
        {1,9,1,1,9,1},
        {9,1,9,9,1,9},
        {1,9,1,1,9,1},
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
        {name="DemonEye",rank=1},
        {name="Volgear",rank=2},
    },
    obstacles={
    },
    positions={
        {0,0,0,1,0,0},
        {0,0,0,0,0,2},
        {0,0,0,0,0,0},
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
        {1,9,1,1,9,1},
        {9,2,9,9,2,9},
        {1,9,1,1,9,1},
    },
    teams={
        {2,2,2,1,1,1},
        {2,2,2,1,1,1},
        {2,2,2,1,1,1},
    },

    results_callback = give_result_awards --function (player_id,encounter_info,stats)
}

local encounter4 = {
    name="Encounter4",
    path="/server/assets/ezlibs-assets/ezencounters/ezencounters.zip",
    weight=10,
    enemies={
        {name="Zomon",rank=3},
        {name="Skarab",rank=1},
    },
    obstacles={
    },
    positions={
        {0,0,0,0,0,2},
        {0,0,0,0,0,1},
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
        {2,2,1,1,1,1},
        {2,2,1,1,1,1},
        {2,2,1,1,1,1},
    },
    teams={
        {2,2,2,1,1,1},
        {2,2,2,1,1,1},
        {2,2,2,1,1,1},
    },

    results_callback = give_result_awards --function (player_id,encounter_info,stats)
}

local encounter5 = {
    name="Encounter5",
    path="/server/assets/ezlibs-assets/ezencounters/ezencounters.zip",
    weight=5,
    enemies={
        {name="BigBrute",rank=1},
    },
    obstacles={
    },
    positions={
        {0,0,0,0,0,1},
        {0,0,0,0,0,0},
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
        {1,9,1,1,9,1},
        {9,14,9,9,14,9},
        {1,9,1,1,9,1},
    },
    teams={
        {2,2,2,1,1,1},
        {2,2,2,1,1,1},
        {2,2,2,1,1,1},
    },

    results_callback = give_result_awards --function (player_id,encounter_info,stats)
}


return {
    --persistent_health=true
    minimum_steps_before_encounter=30,
    encounter_chance_per_step=0.1,
    encounters={encounter1, encounter2, encounter3, encounter4, encounter5}
}

