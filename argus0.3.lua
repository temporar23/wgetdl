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
end
