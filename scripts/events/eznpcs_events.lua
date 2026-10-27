local eznpcs = require('scripts/ezlibs-scripts/eznpcs/eznpcs')
local ezmemory = require('scripts/ezlibs-scripts/ezmemory')
local ezencounters = require('scripts/ezlibs-scripts/ezencounters/main')
local ezwarps = require('scripts/ezlibs-scripts/ezwarps/main')
local helpers = require('scripts/ezlibs-scripts/helpers')
local ezbus = require('scripts/ezlibs-scripts/ezbus')
local ezexplosions = require('scripts/ezlibs-scripts/ezexplosions')
local ezquests = require('scripts/ezlibs-scripts/ezquests')


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
        Net.set_player_health(player_id,1)
        local area_id = Net.get_player_area(player_id)
        if area_id == "default" then
            Net.transfer_player(player_id, "default", true, 14, 15, 0, "Down")
        end
        if area_id == "Transport" or area_id == "Transport2" or area_id == "SwitchComp" or area_id == "KitchenComp" or area_id == "CoffeeComp" or area_id == "Transport3" then
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

local subnet_1_boss_fight = {
    name="subnet_1_boss_fight",
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
    --results_callback = boss_rewards
}

local circusman = {
    name="circusman_boss",
    path="/server/assets/ezlibs-assets/ezencounters/ezencounters.zip",
    weight=10,
    enemies={
        {name="CircusMan",rank=1},
    },
    obstacles={
    },
    positions={
        {0,0,0,0,0,0},
        {0,0,0,0,1,0},
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
        {14,1,1,1,1,1},
        {1,1,1,1,1,1},
        {14,1,1,1,1,1},
    },
    teams={
        {2,2,2,1,1,1},
        {2,2,2,1,1,1},
        {2,2,2,1,1,1},
    },
    music={
        path="bn6_boss.mid"
    },
    results_callback = give_result_awards
}

local circusman_rematch = {
    name="circusman_boss",
    path="/server/assets/ezlibs-assets/ezencounters/ezencounters.zip",
    weight=10,
    enemies={
        {name="CircusMan",rank=1},
    },
    obstacles={
    },
    positions={
        {0,0,0,0,0,0},
        {0,0,0,0,1,0},
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
        {14,1,1,1,1,1},
        {1,1,1,1,1,1},
        {14,1,1,1,1,1},
    },
    teams={
        {2,2,2,1,1,1},
        {2,2,2,1,1,1},
        {2,2,2,1,1,1},
    },
    music={
        path="bn6_boss.mid"
    },
    --results_callback = give_result_awards
}

