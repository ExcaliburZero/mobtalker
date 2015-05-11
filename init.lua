mobtalker = {}
mobtalker.datadir = minetest.get_worldpath().."/mobtalker"

-- Run API
dofile(minetest.get_modpath("mobtalker").."/api.lua")

-- Run item registration
dofile(minetest.get_modpath("mobtalker").."/item.lua")

-- If the creeper mod is intalled, then run the creeper file
if minetest.get_modpath("creeper") then
    dofile(minetest.get_modpath("mobtalker").."/creeper.lua")
end
-- If the simple mobs mod is installed, then run the dungeon master file
-- (beta)
if minetest.get_modpath("mobs") then
    --dofile(minetest.get_modpath("mobtalker").."/dm.lua")
end

-- Make a directory for modtalker, or read it if it already exists
mobtalker_mkdir()
