local helpers      = require('scripts/ezlibs-scripts/helpers')
local ezmemory     = require('scripts/ezlibs-scripts/ezmemory')
local candymaze = {}
local MAZE = {
 -- Leaderboard persistence (stored under this area)
  LEADERBOARD            = {
    MEM_AREA = "Event", -- << your MAZE zone
    KEY      = "maze_top10_v4",
    MAX      = 10,
    UNIQUE_PER = "secret",  -- or "name" if you prefer name-based uniqueness
  },
}



-- ====================== Leaderboard helpers ======================
local function _lb_bucket()
  local area = (MAZE.LEADERBOARD and MAZE.LEADERBOARD.MEM_AREA) or "Event"
  local key  = (MAZE.LEADERBOARD and MAZE.LEADERBOARD.KEY) or "maze_top10_v4"
  local mem  = ezmemory.get_area_memory(area) or {}
  mem[key]   = mem[key] or {}
  return mem, mem[key], area, key
end

-- Insert a catch, sort desc by weight, trim to MAX. Returns rank (1-based) if in top MAX.
local function _record_catch(pid, weight_lb)
  if not weight_lb then return nil end
  local name = nil
  pcall(function() name = Net.get_player_name(pid) end)
  name = name or tostring(pid)

  local mem, list, area = _lb_bucket()
  local rec = { weight = tonumber(weight_lb) or 0, player_name = tostring(name), pid = tostring(pid), ts = os.time() }
  table.insert(list, rec)
  table.sort(list, function(a, b) return (a.weight or 0) > (b.weight or 0) end)
  local maxn = (MAZE.LEADERBOARD and MAZE.LEADERBOARD.MAX) or 10
  while #list > maxn do table.remove(list) end

  local rank = nil
  for i, r in ipairs(list) do
    if r == rec then
      rank = i; break
    end
  end
  ezmemory.save_area_memory(area)
  return rank
end

function candymaze.pass_stats(player_id, points)
  _record_catch(player_id, points)
end


-- ===== Leaderboard: one-entry-per-player helpers =====
local function _lb_cfg(area_id)
  local C = _C_for and _C_for(area_id) or nil
  local L = (C and C.LEADERBOARD) or MAZE.LEADERBOARD or {}
  local mem_area = L.MEM_AREA or L.mem_area or "Event"
  local key      = L.KEY or L.key or "maze_top10_v4"
  local max      = L.MAX or (MAZE.LEADERBOARD and MAZE.LEADERBOARD.MAX) or 10
  local uniq_by  = L.UNIQUE_PER or L.unique_per
                or (MAZE.LEADERBOARD and MAZE.LEADERBOARD.UNIQUE_PER)
                or "player_id"
  return mem_area, key, max, uniq_by
end

local function _lb_load(area_id)
  local area, key = _lb_cfg(area_id)
  local mem  = ezmemory.get_area_memory(area) or {}
  local list = mem[key]
  if type(list) ~= "table" then list = {} end
  return area, key, mem, list
end

local function _lb_top10(area_id)
  local _, _, _, list = _lb_load(area_id)
  return list
end

local function _lb_save(area, key, mem, list)
  mem[key] = list
  ezmemory.save_area_memory(area)
end
local function _lb_upsert(pid, weight_lb, area_id)

  local name = Net.get_player_name(pid) or pid
  local area, key, mem, list = _lb_load(area_id)
  local _, _, max, uniq_by    = _lb_cfg(area_id)

  local secret = nil
  if uniq_by == "secret" and helpers.get_safe_player_secret then
    pcall(function() secret = helpers.get_safe_player_secret(pid) end)
  end
  local k_new = (uniq_by == "name") and tostring(name)
            or (uniq_by == "secret") and tostring(secret or pid)
            or tostring(pid)

  -- find existing
  local idx = nil
  for i, e in ipairs(list) do
    local row_pid    = tostring(e.player_id or e.pid or "")
    local row_name   = tostring(e.name or e.player_name or "")
    local row_secret = tostring(e.player_secret or e.secret or e.sid or "")
    local k_row = (uniq_by == "name") and row_name
              or (uniq_by == "secret") and row_secret
              or row_pid
    if k_row == k_new then idx = i; break end
  end

  local improved = false
  if idx then
    if weight_lb > (tonumber(list[idx].weight) or 0) then
      list[idx].weight       = weight_lb
      list[idx].name         = name
      list[idx].player_name  = name
      list[idx].player_id    = pid
      list[idx].player_secret= secret   -- NEW
      list[idx].when         = os.time()
      improved = true
    end
  else
    table.insert(list, {
      player_id     = pid,
      player_secret = secret,           -- NEW
      name          = name,
      player_name   = name,
      weight        = weight_lb,
      when          = os.time()
    })
    improved = true
  end

  table.sort(list, function(a,b) return (a.weight or 0) > (b.weight or 0) end)
  while #list > max do list[#list] = nil end

  mem[key] = list
  ezmemory.save_area_memory(area)

  local rank = nil
  for i, e in ipairs(list) do
    local k_row = (uniq_by == "name") and tostring(e.name or e.player_name or "")
              or (uniq_by == "secret") and tostring(e.player_secret or e.secret or e.sid or "")
              or tostring(e.player_id or e.pid or "")
    if k_row == k_new then rank = i; break end
  end

  return rank, improved
end

function candymaze.checkrecords(player_id, treats, area_id)
  return async(function ()
    local rank, improved = _lb_upsert(player_id, treats, area_id)
    return rank, improved
  end)
end
-- ====================== MazeBBS (Top 10 board) ======================
local MAZEBBS = {
  TITLE = "Candy Maze - Top 10",
  COLOR = { r = 90, g = 35, b = 90 },
}

local function _trunc(s, n)
  s = tostring(s or "")
  if #s <= n then return s end
  return s:sub(1, n)
end

local function _open_mazebbs(pid)
  local aid  = Net.get_player_area(pid)
  local list = _lb_top10(aid) or {}
  local _, _, LBmax = _lb_cfg(aid)
  local posts = {}

  if #list == 0 then
    posts[#posts + 1] = { id = '__mazebbs:none', read = true, title = 'No runs yet.', author = '' }
  else
    local MAX_NAME = 20
    for i, rec in ipairs(list) do
      local nm = _trunc(tostring(rec.name or rec.player_name or "Unknown"), MAX_NAME)
      local wt = tonumber(rec.weight or 0) or 0
      posts[#posts + 1] = {
        id     = '__mazebbs:post:' .. i,
        read   = true,
        title  = string.format('%2d  %s', i, nm),
        author = string.format('%.1f pts', wt),
      }
      if i >= LBmax then break end  -- was hardcoded 10
    end
  end

  Net.open_board(pid, MAZEBBS.TITLE, MAZEBBS.COLOR, posts)
end

-- Handle clicks on MazeBBS
Net:on("bbs_post_selection", function(ev)
  local pid = ev.player_id; if not pid then return end
  local id = tostring(ev.post_id or '')
  if id:match('^__mazebbs:') then
    -- read-only; nothing else to do
  end
end)

Net:on("object_interaction", function(ev)
  if ev.button ~= 0 then return end -- A only
  local pid = ev.player_id
  local area_id = Net.get_player_area(pid)

  -- Which object was clicked
  local obj = Net.get_object_by_id(area_id, ev.object_id)
  if obj then
    local cls = tostring(obj.class or '')
    local typ = tostring(obj.type or '')
    -- Open MazeBBS if this is a board
    if cls == 'MazeBBS' or typ == 'MazeBBS' then
      _open_mazebbs(pid)
      return
    end
  end
end)

return candymaze