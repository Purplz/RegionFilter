local RF = select(2, ...)

RF.consolePrefix = "|cff00ffff[Region Filter]:|r "

function RF:regionTag(label, activity, regionColour)
	-- Creates and colours the REGION tag
	return regionColour..'['..label..']|r '..activity
end

function RF:dungeonText(playerRegion, listRegion)
    if not playerRegion or not listRegion then return 0.5, 0.5, 0.5 end  -- Neutral color for invalid input
    if playerRegion == listRegion then return 0, 1, 1 else return 0.75, 0.75, 0.75 end
end

function RF:splitName(leaderName)
    local name, realm = strsplit("-", leaderName, 2)
    realm = realm and realm:gsub("'", "") or RF.myRealm
    return name, realm
end

function RF:sanitiseName(fullName)
    if not fullName then return nil, nil end
    return fullName:match("([^%-]+)%-(.+)")
end