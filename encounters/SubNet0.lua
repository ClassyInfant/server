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

--Bosses for the rematch machine

local sub1_boss = {
    name="SubNet1 Boss",
    path="/server/assets/ezlibs-assets/ezencounters/ezencounters.zip",
    weight=0,
    enemies={
        {name="HeelNavi",rank=1},
        {name="Mettaur",rank=1},
    },
    obstacles={
    },
    positions={
        {0,0,0,2,0,0},
        {0,0,0,0,1,0},
        {0,0,0,0,2,0},
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
        {1,1,1,1,1,1},
        {1,1,1,1,1,1},
    },
    teams={
        {2,2,2,1,1,1},
        {2,2,2,1,1,1},
        {2,2,2,1,1,1},
    },
    music={
        path="bn4_boss.mid"
    },
}

return {
    --persistent_health=true
    minimum_steps_before_encounter=30,
    encounter_chance_per_step=0.1,
    encounters={encounter1, sub1_boss}
}