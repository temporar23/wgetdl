-- =====================================
-- RELAY NETWORK ACTIVITY SIMULATOR
-- FRONT ONLY VERSION
-- =====================================

math.randomseed(os.time())

-- Alle Relays finden
local relays = { peripheral.find("redstone_relay") }

if #relays == 0 then
    error("Keine redstone_relays gefunden!")
end

print(#relays .. " RELAYS ONLINE")
sleep(1)

local side = "front"

while true do

    -- Niemals alle gleichzeitig
    local maxActive = math.random(3, 8)

    local active = {}

    -- Zufällige Relays aktivieren
    for i = 1, maxActive do

        local relay = relays[math.random(#relays)]

        -- Doppelte vermeiden
        local alreadyActive = false

        for _, used in ipairs(active) do
            if used == relay then
                alreadyActive = true
                break
            end
        end

        if not alreadyActive then

            relay.setOutput(side, true)

            table.insert(active, relay)

            print("ACTIVE -> RELAY " .. i)

            sleep(math.random() * 0.2)
        end
    end

    -- Aktivitätsdauer
    sleep(math.random(1, 4))

    -- Wieder ausschalten1
    for _, relay in ipairs(active) do

        relay.setOutput(side, false)

        print("OFFLINE")

        sleep(math.random() * 0.15)
    end

    -- Kleine Pause
    sleep(math.random() * 2)
end
