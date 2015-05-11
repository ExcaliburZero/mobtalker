-- Local
local mobname = "creeper"
local route = {}
local pself = {}
local count = {}
--local day = {}

-- intllib
local S
if minetest.get_modpath("intllib") then
	S = intllib.Getter()
else
	S = function(s) return s end
end

-- Form func
local function form(text,type,def)
	return xform(mobname,text,type,def)
end

-- Return Form
local function creeper_form(player,love,route)
	if love == 0 and route == 0 and count[player] == 0 then
		return form(S("Hey."))
	elseif love == 1 and route == 0 and count[player] == 0 then
		return form(S("Hey."))
	else
		return form(S("Exception handling error"))
	end
end

-- Global
function mobtalker_creeper(self,clicker)
	creeper_talk[self] = true
	pself[clicker] = self
	self.object:setvelocity({x=0,y=0,z=0})
	minetest.show_formspec(clicker:get_player_name(),mobname..":form",creeper_form(clicker,creeper_love[self],route[clicker]))
end

-- Event
minetest.register_on_player_receive_fields(function(player, formname, fields)
	local entity = pself[player]
	if formname == mobname..":form" then
		if fields.creeper_proceed then
			creeper_talk[entity] = false
			if creeper_love[entity] == 0 then
				creeper_love[entity] = 1
			end
		elseif fields["quit"] == "true" then
			creeper_talk[entity] = false
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
