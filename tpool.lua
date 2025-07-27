_addon.name = 'Treasure Pool'
_addon.author = 'Maptwo'
_addon.version = '5.0.14.4'


print("Ashita")
require 'common'
require 'core'
require 'stringex'
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

local default_config ={
    font =
    {
        family      = 'Arial',
        size        = 10,
        color       = 0xFFFF0000,
        position    = { 50, 125 },
        bgcolor     = 0x80000000,
        bgvisible   = true
    },
    dyna_timer = {
        active = false,
        value = 0
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


ashita.register_event('render', function()
    local playerEntity = GetPlayerEntity()
    if(playerEntity) then
        Draw_Box()
    end
end);

if(GetPlayerEntity()) then
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
            if(packet_data.Item~=0) then
                Treasure_Time[packet_data.Index].ItemId = packet_data.Item
                Treasure_Time[packet_data.Index].Time = os.time()
                Treasure_Time[packet_data.Index].Drop_Time = os.time() + (5*60)
                local h,m = Time_To_Drop(Treasure_Time[packet_data.Index].Drop_Time,true)
                
            end
        end

        if (id == 0x029) then --Action Message Packet
            local pack_data = {
                Actor = struct.unpack('I', packet, 0x04),
                Target = struct.unpack('I', packet, 0x08),
                Param_1 = struct.unpack('I', packet, 0x0C +1),
                Param_2 = struct.unpack('I', packet, 0x10 +1),
                Actor_Index = struct.unpack('H', packet,0x14 ),
                Target_Index = struct.unpack('H', packet,0x16 ),
                Message = struct.unpack('H', packet,0x18 +1)
            }

		--Dynamis Time Extended
            if(pack_data.Message == 448 ) then
                if(pool_config.dyna_timer.active == true) then
                    pool_config.dyna_timer.value = pool_config.dyna_timer.value + (pack_data.Param_1*60)
                end
            end
            

            if(pack_data.Message == 449) then
                if(pool_config.dyna_timer.active == true) then
                    pool_config.dyna_timer.value = pack_data.Param_1*60
                end
            end
            pack_data = nil
		return false
	end

        return false
    end);
end

ashita.register_event('command', function(command, ntype)
    local args = command:args();
    if(args[1] == nil) then
        return false;
    end;
    local cmd = args[1];
    cmd = cmd:lower();
    if(cmd == '/tp')then
        if(args[2] == "start" )then
            local start_arg = args
            local timer_sec = nil
            local timer_min = nil
            local timer_hour =nil
            local timer_total = 0

            table.remove(start_arg,1)
            table.remove(start_arg,1)
            for i = 1, #start_arg, 1 do
                local tmp_len = nil    
                if(string.contains(start_arg[i],"h"))then
                    tmp_len =string.len(start_arg[i])
                    timer_hour = string.remove(start_arg[i],tmp_len)
                    
                end
                if(string.contains(start_arg[i],"m"))then
                    tmp_len =string.len(start_arg[i])
                    timer_min = string.remove(start_arg[i],tmp_len)
                end
                if(string.contains(start_arg[i],"s"))then
                    tmp_len =string.len(start_arg[i])
                    timer_sec = string.remove(start_arg[i],tmp_len)
                end
                
                
            end
            
            if(timer_hour ~= nil)then
                timer_total = timer_total + (timer_hour*3600)
            end
            if(timer_min ~= nil)then
                timer_total = timer_total + (timer_min*60)
            end
            if(timer_sec ~= nil)then
                timer_total = timer_total + (timer_sec)
            end
            
            if(timer_total~=0)then
                print(string.format("Timer started: %i Hour %i Min %i Sec",timer_hour,timer_min,timer_sec))
                pool_config.dyna_timer.value = os.time() + timer_total
                pool_config.dyna_timer.active = true
            else
                print("Timer Started: 1 Hour")
                pool_config.dyna_timer.active = true
                pool_config.dyna_timer.value = os.time() + (60*60)
            end
        
            
        end
        if(args[2] == "stop" )then
            pool_config.dyna_timer.active = false
            pool_config.dyna_timer.value = 0
        end
        if(args[2] == "te" )then
            if(args[3])then
                local time_extension = tonumber(args[3])
                if(type(time_extension) =="number")then
                    print(time_extension)
                    pool_config.dyna_timer.value = pool_config.dyna_timer.value + (time_extension*60)
                end
            end
        end    
    end
    return false
end);