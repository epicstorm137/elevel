include("shared.lua")

AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

util.AddNetworkString("elevel_openhelpmenu")
util.AddNetworkString("elevel_savehelpnpc")

elevel.helpnpc = elevel.helpnpc or {}

function ENT:Initialize()

	self:SetModel(elevel.Config.DefaultSNPCModel)
	self:SetHullType(HULL_HUMAN)
	self:SetHullSizeNormal()
	self:SetNPCState(NPC_STATE_SCRIPT)
	self:SetSolid(SOLID_BBOX)
	self:CapabilitiesAdd(bit.bor(CAP_ANIMATEDFACE, CAP_TURN_HEAD))
	self:SetUseType(SIMPLE_USE)
	self:DropToFloor()
	self:SetMaxYawSpeed(90)
	self:DropToFloor()

end

function ENT:Use( activator )

	if ( activator:IsPlayer() ) then

		net.Start("elevel_openhelpmenu")
		net.Send(activator)
	
	end

end

function elevel.helpnpc:SaveEnts()
	local data = {}
	for k ,v in pairs(ents.FindByClass("elevel_helpnpc")) do
		table.insert(data, {pos = v:GetPos(), ang = v:GetAngles()})
	end
	if not file.Exists("elevel/helpnpc" , "DATA") then
		file.CreateDir("elevel/helpnpc")
	end

	file.Write("elevel/helpnpc/"..game.GetMap()..".json", util.TableToJSON(data))
end

function elevel.helpnpc:RemoveEnts()
	for k,v in ipairs(ents.FindByClass("elevel_helpnpc")) do
		v:Remove()
	end
end

function elevel.helpnpc:LoadEnts()
	if file.Exists("elevel/helpnpc/"..game.GetMap()..".json" , "DATA") then
		local data = file.Read("elevel/helpnpc/"..game.GetMap()..".json", "DATA")
		data = util.JSONToTable(data)
		for k, v in pairs(data) do
			local slot = ents.Create("elevel_helpnpc")
			slot:SetPos(v.pos)
			slot:SetAngles(v.ang)
			slot:Spawn()
		end
		print("[ELevel] Finished loading "..#data.." Help NPC's.")
	else
		print("[ELevel] No map data found for Help NPC's. Please place some and do elevel_"..elevel.Config.HNPCSaveCmd.." to create the data.")
	end
end

hook.Add("InitPostEntity", "elevel:spawnhnpc", elevel.helpnpc.LoadEnts)
hook.Add("PostCleanupMap","elevel:respawnhnpc", elevel.helpnpc.LoadEnts)

net.Receive("elevel_savehelpnpc",function(len,ply)
    if !elevel.Config.Admins[ply:GetUserGroup()] then return end

    elevel.helpnpc:SaveEnts()
    elevel.helpnpc:RemoveEnts()
    elevel.helpnpc:LoadEnts()

    ply:ELMessage("Saved Help NPC's for "..game.GetMap().."!")
end)