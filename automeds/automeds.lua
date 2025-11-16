_addon.name = 'Automeds'
_addon.version = '1.0.25'
_addon.author = 'Multi'
_addon.command = 'automeds'

require('tables')
require('strings')
require('logger')
require('sets')
config = require('config')
chat = require('chat')
res = require('resources')

defaults = {}
defaults.buffs = S{"poison","amnesia","curse","disease","doom","paralysis","plague","silence",
"Defense Down","Magic Def. Down", "Evasion Down","Max HP Down","Attack Down",
 "STR Down" ,"VIT Down", "MND Down", "MND Down", "INT Down", "AGI Down",
 "Dia","Bio", "Bind", "slow"
 }
defaults.alttrack = false
defaults.sitrack = false

settings = config.load(defaults)

automeds = true

-- Debuff to item mappings
local debuff_items = {
["amnesia"] = "Panacea",
["curse"] = "Holy Water",
["disease"] = "Remedy",
["doom"] = "Holy Water",
["paralysis"] = "Remedy",
["plague"] = "Remedy",
["silence"] = "Remedy",
["poison"] = "Remedy",
["silence"] = "Remedy",
["Defense Down"] = "Panacea",
["Magic Def. Down"] = "panacea",
["Max HP Down"] = "panacea",
["Evasion Down"] = "panacea",
["Magic Evasion Down"] = "panacea",
["Dia"] = "panacea",
["Bio"] = "panacea",
["Bind"] = "panacea",
["slow"] = "panacea",
["weight"] = "panacea",
["Attack Down"] = "panacea",
["VIT Down"] = "panacea",
["INT Down"] = "panacea",
["MND Down"] = "panacea",
["STR Down"] = "panacea",
["AGI Down"] = "panacea",

}

-- Retry handling
local retry_delay = 4 -- retry in seconds
local last_retry_time = os.clock()
local active_debuff = nil
local missing_item_alerts = {}

-- Retry medicine continuously until debuff is cleared
windower.register_event('prerender', function()
if not automeds then return end

local player = windower.ffxi.get_player()
if not player or not player.buffs then return end

local found_buff = false

for _, buff_id in ipairs(player.buffs) do
local buff_name = res.buffs[buff_id] and res.buffs[buff_id].english:lower()
if buff_name and settings.buffs:contains(buff_name) then
local item = debuff_items[buff_name]
if item and os.clock() - last_retry_time > retry_delay then
-- Check if the medicine exists in inventory
local inventory = windower.ffxi.get_items().inventory
local has_item = false

for _, slot in pairs(inventory) do
if type(slot) == "table" and slot.id and slot.id > 0 then
local item_res = res.items[slot.id]
if item_res and item_res.name and item_res.name:lower() == item:lower() and slot.count > 0 then
has_item = true
break
end
end
end

if has_item then
windower.add_to_chat(207, 'Using '..item..' for '..buff_name)
windower.send_command('input /item "'..item..'" '..player.name)
last_retry_time = os.clock()
missing_item_alerts[buff_name] = nil -- reset alert if item becomes available
elseif not missing_item_alerts[buff_name] then
windower.add_to_chat(123, 'Missing item "'..item..'" for debuff: '..buff_name)
missing_item_alerts[buff_name] = true
end
end
active_debuff = buff_name
found_buff = true
break
end
end

if not found_buff then
active_debuff = nil
end
end)

-- Stop tracking once debuff is cleared
windower.register_event('lose buff', function(id)
local name = res.buffs[id].english:lower()
if name == active_debuff then
windower.add_to_chat(207, 'Debuff "'..name..'" cleared.')
active_debuff = nil
end
end)

-- Trigger once + alt notifications
windower.register_event('gain buff', function(id)
local name = res.buffs[id].english:lower()
if settings.buffs:contains(name) then
if name == 'silence' and automeds then
windower.send_command('input /item "Remedy" '..windower.ffxi.get_player().name)
end
if settings.alttrack then
windower.send_command('send @others atc '..windower.ffxi.get_player().name..' - '..name)
end
end
end)

-- Invisible/Sneak wear tracking
windower.register_event('incoming text', function(old,new,color)
if settings.sitrack then
local _,_,txt = string.find(new,'The effect of ([%w]+) is about to wear off.')
if txt then
windower.send_command('@send @others atc '..windower.ffxi.get_player().name..' - '..txt..' wearing off.')
end
end
return new,color
end)

windower.register_event('addon command', function(...)
local args = {...}
if not args[1] then return end
local cmd = args[1]:lower()

if cmd == 'help' then
windower.add_to_chat(208, '[Automeds] Commands:')
windower.add_to_chat(208, '//automeds watch [buffname] - Adds buff to tracker')
windower.add_to_chat(208, '//automeds unwatch [buffname] - Removes buff from tracker')
windower.add_to_chat(208, '//automeds trackalt - Toggles alt message broadcast')
windower.add_to_chat(208, '//automeds sitrack - Toggles Sneak/Invisible wear message')
windower.add_to_chat(208, '//automeds list - Displays tracked debuffs')
windower.add_to_chat(208, '//automeds toggle - Turns automatic medicine use on/off')

elseif cmd == 'watch' and args[2] then
local buff = table.concat(args, ' ', 2):lower()
if not settings.buffs:contains(buff) then
settings.buffs:add(buff)
settings:save()
windower.add_to_chat(207, 'Tracking buff: '..buff)
else
windower.add_to_chat(207, buff..' is already being tracked')
end

elseif cmd == 'unwatch' and args[2] then
local buff = table.concat(args, ' ', 2):lower()
if settings.buffs:contains(buff) then
settings.buffs:remove(buff)
settings:save()
windower.add_to_chat(207, 'Stopped tracking buff: '..buff)
else
windower.add_to_chat(207, buff..' is not currently tracked')
end

elseif cmd == 'trackalt' then
settings.alttrack = not settings.alttrack
settings:save()
windower.add_to_chat(207, 'Alt tracking: '..tostring(settings.alttrack))

elseif cmd == 'sitrack' then
settings.sitrack = not settings.sitrack
settings:save()
windower.add_to_chat(207, 'Invisible/Sneak tracker: '..tostring(settings.sitrack))

elseif cmd == 'list' then
windower.add_to_chat(207, 'Tracked debuffs:')
for buff in settings.buffs:it() do
windower.add_to_chat(207, ' - '..buff)
end

elseif cmd == 'toggle' then
automeds = not automeds
windower.add_to_chat(207, 'Auto medicine use is now: '..tostring(automeds))

else
windower.add_to_chat(207, 'Invalid command. Use //automeds help for available options')
end
end)
