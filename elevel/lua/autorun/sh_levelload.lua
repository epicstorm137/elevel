elevel = elevel or {}

local dir = "elevels/"

if SERVER then

    local files = file.Find(dir .. "*", "LUA")
	for k, v in pairs(files) do
		if string.StartWith(v, "sv_") then
			include(dir .. v)
			print("[ELevel] Module:"..v.." loaded!")
		elseif string.StartWith(v, "sh_") then
			AddCSLuaFile(dir .. v)
			include(dir .. v)
			print("[ELevel] Module:"..v.." loaded!")
		elseif string.StartWith(v, "cl_") then
			AddCSLuaFile(dir .. v)
            print("[ELevel] Module:"..v.." sent to clients!")
		end
	end

elseif CLIENT then

    local files = file.Find(dir .. "*", "LUA")
	for k, v in pairs(files) do
		if string.StartWith(v, "sh_") || string.StartWith(v, "cl_") then
			include(dir .. v)
			print("[ELevel] Module:"..v.." loaded!")
		end
	end

end

AddCSLuaFile("elevel_config.lua")
include("elevel_config.lua")