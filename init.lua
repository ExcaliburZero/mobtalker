mobtalker = {}

minetest.register_tool("mobtalker:mobtalker", {
	description = "Mob Talker",
	inventory_image = "mobtalker.png",
})
minetest.register_craft({
	output = 'mobtalker:mobtalker',
	recipe = {
		{'default:meselamp'},
		{'group:stick'},
	}
})
if minetest.get_modpath("creeper") then
	dofile(minetest.get_modpath("mobtalker").."/creeper.lua")
end
if minetest.get_modpath("mobs") then
	dofile(minetest.get_modpath("mobtalker").."/mobs.lua")
end
