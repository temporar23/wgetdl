-- =====================================
-- SKALA REACTOR MONITOR
-- =====================================

term.clear()
term.setCursorPos(1,1)

print("INITIALIZING...")

-- =====================
-- REACTOR
-- =====================

local reactor = peripheral.wrap("fissionReactorLogicAdapter_1")

if not reactor then
    error("REACTOR NOT FOUND")
end

-- =====================
-- MONITOR
-- =====================

local monitor = peripheral.wrap("monitor_1")

if not monitor then
    error("MONITOR NOT FOUND")
end

monitor.setTextScale(1)

print("SYSTEM ONLINE")

sleep(1)

-- =====================
-- MAIN LOOP
-- =====================

while true do

    -- ===== VALUES =====

    local temp = math.floor(
        reactor.getTemperature()
    )

    local coolant = math.floor(
        reactor.getCoolantFilledPercentage() * 100
    )

    local damage = math.floor(
        reactor.getDamagePercent()
    )

    local burn = reactor.getBurnRate()

    local status = "ONLINE"

    if damage > 0 then
        status = "WARNING"
    end

    if damage >= 25 then
        status = "CRITICAL"
    end

    -- ===== MONITOR =====

    monitor.clear()

    monitor.setCursorPos(1,1)
    monitor.write("=== REACTOR ===")

    monitor.setCursorPos(1,3)
    monitor.write("STATUS: "..status)

    monitor.setCursorPos(1,5)
    monitor.write("TEMP: "..temp.." C")

    monitor.setCursorPos(1,7)
    monitor.write("COOLANT: "..coolant.."%")

    monitor.setCursorPos(1,9)
    monitor.write("DAMAGE: "..damage.."%")

    monitor.setCursorPos(1,11)
    monitor.write("BURN: "..burn)

    sleep(1)

end
