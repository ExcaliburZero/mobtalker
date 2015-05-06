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
--[[
function mobtalker_mobs(self,clicker)
	self.object:setvelocity({x=0,y=0,z=0})
	talk[self] = true
	talking[clicker:get_player_name()] = true
	local hud1 = clicker:hud_add({
		hud_elem_type = "image",
		position = {x=0.55, y=0.6},
		offset = {x=-30, y=0},
		scale = {x=0.5, y=0.5},
		text = "test.png",
	});
	minetest.show_formspec(clicker:get_player_name(),"mobs:talk",mobtalker_mobs_talk(clicker,mobs_love[clicker:get_player_name()],1))
end

-- Return Formspec
function mobtalker_mobs_talk(player,love,Q)
	if love == 0 and Q == 1 then
		return "size[5,2;true]"..
			"label[0,0;"..S("Hey who are you?").."]"..
			"button_exit[0,0.6;4.8,0.5;choose1;"..S("My name is %s."):format(player:get_player_name()).."]"..
			"button_exit[0,1.4;4.8,0.5;choose2;"..S("Your death!").."]"
	elseif love > 0 and Q == 1 then
		return "size[5,2;true]"..
			"label[0,0;"..S("Hmm?").."]"..
			"button_exit[0,1.4;4.8,0.5;bye;"..S("See you!").."]"
	elseif love < 0 and Q == 1 then
		return "size[5,2;true]"..
			"label[0,0;"..S("Die!").."]"..
			"button_exit[0,1.4;4.8,0.5;bye;"..S("F**k").."]"
	elseif Q == "bye" then
		return "size[5,2;true]"..
			"label[0,0;"..S("Thanks!").."]"..
			"button_exit[0,1.4;4.8,0.5;bye;"..S("See you!").."]"
	elseif Q == "fuck" then
		return "size[5,2;true]"..
			"label[0,0;"..S("Yeah I don't like you either.").."]"..
			"button_exit[0,1.4;4.8,0.5;boom;"..S("F**k").."]"
	end
end

-- Event
minetest.register_on_player_receive_fields(function(player, formname, fields)
	if fields.choose1 then
		minetest.after(0.2, function()
			minetest.show_formspec(player:get_player_name(),"mobs:talk",mobtalker_mobs_talk(player,mobs_love[player:get_player_name()],"bye"))
		end)
	elseif fields.choose2 then
		minetest.after(0.2, function()
			minetest.show_formspec(player:get_player_name(),"mobs:talk",mobtalker_mobs_talk(player,mobs_love[player:get_player_name()],"fuck"))
		end)
	elseif fields.bye then
		talk = {}
		mobs_love[player:get_player_name()] = mobs_love[player:get_player_name()] + 1
		talking[player:get_player_name()] = false
		player:hud_remove(hudnumber)
	elseif fields.boom then
		talk = {}
		mobs_love[player:get_player_name()] = mobs_love[player:get_player_name()] - 1
		talking[player:get_player_name()] = false
		player:hud_remove(hudnumber)
		mobs_boom(player:getpos())
	elseif fields["quit"] == "true" then
		talk = {}
		talking[player:get_player_name()] = false
		player:hud_remove(hudnumber)
	end
end)
]]--
