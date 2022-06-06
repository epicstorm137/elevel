local metaply = FindMetaTable("Player")

hook.Add("Initialize","elevel:setupsql",function()
    sql.Query("CREATE TABLE IF NOT EXISTS elevel('SteamID' TEXT NOT NULL, 'level' INT NOT NULL, 'xp' INT NOT NULL, PRIMARY KEY('SteamID'));")
end)

function metaply:CheckXPAccount()
    local query = sql.Query("SELECT * FROM elevel WHERE SteamID = "..sql.SQLStr(self:SteamID())..";")
    if (!query) then
        sql.Query("INSERT INTO elevel(SteamID, level, xp) VALUES("..sql.SQLStr(self:SteamID())..", "..sql.SQLStr(0)..", "..sql.SQLStr(0)..");")
        ServerLog("[ELevel] Creating new account data for "..self:Nick().."\n")
    else
        ServerLog("[ELevel] Loading saved account data for "..self:Nick().."\n")
    end
end

function metaply:GetStoredXP()
    local query = sql.QueryRow("SELECT xp FROM elevel WHERE SteamID = "..sql.SQLStr(self:SteamID())..";")
    return tonumber(query.xp) or 0
end

function metaply:GetStoredLevel()
    local query = sql.QueryRow("SELECT level FROM elevel WHERE SteamID = "..sql.SQLStr(self:SteamID())..";")
    return tonumber(query.level) or 0
end

function metaply:SetStoredXP( xp )
    sql.Query("UPDATE elevel SET xp = "..sql.SQLStr(xp).." WHERE SteamID = "..sql.SQLStr(self:SteamID())..";")
end

function metaply:SetStoredLevel( level )
    sql.Query("UPDATE elevel SET level = "..sql.SQLStr(level).." WHERE SteamID = "..sql.SQLStr(self:SteamID())..";")
end