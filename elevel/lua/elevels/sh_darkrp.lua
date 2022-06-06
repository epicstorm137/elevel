hook.Add("loadCustomDarkRPItems","elevel:loadf4",function()
    if !DarkRP then return end

    DarkRP.createCategory{
        name = "ELevel",
        categorises = "entities",
        startExpanded = true,
        color = Color(255, 152, 35),
        canSee = function(ply) return true end,
    }

    DarkRP.createEntity("ELevel Printer", {
        ent = "elevel_printer",
        model = "models/props_c17/consolebox01a.mdl",
        price = elevel.Config.PrinterPrice,
        max = 2,
        cmd = "buyeprinter",
        customCheck = function(ply) return ply:GetLevel() > 0 end,
        CustomCheckFailMsg = function(ply, entTable) return "You need to be at least level 1!" end,
        --getPrice = function(ply, price) return ply:GetUserGroup() == "donator" and price * 0.9 or price end,
        category = "ELevel",
        --allowTools = false,
    })

    DarkRP.createEntity("ELevel XP Parcel", {
        ent = "elevel_printer",
        model = "models/props_junk/cardboard_box004a.mdl",
        price = elevel.Config.ParcelPrice,
        max = 1,
        cmd = "buyeparcel",
        category = "ELevel",
    })

    print("[ELevel] Initialised DarkRP custom module!")
end)

hook.Add("playerBoughtCustomEntity","elevel:darkrp:setowner",function(ply, entTbl, ent, price)
    if entTbl.ent == "elevel_printer" then
        ent:CPPISetOwner(ply)
    end
end)
