local _, ns = ...

local function FormatValue(value)
    if (value >= 1e6) then
        return tonumber(format('%.1f', value/1e6))..'m'
    elseif (value >= 1e3) then
        return tonumber(format('%.1f', value/1e3))..'k'
    else
        return value
    end
end

oUF.Tags.Events['h:pp'] = "UNIT_POWER"
oUF.Tags.Methods['h:pp'] = function(unit)
	local pp = UnitPower(unit)
	local pt = UnitPowerType(unit)
	--mana
	if(pt == 0)then
		local value = FormatValue(pp)
		return value
	--rage--focus--energy--runicpower--insanity (basicly short numbers)
	else
		return pp
	end
end

oUF.Tags.Events["h:hp"] = "UNIT_HEALTH"
oUF.Tags.Methods["h:hp"] = function(unit)
    if not UnitIsDeadOrGhost(unit) then
        local hp = UnitHealth(unit)
        return FormatValue(hp)
    else
        return 'dead'
    end
end

oUF.Tags.Events["h:lvldef"] = "UNIT_LEVEL PLAYER_LEVEL_UP"
oUF.Tags.Methods["h:lvldef"] = function(unit)
	local c = UnitClassification(unit)
	local plvl = UnitLevel("player")
	local ulvl = UnitLevel(unit)
	local def = ulvl - plvl
	local lvltag
	local ctag
	if(ulvl == -1)then
		lvltag = "|cffD50000B|r "
	else
		if(c == "elite")then
			ctag = "|cffCDDC39e|r "
		elseif(c == "rare" or c == "rareelite") then
			ctag = "|cff757575r|r "
		elseif(c == "worldboss") then
			ctag = "|cffD50000b|r "
		else
			ctag = ''
		end
		if(def >= 4 or def <= -4) then
			lvltag = ulvl .. ctag .. " " 
		elseif (def == -3 or def == -2 or def == -1) then
			lvltag = '|cff64DD17-|r' .. math.abs(def) .. ctag .. " " 
		elseif (def == 3 or def == 2 or def == 1) then
			lvltag = '|cffD50000+|r' .. def .. ctag .. " "
		elseif (def == 0) then
			lvltag = ctag .. ' ' 
		end
	end
	return lvltag
end
