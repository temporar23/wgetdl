-- =====================================
-- SKALA TURBINE DISPLAY
-- =====================================

term.clear()
term.setCursorPos(1,1)

print("INITIALIZING...")

-- =====================
-- TURBINE
-- =====================

local turbine = peripheral.wrap("turbineValve_1")

if not turbine then
    error("TURBINE NOT FOUND")
end

-- =====================
-- MONITOR
-- =====================

local monitor = peripheral.wrap("monitor_3")

if not monitor then
    error("MONITOR NOT FOUND")
end

monitor.setTextScale(1)

-- =====================
-- RELAYS
-- =====================

local relayOff = peripheral.wrap("redstone_relay_2")
local relayOn  = peripheral.wrap("redstone_relay_3")

if not relayOff then
    error("RELAY 2 NOT FOUND")
end

if not relayOn then
    error("RELAY 3 NOT FOUND")
end

print("SYSTEM ONLINE")

sleep(1)

-- =====================
-- MAIN LOOP
-- =====================

while true do

    -- =====================
    -- READ VALUES
    -- =====================

    local steam = math.floor(
        turbine.getSteamFilledPercentage() * 100
    )

    local energy = math.floor(
        turbine.getEnergyFilledPercentage() * 100
    )

    local production = math.floor(
        turbine.getProductionRate()
    )

    local flow = math.floor(
        turbine.getFlowRate()
    )

    local status = "ONLINE"

    -- =====================
    -- STATUS CHECK
    -- =====================

    if production <= 0 then
        status = "OFFLINE"
    end

    if steam <= 10 then
        status = "LOW STEAM"
    end

    -- =====================
    -- RELAY CONTROL
    -- =====================

    if production > 0 then

        -- TURBINE ONLINE

        relayOff.setOutput("front", false)
        relayOn.setOutput("front", true)

    else

        -- TURBINE OFFLINE

        relayOff.setOutput("front", true)
        relayOn.setOutput("front", false)

    end

    -- =====================
    -- DISPLAY OUTPUT
    -- =====================

    monitor.clear()

    monitor.setCursorPos(1,1)
    monitor.write("=== TURBINE ===")

    monitor.setCursorPos(1,3)
    monitor.write("STATUS: "..status)

    monitor.setCursorPos(1,5)
    monitor.write("STEAM: "..steam.."%")

    monitor.setCursorPos(1,7)
    monitor.write("ENERGY: "..energy.."%")

    monitor.setCursorPos(1,9)
    monitor.write("OUTPUT: "..production)

    monitor.setCursorPos(1,11)
    monitor.write("FLOW: "..flow)

    sleep(1)

end
