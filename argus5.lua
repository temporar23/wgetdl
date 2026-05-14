-- =====================================
-- ARGUS CENTRAL ALARM SYSTEM
-- =====================================

term.clear()
term.setCursorPos(1,1)

print("========================")
print(" ARGUS CONTROL SYSTEM")
print("========================")

-- =====================================
-- RELAY OUTPUT HELPER
-- =====================================

local function setRelay(relay, state)

    if relay and relay.setOutput then
        relay.setOutput("front", state)
    end
end

-- =====================================
-- PERIPHERALS
-- =====================================

local reactor = peripheral.wrap("fissionReactorLogicAdapter_1")
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
local relayBatCharging = peripheral.wrap("redstone_relay_22")
local relayBatFault = peripheral.wrap("redstone_relay_18")
local relayBatFull = peripheral.wrap("redstone_relay_19")

-- MUTE SYSTEM
local muteButton = peripheral.wrap("redstone_relay_20")
local muteLamp = peripheral.wrap("redstone_relay_21")

-- EXTERNAL SIREN SYSTEM
-- Relay 10-13 trigger physical in-game alarm systems

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

local infoActive = false
local warningActive = false
local failActive = false
local alarmActive = false

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
-- EXTERNAL ALARM RELAYS
-- =====================================

-- Relay 10 = INFO SIREN
-- Relay 11 = WARNING KLAXON
-- Relay 12 = FAIL ALARM
-- Relay 13 = ALARM / ROTATING LIGHT

-- These are external in-game alarm systems.
-- ARGUS only provides persistent redstone signals.
-- No ComputerCraft speaker system is used.

-- =====================================
-- BLINK PATTERNS
-- =====================================

local blinkStateFast = false
local blinkStateSlow = false
local blinkStateOneSecond = false

local lastFast = 0
local lastSlow = 0
local lastOneSecond = 0

local function updateBlinkStates()

    local now = os.clock()

    if now - lastFast >= 0.5 then
        blinkStateFast = not blinkStateFast
        lastFast = now
    end

    if now - lastSlow >= 2 then
        blinkStateSlow = not blinkStateSlow
        lastSlow = now
    end

    if now - lastOneSecond >= 1 then
        blinkStateOneSecond = not blinkStateOneSecond
        lastOneSecond = now
    end
end

-- =====================================
-- MUTE SYSTEM
-- =====================================

-- Mute now affects ONLY:
-- Relay 10 = INFO
-- Relay 11 = WARNING
-- Relay 12 = FAIL
--
-- Relay 13 = ALARM is NEVER muted.
-- Emergency visual alarms must always remain active.

local function updateMute()
    updateBlinkStates()

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
-- GLOBAL STATE RESET
-- =====================================

local function resetStates()

    infoActive = false
    warningActive = false
    failActive = false
    alarmActive = false

end

-- =====================================
-- STATE HANDLER
-- =====================================

local function setPriority(priority)

    if priority == "INFO" then
        infoActive = true
    end

    if priority == "WARNING" then
        warningActive = true
    end

    if priority == "FAIL" then
        failActive = true
    end

    if priority == "ALARM" then
        alarmActive = true
    end
end
end

-- =====================================
-- MAIN LOOP
-- =====================================

