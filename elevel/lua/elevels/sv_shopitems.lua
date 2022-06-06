--[[
        Tutorial on how to create an Item:

        1) Add a comma onto the last item, then add {} to create the table
        2) Insert the following collums, make sure you add a comma to the end of each line in the table.
            {
                ["Type"] = "String Type", --Type can be either "ent", "weapon", "health" or "armor"
                ["Content"] = "String Content / Number Content", - -- Will be whatever you would like to spawn / do, defined in the line above, e.g. Weapon class name or entity class name, or Health / Armor
                ["PrintName"] = "String Name", -- The name that will come up on the shop menu
                ["Cost"] = Number XP, -- The xp that will be taken when you purchase this
                ["Max"] = Number Max, -- Only needed on the ent type, it sets the max amount you can buy at one time. Set to 'math.huge' if you want infinite.
            },
        3) It is then done, and it should be in the menu, the next time you open it!

]]


elevel.items = {
    {
        ["Type"] = "ent",
        ["Content"] = "elevel_printer",
        ["PrintName"] = "Elevel Printer",
        ["Cost"] = 50,
        ["Max"] = 1,
    },{
        ["Type"] = "ent",
        ["Content"] = "elevel_parcel",
        ["PrintName"] = "Elevel XP Parcel",
        ["Cost"] = 180,
        ["Max"] = 2,
    },
}

function elevel:GetShopData()
    return elevel.items
end