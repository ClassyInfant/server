local eznpcs = require('scripts/ezlibs-scripts/eznpcs/eznpcs')
local ezmemory = require('scripts/ezlibs-scripts/ezmemory')
local ezencounters = require('scripts/ezlibs-scripts/ezencounters/main')
local ezwarps = require('scripts/ezlibs-scripts/ezwarps/main')
local helpers = require('scripts/ezlibs-scripts/helpers')
local ezbus = require('scripts/ezlibs-scripts/ezbus')


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
        local area_id = Net.get_player_area(player_id)
        if area_id == "default" then
            Net.transfer_player(player_id, "default", true, 14, 15, 0, "Down")
        end
        if area_id == "Transport" then
            Net.transfer_player(player_id, "Transport", true, 24, 6, 2, "Down")
        end
        if area_id == nil then
            print("No area ID")
            Net.transfer_player(player_id, "default", true, 14, 15, 0, "Down")
        end
        return
    end
    if stats.ran then
        return -- no rewards for wimps
    end

end

local function _encounter_result_flags(stats)
    local reason = tonumber(stats and stats.reason or 0) or 0
    local hp = tonumber(stats and (stats.health or stats.player_hp or stats.hp) or 0) or 0

    local ran, won, lost = false, false, false

    if reason == 1 then        -- battle won
        won = true
    elseif reason == 2 then    -- battle lost
        lost = true
    elseif reason == 3 then    -- ran with L
        ran = true
    elseif reason == 4 then    -- ESC / dev escape
        ran = true
    else
        -- backwards compatibility with older builds
        ran = stats and (stats.ran or stats.fled or stats.escape) or false
        if not ran then
            if hp > 0 then
                won = true
            else
                lost = true
            end
        end
    end

    return {
        reason = reason,
        hp = hp,
        ran = ran,
        won = won,
        lost = lost,
    }
end


