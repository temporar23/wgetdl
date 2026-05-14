local relay = peripheral.find("redstone_relay")

local sides = {
    "top",
    "bottom",
    "left",
    "right",
    "front",
    "back"
}

for _, side in ipairs(sides) do
    print("Teste: " .. side)

    relay.setOutput(side, true)

    sleep(2)

    relay.setOutput(side, false)
end
