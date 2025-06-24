_addon.name = 'Treasure Pool'
_addon.author = 'Maptwo'
_addon.version = '5.0.9'

if(ashita)then
    print("Ashita")
    require 'common'
    require 'core'
end
if(windower)then
    print("Windower")
end

require 'tpool_functions'
require 'dyna_items'


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
    },
    activeDyna = false
};
local dyna_config = default_config
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
    local in_dyna = string.startswith(area,"Dyna")
    local dyna_box = AshitaCore:GetFontManager():Get('__dyna_box');
    local box_text = string.format('|cFF00FF00|Loot Table - (|cFFFFFF00|%s|cFF00FF00|)', area)
    local playerEntity = GetPlayerEntity()
    if(playerEntity) then

        for i = 0, 9, 1 do
            local treasure_item = AshitaCore:GetDataManager():GetInventory():GetTreasureItem(i)
            if(treasure_item) then
                local item = AshitaCore:GetResourceManager():GetItemById(treasure_item.ItemId)
                if(item) then
                    if(in_dyna == true and table.haskey(Dyna_Items,item.ItemId) == true)then
                            local dyna_item = Dyna_Items[item.ItemId]
                            local Name = dyna_item.name
                            local Slot = dyna_item.slot
                            local Job = dyna_item.job
                            local lot = treasure_item.WinningLot
                            if(treasure_item.WinningLotterName ~= "") then
                                local winner = treasure_item.WinningLotterName
                                --|cFFfc7b03| Orange
                                --|cFF42bff5| blue 
                                --|cFF98f542| green
                                --|cFFca03fc| purple
                                box_text = box_text .. string.format("\n|cFF42bff5|[%i]|cFF98f542| %s - %s - %s (|cFFfc7b03|%s - %i|cFF98f542|)",i,Name, Job,Slot,winner,lot)
                            else
                                box_text = box_text .. string.format("\n|cFF42bff5|[%i]|cFF98f542| %s - %s - %s",i,Name, Job,Slot)
                            end
                        else
                            local Name = item.Name[0]
                            local lot = treasure_item.WinningLot
                            if(treasure_item.WinningLotterName ~= "") then
                                local winner = treasure_item.WinningLotterName
                                box_text = box_text .. string.format("\n|cFF42bff5|[%i]|cFF98f542| %s (|cFFfc7b03|%s - %i|cFF98f542|)",i,Name,winner,lot)
                            else
                                box_text = box_text .. string.format("\n|cFF42bff5|[%i]|cFF98f542| %s",i,Name)
                            end
                    end
                end
            end
        end
        dyna_box:SetText(box_text);
    end
end


ashita.register_event('load', function()
    dyna_config = ashita.settings.load_merged(_addon.path .. 'settings/settings.json', dyna_config);
    local dyna_box = AshitaCore:GetFontManager():Create('__dyna_box');
    dyna_box:SetColor(dyna_config.font.color);
    dyna_box:SetFontFamily(dyna_config.font.family);
    dyna_box:SetFontHeight(dyna_config.font.size);
    dyna_box:SetBold(false);
    dyna_box:SetPositionX(dyna_config.font.position[1]);
    dyna_box:SetPositionY(dyna_config.font.position[2]);
    dyna_box:SetText('Loot Table');
    dyna_box:SetVisibility(true);
    dyna_box:GetBackground():SetColor(dyna_config.font.bgcolor);
    dyna_box:GetBackground():SetVisibility(dyna_config.font.bgvisible);
end);

ashita.register_event('unload', function()
    local dyna_box = AshitaCore:GetFontManager():Create('__dyna_box');
    dyna_config.font.position = { dyna_box:GetPositionX(), dyna_box:GetPositionY() };
        
    -- Save the configuration..
    ashita.settings.save(_addon.path .. 'settings/settings.json', dyna_config);
    
    -- Unload our font object..
    AshitaCore:GetFontManager():Delete('__dyna_box');
end);



-- | cFF     00     FF      00|
--  Alpha    Red    Green   Blue

ashita.register_event('render', function()
    local playerEntity = GetPlayerEntity()
    if(playerEntity) then
        Draw_Box()
    end
end);