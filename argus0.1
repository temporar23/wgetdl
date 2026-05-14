-- =====================================
-- ARGUS CENTRAL ALARM SYSTEM
-- =====================================

term.clear()
term.setCursorPos(1,1)

print("========================")
print(" ARGUS CONTROL SYSTEM")
print("========================")

-- =====================================
-- PERIPHERALS
-- =====================================

local reactor = peripheral.wrap("fissionReactorLogicAdapter_0")
local turbine = peripheral.wrap("turbineValve_1")
local battery = peripheral.wrap("advancedEnergyCube_0")

-- GLOBAL STATE RELAYS
local relayInfo = peripheral.wrap("redstone_relay_10")
local relayWarning = peripheral.wrap("redstone_relay_11")
local relayFail = peripheral.wrap("redstone_relay_12")
local relayAlarm = peripheral.wrap("redstone_relay_13")

-- REACTOR RELAYS
local relayDamage = peripheral.wrap("redstone_relay_2")
local relayRESA = peripheral.wrap("redstone_relay_3")
local relayReactorFault = peripheral.wrap("redstone_relay_4")
local relayHeatedCoolant = peripheral.wrap("redstone_relay_5")
local relayCoolantLow = peripheral.wrap("redstone_relay_6")
local relayWaste = peripheral.wrap("redstone_relay_7")
local relayTemp = peripheral.wrap("redstone_relay_8")
local relayFuel = peripheral.wrap("redstone_relay_9")

-- TURBINE RELAYS
local relaySteam = peripheral.wrap("redstone_relay_14")
local relayTurbineFault = peripheral.wrap("redstone_relay_15")
local relayTurbineBuffer = peripheral.wrap("redstone_relay_16")

-- BATTERY RELAYS
local relayBatCharging = peripheral.wrap("redstone_relay_17")
local relayBatFault = peripheral.wrap("redstone_relay_18")
local relayBatFull = peripheral.wrap("redstone_relay_19")

-- MUTE SYSTEM
local muteButton = peripheral.wrap("redstone_relay_20")
local muteLamp = peripheral.wrap("redstone_relay_21")

-- SPEAKERS
local speaker = peripheral.find("speaker")

-- =====================================
-- SETTINGS
-- =====================================

local TEMP_WARNING = 900
local TEMP_FAIL = 1100
local TEMP_ALARM = 1300

local TURBINE_BUFFER_MAX = 1440000000
local BATTERY_CAPACITY = 6400000

local MUTE_DURATION = 300

-- =====================================
-- STATE
-- =====================================

local muted = false
local muteEnd = 0
local lastButton = false

local activePriority = "INFO"

local lastLogged = {}

-- =====================================
-- LOGGING / PRINTER
-- =====================================

local printer = peripheral.wrap("printer_1")

local function printLog(text)

    if not printer then
        return
    end

    if not printer.getPaperLevel or printer.getPaperLevel() <= 0 then
        return
    end

    if not printer.getInkLevel or printer.getInkLevel() <= 0 then
        return
    end

    if not printer.getPageSize then
        return
    end

    local x, y = printer.getCursorPos()
    local width, height = printer.getPageSize()

    if y >= height then

        printer.endPage()
        printer.newPage()

        printer.setCursorPos(1,1)
    end

    printer.write(text)
    printer.setCursorPos(1, y + 1)

end

local function logEvent(text)

    local timestamp = textutils.formatTime(os.time(), true)

    local line = "["..timestamp.."] "..text

    print(line)

    local file = fs.open("argus_log.txt", "a")

    if file then
        file.writeLine(line)
        file.close()
    end

    if printer then

        if not printer.getCursorPos then
            return
        end

        if not printer.newPage then
            return
        end

        local started = printer.newPage()

        if started then
            printer.setCursorPos(1,1)
        end

        printLog(line)

    end
end

-- =====================================
-- SOUND SYSTEM
-- =====================================

local function playInfo()

    if muted then
        return
    end

    if speaker then
        speaker.playSound("minecraft:block.note_block.pling")
    end
end

local function playWarning()

    if muted then
        return
    end

    if speaker then
        speaker.playSound("minecraft:block.beacon.activate")
    end
end

local function playFail()

    if muted then
        return
    end

    if speaker then
        speaker.playSound("minecraft:block.anvil.land")
    end
end

local function playAlarm()

    if speaker then
        speaker.playSound("minecraft:block.beacon.power_select")
    end
end

-- =====================================
-- BLINK PATTERNS
-- =====================================

local function blinkFast(relay)

    relay.setOutput("front", true)
    sleep(0.5)

    relay.setOutput("front", false)
    sleep(0.5)
end

local function blinkSlow(relay)

    relay.setOutput("front", true)
    sleep(2)

    relay.setOutput("front", false)
    sleep(0.25)
end

local function blinkOneSecond(relay)

    relay.setOutput("front", true)
    sleep(1)

    relay.setOutput("front", false)
    sleep(1)
end

-- =====================================
-- MUTE SYSTEM
-- =====================================

local function updateMute()

    local current = muteButton.getInput("front")

    if current and not lastButton then

        muted = true
        muteEnd = os.clock() + MUTE_DURATION

        logEvent("ALARMS MUTED FOR 5 MINUTES")

    end

    lastButton = current

    if muted and os.clock() >= muteEnd then

        muted = false

        logEvent("ALARM MUTE EXPIRED")

    end
