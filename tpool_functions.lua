-- | cFF     00     FF      00|
--  Alpha    Red    Green   Blue


function Time_To_Drop(future_time,split)
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
        if(split) then
            return minutes_left,seconds_left
        else
            return string.format("%s:%s",tostring(minutes_left),tostring(seconds_left))
        end
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
    if(pool_config.dyna_timer.active == true) then
        if(pool_config.dyna_timer.value ~= 0) then
        box_text =box_text .. string.format('(|cFFca03fc| %s|cFF98f542| )', tostring(Time_To_Drop(pool_config.dyna_timer.value)))
        else
            pool_config.dyna_timer.active = false
        end
    end
    
    local playerEntity = GetPlayerEntity()
    if(playerEntity) then

        for i = 0, 9, 1 do
            local treasure_item = AshitaCore:GetDataManager():GetInventory():GetTreasureItem(i)
            local drop_time = Time_To_Drop(Treasure_Time[i].Drop_Time)
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
                            
                            --|cFFfc7b03| Orange
                            --|cFF42bff5| blue 
                            --|cFF98f542| green
                            --|cFFca03fc| purple
                            if(drop_time~=nil) then
                                box_text = box_text .. string.format("\n|cFF42bff5|[%s]|cFF98f542| %s - %s - %s (|cFFfc7b03|%s - %i|cFF98f542|)",drop_time,Name, Job,Slot,winner,lot)
                            else
                                box_text = box_text .. string.format("\n|cFF42bff5|[n/a]|cFF98f542| %s - %s - %s (|cFFfc7b03|%s - %i|cFF98f542|)",Name, Job,Slot,winner,lot)
                            end
                        else
                            
                            if(drop_time~=nil) then
                                box_text = box_text .. string.format("\n|cFF42bff5|[%s]|cFF98f542| %s - %s - %s",drop_time,Name, Job,Slot)
                            else
                                box_text = box_text .. string.format("\n|cFF42bff5|[n/a]|cFF98f542| %s - %s - %s",Name, Job,Slot)
                            end
                        end
                    else
                        local Name = item.Name[0]
                        local lot = treasure_item.WinningLot
                        if(treasure_item.WinningLotterName ~= "") then
                            local winner = treasure_item.WinningLotterName
                            
                            if(drop_time) then
                                box_text = box_text .. string.format("\n|cFF42bff5|[%s]|cFF98f542| %s (|cFFfc7b03|%s - %i|cFF98f542|)",drop_time,Name,winner,lot)
                            else
                                box_text = box_text .. string.format("\n|cFF42bff5|[n/a]|cFF98f542| %s (|cFFfc7b03|%s - %i|cFF98f542|)",Name,winner,lot)
                            end
                        else
                            
                            if(drop_time) then
                                box_text = box_text .. string.format("\n|cFF42bff5|[%s]|cFF98f542| %s",drop_time,Name)
                            else
                                box_text = box_text .. string.format("\n|cFF42bff5|[n/a]|cFF98f542| %s",Name)
                            end
                        end
                    end
                end
            end
        end
        pool_box:SetText(box_text);
    end
end