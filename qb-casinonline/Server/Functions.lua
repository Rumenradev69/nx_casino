local QBCore = exports['qb-core']:GetCoreObject()

local cacheFiles = {}

Citizen.CreateThread(function()
	if GetResourceState("qb-core") == "started" then
		Framework = exports['qb-core']:GetCoreObject()
	elseif GetResourceState("vrp") == "started" then
		Framework = exports.vrp:GetCoreObject()
	else 
	end
end)

-- Save cacheFiles to Server\Data\players.json every 30 minutes
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(30 * 60000)
		local data = LoadResourceFile(GetCurrentResourceName(), 'Server/Data/players.json')
		local data = json.decode(data)
		for k,v in pairs(cacheFiles) do
			data[k] = v
		end
		SaveResourceFile(GetCurrentResourceName(), 'Server/Data/players.json', json.encode(data), -1)
	end
end)

AddEventHandler('onResourceStop', function(resource)
	if resource == GetCurrentResourceName() then
		local data = LoadResourceFile(GetCurrentResourceName(), 'Server/Data/players.json')
		local data = json.decode(data)
		for k,v in pairs(cacheFiles) do
			data[k] = v
		end
		SaveResourceFile(GetCurrentResourceName(), 'Server/Data/players.json', json.encode(data), -1)
	end
end)

---@param playerData table // player data
---@param src number // player id
function savePlayerData(playerData, src)
	if not next(cacheFiles) then
		local data = LoadResourceFile(GetCurrentResourceName(), 'Server/Data/players.json')
		local data = json.decode(data)
		cacheFiles = data
	end

    if playerData.identifier then 
        cacheFiles[playerData.identifier] = playerData
		if src then 
			TriggerClientEvent('ctake:client:receiveData', src, cacheFiles[playerData.identifier])
		end
        return true
    end
	
	return false
end

---@param identifier string // player identifier
---@param src number // player id
function getPlayerData(identifier, src)
	local src = source
	if not next(cacheFiles) then 
		local data = LoadResourceFile(GetCurrentResourceName(), 'Server/Data/players.json')
		local data = json.decode(data)
		cacheFiles = data
	end
	local data = cacheFiles
	local found = false
	if data[identifier] then 
		local v = data[identifier]
		found = true
		v.isAdmin = isPlayerAdmin(src)
		return v
	end

	if not found then 
		local player = {
			identifier = identifier,
			money = 0,
            name = GetPlayerName(src),
			bets = {},
			veniatorHistory = {},
			isAdmin = isPlayerAdmin(src),
			chatban = false,
			timeout = false,
			image = "https://cdn.discordapp.com/attachments/932478723700183140/1120182521481662495/blank-profile-picture-973460_640.webp"
		}
		savePlayerData(identifier, src)
		return player
	end

	return false
end

---@param id number // player id
function getPlayerIdentifier(id)
    local license  = false

    for k,v in pairs(GetPlayerIdentifiers(source))do
        if string.sub(v, 1, string.len("license:")) == "license:" then
            license = v
        end
    end

    return license
end

