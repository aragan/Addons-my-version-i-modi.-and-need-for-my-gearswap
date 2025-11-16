
_addon.name = 'AutoDropItem'
_addon.version = '1.0'
_addon.author = 'Aragan'
_addon.commands = {'autodrop', 'ad'}

-- استدعاء المكتبات اللازمة
packets = require('packets')
res = require('resources')

-- حالة AutoDrop
state = {
    AutoDropItem = {value = true}
}

-- تسجيل الحدث عند استقبال حزمة بيانات
windower.register_event('incoming chunk', function(id, original, modified, injected, blocked)
    if not state.AutoDropItem.value then return end

    if id ~= 0x009 or injected then return end
    local packet = packets.parse('incoming', original)
    if packet.Message ~= 180 then return end -- Item dropped
    local _, item_id_string, _, quantity_string = unpack(packet.data:split(' '))
    local item_data = res.items[tonumber(item_id_string)]
    local quantity = tonumber(quantity_string) or 1

    if not item_data then
        windower.add_to_chat(207, '[Error] Item not found in resources.')
        return
    end

    windower.add_to_chat(123, 'Detected that you dropped a "%s" x%d':format(item_data.en, quantity))

    windower.send_command('treasury drop add '..item_data.en)
end)

-- أمر لتفعيل أو تعطيل AutoDrop
windower.register_event('addon command', function(command, ...)
    local args = {...}
    if command:lower() == 'toggle' then
        state.AutoDropItem.value = not state.AutoDropItem.value
        windower.add_to_chat(207, 'AutoDropItem: ' .. (state.AutoDropItem.value and 'Enabled' or 'Disabled'))
    elseif command:lower() == 'status' then
        windower.add_to_chat(207, 'AutoDropItem is currently: ' .. (state.AutoDropItem.value and 'Enabled' or 'Disabled'))
    else
        windower.add_to_chat(207, 'Invalid command. Use "//autodrop toggle" or "//autodrop status".')
    end
end)