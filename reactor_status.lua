local monitor = peripheral.wrap("monitor_1")

rednet.open("back")

monitor.setTextScale(1)

while true do
    local id, msg = rednet.receive()

    if msg.type == "reactor" then

        monitor.clear()
        monitor.setCursorPos(1,1)

        monitor.write("=== REACTOR ===")

        monitor.setCursorPos(1,3)
        monitor.write("STATUS: " .. msg.status)

        monitor.setCursorPos(1,5)
        monitor.write("TEMP: " .. msg.temp .. " C")

        monitor.setCursorPos(1,7)
        monitor.write("COOLANT: " .. msg.coolant .. "%")

        monitor.setCursorPos(1,9)
        monitor.write("DAMAGE: " .. msg.damage .. "%")

        monitor.setCursorPos(1,11)
        monitor.write("BURN: " .. msg.burn)
    end
end
