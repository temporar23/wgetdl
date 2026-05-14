-- =========================================
-- REACTOR MAIN DATA SERVER
-- MEKANISM FISSION REACTOR
-- =========================================

term.clear()
term.setCursorPos(1,1)

print("SKALA REACTOR NODE")
print("INITIALIZING...")

-- =====================
-- MODEM AUTO DETECTION
-- =====================

local modem = peripheral.find("modem")

if not modem then
    error("NO MODEM FOUND")
end

local modemSide = peripheral.getName(modem)

rednet.open(modemSide)

print("MODEM ONLINE: "..modemSide)

-- =====================
-- REACTOR ADAPTER
-- =====================

local reactor = peripheral.wrap("fissionReactorLogicAdapter_1")

if not reactor then
    error("REACTOR ADAPTER NOT FOUND")
end

print("REACTOR LINK ONLINE")

sleep(2)

-- =====================
-- MAIN LOOP
-- =====================

while true do

    -- ===== READ VALUES =====

    local status = "ONLINE"

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

    -- ===== SAFETY =====

    if damage > 0 then
        status = "WARNING"
    end

    if damage >= 25 then
        status = "CRITICAL"
    end

    -- ===== SEND DATA =====

    rednet.broadcast({
        type = "reactor",

        status = status,

        temp = temp,

        coolant = coolant,

        damage = damage,

        burn = burn
    })

    -- ===== LOCAL STATUS =====

    term.clear()

    term.setCursorPos(1,1)
    print("SKALA REACTOR NODE")

    term.setCursorPos(1,3)
    print("STATUS: "..status)

    term.setCursorPos(1,5)
    print("TEMP: "..temp.." C")

    term.setCursorPos(1,6)
    print("COOLANT: "..coolant.."%")

    term.setCursorPos(1,7)
    print("DAMAGE: "..damage.."%")

    term.setCursorPos(1,8)
    print("BURN: "..burn)

    term.setCursorPos(1,10)
    print("DATA BROADCAST ACTIVE")

    sleep(1)

end
