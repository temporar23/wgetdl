-- =====================================
-- RELAY NETWORK ACTIVITY SIMULATOR
-- Für CC:Tweaked Redstone Relays
-- =====================================

math.randomseed(os.time())

-- Alle Relays finden
local relays = { peripheral.find("redstone_relay") }

if #relays == 0 then
    error("Keine redstone_relays gefunden!")
end

print(#relays .. " RELAYS ONLINE")
sleep(1)

local sides = {
    "top",
    "bottom",
    "left",
    "right",
    "front",
    "back"
}

while true do

    -- Wieviele Relays gleichzeitig aktiv sein dürfen
    local maxActive = math.random(3, 8)

    -- Aktive Relays speichern
    local active = {}

    -- Zufällige Relays aktivieren
    for i = 1, maxActive do

        local relay = relays[math.random(#relays)]
        local side = sides[math.random(#sides)]

        relay.setOutput(side, true)

        table.insert(active, {
            relay = relay,
            side = side
        })

        print("ACTIVE -> Relay " .. i .. " / " .. side)

        sleep(math.random() * 0.2)
    end

    -- Laufzeit simulieren
    sleep(math.random(1, 4))

    -- Wieder ausschalten
    for _, entry in ipairs(active) do

        entry.relay.setOutput(entry.side, false)

        print("OFFLINE -> " .. entry.side)

        sleep(math.random() * 0.15)
    end

    -- Kleine Leerlaufphase
    sleep(math.random() * 2)
end
