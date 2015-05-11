-- Register mobtalker tool
minetest.register_tool("mobtalker:mobtalker", {
	description = "Mob Talker",
	inventory_image = "mobtalker.png",
})
-- Register crafting recipe for mobtalker tool
minetest.register_craft({
	output = 'mobtalker:mobtalker',
	recipe = {
		{'default:meselamp'},
		{'group:stick'},
	}
})
