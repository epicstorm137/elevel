local metaply = FindMetaTable("Player")

function elevel:Formula( level )
    if !isnumber(level) then return end
    level = level + 5
    return math.Round(level^2.5)
end

function metaply:GetXP()
    return self:GetNWInt("elevel:xp",0)
end

function metaply:GetLevel()
    return self:GetNWInt("elevel:level",0)
end

function metaply:IsLevel( level )
    if !isnumber(level) then return end
    return self:GetLevel() >= level
end

function metaply:CanAfford( xp )

    if self:GetXP() > xp then
        return true
    end

    if self:GetLevel() < 0 and self:GetXP() < xp then
        return false
    end

    if xp > self:GetXP() then
        local overflow = xp - self:GetXP()
        local lvl = -1

        ::cycle::
        if overflow > elevel:Formula( self:GetLevel() + lvl ) then
            overflow = overflow - elevel:Formula( self:GetLevel() + lvl )
            lvl = lvl - 1
            goto cycle
        end

        lvl = lvl + self:GetLevel()

        if lvl < 0 then
            return false
        end

        return true
    end

    return false
end

if SERVER then

    function metaply:AddLevel( level )
        if !isnumber(level) then return end

        levelold = math.Round(level)
        level = levelold + self:GetLevel()
        if level < 0 then
            level = 0
        end
        self:SetNWInt("elevel:level",level)
        self:SetStoredLevel( level )
        if levelold < 0 then
            self:ELNotify( "Level Down!", 6, elevel.red )
            self:ELMessage("Leveled down to level "..level.."!")
        else
            self:ELNotify( "Level Up!", 6, elevel.green )
            self:ELMessage("Leveled up to level "..level.."!")
        end
    end

    function metaply:AddXP( xp )
        if !isnumber(xp) then return end

        xp = math.Round(xp)
        local currentxp = self:GetXP()
        local neededxp = elevel:Formula( self:GetLevel() )
        currentxp = currentxp + xp
        if xp < 0 then
            if xp < -self:GetXP() then
                local overflow = self:GetXP() - xp
                local lvl = -1

                ::cycle::
                if overflow > elevel:Formula( self:GetLevel() + lvl ) then
                    overflow = overflow - elevel:Formula( self:GetLevel() + lvl )
                    lvl = lvl - 1
                    goto cycle
                end
                
                if self:GetLevel() + lvl >= 0 then
                    self:ELNotify( xp.."XP", 3, color_black )
                    self:AddLevel( lvl )
                    self:SetNWInt("elevel:xp",overflow)
                    self:SetStoredXP( overflow )
                elseif self:GetXP() > overflow then
                    self:ELNotify( xp.."XP", 3, color_black )
                    self:SetNWInt("elevel:xp",overflow)
                    self:SetStoredXP( overflow )
                else
                    self:ELNotify( -self:GetXP().."XP", 3, color_black )
                    self:AddLevel(-self:GetLevel()) -- Can Bug
                    self:SetNWInt("elevel:xp",0)
                    self:SetStoredXP( 0 )
                end
            else
                local bal = self:GetXP() + xp
                self:ELNotify( xp.."XP", 3, color_black )
                self:SetNWInt("elevel:xp",bal)
                self:SetStoredXP( bal )
            end
        elseif currentxp >= neededxp then
            local overflow = currentxp - neededxp
            local lvl = 1

            ::cycle::
            if overflow > elevel:Formula( self:GetLevel() + lvl ) then
                overflow = overflow - elevel:Formula( self:GetLevel() + lvl )
                lvl = lvl + 1
                goto cycle
            end
            self:ELNotify( "+"..xp.."XP", 3, color_black )
            self:AddLevel( lvl )
            self:SetNWInt("elevel:xp",overflow)
            self:SetStoredXP( overflow )
        else
            self:ELNotify( "+"..xp.."XP", 3, color_black )
            self:SetNWInt("elevel:xp",currentxp)
            self:SetStoredXP( currentxp )
        end
    end

end