while true do

    resetStates()

    updateMute()

    -- =====================================
    -- MUTE LAMP
    -- =====================================

    if muted then

        setRelay(muteLamp, blinkStateOneSecond)

    else

        setRelay(muteLamp, false)

    end

    -- =====================================
    -- REACTOR VALUES
    -- =====================================

    local reactorOnline = reactor and reactor.getStatus and reactor.getStatus()
    local forceDisabled = reactor and reactor.isForceDisabled and reactor.isForceDisabled()

    local damage = reactor and reactor.getDamagePercent and reactor.getDamagePercent()
    local coolant = reactor and reactor.getCoolantFilledPercentage and reactor.getCoolantFilledPercentage()
    local heatedCoolant = reactor and reactor.getHeatedCoolantFilledPercentage and reactor.getHeatedCoolantFilledPercentage()
    local waste = reactor and reactor.getWasteFilledPercentage and reactor.getWasteFilledPercentage()
    local fuel = reactor and reactor.getFuelFilledPercentage and reactor.getFuelFilledPercentage()

    local tempK = reactor and reactor.getTemperature and reactor.getTemperature()

    -- =====================================
    -- REACTOR COMMUNICATION FAILURE
    -- =====================================

    if reactorOnline == nil
    or forceDisabled == nil
    or damage == nil
    or coolant == nil
    or heatedCoolant == nil
    or waste == nil
    or fuel == nil
    or tempK == nil then

        setRelay(relayReactorFault, blinkStateSlow)
        setPriority("FAIL")

        logEvent("REACTOR COMMUNICATION FAILURE")

    else

        setRelay(relayReactorFault, false)

    end

    -- =====================================
    -- RELAY 3 - RESA
    -- =====================================

    if forceDisabled or not reactorOnline then

        setRelay(relayRESA, blinkStateFast)
        setPriority("ALARM")

    else

        setRelay(relayRESA, false)

    end

    -- =====================================
    -- RELAY 2 - DAMAGE
    -- =====================================

    if damage > 10 then

        setRelay(relayDamage, blinkStateSlow)
        setPriority("FAIL")

    else

        setRelay(relayDamage, false)

    end

    -- =====================================
    -- RELAY 5 - HEATED COOLANT
    -- =====================================

    if heatedCoolant > 0.25 then

        setRelay(relayHeatedCoolant, blinkStateFast)
        setPriority("WARNING")

    else

        setRelay(relayHeatedCoolant, false)

    end

    -- =====================================
    -- RELAY 6 - COOLANT LOW
    -- =====================================

    if coolant < 0.90 then

        setRelay(relayCoolantLow, blinkStateFast)
        setPriority("WARNING")

    else

        setRelay(relayCoolantLow, false)

    end

    -- =====================================
    -- RELAY 7 - WASTE HIGH
    -- =====================================

    if waste > 0.50 then

        setRelay(relayWaste, blinkStateOneSecond)
        setPriority("WARNING")

    else

        setRelay(relayWaste, false)

    end

    -- =====================================
    -- RELAY 8 - TEMP HIGH
    -- =====================================

    if tempK > TEMP_FAIL then

        setRelay(relayTemp, blinkStateFast)
        setPriority("FAIL")

    else

        setRelay(relayTemp, false)

    end

    -- =====================================
    -- RELAY 9 - FUEL LOW
    -- =====================================

    if fuel < 0.40 then

        setRelay(relayFuel, blinkStateSlow)
        setPriority("WARNING")

    else

        setRelay(relayFuel, false)

    end

    -- =====================================
    -- TURBINE
    -- =====================================

    local steam = turbine and turbine.getSteamFilledPercentage and turbine.getSteamFilledPercentage()

    local turbineEnergy = turbine and turbine.getEnergy and ((tonumber(turbine.getEnergy()) or 0) / 2.5)

    if steam == nil or turbineEnergy == nil then

        setRelay(relayTurbineFault, blinkStateSlow)
        setPriority("FAIL")

        logEvent("TURBINE COMMUNICATION FAILURE")

    else

        setRelay(relayTurbineFault, false)

    end

    if steam ~= nil and steam < 0.20 then

        setRelay(relaySteam, true)
        setPriority("INFO")

    else

        setRelay(relaySteam, false)

    end

    if turbineEnergy >= TURBINE_BUFFER_MAX then

        setRelay(relayTurbineBuffer, blinkStateFast)
        setPriority("FAIL")

    else

        setRelay(relayTurbineBuffer, false)

    end

    -- =====================================
    -- BATTERY
    -- =====================================

    local batteryEnergy = battery.getEnergy()

    if batteryEnergy == nil then

        setRelay(relayBatFault, blinkStateSlow)
        setPriority("FAIL")

    else

        setRelay(relayBatFault, false)

        local batteryFE = batteryEnergy / 2.5

        if batteryFE >= 6400000 then

            setRelay(relayBatFull, true)
            setRelay(relayBatCharging, false)

        elseif batteryFE >= 0 and batteryFE < 6400000 then

            setRelay(relayBatFull, false)
            setRelay(relayBatCharging, true)

        else

            setRelay(relayBatFull, false)
            setRelay(relayBatCharging, false)

        end
    end

    print("INFO ACTIVE: "..tostring(infoActive))
    print("WARNING ACTIVE: "..tostring(warningActive))
    print("FAIL ACTIVE: "..tostring(failActive))
    print("ALARM ACTIVE: "..tostring(alarmActive))

    -- =====================================
    -- GLOBAL STATE RELAYS
    -- =====================================

    setRelay(relayInfo, infoActive and not muted)

    setRelay(relayWarning, warningActive and not muted)

    setRelay(relayFail, failActive and not muted)

    -- ALARM CAN NEVER BE MUTED
    setRelay(relayAlarm, alarmActive)

    print("INFO RELAY: "..tostring(infoActive))
    print("WARNING RELAY: "..tostring(warningActive))
    print("FAIL RELAY: "..tostring(failActive))
    print("ALARM RELAY: "..tostring(alarmActive))

    -- =====================================
    -- EXTERNAL ALARM ROUTING
    -- =====================================

    -- Relay 10-13 remain continuously active
    -- while their priority state is active.
    -- External sirens/lights handle audio and visuals.

    sleep(1)

end
