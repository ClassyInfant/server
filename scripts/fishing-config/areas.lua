-- /server/scripts/fishing-config/areas.lua

local E = require('scripts/fishing-config/encounters')
local helpers = require('scripts/ezlibs-scripts/helpers')

local function with_weight(enc, w)
  local x = helpers.deep_copy(enc)
  x.weight = w
  return x
end



return {
  SeaBBS = {
    CONSTANTS = {
      LEADERBOARD           = {
        ENABLED  = true,
        MEM_AREA = "SeaBBS",
        KEY      = "fish_top10_v4",
        MAX      = 10,
        UNIQUE_PER = "secret",
      },
      VIRUS_CHANCE           = 0.001,
      VIRUS_EXCLUDED          = {
        light = true,
        medium = true,
        heavy      = true,
        very_heavy = true,
        brutal     = false,
        legendary  = false,
      },
      FISH_REWARD_PER_LB = 10,
    },
    FISHING_VIRUS = {
      E.encounter1,
    },
   
  }
--  fisharea = {
--    CONSTANTS = {
--      LEADERBOARD           = {
--        ENABLED  = true,
--        MEM_AREA = "fisharea",
--        KEY      = "fish_top10_v4",
--        MAX      = 10,
--        UNIQUE_PER = "secret",
--      },
--    },
--    FISHING_VIRUS = {
--      E.encounter1,
--      E.encounter2,
--      E.encounter3,
--    },
--  },
--  rink = {
--    CONSTANTS = {
--      LEADERBOARD           = {
--        ENABLED  = true,
--        MEM_AREA = "rink",
--        KEY      = "rink_top5",
--        MAX      = 5,
--        UNIQUE_PER = "secret",
--      },
--      VIRUS_CHANCE           = 0.28,
--      ASSET_NORMAL_DIR       = "icy-normal/",
--      ASSET_SWEET_DIR        = "icy-sweet/",
--      EXPECTED_METER_SIZE    = {w = 24, h = 93},
--      METER_SCREEN_SHIFT     = { x = 1.75, y = 0.0, z = 0.0 },
--      WINDOW_S              = {
--        light = 0.95,
--        medium = 0.85,
--        heavy = 0.75,
--        very_heavy = 0.55,
--        brutal = 0.45,
--        legendary = 0.35,
--      },
--      HEAVINESS              = {
          --  key            decay/s   mashGain  hold_mult
--        { key = "light",      decay = 1.2, mash = 1.20, hold_mult = 0.85 },
--        { key = "medium",     decay = 1.8, mash = 1.00, hold_mult = 0.90 },
--        { key = "heavy",      decay = 2.5, mash = 0.90, hold_mult = 1.00 },
--        -- Harder tiers
--        { key = "very_heavy", decay = 3.6, mash = 0.85, hold_mult = 1.05 },
--        { key = "brutal",     decay = 4.8, mash = 0.80, hold_mult = 1.10 },
--        { key = "legendary",  decay = 5.4, mash = 0.75, hold_mult = 1.20 },
--      },
--      WEIGHT_RANGES_LB = {
--        light      = { 2.0, 4.0 },
--        medium     = { 4.0, 8.0 },
--        heavy      = { 8.0, 13.0 },
--        very_heavy = { 13.0, 19.0 },
--        brutal     = { 19.0, 26.0 },
--        legendary  = { 26.0, 41.0 },
--      },
--      VIRUS_EXCLUDED          = {
--        heavy      = true,
--        very_heavy = true,
--        brutal     = true,
--        legendary  = true,
--      },
--      HEAVINESS_CHANCES = {
--        light      = 20,
--        medium     = 20,
--        heavy      = 20,
--        very_heavy = 15,
--        brutal     = 15,
--        legendary  = 10,
--      },
--      BITE_WAIT_RANGE        = { min = 7, max = 12.0 },
--      BAIT = {
--        VIRUS_CHANCE = 0.08,
--        HEAVINESS_CHANCES = {
--          light      = 15,
--          medium     = 15,
--          heavy      = 15,
--          very_heavy = 20,
--          brutal     = 20,
--          legendary  = 15,
--        },
--      },
--    },
--    FISHING_VIRUS = {
--      with_weight(E.encounter4, 1),
--      with_weight(E.encounter5, 20),
--      with_weight(E.encounter6, 1),
--      with_weight(E.encounter7, 20),
--    },
--  },
}