local bass = {
    name="bass_boss",
    path="/server/assets/ezlibs-assets/ezencounters/ezencounters.zip",
    weight=10,
    enemies={
        {name="Forte",rank=1},
    },
    obstacles={
    },
    positions={
        {0,0,0,0,0,0},
        {0,0,0,0,1,0},
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
    music={
        path="bn5_boss.mid"
    },
    --results_callback = give_result_awards
}

local virustraders = {
    name="virustraders",
    path="/server/assets/ezlibs-assets/ezencounters/ezencounters.zip",
    weight=10,
    enemies={
        {name="Scuttle",rank=1},
    },
    obstacles={
    },
    positions={
        {0,0,0,0,0,1},
        {0,0,0,0,1,0},
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
        {1,12,1,1,12,1},
        {1,1,1,1,1,1},
    },
    teams={
        {2,2,2,1,1,1},
        {2,2,2,1,1,1},
        {2,2,2,1,1,1},
    },
    music={
        path="bn6_battle_xg.mid"
    },
    results_callback = give_result_awards
}

local virustraders2 = {
    name="virustraders2",
    path="/server/assets/ezlibs-assets/ezencounters/ezencounters.zip",
    weight=10,
    enemies={
        {name="Scuttle",rank=1},
        {name="Mettaur",rank=2},
    },
    obstacles={
    },
    positions={
        {0,0,0,0,0,2},
        {0,0,0,0,1,0},
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
    music={
        path="bn6_battle_xg.mid"
    },
    results_callback = give_result_awards
}

local virustraders3 = {
    name="virustraders3",
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
        path="bn6_battle_xg.mid"
    },
    results_callback = give_result_awards
}

local virustraders4 = {
    name="virustraders4",
    path="/server/assets/ezlibs-assets/ezencounters/ezencounters.zip",
    weight=10,
    enemies={
        {name="Scuttle",rank=1},
        {name="Spikey",rank=1}
    },
    obstacles={
    },
    positions={
        {0,0,0,0,0,0},
        {0,0,0,0,1,0},
        {0,0,0,2,0,0},
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
        path="bn6_battle_xg.mid"
    },
    results_callback = give_result_awards
}

--remove object listed in called custom_property ["Delete"] or relay object and play animation for it
local remove_object = {
    name = "remove_object",
    action = function(npc, player_id, dialogue, relay_object)
        return async(function()
            local area_id = Net.get_player_area(player_id)

            local objnum = dialogue.custom_properties["Delete"]
            --print(objnum)
            local obj = Net.get_object_by_id(area_id, objnum)
            
            local sfx = {
                item_get='/server/assets/ezlibs-assets/sfx/item_get.ogg'
            }
            local offsetx = 0
            local offsety = 0
            Net.provide_asset(area_id, "/server/assets/ezlibs-assets/ezwarps/logout.png")
            Net.provide_asset(area_id, "/server/assets/ezlibs-assets/ezwarps/logout.animation")
            Net.provide_asset(area_id, "/server/assets/teleporter.png")
            Net.provide_asset(area_id, "/server/assets/teleporter.animation")

            if dialogue.custom_properties["Animate"] then
                    if dialogue.custom_properties["Animation"] ~= "Explode" then
                        --set variables base on options and preload assets [texture path][animation path][animation][sound]
                        if dialogue.custom_properties["Animation"] == "Warp" then
                            texture = "/server/assets/teleporter.png"
                            animation = "/server/assets/teleporter.animation"
                            state = "JACK_OUT"
                            sound = '/server/assets/teleport.ogg'
                            offsetx = .02
                            offsety = .02
                        end
                        if dialogue.custom_properties["Animation"] == "Logout" then
                            texture = "/server/assets/ezlibs-assets/ezwarps/logout.png"
                            animation = "/server/assets/ezlibs-assets/ezwarps/logout.animation"
                            state = "JACK_OUT"
                            sound = '/server/assets/ezlibs-assets/ezwarps/log_out.ogg'
                        end

                        local warp_in_effect_id = "warp_in_effect_"..obj.id
                        print('spawning log in effect bot')
                        Net.create_bot(warp_in_effect_id, {
                            warp_in = false,
                            texture_path = texture,
                            animation_path = animation,
                            area_id = area_id,
                            x = obj.x - offsetx,
                            y = obj.y - offsety,
                            z = obj.z
                        })
                        --hide object then play animation where it was
                        ezmemory.hide_object_from_player(player_id, area_id, obj.id)
                        Net.animate_bot(warp_in_effect_id, state, false)
                        Net.play_sound_for_player(player_id, sound)
                        --sleep so that animation plays before bot is removed
                        Async.sleep(0.7).and_then(function()
                        Net.remove_bot(warp_in_effect_id)
                        end)
                    elseif dialogue.custom_properties["Animation"] == "Explode" then
                        --explode object then hide it part way through animation                  
                        ezexplosions.explode(obj.id, area_id, 5)
                        Async.sleep(0.5).and_then(function()
                            ezmemory.hide_object_from_player(player_id, area_id, obj.id)
                        end) 
                    end
            else
                --hide object and play sound
                ezmemory.hide_object_from_player(player_id, area_id, obj.id)
                Net.play_sound_for_player(player_id,sfx.item_get)
            end

            if dialogue.custom_properties["Next 1"] == nil then
                await(Async.sleep(0.5))
                return
            else
                await(Async.sleep(0.5))
                return dialogue.custom_properties["Next 1"]
            end
            
        end)
    end  
}
eznpcs.add_event(remove_object)

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

local subnet_1_boss = {
    name = "SubNet1 Boss",
    action = function(npc, player_id, dialogue, relay_object)
        return async(function()           
            
            local stats = await(ezencounters.begin_encounter(player_id, subnet_1_boss_fight, nil))
            local flags = _encounter_result_flags(stats)
            
        end)
    end
}
eznpcs.add_event(subnet_1_boss)

local bass_boss = {
    name = "Bass Boss",
    action = function(npc, player_id, dialogue, relay_object)
        return async(function()           
            
            local stats = await(ezencounters.begin_encounter(player_id, bass, nil))
            local flags = _encounter_result_flags(stats)
            
        end)
    end
}
eznpcs.add_event(bass_boss)

local circusman_rematch = {
    name = "Circusman Boss Rematch",
    action = function(npc, player_id, dialogue, relay_object)
        return async(function()           
            
            local stats = await(ezencounters.begin_encounter(player_id, circusman_rematch, nil))
            local flags = _encounter_result_flags(stats)
            
        end)
    end
}
eznpcs.add_event(circusman_rematch)

--box of viruses name is a hold over from an older idea
local free_prog = {
name = "free_prog",
    action = function(npc, player_id, dialogue, relay_object)
        return async(function()
            local player_mugshot = Net.get_player_mugshot(player_id)
            local area_id = Net.get_player_area(player_id)
            local waiting = true                      
             
            --print(tostring(relay_object.id))           
            
            await(Async.message_player(player_id, "Oh no this cube is full of viruses!", player_mugshot.texture_path, player_mugshot.animation_path))
            local stats = await(ezencounters.begin_encounter(player_id, progfight, nil))
            local flags = _encounter_result_flags(stats)
            if flags.ran or flags.lost then
                return
            else
                Net:on("battle_exit", function(event)  
                    if ezmemory.object_is_hidden_from_player(player_id, area_id, relay_object.id) == false then               
                        --print("Prog battle over.")
                        waiting = false
                    
                    end
                end)
                while waiting == true do
                    await(Async.sleep(0.5))
                    --print("Waiting")
                end
                return dialogue.custom_properties["Next 1"]
            end           
        end)
    end
}
eznpcs.add_event(free_prog)



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

local btl_pass_count = {
    name = "Battle Pass Count",
    action = function(npc, player_id, dialogue, relay_object)

        return async(function()

            local count = tostring(ezmemory.count_player_item(player_id, "Btl_Pass"))
            print(count)
            local message = "Btl_Pass count: "

            await(Async.message_player(player_id, "Btl_Pass count: " .. count .. "", Blank, Blank))
            --Move to the next dialogue if there is one
            if dialogue.custom_properties["Next 1"] == nil then
                return
            else
                return dialogue.custom_properties["Next 1"]
            end
        end)
    end
}
eznpcs.add_event(btl_pass_count)

local heal = {
    name = "heal",
    action = function(npc, player_id, dialogue, relay_object)

        return async(function()

            --heal player
            local max_hp = Net.get_player_max_health(player_id)
            print(max_hp)
            Net.set_player_health(player_id,max_hp)
            Net.play_sound_for_player(player_id, '/server/assets/ezlibs-assets/sfx/recover.ogg')

            if dialogue.custom_properties["Next 1"] == nil then
                return
            else
                return dialogue.custom_properties["Next 1"]
            end
        end)
    end
}
eznpcs.add_event(heal)

local virus_traders = {
    name = "virus traders",
    action = function(npc, player_id, dialogue, relay_object)

        return async(function()
            --virus traders cutscene
            local area_id = Net.get_player_area(player_id)
            local stats = await(ezencounters.begin_encounter(player_id, virustraders, nil))
            local flags = _encounter_result_flags(stats)
            local quest_name = ezquests.get_quest("Virus Traders")
            local event_value = 'beat'
            local player_mugshot = Net.get_player_mugshot(player_id)

            if flags.ran or flags.lost then
                Net.transfer_player(player_id, "Transport", true, 24, 6, 2, "Down")
                return
            else               
                if dialogue.custom_properties["Debug"] then
                    hide = ezmemory.hide_object_from_player_till_disconnect
                    event_value = 'reset'
                else
                    hide = ezmemory.hide_object_from_player
                end         
            --hide crates 3,4,5,6,7,8 and the NPC
                hide(player_id, area_id, 3)
                hide(player_id, area_id, 4)
                hide(player_id, area_id, 5)
                hide(player_id, area_id, 6)
                hide(player_id, area_id, 7)
                hide(player_id, area_id, 8)
                Net.exclude_actor_for_player(player_id, npc.bot_id)
            --checks for battle to exit to explode red crate 
                   
                    Net:on("battle_exit", function(event)
        
                            if ezmemory.object_is_hidden_from_player(player_id, area_id, 10) == false then 
                                Net.lock_player_input(player_id)                   
                                ezexplosions.explode(10, area_id, 5)
                                Async.sleep(0.5).and_then(function()
                                    hide(player_id, area_id, 10)
                                end)                     
                            end

                    end)
                

                while ezmemory.object_is_hidden_from_player(player_id, area_id, 10) == false do
                    --print("Waiting for crate to be gone")
                    await(Async.sleep(0.5))
                end
                await(Async.message_player(player_id, "Looks like he got away...", player_mugshot.texture_path, player_mugshot.animation_path))
                await(Async.message_player(player_id, "Huh? The goods! They're all gone... where did...", "/server/assets/ezlibs-assets/eznpcs/mug/punk-navi-exe6_navy.png", "/server/assets/ezlibs-assets/eznpcs/mug/mug.animation"))

                await(Async.sleep(0.5))
            --security interaction
            local securityOne = Net.get_object_by_id(area_id, 49)
            local securityTwo = Net.get_object_by_id(area_id, 50)
            
            --securityOne
            create_bot_from_object(area_id, securityOne, player_id)
            Net.play_sound_for_player(player_id, '/server/assets/teleport.ogg')
            await(Async.sleep(0.2))

            --securityTwo
            create_bot_from_object(area_id, securityTwo, player_id)
            Net.play_sound_for_player(player_id, '/server/assets/teleport.ogg')
            await(Async.sleep(0.5))

            --dialogue
            Net.message_player(player_id, "Don't move! You are under arrest for illegal virus trading.", "/server/assets/ezlibs-assets/eznpcs/mug/GMNavi.png", "/server/assets/ezlibs-assets/eznpcs/mug/mug.animation")           
            Net.message_player(player_id, "This isn't fair! I swear we're just hired hands. We didn't know what was in the crates!", "/server/assets/ezlibs-assets/eznpcs/mug/punk-navi-exe6_navy.png", "/server/assets/ezlibs-assets/eznpcs/mug/mug.animation")
            Net.message_player(player_id, "We've been tailing you and your buddies for a while. We were just waiting for one of you to pull something.", "/server/assets/ezlibs-assets/eznpcs/mug/GMNavi.png", "/server/assets/ezlibs-assets/eznpcs/mug/mug.animation")     
            Net.message_player(player_id, "We're sorry we ended up getting a member of the public involved in this.", "/server/assets/ezlibs-assets/eznpcs/mug/GMNavi.png", "/server/assets/ezlibs-assets/eznpcs/mug/mug.animation")
            Net.message_player(player_id, "I'm just glad you didn't assume I was with them.", player_mugshot.texture_path, player_mugshot.animation_path)
                
            --update quest            
            ezquests.quest_event(player_id,quest_name.name,event_value)           
            Net.unlock_player_input(player_id)

            --remove quest door in Transport2
            ezmemory.hide_object_from_player(player_id, "Transport2", 48)   
            end
        end)
    end
}
eznpcs.add_event(virus_traders)

local virus_traders_2 = {
    name = "virus traders 2",
    action = function(npc, player_id, dialogue, relay_object)

        return async(function()
            --local variables
            local area_id = Net.get_player_area(player_id)
            local color = {r=144,g=80,b=240,a=255}
            local color2 = {r=144,g=80,b=240,a=0}
            local colorex = {r=255,g=216,b=44,a=200}
            local colorex2 = {r=255,g=216,b=44,a=0}
            local marker = Net.get_object_by_id(area_id,84)
            local player_mugshot = Net.get_player_mugshot(player_id)
            local texture = "/server/assets/ezlibs-assets/ezwarps/logout.png"
            local animation = "/server/assets/ezlibs-assets/ezwarps/logout.animation"
            local state = "JACK_OUT"
            local sound = '/server/assets/ezlibs-assets/ezwarps/log_out.ogg'
            local offsetx = 0.2
            local offsety = 0.2
            local warp_in_effect_id = "warp_in_effect_"..npc.bot_id
            local circusmanpng = "/server/assets/ezlibs-assets/eznpcs/sheet/circusman.png"
            local circusmananimation = "/server/assets/ezlibs-assets/eznpcs/sheet/circusman.animation"
            local quest_name = ezquests.get_quest("Virus Traders")
            local event_value = 'circusman'
            --preload assets
            
            Net.provide_asset(area_id, "/server/assets/ezlibs-assets/ezwarps/logout.png")
            Net.provide_asset(area_id, "/server/assets/ezlibs-assets/ezwarps/logout.animation")
            Net.provide_asset(area_id,"/server/assets/ezlibs-assets/eznpcs/sheet/circusman.png")
            Net.provide_asset(area_id,"/server/assets/ezlibs-assets/eznpcs/sheet/circusman.animation")

            --fade out
            Net.lock_player_input(player_id)
            Net.fade_player_camera(player_id, color, 0.5)
            await(Async.sleep(0.6))
            --move player
            Net.teleport_player(player_id, false, marker.x, marker.y, marker.z, "Up Right")
            --fade in
            Net.fade_player_camera(player_id, color2, 0.5)
            await(Async.sleep(0.6))
            --then talk
            Net.message_player(player_id, "Seems you caught up to me.", "/server/assets/ezlibs-assets/eznpcs/mug/punk-navi-exe6_red.png", "/server/assets/ezlibs-assets/eznpcs/mug/mug.animation")
            Net.message_player(player_id, "Even cleared the bugfrag barriers.", "/server/assets/ezlibs-assets/eznpcs/mug/punk-navi-exe6_red.png", "/server/assets/ezlibs-assets/eznpcs/mug/mug.animation")
            await(Async.message_player(player_id, "In that case I'll drop the act, Ahoo, hoo, hoo!! And deal with you myself!", "/server/assets/ezlibs-assets/eznpcs/mug/punk-navi-exe6_red.png", "/server/assets/ezlibs-assets/eznpcs/mug/mug.animation"))                                                           
            
            --hide npc and then change them to circusman                                           
            Net.exclude_actor_for_player(player_id, npc.bot_id)
            Net.set_bot_avatar(npc.bot_id, circusmanpng, circusmananimation)
            --created bot for animation
            Net.create_bot(warp_in_effect_id, {
                warp_in = false,
                texture_path = texture,
                animation_path = animation,
                area_id = area_id,
                x = npc.x + offsetx,
                y = npc.y + offsety,
                z = npc.z
            })
            
            --play animation and sound
            Net.animate_bot(warp_in_effect_id, state, false)
            Net.play_sound_for_player(player_id, sound)

            --sleep so that animation plays before bot is removed                 
            await(Async.sleep(0.7))
            --reveal actor and remove bot for animation
            Net.include_actor_for_player(player_id, npc.bot_id)
            Net.remove_bot(warp_in_effect_id)           
            --try to animate bot NOT WORKING                
            Net.animate_bot(npc.bot_id, "WALK_DL", false)
                                                                   
            --end)
           
            --continue dialogue
            await(Async.message_player(player_id, "Ahoo, hoo, hoo!!", "/server/assets/ezlibs-assets/eznpcs/mug/circusman.png", "/server/assets/ezlibs-assets/eznpcs/mug/circusmanmug.animation"))         
            Net.animate_bot(npc.bot_id, "IDLE_DL", false)
            --trigger encounter --This breaks the NPC
            local stats = await(ezencounters.begin_encounter(player_id, circusman, nil))
                
            local flags = _encounter_result_flags(stats)
            
                
            if flags.ran or flags.lost then
                --Net.transfer_player(player_id, "Transport", true, 24, 6, 2, "Down")
                return
            else       
                --explode with dialogue
                Net:on("battle_exit", function(event)
                
                    if ezquests.get_player_quest_state(event.player_id, "Virus Traders") ~= 'circusman' then                    
                        --explode
                        boom = ezexplosions.explode(npc.bot_id, area_id, nil)
                        

                    end
                end)
                Net.message_player(player_id, "Ahoo, hoo, hoo!!", "/server/assets/ezlibs-assets/eznpcs/mug/circusman.png", "/server/assets/ezlibs-assets/eznpcs/mug/circusmanmug.animation")         
                await(Async.message_player(player_id, "This was only one store house of the viruses I collected... this isn't over...", "/server/assets/ezlibs-assets/eznpcs/mug/circusman.png", "/server/assets/ezlibs-assets/eznpcs/mug/circusmanmug.animation"))                 
                --fade out with red and increase explosions
                Net.fade_player_camera(player_id, colorex, 0.5)
                ezexplosions.explode(npc.bot_id, area_id, 8)
                ezexplosions.explode(npc.bot_id, area_id, 6)
                ezexplosions.explode(npc.bot_id, area_id, 4)
                await(Async.sleep(0.5))
                Net.fade_player_camera(player_id, colorex2, 0.2)
                --remove npc and the infinate booms set quest flag
                Net.exclude_actor_for_player(player_id, npc.bot_id)
                boom.stopped = true
                ezquests.quest_event(player_id,quest_name.name,event_value)
                Net.unlock_player_input(player_id)
                
            end            
        end)       
    end
}
eznpcs.add_event(virus_traders_2)

