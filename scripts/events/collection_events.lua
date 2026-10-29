local eznpcs = require('scripts/ezlibs-scripts/eznpcs/eznpcs')
local ezmemory = require('scripts/ezlibs-scripts/ezmemory')
local ezencounters = require('scripts/ezlibs-scripts/ezencounters/main')
local ezwarps = require('scripts/ezlibs-scripts/ezwarps/main')
local helpers = require('scripts/ezlibs-scripts/helpers')
local ezbus = require('scripts/ezlibs-scripts/ezbus')
local ezexplosions = require('scripts/ezlibs-scripts/ezexplosions')
local ezquests = require('scripts/ezlibs-scripts/ezquests')

function await(v) return Async.await(v) end

collection_events = {}

--add events here with the same format as test()

function test(player_id,object_id,area_id)
    print("Success")
end

function explode(player_id,object_id,area_id)
    ezexplosions.explode(object_id, area_id, 3)
end

function collection_events.load_event(player_id,event_name,object_id,area_id)
    assert(load('return '..event_name..'(...)'))(player_id,object_id,area_id)
end

return collection_events
