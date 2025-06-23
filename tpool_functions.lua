Step_Msg = { [1] = "75",  [2] = "70+",    [3] = "65+",    [4] = "Free"}
TreasurePool = {
    [0] = {id = nil,        name = nil,        job = nil,        slot= nil,        active = false,        highest_lotter = nil,item = {},step = 0 , ttl = nil },
    [1] = {id = nil,        name = nil,        job = nil,        slot= nil,        active = false,        highest_lotter = nil,item = {},step = 0, ttl = nil},
    [2] = {id = nil,        name = nil,        job = nil,        slot= nil,        active = false,        highest_lotter = nil,item = {},step = 0, ttl = nil}, 
    [3] = {id = nil,        name = nil,        job = nil,        slot= nil,        active = false,        highest_lotter = nil,item = {},step = 0, ttl = nil},
    [4] = {id = nil,        name = nil,        job = nil,        slot= nil,        active = false,        highest_lotter = nil,item = {},step = 0, ttl = nil},
    [5] = {id = nil,        name = nil,        job = nil,        slot= nil,        active = false,        highest_lotter = nil,item = {},step = 0, ttl = nil},
    [6] = {id = nil,        name = nil,        job = nil,        slot= nil,        active = false,        highest_lotter = nil,item = {},step = 0, ttl = nil},
    [7] = {id = nil,        name = nil,        job = nil,        slot= nil,        active = false,        highest_lotter = nil,item = {},step = 0, ttl = nil},
    [8] = {id = nil,        name = nil,        job = nil,        slot= nil,        active = false,        highest_lotter = nil,item = {},step = 0, ttl = nil},
    [9] = {id = nil,        name = nil,        job = nil,        slot= nil,        active = false,        highest_lotter = nil,item = {},step = 0, ttl = nil}
}


local Packet_Data = {
    Actor = '',
    Actor_Index ='',
    Target = '',
    Target_Index =          '',
    Param_1 =               '',
    Param_2 =               '',
    Message =               '',
    Dropper =               '',
    Count =                 '',
    Item =                  '',
    Index =                 '',
    Drop = 					'',
    Dropper_Index =         '',
    Highest_Lot = 			'',
    Highest_Lotter = 		'',
    Highest_Lotter_Name = 	'',
    Highest_Lotter_Index = 	'',
    Current_Lot = 			'',
    Current_Lotter = 		'',
    Current_Lotter_Name =	'',
    Current_Lotter_Index = 	'',
    WinningLotterName =		'',
    Job =					'',
    Slot =					'',
    ItemId =				'',
    Area	=				'',
    Name =					'',
    LongName	=		''
}
function Send_Chat(msg)
    if(msg ~= nil) then
        ashita.core.queuecommand(msg,1)
    else
        print("msg is nil")
    end
end


function Time_stamp(msg)
    local format = "%H:%M:%S"
    local timestamp = os.date(string.format('[%s]', format));
    return string.format("%s %s",timestamp,msg)
end

function WriteToLog(msg)
    if(msg) then
        local area = AshitaCore:GetResourceManager():GetString("areas",AshitaCore:GetDataManager():GetParty():GetMemberZone(0))
        local date = string.gsub((os.date("%x")),"/","-")
        local data_dir = _addon.path .. '/data/'
        local data_file = io.open(string.format("%s%s-%s.txt",data_dir,area,date),"a+")
        io.output(data_file)
        io.write(Time_stamp(msg .. "\n"))
        io.close(data_file)
    else
        print("msg is nil")
    end
end

function Announce(msg)
    if(msg)then
        for key, value in pairs(settings.chat_mode) do --chat_mode
            if(value.enabled == true)then
                Send_Chat(string.format("%s %s",value.command,msg))
                coroutine.sleep(3)
            end
        end
    else
        print("Error")
    end
end

function Check_DynaItem(id)
    if(Dyna_Items[id])then
        return true
    else
        return false
    end
end


function Update_Timer(index,msg)
    if(index~=nil and type(index) == 'number')then
        if(index == 0)then
            timers.item_0 = msg
        elseif(index == 1)then
            timers.item_1 = msg
        elseif(index == 2)then
            timers.item_2 = msg
        elseif(index == 3)then
            timers.item_3 = msg
        elseif(index == 4)then
            timers.item_4 = msg
        elseif(index == 5)then
            timers.item_5 = msg
        elseif(index == 6)then
            timers.item_6 = msg
        elseif(index == 7)then
            timers.item_7 = msg
        elseif(index == 8)then
            timers.item_8 = msg
        elseif(index == 9)then
            timers.item_9 = msg
        end
    end
