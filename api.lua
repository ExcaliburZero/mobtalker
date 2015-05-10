local form_def = "size[16,15;true]".."bgcolor[#00000000;true]"

local function return_form_image(mobname,face)
	if face == nil then
		face = "normal"
	end
	return "image[3,2;12.5,15.5;"..mobname.."_"..face..".png]"
end

local function return_form_text(mobname,text,pname)
	local name
	if pname == nil then
		if mobname == "creeper" then
			name = "Cupa"
		else
			name = "Unknown"
		end
	else
		name = pname
	end
	if text == nil then
		face = "MESSAGE IS NIL"
	end
	return "label[2,11;"..name.."]".."label[2,12;"..text.."]".."image[1.5,11.5;15,3;mobtalker_form.png]"
end

function mobtalker_form(mobname,text,face,pname)
	return form_def..return_form_image(mobname,face)..return_form_text(mobname,text,pname)
end

-- Global
function mobtalker_mkdir()
	local input = io.open(mobtalker.datadir,"r")
	if input then
		io.close(input)
	else
		os.execute("mkdir \""..mobtalker.datadir.."\"")
	end
end

--[[ Save and Load
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
]]--
