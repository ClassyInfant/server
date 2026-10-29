local ezmemory = require('scripts/ezlibs-scripts/ezmemory')
local eztriggers = require('scripts/ezlibs-scripts/eztriggers')
local object_registry = require('scripts/ezlibs-scripts/object_registry')
local eznpcs = require('scripts/ezlibs-scripts/eznpcs/eznpcs')
local events = require('scripts/events/collection_events')
local helpers = require('scripts/ezlibs-scripts/helpers')


local function on_radius_item_triggered(event)
    return async(function ()
        --print('[collection] item touched ',event.object.custom_properties)
        local player_area = Net.get_player_area(event.player_id)
        local is_hidden_already = ezmemory.object_is_hidden_from_player(event.player_id,player_area,event.object.id)
        if is_hidden_already then
            return
        else         
            --Run function in collection_events 
            local script = event.object.custom_properties["Event"]
            if script then
              print(event.player_id,script,event.object.id,player_area)
              events.load_event(event.player_id,script,event.object.id,player_area)
            end

            --Give the player an item - obj
            local item = event.object.custom_properties["Item"]
            
            if item then
              --print("Give item")
              local notify_player = event.object.custom_properties["Dont Notify"] ~= "true"
              ezmemory.give_item_with_optional_notify(event.player_id,player_area,item,nil,notify_player)
            end

            --Play this sound/sounds on trigger - string
            local sound1 = event.object.custom_properties["Sound 1"]
            local sound2 = event.object.custom_properties["Sound 2"]
            local sound3 = event.object.custom_properties["Sound 3"]
            local sound4 = event.object.custom_properties["Sound 4"]
            local sfx = event.object.custom_properties["Sound"]
            if sound1 then
                --select random audio file from base name
                math.randomseed(os.time())
                local rand = math.random(1,4)
                local function randsfx()
                    if rand == 1 then
                        --print(rand)
                        return sound1
                    elseif rand == 2 then
                        --print(rand)
                        return sound2
                    elseif rand == 3 then
                        --print(rand)
                        return sound3
                    elseif rand == 4 then
                        --print(rand)
                        return sound4
                    else
                        return sound4
                    end
                end
            
                Net.play_sound_for_player(event.player_id, randsfx())           

            elseif sfx then
                Net.play_sound_for_player(event.player_id, sfx)
            end

            --Remove permanently - bool
            if event.object.custom_properties["Once"] == "true" then
                ezmemory.hide_object_from_player(event.player_id,player_area,event.object.id)
            end
        end
        
        ezmemory.hide_object_from_player_till_disconnect(event.player_id,player_area,event.object.id)
    end)
end

-- Register handler for Radius item objects
object_registry.register_handler("Radius Item", function(area_id, object)
    local radius = tonumber(object.custom_properties["Radius"] or 1)
    local emitter = eztriggers.add_radius_trigger(area_id, object, radius, radius, 0, 0)
    emitter:on('entered', function(event)
        return on_radius_item_triggered(event)
    end)
end,false)

return collection
