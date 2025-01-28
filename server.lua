local QBCore = exports['qb-core']:GetCoreObject()
local function isNumberValid(newNumber)
    return string.match(newNumber, '^%d+$') and #newNumber >= 7 and #newNumber <= 9
end

local function updateTables(oldNumber, newNumber, citizenid)
    local queries = {
        {
            query = 'UPDATE phone_phones SET phone_number = ? WHERE citizenid = ?',
            values = {newNumber, citizenid}
        },
        {
            query = 'UPDATE phone_last_phone SET phone_number = ? WHERE phone_number = ?',
            values = {newNumber, oldNumber}
        },
        {
            query = 'UPDATE phone_photo_albums SET phone_number = ? WHERE phone_number = ?',
            values = {newNumber, oldNumber}
        },
        {
            query = 'UPDATE phone_photos SET phone_number = ? WHERE phone_number = ?',
            values = {newNumber, oldNumber}
        },
        {
            query = 'UPDATE phone_notes SET phone_number = ? WHERE phone_number = ?',
            values = {newNumber, oldNumber}
        },
        {
            query = 'UPDATE phone_notifications SET phone_number = ? WHERE phone_number = ?',
            values = {newNumber, oldNumber}
        },
        {
            query = 'UPDATE phone_twitter_accounts SET phone_number = ? WHERE phone_number = ?',
            values = {newNumber, oldNumber}
        },
        {
            query = 'UPDATE phone_instagram_accounts SET phone_number = ? WHERE phone_number = ?',
            values = {newNumber, oldNumber}
        },
        {
            query = 'UPDATE phone_clock_alarms SET phone_number = ? WHERE phone_number = ?',
            values = {newNumber, oldNumber}
        },
        {
            query = 'UPDATE phone_tinder_accounts SET phone_number = ? WHERE phone_number = ?',
            values = {newNumber, oldNumber}
        },
        {
            query = 'UPDATE phone_darkchat_accounts SET phone_number = ? WHERE phone_number = ?',
            values = {newNumber, oldNumber}
        },
        {
            query = 'UPDATE phone_wallet_transactions SET phone_number = ? WHERE phone_number = ?',
            values = {newNumber, oldNumber}
        },
        {
            query = 'UPDATE phone_yellow_pages_posts SET phone_number = ? WHERE phone_number = ?',
            values = {newNumber, oldNumber}
        },
        {
            query = 'UPDATE phone_backups SET phone_number = ? WHERE phone_number = ?',
            values = {newNumber, oldNumber}
        },
        {
            query = 'UPDATE phone_marketplace_posts SET phone_number = ? WHERE phone_number = ?',
            values = {newNumber, oldNumber}
        },
        {
            query = 'UPDATE phone_music_playlists SET phone_number = ? WHERE phone_number = ?',
            values = {newNumber, oldNumber}
        },
        {
            query = 'UPDATE phone_music_saved_playlists SET phone_number = ? WHERE phone_number = ?',
            values = {newNumber, oldNumber}
        },
        {
            query = 'UPDATE phone_maps_locations SET phone_number = ? WHERE phone_number = ?',
            values = {newNumber, oldNumber}
        },
        {
            query = 'UPDATE phone_voice_memos_recordings SET phone_number = ? WHERE phone_number = ?',
            values = {newNumber, oldNumber}
        },
        {
            query = 'UPDATE phone_tinder_swipes SET swiper = ?, swipee = ? WHERE swiper = ? OR swipee = ?',
            values = {newNumber, newNumber, oldNumber, oldNumber}
        },
        {
            query = 'UPDATE phone_tinder_matches SET phone_number_1 = ?, phone_number_2 = ? WHERE phone_number_1 = ? OR phone_number_2 = ?',
            values = {newNumber, newNumber, oldNumber, oldNumber}
        },
        {
            query = 'UPDATE phone_tinder_messages SET sender = ?, recipient = ? WHERE sender = ? OR recipient = ?',
            values = {newNumber, newNumber, oldNumber, oldNumber}
        },
        {
            query = 'UPDATE phone_message_members SET phone_number = ? WHERE phone_number = ?',
            values = {newNumber, oldNumber}
        },
        {
            query = 'UPDATE phone_phone_contacts SET contact_phone_number = ?, phone_number = ? WHERE contact_phone_number = ? OR phone_number = ?',
            values = {newNumber, newNumber, oldNumber, oldNumber}
        },
        {
            query = 'UPDATE phone_phone_calls SET caller = ?, callee = ? WHERE caller = ? OR callee = ?',
            values = {newNumber, newNumber, oldNumber, oldNumber}
        },
        {
            query = 'UPDATE phone_phone_blocked_numbers SET phone_number = ?, blocked_number = ? WHERE phone_number = ? OR blocked_number = ?',
            values = {newNumber, newNumber, oldNumber, oldNumber}
        },
        {
            query = 'UPDATE phone_phone_voicemail SET caller = ?, callee = ? WHERE caller = ? OR callee = ?',
            values = {newNumber, newNumber, oldNumber, oldNumber}
        },
        {
            query = 'UPDATE phone_services_channels SET phone_number = ? WHERE phone_number = ?',
            values = {newNumber, oldNumber}
        }
    }
    
    return MySQL.transaction.await(queries)
end

RegisterNetEvent('kb-phonechanger:server:changeNumber', function(newNumber)
    local src = source
    local player = QBCore.Functions.GetPlayer(src)
    if not player then return end

    if not isNumberValid(newNumber) then
        TriggerClientEvent('QBCore:Notify', src, 'Geçersiz telefon numarası formatı!', 'error')
        return
    end

    local result = MySQL.query.await('SELECT phone_number FROM phone_phones WHERE citizenid = ?', {player.PlayerData.citizenid})
    if not result or #result == 0 then
        TriggerClientEvent('QBCore:Notify', src, 'Telefon numarası bulunamadı!', 'error')
        return
    end
    
    local oldNumber = result[1].phone_number
    if oldNumber == newNumber then
        TriggerClientEvent('QBCore:Notify', src, 'Bu zaten sizin numaranız!', 'error')
        return
    end

    local existing = MySQL.query.await('SELECT phone_number FROM phone_phones WHERE phone_number = ?', {newNumber})
    if existing and #existing > 0 then
        TriggerClientEvent('QBCore:Notify', src, 'Bu numara zaten kullanımda!', 'error')
        return
    end

    local success = updateTables(oldNumber, newNumber, player.PlayerData.citizenid)
    if success then
        TriggerClientEvent('QBCore:Notify', src, 'Numara başarıyla değiştirildi: '..newNumber, 'success')
    else
        TriggerClientEvent('QBCore:Notify', src, 'Numara değiştirme hatası!', 'error')
    end
end)