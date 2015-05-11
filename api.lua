-- Intllib
local S
if minetest.get_modpath("intllib") then
	S = intllib.Getter()
else
	S = function(s) return s end
end

-- Return Formspec Function
function xform(mobname,text,type,def)
	-- If no message is passed, then set a default message
	if not text then
		text = S("Message is nil.")
	end

	-- Set proceed button
	local button
	if not type or type == "proceed" or type.type == "proceed" then
		button = "button_exit[5.5,11;5,0.5;"..mobname.."_proceed;"..S("proceed").."]"
	elseif type.choose3 then
		button = "button_exit[5.5,9.6;5,0.5;"..mobname.."_choose1;"..type.choose1.."]"..
			"button_exit[5.5,10.3;5,0.5;"..mobname.."_choose2;"..type.choose2.."]"..
			"button_exit[5.5,11;5,0.5;"..mobname.."_choose3;"..type.choose3.."]"
	elseif type.choose2 then
		button = "button_exit[5.5,10.3;5,0.5;"..mobname.."_choose1;"..type.choose1.."]"..
			"button_exit[5.5,11;5,0.5;"..mobname.."_choose2;"..type.choose2.."]"
	else
		button = "button_exit[5.5,11;5,0.5;"..mobname.."_"..string.lower(type)..";"..type.."]"
	end

	-- Create def array if it does not exist
	if not def then
		def = {}
	end

	-- Set the name of the mob that is talking
	local name
	if not def.name  then
		-- Creepers
		if mobname == "creeper" then
			name = S("Cupa")
		-- If mob name is not listed above, then give it a default name
		else
			name = S("Unknown")
		end
	else
		name = def.name
	end

	-- Set the mob's face for its image if a face isn't passed through def array
	local face
	if not def.face then
		face = "normal"
	end

	-- Return Formspec
	return "size[16,15;true]"..
		"bgcolor[#00000000;true]"..	-- Remove the default formspec background color
		"image[3,2;12.5,15.5;"..mobname.."_"..face..".png]"..	-- Mob image
		"label[2,11;"..name.."]"..	-- Mob name
		"label[2,12;"..text.."]"..	-- The text the mob is saying
		"image[1.5,11.5;15,3;mobtalker_form.png]"..	-- Text box
		button	-- Proceed button
end

-- Read the directory for modtalker, or create it if it doesn't exist
function mobtalker_mkdir()
	local input = io.open(mobtalker.datadir,"r")
	if input then
		io.close(input)
	else
		os.execute("mkdir \""..mobtalker.datadir.."\"")
	end
end

--[[ Can't use!
Save and Load
function mobtalker_save(mobname,love)
	local output = io.open(mobtalker.datadir.."/"..mobname..".txt", "w")
	for _,v in pairs(love) do
		output:write(v.."\n")
	end
	io.close(output)
end
function mobtalker_load(mobname,love)
	local input = io.open(mobtalker.datadir.."/"..mobname..".txt", "r")
	if input then
		repeat
			local lv = input:read("*n")
			if lv == nil then
				break
			end
			local self = input:read("*l")
			love[self] = lv
		until input:read(0) == nil
		io.close(input)
	else
		love = {}
	end
end
]]
