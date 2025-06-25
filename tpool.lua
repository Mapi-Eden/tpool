_addon.name = 'Treasure Pool'
_addon.author = 'Maptwo'
_addon.version = '5.0.10'

if(ashita)then
    print("Ashita")
    require 'common'
    require 'core'
    Countdown =  require 'time_functions'
end
if(windower)then
    print("Windower")
end

require 'tpool_functions'
require 'items'

local Treasure_Time = {
    [0] = {ItemId = nil, Time = nil, Drop_Time = nil},
    [1] = {ItemId = nil, Time = nil, Drop_Time = nil},
    [2] = {ItemId = nil, Time = nil, Drop_Time = nil},
    [3] = {ItemId = nil, Time = nil, Drop_Time = nil},
    [4] = {ItemId = nil, Time = nil, Drop_Time = nil},
    [5] = {ItemId = nil, Time = nil, Drop_Time = nil},
    [6] = {ItemId = nil, Time = nil, Drop_Time = nil},
    [7] = {ItemId = nil, Time = nil, Drop_Time = nil},
    [8] = {ItemId = nil, Time = nil, Drop_Time = nil},
    [9] = {ItemId = nil, Time = nil, Drop_Time = nil}
}

local default_config =
{
    font =
    {
        family      = 'Arial',
        size        = 10,
        color       = 0xFFFF0000,
        position    = { 50, 125 },
        bgcolor     = 0x80000000,
        bgvisible   = true
    }
};
local pool_config = default_config
local local_pool = {
    [0] = {Name = nil, ItemId = nil},
    [1] = {Name = nil, ItemId = nil},
    [2] = {Name = nil, ItemId = nil},
    [3] = {Name = nil, ItemId = nil},
    [4] = {Name = nil, ItemId = nil},
    [5] = {Name = nil, ItemId = nil},
    [6] = {Name = nil, ItemId = nil},
    [7] = {Name = nil, ItemId = nil},
    [8] = {Name = nil, ItemId = nil},
    [9] = {Name = nil, ItemId = nil}
}

function Time_To_Drop(future_time)
    if(future_time == nil) then
        return nil
    else
        local current_time = os.time()
        local time_to_drop = future_time - current_time
        local minutes_left = math.floor(time_to_drop / 60)
        local seconds_left = time_to_drop % 60
        if(seconds_left<10) then
            seconds_left = '0' .. seconds_left
        end
        return string.format("%s:%s",tostring(minutes_left),tostring(seconds_left))
    end
end
function Future_Time(futuretime)
    local current_time = os.time()
    local futuretime = current_time + futuretime
    local time_string = os.date("%I:%M:%S",futuretime)
    return time_string
end

function HowLongAgo(date)
    local msg = "";
    local now = os.time();
    local past = date;
    local diff = now - past;
    local dTime = 86400;
    local hTime = 3600;
    local days = math.floor(diff / dTime );
    local hours = math.floor((diff - days * dTime) / hTime);
    local minutes = math.floor((diff - days * (dTime) - hours * (hTime)) / 60);
    if(days>0) then
        if days>1 then
        msg = string.format("%i days",days)
        else
        msg = string.format("%i day",days)
        end
    end
    if(hours>0) then
        if hours>1 then
        msg = msg .. string.format(" %i hours",hours)
        
        else
            msg = msg .. string.format(" %i hour",hours)
        end
    end
    if minutes then
        msg = msg .. string.format(" %i minutes",minutes)
    end
    msg =  msg .. ' ago'
    msg = string.trimstart(msg)
    return msg
end

