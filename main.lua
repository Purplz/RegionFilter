local RF = select(2, ...)
local servers = RF.servers
local posts = RF.posts
RF.version = "1.6.1"
RF.togRemove = false

local spaced_realm = string.gsub(GetRealmName(), "%s+", "")
RF.myRealm = string.gsub(spaced_realm, "'", "")
---- Set variables for realm/data-centre info ----
RF.info = servers[RF.myRealm] 
RF.region, RF.dataCentre = RF.info[1], RF.info[2]

if RF.region == 'NA' then
	if RF.dataCentre == 'EAST' then
		RF.postType = posts.na_east_post
	end

	if RF.dataCentre == 'WEST' then
		RF.postType = posts.na_west_post
	end
end

if RF.region == 'OC' then RF.postType = posts.oc_post end
if RF.region == 'LA' then RF.postType = posts.la_post end
if RF.region == 'BR' then RF.postType = posts.br_post end

---- Updating the text of entries
function RF.updateEntries(results)
    local searchResults = C_LFGList.GetSearchResultInfo(results.resultID)

    if not searchResults then
        print("Warning: searchResults is nil for resultID:", results.resultID)
        return
    end

    -- Try to get activityID safely
    local activityID = searchResults.activityID
    if not activityID and searchResults.activityIDs then
        activityID = searchResults.activityIDs[1] -- Get the first activity ID if it's a table
    end

    if not activityID then
        print("Warning: activityID is nil for resultID:", results.resultID)
        return
    end

    local leaderName = searchResults.leaderName
    local activityInfo = C_LFGList.GetActivityInfoTable(activityID)

    if activityInfo then
        local activityName = activityInfo.fullName
        if leaderName then -- Filter out nil entries from LFG Pane
            local name, realm = RF:splitName(leaderName) -- Use splitName instead of sanitiseName
            local info = servers[realm]
            if info then
                local region, dataCentre, regionColour = info[1], info[2], info[3]
                local regionLabel = (region == "NA") and (region .. '-' .. dataCentre) or region

                results.ActivityName:SetText(
                    RF:regionTag(regionLabel, activityName, regionColour)
                )
                results.ActivityName:SetTextColor(
                    RF:dungeonText(RF.region, region)
                )
            else
                print("Warning: Realm not found in servers table -", realm)
            end
        end
    else
        print("Warning: Activity info not found for ID:", activityID)
    end
end

---- Print When Loaded ----
local welcomePrompt = CreateFrame("Frame")
welcomePrompt:RegisterEvent("PLAYER_LOGIN")
welcomePrompt:SetScript("OnEvent", function(_, event)
	if event == "PLAYER_LOGIN" then
		print("|cff00ffff[Region Filter]|r |cffffcc00Version "..RF.version.."|r. If there any bugs please report them at https://github.com/Purplz/RegionFilter")
		print(RF.postType)
	end
end)

hooksecurefunc("LFGListSearchEntry_Update", RF.updateEntries)