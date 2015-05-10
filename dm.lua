-- Local
local mobname = "dungeon_master"
local day = {}
local route = {}
local pself = {}
local count = {}

-- intllib
local S
if minetest.get_modpath("intllib") then
	S = intllib.Getter()
else
	S = function(s) return s end
end

-- All
local function c_xform(type,text,def)
	local button
	if def == nil then
		def = {}
	end
	if type == "proseed" or type.type == "proseed" or type == nil then
		button = "button_exit[5.5,11;5,0.5;dm_proseed;"..S("Proseed").."]"
	elseif type.choose3 then
		button = "button_exit[5.5,9.6;5,0.5;dm_choose1;"..type.choose1.."]"..
			"button_exit[5.5,10.3;5,0.5;dm_choose2;"..type.choose2.."]"..
			"button_exit[5.5,11;5,0.5;dm_choose3;"..type.choose3.."]"
	elseif type.choose2 then
		button = "button_exit[5.5,10.3;5,0.5;dm_choose1;"..type.choose1.."]"..
			"button_exit[5.5,11;5,0.5;dm_choose2;"..type.choose2.."]"
	else
		button = "button_exit[5.5,11;5,0.5;dm_"..string.lower(type)..";"..type.."]"
	end
	return mobtalker_form(mobname,text,def.face,def.pname)..button
end

-- Function
local function dm_form(player,love,route)
	if love == 0 and route == 0 and count[player] == 0 then
		return c_xform("proseed",S("Hey."))
	else
		return c_xform("proseed",S("Exception handling error"))
	end
end

function mobtalker_dm(self,clicker)
	pself[clicker] = self
	self.object:setvelocity({x=0,y=0,z=0})
	minetest.show_formspec(clicker:get_player_name(),mobname..":form",dm_form(clicker,dm_love[self],route[clicker]))
end

-- Event
minetest.register_on_player_receive_fields(function(player, formname, fields)
	local entity = pself[player]
	if formname == mobname..":form" then
		if fields.dm_proseed then
			dm_talk[entity] = false
			if dm_love[entity] == 0 then
				dm_love[entity] = 1
			end
		elseif fields["quit"] == "true" then
			dm_talk[entity] = false
		end
	end
end)

minetest.register_on_joinplayer(function(player)
	count[player] = 0
	route[player] = 0
	--mobtalker_load(mobname,creeper_love)
end)
minetest.register_on_shutdown(function(player)
	local entity = pself[player]
	--print(creeper_love[entity])
	--mobtalker_save(mobname,creeper_love)
end)