end

-- =====================================
-- GLOBAL PRIORITY RESET
-- =====================================

local function resetGlobalStates()

    relayInfo.setOutput("front", false)
    relayWarning.setOutput("front", false)
    relayFail.setOutput("front", false)
    relayAlarm.setOutput("front", false)

    activePriority = "INFO"
end

-- =====================================
-- PRIORITY HANDLER
-- =====================================

local function setPriority(priority)

    local order = {
        INFO = 1,
        WARNING = 2,
        FAIL = 3,
        ALARM = 4
    }

    if order[priority] > order[activePriority] then
        activePriority = priority
    end
end

-- =====================================
-- MAIN LOOP
-- =====================================

while true do

    resetGlobalStates()

    updateMute()

    -- =====================================
    -- MUTE LAMP
    -- =====================================

    if muted then

        muteLamp.setOutput("front", true)

    else

        muteLamp.setOutput("front", false)

    end

    -- =====================================
    -- REACTOR VALUES
    -- =====================================

    local reactorOnline = reactor.getStatus()
    local forceDisabled = reactor.isForceDisabled()

    local damage = reactor.getDamagePercent()
    local coolant = reactor.getCoolantFilledPercentage()
    local heatedCoolant = reactor.getHeatedCoolantFilledPercentage()
    local waste = reactor.getWasteFilledPercentage()
    local fuel = reactor.getFuelFilledPercentage()

    local tempK = reactor.getTemperature()

    -- =====================================
    -- RELAY 3 - RESA
    -- =====================================

    if forceDisabled or not reactorOnline then

        relayRESA.setOutput("front", true)
        setPriority("ALARM")

    else

        relayRESA.setOutput("front", false)

    end

    -- =====================================
    -- RELAY 2 - DAMAGE
    -- =====================================

    if damage > 10 then

        relayDamage.setOutput("front", true)
        setPriority("FAIL")

    else

        relayDamage.setOutput("front", false)

    end

    -- =====================================
    -- RELAY 5 - HEATED COOLANT
    -- =====================================

    if heatedCoolant > 0.25 then

        relayHeatedCoolant.setOutput("front", true)
        setPriority("WARNING")

    else

        relayHeatedCoolant.setOutput("front", false)

    end

    -- =====================================
    -- RELAY 6 - COOLANT LOW
    -- =====================================

    if coolant < 0.90 then

        relayCoolantLow.setOutput("front", true)
        setPriority("WARNING")

    else

        relayCoolantLow.setOutput("front", false)

    end

    -- =====================================
    -- RELAY 7 - WASTE HIGH
    -- =====================================

    if waste > 0.50 then

        relayWaste.setOutput("front", true)
        setPriority("WARNING")

    else

        relayWaste.setOutput("front", false)

    end

    -- =====================================
    -- RELAY 8 - TEMP HIGH
    -- =====================================

    if tempK > TEMP_FAIL then

        relayTemp.setOutput("front", true)
        setPriority("FAIL")

    else

        relayTemp.setOutput("front", false)

    end

    -- =====================================
    -- RELAY 9 - FUEL LOW
    -- =====================================

    if fuel < 0.40 then

        relayFuel.setOutput("front", true)
        setPriority("WARNING")

    else

        relayFuel.setOutput("front", false)

    end

    -- =====================================
    -- TURBINE
    -- =====================================

    local steam = turbine.getSteamFilledPercentage()

    local turbineEnergy = (tonumber(turbine.getEnergy()) or 0) / 2.5

    if steam < 0.20 then

        relaySteam.setOutput("front", true)
        setPriority("INFO")

    else

        relaySteam.setOutput("front", false)

    end

    if turbineEnergy >= TURBINE_BUFFER_MAX then

        relayTurbineBuffer.setOutput("front", true)
        setPriority("FAIL")

    else

        relayTurbineBuffer.setOutput("front", false)

    end

    -- =====================================
    -- BATTERY
    -- =====================================

    local batteryEnergy = battery.getEnergy()

    if batteryEnergy == nil then

        relayBatFault.setOutput("front", true)
        setPriority("FAIL")

    else

        relayBatFault.setOutput("front", false)

        local batteryFE = batteryEnergy / 2.5

        if batteryFE >= BATTERY_CAPACITY then

            relayBatFull.setOutput("front", true)
            relayBatCharging.setOutput("front", false)

        else

            relayBatFull.setOutput("front", false)
            relayBatCharging.setOutput("front", true)

        end
    end

    -- =====================================
    -- GLOBAL STATE RELAYS
    -- =====================================

    if activePriority == "INFO" then

        relayInfo.setOutput("front", true)

    elseif activePriority == "WARNING" then

        relayWarning.setOutput("front", true)

    elseif activePriority == "FAIL" then

        relayFail.setOutput("front", true)

    elseif activePriority == "ALARM" then

        relayAlarm.setOutput("front", true)

    end

    -- =====================================
    -- SOUND ROUTING
    -- =====================================

    if activePriority == "INFO" then

        playInfo()

    elseif activePriority == "WARNING" then

        playWarning()

    elseif activePriority == "FAIL" then

        playFail()

    elseif activePriority == "ALARM" then

        playAlarm()

    end

    sleep(1)

end
