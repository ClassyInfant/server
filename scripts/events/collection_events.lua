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
     local start = "/server/assets/sfx/StartGun.ogg"
     ezmemory.remove_player_item(player_id, "Candy", treats)
     games.spawn_timer("mazetimer", player_id, 90, 3, 1000, false)
     Net.play_sound_for_player(player_id, start)

end

function trickortreat(player_id,object_id,area_id)
    local treats = ezmemory.count_player_item(player_id, "Candy")
    local marker = Net.get_object_by_id(area_id,366)
    local rank = nil
    local improved = false
    local score = 0
    local bonus = 0
    local pen = 0
    local whistle = "/server/assets/sfx/WhistleStop.ogg"
    local item_get = "/server/assets/ezlibs-assets/sfx/item_get.ogg"
    
    --sound end
    Net.play_sound_for_player(player_id, whistle)

    --calcualte score with time bonus and penatlies
    local function calcscore(treats, time)
        timenorm = math.floor(time)
        --print(timenorm)
        local bonus = (treats * 10) / timenorm 
        local score = math.floor(bonus + treats)
        --print(score)
        if timenorm >= 300 then
            pen = math.floor(timenorm / 8)
        end

        local score = score - pen  
        --print(score)
        return score
    end

    --move player out of maze and stop timer, grab timer stop time
    Net.teleport_player(player_id, true, marker.x, marker.y, marker.z, "Up Right") 
    local time = games.pause_timer("mazetimer", player_id)
    --print(time.current)
    score = calcscore(treats, time.current)
    local rank, improved = await(candymaze.checkrecords(player_id, score, area_id))
    
    --reward
    local reward = score * 10
    await(Async.message_player(player_id, "Score: "..score.."   Monies: "..reward))
    ezmemory.spend_player_money(player_id, -reward)

    --check if score is improved or if newly on leaderboard
    if improved == true then
        --print(improved)
        local msg = "New Personal Record!"
    

        if rank and rank <= 10 then
            --print(rank) 
            local msg = msg..("New leaderboard %d!"):format(rank)   
        end
        
        
        await(Async.sleep(0.05))
        Net.play_sound_for_player(player_id, item_get)
        await(Async.message_player(player_id, msg))
    end

    --reset game state
    ezmemory.remove_player_item(player_id, "Candy", treats)
    games.remove_timer("mazetimer", player_id)
    
    local count = 1
    while count <= 373 do
        ezmemory.unhide_object_from_player_till_disconnect(player_id, area_id, count)
        count = count + 1
    end
    
    
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