end

function Update_Item(index,msg)
    if(TreasurePool[index].active==true)then
        updateTimer(index,msg)
    end
    if(index~=nil and type(index) == 'number')then
        if(index == 0)then
            box.item_0 = msg
        elseif(index == 1)then
            box.item_1 = msg
        elseif(index == 2)then
            box.item_2 = msg
        elseif(index == 3)then
            box.item_3 = msg
        elseif(index == 4)then
            box.item_4 = msg
        elseif(index == 5)then
            box.item_5 = msg
        elseif(index == 6)then
            box.item_6 = msg
        elseif(index == 7)then
            box.item_7 = msg
        elseif(index == 8)then
            box.item_8 = msg
        elseif(index == 9)then
            box.item_9 = msg
        end
    end
end




function Timer_Loop(index,item)
    TreasurePool[index].active = true    
    
    local loop_item = Dyna_Items[item]
    while (TreasurePool[index].active == true and TreasurePool[index].step <=4) do
        if(TreasurePool[index].highest_lotter==nil) then
            --wprint(string.format("Drop: %s %s %s %s",loop_item.name,loop_item.slot,loop_item.job,defaults.time_msg[TreasurePool[index].step])) --75)
            Announce(string.format("Drop: %s %s %s %s",loop_item.name,loop_item.slot,loop_item.job,settings.time_msg[TreasurePool[index].step])) --75
            Update_Item(index,string.format("%s - %s - %s",TreasurePool[index].name,TreasurePool[index].job,step_msg[TreasurePool[index].step]))
            TreasurePool[index].step = TreasurePool[index].step + 1
            coroutine.sleep(30)
            if(TreasurePool[index].highest_lotter~=nil) then
                
                TreasurePool[index].active = false
                Announce(string.format('Current High Lotter: %s for %s',TreasurePool[index].highest_lotter,loop_item.name))
                break
            end
        end
    end
end
function Update_modes()
    local cm = {
        ls = nil,
        ls2 = nil,
        p = nil,
        sh = nil,
        auto  = nil
    }
    
    if(settings.auto_pass == true) then
        cm.auto = '\\cs(96, 222, 47)O'
    else
        cm.auto = "\\cs(222, 47, 47)X"
    end
    if(settings.chat_mode.linkshell.enabled == true) then
        cm.ls = '\\cs(96, 222, 47)O'
    else
        cm.ls = "\\cs(222, 47, 47)X"
    end
    if(settings.chat_mode.linkshell2.enabled == true) then
        cm.ls2 = '\\cs(96, 222, 47)O'
    else
        cm.ls2 = "\\cs(222, 47, 47)X"
    end
    if(settings.chat_mode.party.enabled == true) then
        cm.p = '\\cs(96, 222, 47)O'
    else
        cm.p = "\\cs(222, 47, 47)X"
    end
    if(settings.chat_mode.shout.enabled == true) then
        cm.sh = '\\cs(96, 222, 47)O'
    else
        cm.sh = "\\cs(222, 47, 47)X"
    end
    
    box.modes = string.format("\\cs(76, 47, 222)LS: %s\\cs(76, 47, 222) | LS2: %s\\cs(76, 47, 222) | P: %s\\cs(76, 47, 222) | SH: %s | \\cs(76, 47, 222)AUTO: %s",cm.ls,cm.ls2,cm.p,cm.sh,cm.auto)
end


---Ashita 
----------------------------------------------------------------------------------------------------
-- func: GetItem(id)
-- desc: Get Item Resource by id
----------------------------------------------------------------------------------------------------
function GetItem(id)
	return AshitaCore:GetResourceManager():GetItemById(id)
end

function Count_Down(item)
    if not item then
        print("Error: ttl is not set.")
        return
    end

    local remainingTime = item - os.time()

    if remainingTime > 0 then
        local minutes = math.floor(remainingTime / 60)
        local seconds = math.floor(remainingTime % 60)
        print("Time remaining: " .. minutes .. " minutes and " .. seconds .. " seconds")
        return string.format("%i:%i",minutes,seconds)
    else
        return 0
    end
end