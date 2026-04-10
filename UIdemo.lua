local DEFAULT_LIBRARY_URL = 'https://raw.githubusercontent.com/nonzINC/luavm/main/UI.lua'

local function resolveLibrary()
    if type(UILib) == 'table' and type(UILib.Step) == 'function' then
        return UILib
    end
    if type(game) == 'table' and type(game.HttpGet) == 'function' and type(loadstring) == 'function' then
        local okSrc, src = pcall(function()
            return game:HttpGet(DEFAULT_LIBRARY_URL)
        end)
        if okSrc and type(src) == 'string' and #src > 100 then
            local okChunk, chunk = pcall(loadstring, src)
            if okChunk and type(chunk) == 'function' then
                local okRun = pcall(chunk)
                if okRun and type(UILib) == 'table' and type(UILib.Step) == 'function' then
                    return UILib
                end
            end
        end
    end
    return nil
end

local function RunDemo(lib)
    lib:SetMenuSize(Vector2.new(720, 460))
    lib:CenterMenu()
    lib:SetMenuTitle('UILib v2')

    local rage = lib:Tab('Rage')
    local aimbot = rage:Section('Aimbot')
    local enabled = aimbot:Toggle('Enabled', false, nil, false, 'Master aimbot switch')
    local aimKey = enabled:AddKeybind('unbound', 'Hold')
    local silent = aimbot:Toggle('Silent aim', true)
    local hitColor = silent:AddColorpicker('Hit color', Color3.fromRGB(255, 80, 120))
    aimbot:Toggle('Auto wall (unsafe)', false, nil, true, 'Unsafe features may get you banned')
    local fov = aimbot:Slider('FOV', 90, 1, 1, 360, 'deg')
    local smooth = aimbot:Slider('Smoothness', 2.5, 0.1, 0.1, 10, 'x')
    local hitbox = aimbot:Dropdown('Hitbox', {'Head', 'Chest'}, {'Head', 'Neck', 'Chest', 'Stomach', 'Pelvis', 'Arms', 'Legs'}, true)
    aimbot:Button('Reset settings', function()
        enabled:Set(false)
        aimKey:Set(nil)
        silent:Set(false)
        hitColor:Set(Color3.fromRGB(255, 255, 255))
        fov:Set(90)
        smooth:Set(2.5)
        hitbox:Set({'Head'})
    end)

    local accuracy = rage:Section('Accuracy')
    local animOn = false
    accuracy:Toggle('Live meter', animOn, function(v)
        animOn = v
    end)
    local meterSlider = accuracy:Slider('Meter', 0, 1, -100, 100, '%')
    local targetBox = accuracy:Textbox('Target filter', '')
    accuracy:Button('Clear filter', function()
        targetBox:Set('')
    end)

    local vis = lib:Tab('Visuals')
    local esp = vis:Section('ESP')
    local espOn = esp:Toggle('Enabled', false)
    espOn:AddColorpicker('Color', Color3.fromRGB(0, 200, 255))
    esp:Toggle('Box', true)
    esp:Toggle('Name', true)
    esp:Toggle('Health', false)
    esp:Toggle('Distance', false)
    esp:Slider('Max distance', 500, 10, 10, 2000, 'm')
    esp:Dropdown('Style', {'Corner'}, {'Corner', 'Full', 'Outline'}, false)

    local world = vis:Section('World')
    world:Toggle('Chams', false)
    world:Toggle('Glow', false)
    world:Slider('FOV changer', 70, 1, 40, 120, 'deg')

    local misc = lib:Tab('Misc')
    local movement = misc:Section('Movement')
    movement:Toggle('Bunnyhop', false)
    movement:Toggle('Auto strafe', false)
    movement:Slider('Jump height', 16, 1, 10, 100, 'u')
    movement:Button('Teleport home', function()
        lib:Notification('Teleport sent', 3)
    end)

    local _, menuSettings = lib:CreateSettingsTab()
    local shouldDie = false
    menuSettings:Button('Unload', function()
        shouldDie = true
    end)

    lib:Notification('UILib v2 loaded', 5)
    lib:Notification('Press F1 to toggle the menu', 6)

    while not shouldDie do
        if animOn then
            meterSlider:Set(math.floor(math.sin(os.clock() * 3) * 100))
        end
        lib:Step()
    end

    lib:Unload()
    return true
end

local resolvedLibrary = resolveLibrary()
if resolvedLibrary then
    return RunDemo(resolvedLibrary)
end

return RunDemo
