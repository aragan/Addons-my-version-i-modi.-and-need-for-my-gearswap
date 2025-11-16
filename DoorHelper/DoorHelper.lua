_addon.name = 'DoorHelper'
_addon.author = 'Aragan'
_addon.version = '1.0'
_addon.commands = {'doorhelper', 'dh'}

packets = require('packets')
config = require('config')

-- Last known Menu ID
local last_menu_id = 0
local auto_busy = false
local last_door_id = nil -- To track the last door interacted with
local door_message_shown = false -- To track if the message for the current door has been displayed

-- Distance function
local function get_distance(a, b)
    if not a or not b then return 999 end
    return math.sqrt((a.x - b.x)^2 + (a.y - b.y)^2)
end

-- Poke the door
local function poke(target)
    if not target then return end
    local packet = packets.new('outgoing', 0x01A, {
        ["Target"] = target.id,
        ["Target Index"] = target.index,
        ["Category"] = 0,
        ["Param"] = 0,
        ["_unknown1"] = 0
    })
    packets.inject(packet)
end

-- Select "Yes" via packet
local function select_yes(target)
    if not target or last_menu_id == 0 then return end
    local zone = windower.ffxi.get_info().zone
    local yes_packet = packets.new('outgoing', 0x05B, {
        ["Target"] = target.id,
        ["Target Index"] = target.index,
        ["Option Index"] = 1,
        ["_unknown1"] = 0,
        ["Zone"] = zone,
        ["Menu ID"] = last_menu_id
    })
    packets.inject(yes_packet)
end

-- Find the nearest door
local function find_nearest_door()
    local player = windower.ffxi.get_mob_by_target('me')
    if not player then return nil end
    local mobs = windower.ffxi.get_mob_array()
    local nearest, min_dist = nil, 3.2
    for _, mob in pairs(mobs) do
        if mob and mob.name and mob.is_npc then
            if mob.name:lower():find('door', 1, true) then
                local dist = get_distance(player, mob)
                if dist < min_dist then
                    nearest = mob
                    min_dist = dist
                end
            end
        end
    end
    return nearest
end

-- Capture Menu ID from incoming packet
windower.register_event('incoming chunk', function(id, data)
    if id == 0x034 then
        local p = packets.parse('incoming', data)
        if p and p['Menu ID'] and p['Menu ID'] > 0 then
            last_menu_id = p['Menu ID']
            windower.add_to_chat(200, '[DoorHelper] Detected Menu ID: ' .. last_menu_id)
        
        end
    end
end)

-- Handle doors on almost every frame
windower.register_event('prerender', function()
    if auto_busy then return end
    auto_busy = true

    local door = find_nearest_door()
    if door then
        -- Check if the current door is different from the previous door
        if last_door_id ~= door.id then
            last_door_id = door.id -- Update the last door interacted with
            door_message_shown = false -- Reset the message state
        end

        -- Display the message only once
        if not door_message_shown then
            windower.add_to_chat(200, '[DoorHelper] Found door ' .. door.name)
            door_message_shown = true
        end

        poke(door)
        -- After approximately 1.2 seconds, use the Menu ID to select "Yes"
        coroutine.schedule(function()
            select_yes(door)
            -- windower.add_to_chat(200, '[DoorHelper] Pressed Yes on ' .. door.name)
            door_message_shown = true
            auto_busy = false
        end, 1.2)
    else
        auto_busy = false
    end
end)
