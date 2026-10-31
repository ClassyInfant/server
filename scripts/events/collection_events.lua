local eznpcs = require('scripts/ezlibs-scripts/eznpcs/eznpcs')
local ezmemory = require('scripts/ezlibs-scripts/ezmemory')
local ezencounters = require('scripts/ezlibs-scripts/ezencounters/main')
local ezwarps = require('scripts/ezlibs-scripts/ezwarps/main')
local helpers = require('scripts/ezlibs-scripts/helpers')
local ezbus = require('scripts/ezlibs-scripts/ezbus')
local ezexplosions = require('scripts/ezlibs-scripts/ezexplosions')
local ezquests = require('scripts/ezlibs-scripts/ezquests')
local candymaze = require('scripts/ezlibs-custom/candymaze')
local games = require("scripts/net-games/main")

function await(v) return Async.await(v) end

collection_events = {}

--add events here with the same format as test()


function mazetimer(player_id,object_id,area_id)
    local treats = ezmemory.count_player_item(player_id, "Candy")
    ezmemory.remove_player_item(player_id, "Candy", treats)
    games.spawn_timer("mazetimer", player_id, 10, 10, 1000, false)

end

function trickortreat(player_id,object_id,area_id)
    local treats = ezmemory.count_player_item(player_id, "Candy")
    local recordsfx = "/server/assets/ezlibs-assets/sfx/item_get.ogg"
    --local marker = Net.get_object_by_id(area_id,366)
    local rank = nil
    local improved = false
    local score = 0
    --local timer = mazetimer(player_id, object_id, area_id)
    

    --Net.teleport_player(player_id, true, marker.x, marker.y, marker.z, "Up Right") 
    local time = games.pause_timer("mazetimer", player_id)
    print(time.current)
    local rank, improved = await(candymaze.checkrecords(player_id, treats, area_id))
    if improved == true then
        print(improved)
        local msg = "New Personal Record!"
    

        if rank and rank <= 10 then
            print(rank) 
            local msg = msg..(" New leaderboard %d!"):format(rank)
            await(Async.sleep(0.05))
        end

        Net.play_sound_for_player(player_id, recordsfx)
        await(Async.message_player(player_id, msg))
    end

    ezmemory.remove_player_item(player_id, "Candy", treats)
    
    
    
end

function test(player_id,object_id,area_id)
    print("Success")
end

function explode(player_id,object_id,area_id)
    ezexplosions.explode(object_id.id, area_id, 3)
end

function collection_events.load_event(player_id,event_name,object_id,area_id)
    assert(load('return '..event_name..'(...)'))(player_id,object_id,area_id)
end

return collection_events
