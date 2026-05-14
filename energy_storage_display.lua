-- =====================================
-- SKALA ENERGY STORAGE DISPLAY
-- =====================================

term.clear()
term.setCursorPos(1,1)

print("INITIALIZING...")

-- =====================
-- ENERGY STORAGE
-- =====================

local cube = peripheral.wrap("advancedEnergyCube_0")

if not cube then
    error("ENERGY STORAGE NOT FOUND")
end

-- =====================
-- MONITOR
-- =====================

local monitor = peripheral.wrap("monitor_4")

if not monitor then
    error("MONITOR NOT FOUND")
end

monitor.setTextScale(1)

print("SYSTEM ONLINE")

sleep(1)

-- =====================
-- FORMAT FUNCTION
-- =====================

local function formatNumber(num)

    if num >= 1000000000 then
        return string.format("%.2f GFE", num / 1000000000)

    elseif num >= 1000000 then
        return string.format("%.2f MFE", num / 1000000)

    elseif num >= 1000 then
        return string.format("%.2f KFE", num / 1000)
    end

    return tostring(math.floor(num)) .. " FE"
end

-- =====================
-- MAIN LOOP
-- =====================

while true do

    -- =====================
    -- READ VALUES
    -- =====================

    local stored = cube.getEnergy()
    local max = cube.getMaxEnergy()

    local percent = math.floor(
        (stored / max) * 100
    )

    local status = "STABLE"

    -- =====================
    -- STATUS CHECK
    -- =====================

    if percent <= 20 then
        status = "LOW POWER"
    end

    if percent <= 5 then
        status = "CRITICAL"
    end

    -- =====================
    -- DISPLAY OUTPUT
    -- =====================

    monitor.clear()

    monitor.setCursorPos(1,1)
    monitor.write("=== POWER GRID ===")

    monitor.setCursorPos(1,3)
    monitor.write("STATUS: "..status)

    monitor.setCursorPos(1,5)
    monitor.write("STORAGE:")

    monitor.setCursorPos(1,6)
    monitor.write(formatNumber(stored))

    monitor.setCursorPos(1,8)
    monitor.write("CAPACITY:")

    monitor.setCursorPos(1,9)
    monitor.write(formatNumber(max))

    monitor.setCursorPos(1,11)
    monitor.write("CHARGE: "..percent.."%")

    sleep(1)

end