function Draw_Box()
    local area = AshitaCore:GetResourceManager():GetString("areas",AshitaCore:GetDataManager():GetParty():GetMemberZone(0))
    local pool_box = AshitaCore:GetFontManager():Get('__pool_box');
    local box_text = string.format('|cFF00FF00|Loot Table - (|cFFFFFF00|%s|cFF00FF00|)', area)
    local playerEntity = GetPlayerEntity()
    if(playerEntity) then

        for i = 0, 9, 1 do
            local treasure_item = AshitaCore:GetDataManager():GetInventory():GetTreasureItem(i)
            if(treasure_item) then
                local item = AshitaCore:GetResourceManager():GetItemById(treasure_item.ItemId)
                if(item) then
                    if(table.haskey(Item_List,item.ItemId) == true)then
                        local item = Item_List[item.ItemId]
                        local Name = item.name
                        local Slot = item.slot
                        local Job = item.job
                        local lot = treasure_item.WinningLot
                        if(treasure_item.WinningLotterName ~= "") then
                            local winner = treasure_item.WinningLotterName
                            local drop_time = Time_To_Drop(Treasure_Time[i].Drop_Time)
                            --|cFFfc7b03| Orange
                            --|cFF42bff5| blue 
                            --|cFF98f542| green
                            --|cFFca03fc| purple
                            box_text = box_text .. string.format("\n|cFF42bff5|[%s]|cFF98f542| %s - %s - %s (|cFFfc7b03|%s - %i|cFF98f542|)",drop_time,Name, Job,Slot,winner,lot)
                        else
                            local drop_time = Time_To_Drop(Treasure_Time[i].Drop_Time)
                            box_text = box_text .. string.format("\n|cFF42bff5|[%s]|cFF98f542| %s - %s - %s",drop_time,Name, Job,Slot)
                        end
                    else
                        local Name = item.Name[0]
                        local lot = treasure_item.WinningLot
                        if(treasure_item.WinningLotterName ~= "") then
                            local winner = treasure_item.WinningLotterName
                            local drop_time = Time_To_Drop(Treasure_Time[i].Drop_Time)
                            if(drop_time) then
                            box_text = box_text .. string.format("\n|cFF42bff5|[%s]|cFF98f542| %s (|cFFfc7b03|%s - %i|cFF98f542|)",drop_time,Name,winner,lot)
                            end
                        else
                            local drop_time = Time_To_Drop(Treasure_Time[i].Drop_Time)
                            if(drop_time) then
                            box_text = box_text .. string.format("\n|cFF42bff5|[%s]|cFF98f542| %s",drop_time,Name)
                            end
                        end
                    end
                end
            end
        end
        pool_box:SetText(box_text);
    end
end


ashita.register_event('load', function()
    pool_config = ashita.settings.load_merged(_addon.path .. 'settings/settings.json', pool_config);
    local pool_box = AshitaCore:GetFontManager():Create('__pool_box');
    pool_box:SetColor(pool_config.font.color);
    pool_box:SetFontFamily(pool_config.font.family);
    pool_box:SetFontHeight(pool_config.font.size);
    pool_box:SetBold(false);
    pool_box:SetPositionX(pool_config.font.position[1]);
    pool_box:SetPositionY(pool_config.font.position[2]);
    pool_box:SetText('Loot Table');
    pool_box:SetVisibility(true);
    pool_box:GetBackground():SetColor(pool_config.font.bgcolor);
    pool_box:GetBackground():SetVisibility(pool_config.font.bgvisible);
end);

ashita.register_event('unload', function()
    local pool_box = AshitaCore:GetFontManager():Create('__pool_box');
    pool_config.font.position = { pool_box:GetPositionX(), pool_box:GetPositionY() };
        
    -- Save the configuration..
    ashita.settings.save(_addon.path .. 'settings/settings.json', pool_config);
    
    -- Unload our font object..
    AshitaCore:GetFontManager():Delete('__pool_box');
end);



-- | cFF     00     FF      00|
--  Alpha    Red    Green   Blue

ashita.register_event('render', function()
    local playerEntity = GetPlayerEntity()
    if(playerEntity) then
        Draw_Box()
    end
end);

ashita.register_event('incoming_packet', function(id, size, packet, packet_modified, blocked)
    local playerEntity = GetPlayerEntity()
    if (id == 0x0D2) then --Item Dropped Packet
		if (playerEntity == nil) then
			return false
		end
		local packet_data = {
			Dropper = struct.unpack('I', packet, 0x08),
			Count = struct.unpack('I', packet, 0x0C),
			Item = struct.unpack('H', packet, 0x10+1),
			Dropper_Index = struct.unpack('H', packet, 0x12),
			Index = struct.unpack('h', packet, 0x14+1)
		}
    Treasure_Time[packet_data.Index].ItemId = packet_data.Item
    Treasure_Time[packet_data.Index].Time = os.time()
    Treasure_Time[packet_data.Index].Drop_Time = os.time() + (5*60)
    end
    return false
end);