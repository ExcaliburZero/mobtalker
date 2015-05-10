mobtalker = {}
mobtalker.datadir = minetest.get_worldpath().."/mobtalker"
dofile(minetest.get_modpath("mobtalker").."/api.lua")
dofile(minetest.get_modpath("mobtalker").."/item.lua")
if minetest.get_modpath("creeper") then
	dofile(minetest.get_modpath("mobtalker").."/creeper.lua")
end
if minetest.get_modpath("mobs") then
	--dofile(minetest.get_modpath("mobtalker").."/dm.lua")
end
mobtalker_mkdir()
