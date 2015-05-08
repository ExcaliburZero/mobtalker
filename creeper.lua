local id = 1
while true do
	local file = io.open(minetest.get_modpath("mobtalker").."/creeper/"..id..".script")
	if (not file) then break end
	file:close()
	dofile(minetest.get_modpath("mobtalker").."/creeper/"..id..".script")
	id = id +1
end

-- intllib
local S
if minetest.get_modpath("intllib") then
	S = intllib.Getter()
else
	S = function(s) return s end
end

--[[
-- Save
local function save()
	local output = io.open(minetest.get_worldpath() .. "/mobtalker", "w")
	for _,p in ipairs(minetest.get_connected_players()) do
		output:write(creeper_love[p:get_player_name()]..p:get_player_name().."\n")
	end
	io.close(output)
end

-- Load
local function load()
	local input = io.open(minetest.get_worldpath().."/mobtalker", "r")
	if input then
		repeat
			local love = input:read("*n")
			if love == nil then
				break
			end
			local name = input:read("*l")
			creeper_love[name:sub(2)] = love
		until input:read(0) == nil
		io.close(input)
		load()
	else
		creeper_love = {}
	end
end
]]--
-- Return Formspec
function mobtalker_creeper_talk(player,love,Q)
	if love == 0 and Q == 1 then
		return "size[5,3;true]"..
			"label[0,0;"..SET_NAME.."\n"..S("Hey! Who are you?").."]"..
			"button_exit[0,1.2;4.8,0.5;creeper_choose1;"..S("My name is %s."):format(player:get_player_name()).."]"..
			"button_exit[0,2;4.8,0.5;creeper_choose2;"..S("Your death!").."]"
	elseif love > 0 and Q == 1 then
		return "size[5,2;true]"..
			"label[0,0;"..S("Hmm?").."]"..
			"button_exit[0,1.4;4.8,0.5;creeper_bye;"..S("See you!").."]"
	elseif love < 0 and Q == 1 then
		return "size[5,2;true]"..
			"label[0,0;"..S("Die!").."]"..
			"button_exit[0,1.4;4.8,0.5;;"..S("F**k").."]"
	elseif Q == "bye" then
		return "size[5,2;true]"..
			"label[0,0;"..S("Thanks!").."]"..
			"button_exit[0,1.4;4.8,0.5;creeper_bye;"..S("See you!").."]"
	elseif Q == "fuck" then
		return "size[5,2;true]"..
			"label[0,0;"..S("Yeah I don't like you either.").."]"..
			"button_exit[0,1.4;4.8,0.5;creeper_boom;"..S("F**k").."]"
	end
end

function mobtalker_creeper_image(love,Q)
	if love == 0 and Q == 1 then
		return "creeper_normal.png"
	elseif love > 0 and Q == 1 then
		return "creeper_happy.png"
	elseif love < 0 and Q == 1 then
		return "creeper_angry.png"
	else
		return "creeper_normal.png"
	end
end

-- Function
function mobtalker_creeper(self,clicker)
	self.object:setvelocity({x=0,y=0,z=0})
	creeper_talk[self] = true
	creeper_talking[clicker:get_player_name()] = true
	minetest.show_formspec(clicker:get_player_name(),"creeper:talk",mobtalker_creeper_talk(clicker,creeper_love[clicker:get_player_name()],1))
	creeper_hud = clicker:hud_add({
		hud_elem_type = "image",
		position = {x=0.52, y=0.6},
		offset = {x=-30, y=0},
		scale = {x=0.8, y=0.8},
		text = mobtalker_creeper_image(creeper_love[clicker:get_player_name()],1),
	});
end

-- Event
minetest.register_on_player_receive_fields(function(player, formname, fields)
	if fields.creeper_choose1 then
		minetest.after(0.2, function()
			minetest.show_formspec(player:get_player_name(),"creeper:talk",mobtalker_creeper_talk(player,creeper_love[player:get_player_name()],"bye"))
		end)
	elseif fields.creeper_choose2 then
		minetest.after(0.2, function()
			minetest.show_formspec(player:get_player_name(),"creeper:talk",mobtalker_creeper_talk(player,creeper_love[player:get_player_name()],"fuck"))
		end)
	elseif fields.creeper_bye then
		creeper_talk = {}
		creeper_love[player:get_player_name()] = creeper_love[player:get_player_name()] + 1
		creeper_talking[player:get_player_name()] = false
		player:hud_remove(creeper_hud)
		--save()
	elseif fields.creeper_boom then
		creeper_talk = {}
		creeper_love[player:get_player_name()] = creeper_love[player:get_player_name()] - 1
		creeper_talking[player:get_player_name()] = false
		player:hud_remove(creeper_hud)
		minetest.after(0.2, function()
			creeper_boom(player:getpos())
		end)
	elseif fields["quit"] == "true" then
		creeper_talk = {}
		creeper_talking[player:get_player_name()] = false
		player:hud_remove(creeper_hud)
	end
end)

-- Auto Load
minetest.register_on_joinplayer(function(player)
	creeper_love[player:get_player_name()] = 0
	--load()
end)
