-- intllib
local S
if minetest.get_modpath("intllib") then
	S = intllib.Getter()
else
	S = function(s) return s end
end

-- Hud Number
local hudnumber
if minetest.setting_getbool("enable_damage") then
	hudnumber = 1
else
	hudnumber = 0
end

-- Save
--[[
local function savelove()
	local output = io.open(minetest.get_worldpath() .. "/mobtalker", "w")
	for _,p in ipairs(minetest.get_connected_players()) do
		output:write(creeper_love[p:get_player_name()].."\n")
	end
	io.close(output)
end

-- Load
local function loadlove()
	local input = io.open(minetest.get_worldpath() .. "/mobtalker", "r")
	if input then
		repeat
			local love = input:read("*n")
			local name = input:read("*l")
			creeper_love[name:sub(2)] = love
		until input:read() == nil
		io.close(input)
	else
		creeper_love = {}
	end
end
]]--

-- Function
function mobtalker_creeper(self,clicker)
	--loadlove()
	self.object:setvelocity({x=0,y=0,z=0})
	creeper_talk[self] = true
	creeper_talking[clicker:get_player_name()] = true
	local hud1 = clicker:hud_add({
		hud_elem_type = "image",
		position = {x=0.55, y=0.6},
		offset = {x=-30, y=0},
		scale = {x=0.5, y=0.5},
		text = "test.png",
	});
	minetest.show_formspec(clicker:get_player_name(),"creeper:talk",mobtalker_creeper_talk(clicker,creeper_love[clicker:get_player_name()],1))
end

-- Return Formspec
function mobtalker_creeper_talk(player,love,Q)
	if love == 0 and Q == 1 then
		return "size[5,2;true]"..
			"label[0,0;"..S("Hey! Who are you?").."]"..
			"button_exit[0,0.6;4.8,0.5;creeper_choose1;"..S("My name is %s."):format(player:get_player_name()).."]"..
			"button_exit[0,1.4;4.8,0.5;creeper_choose2;"..S("Your death!").."]"
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
		player:hud_remove(hudnumber)
		--savelove()
	elseif fields.creeper_boom then
		creeper_talk = {}
		creeper_love[player:get_player_name()] = creeper_love[player:get_player_name()] - 1
		creeper_talking[player:get_player_name()] = false
		player:hud_remove(hudnumber)
		minetest.after(0.2, function()
			creeper_boom(player:getpos())
		end)
	elseif fields["quit"] == "true" then
		creeper_talk = {}
		creeper_talking[player:get_player_name()] = false
		player:hud_remove(hudnumber)
	end
end)

-- Auto Load
minetest.register_on_joinplayer(function(player)
	creeper_love[player:get_player_name()] = 0
end)
