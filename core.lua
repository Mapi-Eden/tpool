ashita          = ashita or { };
ashita.core    = ashita.core or { };

----------------------------------------------------------------------------------------------------
-- func: queuecommand(command,type)
-- desc: Send Command to game
--ForceHandle = -3,       // Informs Ashita to handle the command by force.
--Script = -2,            // Informs Ashita to handle the command as an Ashita based script command.
--Parse = -1,             // Informs Ashita to handle the command as an Ashita based command.
--Menu = 0,               // Informs Ashita to handle the command as if it were input via an in-game menu.
--Typed = 1,              // Informs Ashita to handle the command as if it were typed into the chat window by the player.
--Macro = 2               // Informs Ashita to handle the command as if it were invoked from a macro.
----------------------------------------------------------------------------------------------------
local function queuecommand(command,type)

    AshitaCore:GetChatManager():QueueCommand(command, type);
end


----------------------------------------------------------------------------------------------------
-- Expose The Functions
----------------------------------------------------------------------------------------------------
ashita.core.queuecommand = queuecommand;
ashita.core.playerEntity = GetPlayerEntity();
ashita.timer.remove_timer = remove_timer;
ashita.timer.is_timer = is_timer;
ashita.timer.once = once;
ashita.timer.create = create;
ashita.timer.start_timer = start_timer;
ashita.timer.adjust_timer = adjust_timer;
ashita.timer.pause = pause;
ashita.timer.unpause = unpause;
ashita.timer.toggle = toggle;
ashita.timer.stop = stop;
ashita.timer.pulse = pulse;