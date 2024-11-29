if Config.AccessTypes["command"].enabled then 
    RegisterCommand(Config.AccessTypes["command"].command, function (source, args, rawCommand)
        TriggerEvent('ctake:client:open')    
    end)
    TriggerEvent('chat:addSuggestion', '/'..Config.AccessTypes["command"].command, 'Use casino')
end

