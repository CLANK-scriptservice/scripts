local function loadScriptHub()
    local scripts = {
        [125723653259639] = "https://raw.githubusercontent.com/CLANK-scriptservice/scripts/refs/heads/main/DrillDiggingSim.lua",
        [15862090066] = "https://raw.githubusercontent.com/CLANK-scriptservice/scripts/refs/heads/main/make%26sellweapons.lua",
        [8328351891] = "https://raw.githubusercontent.com/CLANK-scriptservice/scripts/refs/heads/main/Mega%20Mansion%20Tycoon",
        --[] = "",
    }

    if scripts[game.placeId] then
        local success, err = pcall(function()
            loadstring(game:HttpGet(scripts[game.PlaceId]))()
        end)
        
        if not success then
            warn("Failed to load script for PlaceId " .. game.PlaceId .. ": " .. err)
        end
    else
        warn("No script found for PlaceId " .. game.PlaceId)
    end
end

-- Run the script hub
loadScriptHub()
