local ezmemory = require('scripts/ezlibs-scripts/ezmemory')
local ezquests = require('scripts/ezlibs-scripts/ezquests')
local ezexplosions = require('scripts/ezlibs-scripts/ezexplosions')

function await(v) return Async.await(v) end

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
         Net.transfer_player(player_id, "default", true, 15, 15, 0, "Down")
         return
    end
    if stats.ran then
        return -- no rewards for wimps
    end

    --local reward_monies = (stats.score*50)
    --ezmemory.spend_player_money(player_id,-reward_monies) -- spending money backwards gives money
    --Net.message_player(player_id,"Got $"..reward_monies.."!")
    --Net.play_sound_for_player(player_id,sfx.item_get)
    
end

local boss_rewards = function(player_id,encounter_info,stats)
    if stats.emotion == 1 then
        Net.set_player_emotion(player_id, stats.emotion)
    else
        Net.set_player_emotion(player_id, 0)
    end
    -- set the player health to whatever they finished the battle with
    Net.set_player_health(player_id,stats.health)
    if stats.health == 0 then
         Net.transfer_player(player_id, "default", true, 14, 15, 0, "Down")
         return
    end
    if stats.ran then
        return -- no rewards for wimps
    end

    --defeat message
    local heelmug = "/server/assets/ezlibs-assets/eznpcs/mug/heel-navi-exe4_purple.png"
    local mugani = "/server/assets/ezlibs-assets/eznpcs/mug/mug.animation"
    Net.message_player(player_id, "I was just doing habitat restoration...", heelmug, mugani)
    --sets the Clean Junk quest to a complete status
    local quest_name = ezquests.get_quest("Clean Junk")
    local event_value = 'cleaned'
    ezquests.quest_event(player_id,quest_name.name,event_value)

end


local encounter1 = {
    name="Encounter1",
    path="/server/assets/ezlibs-assets/ezencounters/ezencounters.zip",
    weight=10,
    enemies={
        {name="Gunner",rank=1},
        {name="Beetank",rank=1},
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
        {0,0,0,3,0,0},
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
    results_callback = give_result_awards --function (player_id,encounter_info,stats)
}


local encounter2 = {
    name="Encounter2",
    path="/server/assets/ezlibs-assets/ezencounters/ezencounters.zip",
    weight=10,
    enemies={
        {name="Mettaur",rank=1},
    },
    obstacles={
    },
    positions={
        {0,0,0,0,0,1},
        {0,0,0,0,0,0},
        {0,0,0,0,1,0},
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
    results_callback = give_result_awards --function (player_id,encounter_info,stats)
}
    



local encounter3 = {
    name="Encounter3",
    path="/server/assets/ezlibs-assets/ezencounters/ezencounters.zip",
    weight=10,
    enemies={
        {name="Mettaur",rank=1},
        {name="Beetank",rank=1},
    },
    obstacles={
    },
    positions={
        {0,0,0,0,0,2},
        {0,0,0,0,0,0},
        {0,0,0,0,1,0},
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
    results_callback = give_result_awards --function (player_id,encounter_info,stats)
}

local encounter4 = {
    name="Encounter4",
    path="/server/assets/ezlibs-assets/ezencounters/ezencounters.zip",
    weight=10,
    enemies={
        {name="Gunner",rank=1},
        {name="Mettaur",rank=1},
    },
    obstacles={
    },
    positions={
        {0,0,0,0,0,1},
        {0,0,0,0,2,0},
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
        {1,1,1,1,1,1},
        {1,1,1,1,1,1},
        {1,1,1,1,1,1},
    },
    teams={
        {2,2,2,1,1,1},
        {2,2,2,1,1,1},
        {2,2,2,1,1,1},
    },
    results_callback = give_result_awards --function (player_id,encounter_info,stats)
}

local area_boss = {
    name="Area Boss",
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
    results_callback = boss_rewards
}

return {
    minimum_steps_before_encounter=30,
    encounter_chance_per_step=0.1,
    encounters={encounter1, encounter2, encounter3, encounter4, area_boss}
}