---@param type string // "money" or "bank"
---@param amount number // amount to add
function removePlayerMoney(type, amount)
	local parsedAmount = tonumber(amount)
	local src = source
	if GetResourceState("qb-core") == "started" then
		local Player = Framework.Functions.GetPlayer(src)
		if Player then
			if type == "money" then
				local plyAmount = Player.Functions.GetMoney("cash")
				if plyAmount and plyAmount >= parsedAmount then
					-- sendDiscordLog('money', 'MONEY', '**'..Player.PlayerData.name..'** deposited **$'..parsedAmount..'** from **'..type..'**', getPlayerIdentifier(src))
					return Player.Functions.RemoveMoney("cash", parsedAmount)
				else
					-- sendDiscordLog('money', 'MONEY', '**'..Player.PlayerData.name..'** tried to deposit **$'..parsedAmount..'** from **'..type** but he/she doesn't have enough money.', getPlayerIdentifier(src))
					return false
				end
			elseif type == "bank" then
				local plyAmount = Player.Functions.GetMoney("bank")
				if plyAmount and plyAmount >= parsedAmount then
					-- sendDiscordLog('money', 'MONEY', '**'..Player.PlayerData.name..'** deposited **$'..parsedAmount..'** from **'..type**', getPlayerIdentifier(src))
					return Player.Functions.RemoveMoney("bank", parsedAmount)
				else
					-- sendDiscordLog('money', 'MONEY', '**'..Player.PlayerData.name..'** tried to deposit **$'..parsedAmount..'** from **'..type** but he/she doesn't have enough money.', getPlayerIdentifier(src))
					return false
				end
			end
		end
	end
end
---@param type string // "money" or "bank"
---@param amount number // amount to add
function addPlayerMoney(type, amount)
    local p = promise:new() -- wais :)
    local amount = tonumber(amount)
    local src = source
    if GetResourceState("qb-core") == "started" then
        local Player = Framework.Functions.GetPlayer(src)
        if Player then
            if type == "money" then
                return Player.Functions.AddMoney("cash", amount) 
            elseif type == "bank" then
                return Player.Functions.AddMoney("bank", amount) 
            end
            sendDiscordLog('money', 'MONEY', '**'..Player..'** withdrawn **$'..amount..'** to **'..type..'**', getPlayerIdentifier(src))
        end
    elseif GetResourceState("vrp") == "started" then
            local Player = vRP.getUserId(src)
            if Player then
                if type == "money" then
                    sendDiscordLog('money', 'MONEY', '**'..Player..'** withdrawn **$'..amount..'** to **'..type..'**', getPlayerIdentifier(src))
                    vRP.giveMoney(Player,amount) -- Main 1
                    p:resolve(true)
                elseif type == "bank" then
                    sendDiscordLog('money', 'MONEY', '**'..Player..'** withdrawn **$'..amount..'** to **'..type..'**', getPlayerIdentifier(src))
                    vRP.giveBankMoney(Player, amount) -- Main 2
                    p:resolve(true)
                end
            end
        else
    end
    return Citizen.Await(p)
end

---@param id number // player id
function isPlayerAdmin(id)
	local src = id
	local identifier = getPlayerIdentifier(src)
	return Config.StaffList[identifier]
end

function veniatorCalculation()
	local precision = 100;
	local stopNum;
	local coeffChance = math.random(1, 100);
	
	if coeffChance >= 1 and coeffChance <= 10 then
		stopNum = math.random(1 * precision, 1 * precision) / precision
	elseif coeffChance >= 11 and coeffChance <= 30 then
		stopNum = math.random(1 * precision, 2 * precision) / precision
	elseif coeffChance >= 31 and coeffChance <= 45 then
		stopNum = math.random(1 * precision, 2 * precision) / precision
	elseif coeffChance >= 46 and coeffChance <= 60 then
		stopNum = math.random(1 * precision, 3 * precision) / precision
	elseif coeffChance >= 61 and coeffChance <= 75 then
		stopNum = math.random(1 * precision, 3 * precision) / precision
	elseif coeffChance >= 76 and coeffChance <= 95 then
		stopNum = math.random(1 * precision, 5 * precision) / precision
	elseif coeffChance >= 96 and coeffChance <= 100 then
		stopNum = math.random(10 * precision, 30 * precision) / precision
	end

	return stopNum
end

---@param type string // Config.Webhooks indexes
---@param title string
---@param string message // message to send
---@param identifier string // player identifier
function sendDiscordLog(type, title, message, identifier)
    local Webhook = Config.DiscordWebhooks[type]
    local headers = {
        ['Content-Type'] = 'application/json'
    }
    local embed = {
        {
            ["color"] = 15548997,
            ["title"] = title,
            ["description"] = message .. "\nPlayer Identifier: " .. identifier .. "\nPlayer Steam Name: " .. GetPlayerName(source),
            ["timestamp"] = os.date("!%Y-%m-%dT%H:%M:%SZ"),
            ["footer"] = {
                ["text"] = "Developed by QBCore",
            },
            ["author"] = {
                ["name"] = type .. " LOGS",
            },
        }
    }
    PerformHttpRequest(Webhook, function(err, text, headers) end, 'POST', json.encode({embeds = embed}), { ['Content-Type'] = 'application/json' })
end