local junkfight = {
    name="junkfight",
    path="/server/assets/ezlibs-assets/ezencounters/ezencounters.zip",
    weight=10,
    enemies={
        {name="Mettaur",rank=2},
        {name="Mettaur",rank=1},
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
    npcitions={
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
    results_callback = give_result_awards

}

local progfight = {
    name="progfight",
    path="/server/assets/ezlibs-assets/ezencounters/ezencounters.zip",
    weight=10,
    enemies={
        {name="Swordy",rank=2},
        {name="Mettaur",rank=2},
        {name="Spikey",rank=1}
    },
    obstacles={
    },
    positions={
        {0,0,0,0,0,2},
        {0,0,0,0,1,0},
        {0,0,0,2,0,3},
    },
    obstacle_positions={
        {0,0,0,0,0,0},
        {0,0,0,0,0,0},
        {0,0,0,0,0,0},
    },
    npcitions={
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
    results_callback = give_result_awards

}

--subnet_1 junk quest encounter, cleanup, and save
local clean_junk = {
    name = "clean_junk",
    action = function(npc, player_id, dialogue, relay_object)
        return async(function()
            local player_mugshot = Net.get_player_mugshot(player_id)
            local area_id = Net.get_player_area(player_id)
            local object_id = Net.get_object_by_id(area_id, relay_object.id)                      
             
            --print(tostring(relay_object.id))           
            
            await(Async.message_player(player_id, "Cleaning up this junk...", player_mugshot.texture_path, player_mugshot.animation_path))
            local stats = await(ezencounters.begin_encounter(player_id, junkfight, nil))
            local flags = _encounter_result_flags(stats)
            
            if flags.ran or flags.lost then
                return
            else
                ezmemory.hide_object_from_player(player_id, area_id, relay_object.id)
                if dialogue.custom_properties["Next 1"] == nil then
                    return
                else
                    return dialogue.custom_properties["Next 1"]
                end
            end
            
        end)
    end
}
eznpcs.add_event(clean_junk)

--box of viruses name is a hold over from an older idea
local free_prog = {
name = "free_prog",
    action = function(npc, player_id, dialogue, relay_object)
        return async(function()
            local player_mugshot = Net.get_player_mugshot(player_id)
            local area_id = Net.get_player_area(player_id)
            local object_id = Net.get_object_by_id(area_id, relay_object.id)                      
             
            --print(tostring(relay_object.id))           
            
            await(Async.message_player(player_id, "Oh no this cube is full of viruses!", player_mugshot.texture_path, player_mugshot.animation_path))
            local stats = await(ezencounters.begin_encounter(player_id, progfight, nil))
            local flags = _encounter_result_flags(stats)
            
            if flags.ran or flags.lost then
                return
            else
                ezmemory.hide_object_from_player(player_id, area_id, relay_object.id)
                if dialogue.custom_properties["Next 1"] == nil then
                    return
                else
                    return dialogue.custom_properties["Next 1"]
                end
            end
            
        end)
    end
}
eznpcs.add_event(free_prog)

--remove object listed in called custom_property ["Delete"]
local remove_object = {
    name = "remove_object",
    action = function(npc, player_id, dialogue, relay_object)
        return async(function()
            local area_id = Net.get_player_area(player_id)
            local objnum = dialogue.custom_properties["Delete"]
            --print(objnum)
            local obj = Net.get_object_by_id(area_id, objnum)
            --print(obj.id)
            local sfx = {
                item_get='/server/assets/ezlibs-assets/sfx/item_get.ogg'
            }
            Net.provide_asset(area_id, "/server/assets/ezlibs-assets/ezwarps/logout.png")
            Net.provide_asset(area_id, "/server/assets/ezlibs-assets/ezwarps/logout.animation")

            if dialogue.custom_properties["Animate"] then
                local warp_in_effect_id = "warp_in_effect_"..obj.id
                print('spawning log in effect bot')
                Net.create_bot(warp_in_effect_id, {
                    warp_in = false,
                    texture_path = "/server/assets/ezlibs-assets/ezwarps/logout.png",
                    animation_path = "/server/assets/ezlibs-assets/ezwarps/logout.animation",
                    area_id = area_id,
                    x = obj.x,
                    y = obj.y,
                    z = obj.z
                })
                Net.animate_bot(warp_in_effect_id, "JACK_OUT", false)
                Net.play_sound_for_player(player_id, '/server/assets/ezlibs-assets/ezwarps/log_out.ogg')
                --sleep so that animation plays before bot is removed
                Async.sleep(0.7).and_then(function()
                Net.remove_bot(warp_in_effect_id)
                end)
            else
                Net.play_sound_for_player(player_id,sfx.item_get)
            end
            ezmemory.hide_object_from_player(player_id, area_id, obj.id)

            if dialogue.custom_properties["Next 1"] == nil then
                return
            else
                return dialogue.custom_properties["Next 1"]
            end
            
        end)
    end  
}
eznpcs.add_event(remove_object)

--Play warp animation on relay_object then hide it from that player
local warp_npc = {
    name = "warp_npc",
    action = function(npc, player_id, dialogue, relay_object)

        return async(function()

            local area_id = Net.get_player_area(player_id)
            Net.provide_asset(area_id, "/server/assets/teleporter.png")
            Net.provide_asset(area_id, "/server/assets/teleporter.animation")

            --Create a bot at the relay object location        
            local warp_in_effect_id = "warp_in_effect_"..relay_object.id
            print('spawning log in effect bot')
            Net.create_bot(warp_in_effect_id, {
                warp_in = false,
                texture_path = "/server/assets/teleporter.png",
                animation_path = "/server/assets/teleporter.animation",
                area_id = area_id,
                x = relay_object.x-.02,
                y = relay_object.y-.02,
                z = relay_object.z
            })

            --Hide the relay object from the player interacting and play the warp animation
            ezmemory.hide_object_from_player(player_id, area_id, relay_object.id)
            --For Testing
            --ezmemory.hide_object_from_player_till_disconnect(player_id, area_id, relay_object.id)
            Net.animate_bot(warp_in_effect_id, "JACK_OUT", false)
            Net.play_sound_for_player(player_id, '/server/assets/teleport.ogg')
            --sleep so that animation plays before bot is removed
            Async.sleep(0.25).and_then(function()
            Net.remove_bot(warp_in_effect_id)
            
            --Move to the next dialogue if there is one
            if dialogue.custom_properties["Next 1"] == nil then
                return
            else
                return dialogue.custom_properties["Next 1"]
            end

            end)
        end)
    end
}
eznpcs.add_event(warp_npc)

local move_player = {
    name = "move_player",
    action = function(npc, player_id, dialogue, relay_object)

        return async(function()

            local area = dialogue.custom_properties["Area"]
            local x = dialogue.custom_properties["X"]
            local y = dialogue.custom_properties["Y"]
            local z = dialogue.custom_properties["Z"]
            local facing = dialogue.custom_properties["Direction"]

            Net.transfer_player(player_id, area, true, x, y, z, facing)
        end)
    end
}
eznpcs.add_event(move_player)

local boss_rematch = {
    name = "boss_rematch",
    action = function(npc, player_id, dialogue, relay_object)

        return async(function()
            
        end)
    end
}
eznpcs.add_event(boss_rematch)


