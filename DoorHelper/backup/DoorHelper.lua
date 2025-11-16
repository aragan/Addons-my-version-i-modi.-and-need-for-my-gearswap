_addon.name = 'DoorHelper'
_addon.author = 'assistant'
_addon.version = '1.0'
_addon.commands = {'doorhelper','dh'}

packets = require('packets')

-- آخر Menu ID معروف
local last_menu_id = 0
local auto_busy = false

-- دالة المسافة
local function get_distance(a,b)
    if not a or not b then return 999 end
    return math.sqrt((a.x-b.x)^2 + (a.y-b.y)^2)
end

-- poke الباب
local function poke(target)
    if not target then return end
    local packet = packets.new('outgoing',0x01A,{
        ["Target"]=target.id,
        ["Target Index"]=target.index,
        ["Category"]=0,
        ["Param"]=0,
        ["_unknown1"]=0
    })
    packets.inject(packet)
end

-- اختيار نعم بالباكيت
local function select_yes(target)
    if not target or last_menu_id==0 then return end
    local zone = windower.ffxi.get_info().zone
    local yes_packet = packets.new('outgoing',0x05B,{
        ["Target"]=target.id,
        ["Target Index"]=target.index,
        ["Option Index"]=1,
        ["_unknown1"]=0,
        ["Zone"]=zone,
        ["Menu ID"]=last_menu_id
    })
    packets.inject(yes_packet)
end

-- البحث عن أقرب باب
local function find_nearest_door()
    local player = windower.ffxi.get_mob_by_target('me')
    if not player then return nil end
    local mobs = windower.ffxi.get_mob_array()
    local nearest, min_dist = nil, 3.2
    for _, mob in pairs(mobs) do
        if mob and mob.name and mob.is_npc then
            if mob.name:lower():find('door',1,true) then
                local dist = get_distance(player,mob)
                if dist < min_dist then
                    nearest = mob
                    min_dist = dist
                end
            end
        end
    end
    return nearest
end

-- التقاط Menu ID من الحزمة الواردة
windower.register_event('incoming chunk', function(id,data)
    if id==0x034 then
        local p = packets.parse('incoming',data)
        if p and p['Menu ID'] and p['Menu ID']>0 then
            last_menu_id = p['Menu ID']
            windower.add_to_chat(200,'[DoorHelper] Detected Menu ID: '..last_menu_id)
        end
    end
end)

-- معالجة الأبواب كل فريم تقريبًا
windower.register_event('prerender', function()
    if auto_busy then return end
    auto_busy = true

    local door = find_nearest_door()
    if door then
        windower.add_to_chat(200,'[DoorHelper] Found door '..door.name)
        poke(door)
        -- بعد 1.2 ثانية تقريبًا، استخدم Menu ID لفتح الخيار نعم
        coroutine.schedule(function()
            select_yes(door)
            windower.add_to_chat(200,'[DoorHelper] Pressed Yes on '..door.name)
            auto_busy=false
        end,1.2)
    else
        auto_busy=false
    end
end)
