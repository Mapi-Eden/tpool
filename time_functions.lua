-- countdown_manager.lua

local CountdownManager = {}

-- Private variables to store the countdown state
local countdown_active = false
local start_epoch_time = 0
local total_countdown_duration_seconds = 5 * 60 -- 5 minutes in seconds

--- Starts or resets the 5-minute countdown.
-- When this function is called, the countdown begins from 5 minutes.
function CountdownManager.start_countdown()
    start_epoch_time = os.time() -- Record the current epoch time as the start
    countdown_active = true
    print("5-minute countdown started!")
end

--- Resets the countdown, making it inactive.
-- No time will be returned until `start_countdown()` is called again.
function CountdownManager.reset_countdown()
    countdown_active = false
    start_epoch_time = 0
    print("Countdown reset.")
end

--- Returns the amount of time left in the 5-minute countdown.
-- @return remaining_minutes The whole number of minutes remaining.
-- @return remaining_seconds The whole number of seconds remaining (0-59).
-- @return is_active A boolean indicating if the countdown is currently active.
--                  (false if it hasn't started, has been reset, or has finished)
function CountdownManager.get_time_left()
    if not countdown_active then
        -- If countdown is not active, return 0 for time and false for active status
        return 0, 0, false
    end

    local current_time = os.time()
    local elapsed_seconds = current_time - start_epoch_time
    local remaining_seconds_total = total_countdown_duration_seconds - elapsed_seconds

    -- Ensure remaining_seconds_total does not go below zero
    if remaining_seconds_total <= 0 then
        -- Countdown has finished
        CountdownManager.reset_countdown() -- Automatically reset when finished
        return 0, 0, false
    else
        -- Calculate minutes and seconds for display
        local minutes_left = math.floor(remaining_seconds_total / 60)
        local seconds_left = remaining_seconds_total % 60
        return minutes_left, seconds_left, true
    end
end

return CountdownManager