local virus_crate = {
    name = "virus crate",
    action = function(npc, player_id, dialogue, relay_object)
        
        return async(function()
            local area_id = Net.get_player_area(player_id)
            local virus = virustraders
            --pick at random
            math.randomseed(os.time())
            local rand = math.random(1,4)
            

            local function rand_encounter()
                if rand == 1 then
                    --print(rand)
                    return virustraders
                elseif rand == 2 then
                    --print(rand)
                    return virustraders2
                elseif rand == 3 then
                    --print(rand)
                    return virustraders3
                elseif rand == 4 then
                    --print(rand)
                    return virustraders4
                else
                    return virustraders3
                end
            end
          
            local stats = await(ezencounters.begin_encounter(player_id, rand_encounter(), nil))
            local flags = _encounter_result_flags(stats)
            local waiting = true
            if flags.ran or flags.lost then
                --Net.transfer_player(player_id, "Transport", true, 24, 6, 2, "Down")
                return
            else
                Net:on("battle_exit", function(event)  
                    if ezmemory.object_is_hidden_from_player(player_id, area_id, relay_object.id) == false then               
                        --print("Prog battle over.")
                        waiting = false
                        
                    end
                end)
                while waiting == true do
                    await(Async.sleep(0.5))
                        --print("Waiting")
                end
                --Move to the next dialogue if there is one
                if dialogue.custom_properties["Next 1"] == nil then
                    return
                else
                    return dialogue.custom_properties["Next 1"]
                end
            end
        end)
    end
}
eznpcs.add_event(virus_crate)

local test = {
    name = "test",
    action = function(npc, player_id, dialogue, relay_object)

        return async(function()

            math.randomseed(os.time())
            local rand = math.random(1,4)
            

            local function rand_encounter()
                if rand == 1 then
                    --print(rand)
                    return virustraders
                elseif rand == 2 then
                    --print(rand)
                    return virustraders2
                elseif rand == 3 then
                    --print(rand)
                    return virustraders3
                elseif rand == 4 then
                    --print(rand)
                    return virustraders4
                else
                    return virustraders3
                end
            end
          
            local stats = await(ezencounters.begin_encounter(player_id, rand_encounter(), nil))

            return          
        end)
    end
}
eznpcs.add_event(test)