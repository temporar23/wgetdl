-- =====================================
-- SKALA PROCESS SUPERVISOR
-- =====================================

term.clear()
term.setCursorPos(1,1)

print("SKALA SUPERVISOR")
print("BOOTING SYSTEMS...")
sleep(2)

-- =====================================
-- PROGRAM LIST
-- =====================================

local programs = {
    "reactor_display.lua",
    "turbine_display.lua",
    "energy_storage_display.lua",
    "argus.lua"
}

-- =====================================
-- RUNNER
-- =====================================

local function supervise(program)

    while true do

        term.setCursorPos(1,5)
        print("STARTING: "..program.."      ")

        local ok, err = pcall(function()

            shell.run(program)

        end)

        term.setCursorPos(1,7)

        if ok then
            print(program.." CLOSED         ")
        else
            print(program.." CRASHED        ")
            print(err.."                    ")
        end

        sleep(2)

        term.setCursorPos(1,9)
        print("RESTARTING "..program.."      ")

        sleep(1)

    end
end

-- =====================================
-- START ALL PROGRAMS
-- =====================================

local tasks = {}

for _, program in ipairs(programs) do

    table.insert(tasks, function()
        supervise(program)
    end)

end

parallel.waitForAll(table.unpack(tasks))
