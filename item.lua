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
