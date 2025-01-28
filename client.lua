local QBCore = exports['qb-core']:GetCoreObject()

RegisterNetEvent('kb-phonechanger:client:useItem', function()
    local input = lib.inputDialog('Telefon Numarası Değiştir', {
        { 
            type = 'input',
            label = 'Yeni Telefon Numarası',
            placeholder = '7-9 rakam',
            required = true,
            min = 7,
            max = 9
        }
    })
    
    if not input then return end
    local newNumber = input[1]
    
    if not tonumber(newNumber) then
        QBCore.Functions.Notify('Geçersiz numara formatı!', 'error')
        return
    end
    
    TriggerServerEvent('kb-phonechanger:server:changeNumber', newNumber)
end)