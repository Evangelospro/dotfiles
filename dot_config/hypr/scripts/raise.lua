local raise_state = {}

function raise_or_launch(class, cmd)
    -- cycle if there are multiple windows of the same class using state to keep track of the last focused windows
    local windows = hl.get_windows({ class = class })
    log("raise_or_launch: windows found for class " .. class .. ": " .. #windows)
    if #windows > 0 then
        local last_focused = raise_state[class] or 0
        local next_index = (last_focused % #windows) + 1
        raise_state[class] = next_index
        log({ window = "address:" .. windows[next_index].address})
        hl.dispatch(hl.dsp.focus({ window = "address:" .. windows[next_index].address }))
    else
        hl.exec_cmd(cmd)
    end
end
