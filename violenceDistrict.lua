-- v2.5
-- config setup
local Config = {
    AutoSkillCheck = {
        Activate = true, -- auto skillcheck
        Ratio = "Perfect", -- perfect hit
        Delay = 0.0, -- delay before hit
    },
    Esp = {
        Activate = true, -- main esp toggle
        MaxDistance = 1500, -- max distance
        TextFont = Drawing.Fonts.System, -- esp font
        TextOutline = true, -- text outline
        
        Text = true, -- gen text
        Box3D = true, -- gen box
        TextColor = Color3.fromRGB(255, 105, 180), -- text color
        TextOpacity = 1, -- text opacity
        BoxColor = Color3.fromRGB(255, 105, 180), -- box color
        BoxOpacity = 1, -- box opacity
        
        Self = false, -- show self
        
        KillerName = true, -- killer name
        KillerCircle = true, -- killer circle
        KillerColor = Color3.fromRGB(255, 0, 0), -- killer color
        LookTracer = true, -- look line
        TracerLength = 5, -- line length
        TracerColor = Color3.fromRGB(255, 0, 0), -- start color
        TracerColor2 = Color3.fromRGB(255, 255, 0), -- end color
        
        SurvivorName = true, -- surv name
        SurvivorCircle = true, -- surv circle
        SurvivorColor = Color3.fromRGB(0, 255, 0), -- surv color
        
        CircleRadius = 2.5, -- circle size
        CircleSegments = 16, -- circle roundness
        GenProgress = true,   -- show percentage
        GenBar = false,        -- show progress bar
        GenStatus = true,      -- show "Repairing / Regressing"
        GenHideDone = true,    -- hide gens at 100%
    },
    -- veil bot settings
    Veil = {
        AimActive = false, -- aimbot toggle
        AimKey = 'r', -- aimbot key
        AimMode = 'Hold', -- aim mode
        Target = "HumanoidRootPart", -- aim target
        Smooth = 5.0, -- smoothing
        MaxDist = 1500, -- max calc dist

        PierceActive = false, -- pierce active state
        PierceKey = 'q', -- pierce key
        PierceMode = 'Toggle', -- pierce mode
        CancelKey = 'q', -- cancel key
        
        GravityMult = 3.90, -- gravity mult hidden from ui
        HitThresh = 10, -- green hit distance hidden from ui

        LockLine = true, -- draw line to locked target
        EspActive = true, -- aimbot esp toggle
        EspCross = true, -- draw crosses
        CrossSize = 8, -- cross size
        Thickness = 1, -- line thickness
        ColorOk = Color3.fromRGB(80, 220, 255), -- normal shot color
        ColorPierce = Color3.fromRGB(255, 140, 0), -- pierce shot color
        ColorHit = Color3.fromRGB(80, 255, 80), -- perfect hit color
        ColorApprox = Color3.fromRGB(255, 255, 0), -- low speed warning color
        ShowHit = true, -- toggle hit color
        ShowApprox = true, -- toggle approx warning
        StickyAim = true,  -- keeps target locked instead of switching
        StickyThresh = 200, -- screen distance to release lock

        TriggerActive = false, -- triggerbot toggle
        TriggerMinCharge = 1.2, -- normal spear min charge time
        TriggerMinChargePierce = 2.0, -- pierce spear min charge time
        TriggerDelay = 0.05, -- stabilization delay
        ChargeBar = true,     -- show charge indicator
        ChargeMode = "Bar",   -- "Bar" o "Percent"
        ChargeFullTime = 1.0,   -- hardcoded: 1 second
        ChargeBarW = 120,     -- bar width in px
        ChargeBarH = 8,       -- bar height in px
        ChargeBarOffY = 32,   -- distance below screen center
    },
    -- survivor settings
    Survi = {
        AbyssDodge = false,   -- auto crouch on Dark Severance
        DodgeKey   = "c",     -- crouch key (c or ctrl)
        DodgeDist  = 40,      -- max range to react
        DodgeDelay = 0.0,     -- delay before pressing key
        DodgeHold  = 0.4,     -- how long to hold crouch
        WaveEsp    = false,   -- show wave hitbox
        WaveColor  = Color3.fromRGB(255, 50, 50),  -- wave hitbox color
    },
    Debug = true,
}

-- fallback log flags, prints once then shuts up
-- FALSE = GONNA PRINT // TRUE = AINT GONNA PRINT
local _gravityFallbackLogged = true
local _velocityFallbackLogged = true
local _rsFailLogged = true

-- killer role gate
local _isLocalKiller = false
local _wasLocalKiller = false

-- speedup globals
local math_floor = math.floor
local math_cos = math.cos
local math_sin = math.sin
local math_sqrt = math.sqrt
local math_pi2 = math.pi * 2
local Vector2_new = Vector2.new
local Vector3_new = Vector3.new
local Color3_new = Color3.new
local Drawing_new = Drawing.new
local os_clock = os.clock
local task_spawn = task.spawn
local task_wait = task.wait
local keypress = keypress
local keyrelease = keyrelease
local mem_read = memory_read
local mem_write = memory_write
local WTS = WorldToScreen
local mouse1release = mouse1release
local isrbxactive = isrbxactive
local string_rep = string.rep
local math_clamp = math.clamp

-- pre alloc colors for gen status
local Color_Regressing = Color3.fromRGB(255, 80, 80)
local Color_Repairing = Color3.fromRGB(255, 220, 50)

-- wait for players service so external vm doesnt panic
local Players
repeat
    Players = game:GetService("Players")
    task_wait()
until Players

-- matcha paths
local WorkspacePath = "C:/matcha/workspace/"
-- versioned library path without dots to prevent require() directory parsing errors
local LibPath = WorkspacePath .. "vd-uilib-v25.lua"
local FolderPath = WorkspacePath .. "ViolenceDistrict/"
local ModuleFolder = FolderPath .. "Modules/"

-- folder checks
if not isfolder(WorkspacePath) then makefolder(WorkspacePath) end
if not isfolder(FolderPath) then makefolder(FolderPath) end
if not isfolder(ModuleFolder) then makefolder(ModuleFolder) end

-- load ui lib
if not isfile(LibPath) then
    local src = game:HttpGet("https://raw.githubusercontent.com/nonzINC/luavm/main/vd-uilib.lua")
    if src and type(src) == "string" and #src > 100 then writefile(LibPath, src) end
end
local UILib = require(LibPath)

-- mouse 4 and 5 fix
if UILib._inputs then
    UILib._inputs['m4'] = {id=0x05, held=false, click=false}
    UILib._inputs['m5'] = {id=0x06, held=false, click=false}
end

-- safe localplayer fetch for external environments
local Player
repeat
    Player = Players.LocalPlayer
    task_wait()
until Player

local ConfigPath = WorkspacePath .. "vd-" .. (Player and Player.Name or "unknown") .. ".json"

local PlayerGui = Player:WaitForChild("PlayerGui")

-- mouse fix
local successMouse, CachedMouse = pcall(function() return Player:GetMouse() end)
UILib._GetMousePos = function(self)
    if successMouse and CachedMouse then return Vector2_new(CachedMouse.X, CachedMouse.Y) end
    return Vector2_new(0, 0)
end

-- load mem lib
local MemPath = ModuleFolder .. "MemoryManager.lua"
if not isfile(MemPath) then
    local memsrc = game:HttpGet("https://raw.githubusercontent.com/thelucas128/Macha/refs/heads/main/MemoryManagerFixed.luau")
    if memsrc and type(memsrc) == "string" and #memsrc > 100 then writefile(MemPath, memsrc) end
end
local MemoryManager = require(MemPath)

-- math cache
local CircleMults = {}
for i = 1, Config.Esp.CircleSegments do
    local angle = (i / Config.Esp.CircleSegments) * math_pi2
    CircleMults[i] = { x = math_cos(angle), z = math_sin(angle) }
end

local function normalizeAngle(angle)
    angle = angle % 360
    return angle < 0 and angle + 360 or angle
end

-- blur fix
local function roundVec2(v)
    if not v then return Vector2_new(0, 0) end
    return Vector2_new(math_floor(v.X + 0.5), math_floor(v.Y + 0.5))
end

local configDirty = false
local lastSaveTime = 0

-- color3 save/load helpers for json
local function c3save(c)
    return {R = math_floor(c.R * 255 + 0.5), G = math_floor(c.G * 255 + 0.5), B = math_floor(c.B * 255 + 0.5)}
end
local function c3load(t)
    if type(t) == "table" and t.R and t.G and t.B then
        return Color3.fromRGB(t.R, t.G, t.B)
    end
end

local fontMapping = {
    System = Drawing.Fonts.System,
    SystemBold = Drawing.Fonts.SystemBold,
    UI = Drawing.Fonts.UI,
    Minecraft = Drawing.Fonts.Minecraft,
    Monospace = Drawing.Fonts.Monospace,
    Pixel = Drawing.Fonts.Pixel,
    Fortnite = Drawing.Fonts.Fortnite
}
local fontNameMapping = {}
for name, font in pairs(fontMapping) do fontNameMapping[font] = name end

local function SaveConfig()
    local data = {
        AutoSkillCheck = {
            Activate = Config.AutoSkillCheck.Activate,
            Delay    = Config.AutoSkillCheck.Delay,
        },
        Esp = {
            Activate       = Config.Esp.Activate,
            MaxDistance    = Config.Esp.MaxDistance,
            TextOutline    = Config.Esp.TextOutline,
            Text           = Config.Esp.Text,
            Box3D          = Config.Esp.Box3D,
            TextOpacity    = Config.Esp.TextOpacity,
            BoxOpacity     = Config.Esp.BoxOpacity,
            Self           = Config.Esp.Self,
            KillerName     = Config.Esp.KillerName,
            KillerCircle   = Config.Esp.KillerCircle,
            LookTracer     = Config.Esp.LookTracer,
            TracerLength   = Config.Esp.TracerLength,
            SurvivorName   = Config.Esp.SurvivorName,
            SurvivorCircle = Config.Esp.SurvivorCircle,
            CircleRadius   = Config.Esp.CircleRadius,
            GenProgress    = Config.Esp.GenProgress,
            GenBar         = Config.Esp.GenBar,
            GenStatus      = Config.Esp.GenStatus,
            GenHideDone    = Config.Esp.GenHideDone,
            TextFont       = fontNameMapping[Config.Esp.TextFont] or "System",
            TextColor      = c3save(Config.Esp.TextColor),
            BoxColor       = c3save(Config.Esp.BoxColor),
            KillerColor    = c3save(Config.Esp.KillerColor),
            TracerColor    = c3save(Config.Esp.TracerColor),
            TracerColor2   = c3save(Config.Esp.TracerColor2),
            SurvivorColor  = c3save(Config.Esp.SurvivorColor),
        },
        Veil = {
            AimKey       = Config.Veil.AimKey,
            AimMode      = Config.Veil.AimMode,
            Target       = Config.Veil.Target,
            Smooth       = Config.Veil.Smooth,
            MaxDist      = Config.Veil.MaxDist,
            PierceKey    = Config.Veil.PierceKey,
            PierceMode   = Config.Veil.PierceMode,
            CancelKey    = Config.Veil.CancelKey,
            LockLine     = Config.Veil.LockLine,
            EspActive    = Config.Veil.EspActive,
            EspCross     = Config.Veil.EspCross,
            CrossSize    = Config.Veil.CrossSize,
            Thickness    = Config.Veil.Thickness,
            ShowHit      = Config.Veil.ShowHit,
            ShowApprox   = Config.Veil.ShowApprox,
            StickyAim    = Config.Veil.StickyAim,
            StickyThresh = Config.Veil.StickyThresh,
            TriggerActive       = Config.Veil.TriggerActive,
            TriggerMinCharge    = Config.Veil.TriggerMinCharge,
            TriggerMinChargePierce = Config.Veil.TriggerMinChargePierce,
            TriggerDelay        = Config.Veil.TriggerDelay,
            ChargeBar     = Config.Veil.ChargeBar,
            ChargeMode    = Config.Veil.ChargeMode,
            ChargeFullTime = Config.Veil.ChargeFullTime,
            ChargeBarW    = Config.Veil.ChargeBarW,
            ChargeBarH    = Config.Veil.ChargeBarH,
            ChargeBarOffY = Config.Veil.ChargeBarOffY,
            ColorOk       = c3save(Config.Veil.ColorOk),
            ColorPierce  = c3save(Config.Veil.ColorPierce),
            ColorHit     = c3save(Config.Veil.ColorHit),
            ColorApprox  = c3save(Config.Veil.ColorApprox),
        },
        Survi = {
            AbyssDodge = Config.Survi.AbyssDodge,
            DodgeKey   = Config.Survi.DodgeKey,
            DodgeDist  = Config.Survi.DodgeDist,
            DodgeDelay = Config.Survi.DodgeDelay,
            DodgeHold  = Config.Survi.DodgeHold,
            WaveEsp    = Config.Survi.WaveEsp,
            WaveColor  = c3save(Config.Survi.WaveColor),
        },
    }
    local ok, hs = pcall(function() return game:GetService("HttpService") end)
    if not ok or not hs then return end
    local jsonOk, jsonStr = pcall(function() return hs:JSONEncode(data) end)
    if jsonOk and jsonStr then writefile(ConfigPath, jsonStr) end
end

local function LoadConfig()
    if not isfile(ConfigPath) then return end
    local ok, content = pcall(readfile, ConfigPath)
    if not ok or not content or #content < 5 then return end
    local hsOk, hs = pcall(function() return game:GetService("HttpService") end)
    if not hsOk then return end
    local decOk, data = pcall(function() return hs:JSONDecode(content) end)
    if not decOk or type(data) ~= "table" then return end
    local function merge(target, source)
        if type(source) ~= "table" then return end
        for k, v in pairs(source) do
            if target[k] ~= nil and type(target[k]) == type(v) then
                target[k] = v
            end
        end
    end
    merge(Config.AutoSkillCheck, data.AutoSkillCheck)
    merge(Config.Esp,            data.Esp)
    merge(Config.Veil,           data.Veil)
    merge(Config.Survi,          data.Survi)

    -- restore Color3 values
    if type(data.Esp) == "table" then
        Config.Esp.TextColor     = c3load(data.Esp.TextColor)     or Config.Esp.TextColor
        Config.Esp.BoxColor      = c3load(data.Esp.BoxColor)      or Config.Esp.BoxColor
        Config.Esp.KillerColor   = c3load(data.Esp.KillerColor)   or Config.Esp.KillerColor
        Config.Esp.TracerColor   = c3load(data.Esp.TracerColor)   or Config.Esp.TracerColor
        Config.Esp.TracerColor2  = c3load(data.Esp.TracerColor2)  or Config.Esp.TracerColor2
        Config.Esp.SurvivorColor = c3load(data.Esp.SurvivorColor) or Config.Esp.SurvivorColor
    end
    if type(data.Veil) == "table" then
        Config.Veil.ColorOk      = c3load(data.Veil.ColorOk)      or Config.Veil.ColorOk
        Config.Veil.ColorPierce  = c3load(data.Veil.ColorPierce)  or Config.Veil.ColorPierce
        Config.Veil.ColorHit     = c3load(data.Veil.ColorHit)     or Config.Veil.ColorHit
        Config.Veil.ColorApprox  = c3load(data.Veil.ColorApprox)  or Config.Veil.ColorApprox
    end
    if type(data.Survi) == "table" then
        Config.Survi.WaveColor = c3load(data.Survi.WaveColor) or Config.Survi.WaveColor
    end
    -- restore font
    if type(data.Esp) == "table" and type(data.Esp.TextFont) == "string" and fontMapping[data.Esp.TextFont] then
        Config.Esp.TextFont = fontMapping[data.Esp.TextFont]
    end
end

LoadConfig()

local BoxEdges = {{1,2}, {3,4}, {1,3}, {2,4}, {5,6}, {7,8}, {5,7}, {6,8}, {1,5}, {2,6}, {3,7}, {4,8}}

local function GetCorners3D(part, pos)
    if not pos then return {} end
    local sx, sy, sz = part.Size.X/2, part.Size.Y/2, part.Size.Z/2
    local m = MemoryManager.GetRotationMatrix(part)
    local r = m and Vector3_new(m[0], m[3], m[6]) * sx or Vector3_new(sx, 0, 0)
    local u = m and Vector3_new(m[1], m[4], m[7]) * sy or Vector3_new(0, sy, 0)
    local b = m and Vector3_new(m[2], m[5], m[8]) * sz or Vector3_new(0, 0, sz)
    return {pos-r+u+b, pos+r+u+b, pos-r-u+b, pos+r-u+b, pos-r+u-b, pos+r+u-b, pos-r-u-b, pos+r-u-b}
end

local hasClicked = false
local clickPending = false

-- auto skill
local function Autogen()
    local CheckPrompt = PlayerGui:FindFirstChild("SkillCheckPromptGui")
    if CheckPrompt then
        local check = CheckPrompt:FindFirstChild("Check")
        if not check then return end

        local lineObj = check:FindFirstChild("Line")
        local goalObj = check:FindFirstChild("Goal")
        if not lineObj or not goalObj then return end

        local Rotation = MemoryManager.GetGuiObjectRotation(lineObj.Address)
        local GoalRotation = MemoryManager.GetGuiObjectRotation(goalObj.Address)

        if not Rotation or not GoalRotation then return end

        Rotation = normalizeAngle(Rotation)
        GoalRotation = normalizeAngle(GoalRotation)

        local lowerSuccess = normalizeAngle(104 + GoalRotation)
        local upperSuccess = normalizeAngle(114 + GoalRotation)

        local isPerfect = false
        if lowerSuccess < upperSuccess then
            isPerfect = (Rotation >= lowerSuccess and Rotation <= upperSuccess)
        else
            isPerfect = (Rotation >= lowerSuccess or Rotation <= upperSuccess)
        end

        if isPerfect and Config.AutoSkillCheck.Ratio == "Perfect" then
            if not hasClicked and not clickPending then
                hasClicked = true
                clickPending = true
                task_spawn(function()
                    if Config.AutoSkillCheck.Delay > 0 then
                        task_wait(Config.AutoSkillCheck.Delay)
                    end
                    local ok2 = pcall(function()
                        keypress(32)
                        task_wait(0.02)
                        keyrelease(32)
                    end)
                    clickPending = false
                end)
            end
        else
            hasClicked = false
        end
    else
        hasClicked = false
        clickPending = false
    end
end

-- veil math and prediction

local function getGravityVeil()
    local g = workspace.Gravity
    if not (type(g) == "number" and g > 0) then
        if not _gravityFallbackLogged then
            print("[getGravityVeil] workspace.Gravity unavailable, falling back to 196.2")
            _gravityFallbackLogged = true
        end
        g = 196.2
    end
    return g * Config.Veil.GravityMult
end

-- ultra optimized prediction
local function calcPrediction(ox, oy, oz, part)
    local tp = part.Position
    local tv = part.AssemblyLinearVelocity
    if not tv then
        tv = part.Velocity
        if tv then
            if not _velocityFallbackLogged then
                print("[calcPrediction] AssemblyLinearVelocity unavailable, falling back to Velocity")
                _velocityFallbackLogged = true
            end
        else
            if not _velocityFallbackLogged then
                print("[calcPrediction] AssemblyLinearVelocity and Velocity both unavailable, falling back to zero vector")
                _velocityFallbackLogged = true
            end
            tv = Vector3_new(0,0,0)
        end
    end
    
    local dx = tp.X - ox
    local dz = tp.Z - oz
    local hDist = math_sqrt(dx*dx + dz*dz)
    
    -- HARDCODED SPEEDS HERE
    local v = Config.Veil.PierceActive and 460 or 400
    local t = hDist / v -- time of flight calc
    
    -- future pos
    local px = tp.X + (tv.X * t)
    local pz = tp.Z + (tv.Z * t)
    
    -- recalc
    local pdx = px - ox
    local pdz = pz - oz
    local pHDistSq = (pdx*pdx + pdz*pdz)
    local pDiff = (tp.Y + tv.Y * t) - oy
    
    local gr = getGravityVeil()
    local v2 = v * v
    local disc = v2*v2 - gr*(gr*pHDistSq + 2*pDiff*v2)
    
    local approx = false
    if disc < 0 then
        disc = 0
        approx = true
    end
    
    -- math bypass trig
    local aimY = oy + (v2 - math_sqrt(disc)) / gr
    
    return px, aimY, pz, true, approx
end

-- aimbot lock line
local veilLockLine = Drawing_new("Line")
veilLockLine.Thickness = 1
veilLockLine.Visible = false

local chargeBg    = Drawing_new("Square")
chargeBg.Filled   = true
chargeBg.Color    = Color3.fromRGB(20, 20, 20)
chargeBg.Transparency = 0.4
chargeBg.Visible  = false

local chargeFill  = Drawing_new("Square")
chargeFill.Filled = true
chargeFill.Transparency = 1
chargeFill.Visible = false

local chargeTxt   = Drawing_new("Text")
chargeTxt.Size    = 13
chargeTxt.Center  = true
chargeTxt.Outline = true
chargeTxt.Visible = false

local veilObjs = {}
local function getVeilObj(i)
    if not veilObjs[i] then
        local lines = {}
        for j=1, 4 do
            local l = Drawing_new("Line")
            l.Thickness = 1
            l.Visible = false
            lines[j] = l
        end
        local txt = Drawing_new("Text")
        txt.Size = 11
        txt.Center = true
        txt.Outline = true
        txt.Visible = false
        veilObjs[i] = {lines=lines, txt=txt}
    end
    return veilObjs[i]
end

local function hideVeilObj(o)
    o.lines[1].Visible = false
    o.lines[2].Visible = false
    o.lines[3].Visible = false
    o.lines[4].Visible = false
    o.txt.Visible = false
end

-- optimized cross drawer no table alloc
local function drawVeilCross(o, sx, sy, col)
    local S = Config.Veil.CrossSize
    local T = Config.Veil.Thickness
    local center = Vector2_new(sx, sy)

    local l1 = o.lines[1]
    l1.From = center
    l1.To = Vector2_new(sx, sy - S)
    if l1.Color ~= col then l1.Color = col end
    if l1.Thickness ~= T then l1.Thickness = T end
    if not l1.Visible then l1.Visible = true end

    local l2 = o.lines[2]
    l2.From = center
    l2.To = Vector2_new(sx, sy + S)
    if l2.Color ~= col then l2.Color = col end
    if l2.Thickness ~= T then l2.Thickness = T end
    if not l2.Visible then l2.Visible = true end

    local l3 = o.lines[3]
    l3.From = center
    l3.To = Vector2_new(sx - S, sy)
    if l3.Color ~= col then l3.Color = col end
    if l3.Thickness ~= T then l3.Thickness = T end
    if not l3.Visible then l3.Visible = true end

    local l4 = o.lines[4]
    l4.From = center
    l4.To = Vector2_new(sx + S, sy)
    if l4.Color ~= col then l4.Color = col end
    if l4.Thickness ~= T then l4.Thickness = T end
    if not l4.Visible then l4.Visible = true end
end

-- pool objects
local PlayerDrawings = {}
local GenCache = {}
local LastCacheTime = 0
local lastMap = nil
local activePlayers = {}
local sharedCirclePts = {}
local sharedBoxPts = {}

local function RenderPlayers(playerList)
    if not Config.Esp.Activate then
        for _, cache in pairs(PlayerDrawings) do
            cache.Name.Visible = false
            for i=1,5 do cache.LookLines[i].Visible = false end
            for l=1, Config.Esp.CircleSegments do cache.CircleLines[l].Visible = false end
        end
        return
    end

    local cam = workspace.CurrentCamera
    local camPos = cam and cam.Position or Vector3_new(0, 0, 0)
    
    -- clear pool properly without reallocating
    for k in pairs(activePlayers) do activePlayers[k] = nil end

    local maxSq = Config.Esp.MaxDistance * Config.Esp.MaxDistance

    for i = 1, #playerList do
        local plr = playerList[i]
        local plrName = plr.Name
        if not plrName then continue end

        activePlayers[plrName] = true

        if plrName == Player.Name and not Config.Esp.Self then
            local cache = PlayerDrawings[plrName]
            if cache then
                cache.Name.Visible = false
                for j=1,5 do cache.LookLines[j].Visible = false end
                for l=1, Config.Esp.CircleSegments do cache.CircleLines[l].Visible = false end
            end
            continue
        end

        local team = plr.Team
        local teamName = team and team.Name or ""
        local isKiller = (teamName == "Killer")

        local char = plr.Character
        local hrp = char and char:FindFirstChild("HumanoidRootPart")

        if hrp then
            local pos = hrp.Position
            if not pos then continue end

            local dx, dy, dz = pos.X - camPos.X, pos.Y - camPos.Y, pos.Z - camPos.Z
            local distSq = dx*dx + dy*dy + dz*dz
            
            local cache = PlayerDrawings[plrName]
            if not cache then
                cache = {
                    Name = Drawing_new("Text"),
                    LookLines = {},
                    CircleLines = {}
                }
                cache.Name.Size, cache.Name.Center = 14, true
                for j=1,5 do
                    cache.LookLines[j] = Drawing_new("Line")
                    cache.LookLines[j].Thickness = 1.5
                end
                for l=1, Config.Esp.CircleSegments do 
                    cache.CircleLines[l] = Drawing_new("Line") 
                    cache.CircleLines[l].Thickness = 1 
                end
                PlayerDrawings[plrName] = cache
            end
            
            if distSq > maxSq then
                cache.Name.Visible = false
                for j=1,5 do cache.LookLines[j].Visible = false end
                for l=1, Config.Esp.CircleSegments do cache.CircleLines[l].Visible = false end
                continue
            end
            
            local name3d = pos + Vector3_new(0, 4.5, 0)
            local namePos, nOn = WTS(name3d)

            local circleTog, nameTog, espCol
            if isKiller then
                circleTog = Config.Esp.KillerCircle
                nameTog = Config.Esp.KillerName
                espCol = Config.Esp.KillerColor
            else
                circleTog = Config.Esp.SurvivorCircle
                nameTog = Config.Esp.SurvivorName
                espCol = Config.Esp.SurvivorColor
            end

            if nameTog and nOn and namePos then
                cache.Name.Position = roundVec2(namePos)
                if cache.Name.Text ~= plrName then cache.Name.Text = plrName end
                if cache.Name.Color ~= espCol then cache.Name.Color = espCol end
                if cache.Name.Font ~= Config.Esp.TextFont then cache.Name.Font = Config.Esp.TextFont end
                if cache.Name.Outline ~= Config.Esp.TextOutline then cache.Name.Outline = Config.Esp.TextOutline end
                if not cache.Name.Visible then cache.Name.Visible = true end
            else
                cache.Name.Visible = false
            end

            if circleTog then
                local radius = Config.Esp.CircleRadius
                local segments = Config.Esp.CircleSegments
                local allOn = true
                
                for j = 1, segments do
                    local mults = CircleMults[j]
                    local offset3d = Vector3_new(mults.x * radius, -3, mults.z * radius)
                    local sc, on = WTS(pos + offset3d)

                    if not on or not sc then
                        allOn = false
                        break
                    end
                    sharedCirclePts[j] = roundVec2(sc)
                end
                
                if allOn then
                    for j = 1, segments do
                        local nextIdx = (j % segments) + 1
                        local line = cache.CircleLines[j]
                        line.From = sharedCirclePts[j]
                        line.To = sharedCirclePts[nextIdx]
                        if line.Color ~= espCol then line.Color = espCol end
                        if not line.Visible then line.Visible = true end
                    end
                else
                    for l=1, segments do cache.CircleLines[l].Visible = false end
                end
            else
                for l=1, Config.Esp.CircleSegments do cache.CircleLines[l].Visible = false end
            end

            -- look tracer
            if isKiller and Config.Esp.LookTracer then
                local tracerOk = false
                local primPtr = mem_read("uintptr_t", hrp.Address + 0x148)
                if type(primPtr) == "number" and primPtr > 0x100000 then
                    local r02 = mem_read("float", primPtr + 0xC8)
                    local r12 = mem_read("float", primPtr + 0xD4)
                    local r22 = mem_read("float", primPtr + 0xE0)
                    if type(r02) == "number" and type(r12) == "number" and type(r22) == "number" then
                        tracerOk = true
                        local lookVec = Vector3_new(-r02, -r12, -r22)
                        local tracerOrigin = pos + Vector3_new(0, -3, 0) + (lookVec * Config.Esp.CircleRadius)
                        local prevScreen, prevOn = WTS(tracerOrigin)
                        if prevOn and prevScreen then prevScreen = roundVec2(prevScreen) end

                        local c1 = Config.Esp.TracerColor
                        local c2 = Config.Esp.TracerColor2
                        local dr, dg, db = c2.R - c1.R, c2.G - c1.G, c2.B - c1.B

                        for j=1, 5 do
                            local t = j / 5
                            local current3d = tracerOrigin + (lookVec * (Config.Esp.TracerLength * t))
                            local currScreen, currOn = WTS(current3d)
                            if currOn and currScreen then currScreen = roundVec2(currScreen) end

                            local line = cache.LookLines[j]
                            if currOn and prevOn and prevScreen and currScreen then
                                line.From = prevScreen
                                line.To = currScreen
                                local segCol = Color3_new(c1.R + dr * t, c1.G + dg * t, c1.B + db * t)
                                if line.Color ~= segCol then line.Color = segCol end
                                if not line.Visible then line.Visible = true end
                            else
                                line.Visible = false
                            end
                            prevScreen = currScreen
                            prevOn = currOn
                        end
                    end
                end
                if not tracerOk then
                    for j=1,5 do cache.LookLines[j].Visible = false end
                end
            else
                for j=1,5 do cache.LookLines[j].Visible = false end
            end
        elseif PlayerDrawings[plrName] then
            PlayerDrawings[plrName].Name:Remove()
            for j=1,5 do PlayerDrawings[plrName].LookLines[j]:Remove() end
            for l=1, Config.Esp.CircleSegments do PlayerDrawings[plrName].CircleLines[l]:Remove() end
            PlayerDrawings[plrName] = nil
        end
    end
    
    for cachedName, cache in pairs(PlayerDrawings) do
        if not activePlayers[cachedName] then
            if cache.Name then cache.Name:Remove() end
            if cache.LookLines then for j=1,5 do cache.LookLines[j]:Remove() end end
            if cache.CircleLines then for l=1, Config.Esp.CircleSegments do cache.CircleLines[l]:Remove() end end
            PlayerDrawings[cachedName] = nil
        end
    end
end

local function UpdateGens()
    local map = workspace:FindFirstChild("Map")
    if not map then
        for part, cache in pairs(GenCache) do
            cache.Text:Remove()
            for l=1,12 do cache.Lines[l]:Remove() end
            GenCache[part] = nil
        end
        lastMap = nil
        return
    end

    -- only rescan when map changes, gens dont spawn mid match
    if map == lastMap then return end
    lastMap = map

    -- clear old cache
    for part, cache in pairs(GenCache) do
        cache.Text:Remove()
        for l=1,12 do cache.Lines[l]:Remove() end
        GenCache[part] = nil
    end

    local desc = map:GetDescendants()
    for i = 1, #desc do
        local obj = desc[i]
        if obj.Name == "Generator" then
            local p = obj:IsA("Model") and (obj.PrimaryPart or obj:FindFirstChildWhichIsA("BasePart")) or (obj:IsA("BasePart") and obj)
            if p then
                local pos = p.Position
                if pos then
                    local text = Drawing_new("Text")
                    text.Text, text.Size, text.Center = "Generator", 14, true
                    local lines = {}
                    for l=1, 12 do lines[l] = Drawing_new("Line"); lines[l].Thickness = 1 end
                    GenCache[p] = {Text=text, Lines=lines, Corners=GetCorners3D(p, pos), CachedPos=pos}
                end
            end
        end
    end
end

local function RenderGens()
    local now = os_clock()
    if now - LastCacheTime >= 5 then
        UpdateGens()
        LastCacheTime = now
    end
    
    local cam = workspace.CurrentCamera
    local camPos = cam and cam.Position or Vector3_new(0, 0, 0)
    local maxSq = Config.Esp.MaxDistance * Config.Esp.MaxDistance
    
    for part, cache in pairs(GenCache) do
        if cache.CachedPos then
            local dx, dy, dz = cache.CachedPos.X - camPos.X, cache.CachedPos.Y - camPos.Y, cache.CachedPos.Z - camPos.Z
            local distSq = dx*dx + dy*dy + dz*dz
            
            if Config.Esp.Activate and distSq <= maxSq then
                local cp, on = WTS(cache.CachedPos)
                local genModel = part.Parent
                if not genModel then continue end
                local genHidden = false
                if on and cp and Config.Esp.Text then
                    local pct = math_clamp(math_floor(genModel:GetAttribute("RepairProgress") or 0), 0, 100)
                    local regressing = genModel:GetAttribute("Regressing") or false
                    local repairing = genModel:GetAttribute("PlayersRepairingCount") or 0

                    -- hide if completed
                    if Config.Esp.GenHideDone and pct >= 100 then
                        cache.Text.Visible = false
                        for l=1,12 do cache.Lines[l].Visible = false end
                        genHidden = true
                    else
                        -- only rebuild text when values change
                        if pct ~= cache._lastPct or regressing ~= cache._lastReg or repairing ~= cache._lastRep then
                            local line1 = "Generator"
                            if Config.Esp.GenProgress then
                                line1 = "Generator  " .. pct .. "%"
                            end
                            local line2 = ""
                            if Config.Esp.GenStatus then
                                if regressing then
                                    line2 = "\nRegressing"
                                elseif repairing > 0 then
                                    line2 = "\nRepairing " .. (Config.Esp.GenProgress and "" or pct .. "%")
                                end
                            end
                            local line3 = ""
                            if Config.Esp.GenBar then
                                local filled = math_floor(pct / 100 * 15)
                                line3 = "\n[" .. string_rep("|", filled) .. string_rep(".", 15 - filled) .. "]"
                            end
                            cache._lastText = line1 .. line2 .. line3
                            cache._lastPct = pct
                            cache._lastReg = regressing
                            cache._lastRep = repairing
                        end

                        cache.Text.Text = cache._lastText or "Generator"
                        cache.Text.Position = roundVec2(cp)

                        -- dynamic color
                        if regressing then
                            cache.Text.Color = Color_Regressing
                        elseif repairing > 0 then
                            cache.Text.Color = Color_Repairing
                        else
                            cache.Text.Color = Config.Esp.TextColor
                        end

                        cache.Text.Transparency = Config.Esp.TextOpacity
                        cache.Text.Font = Config.Esp.TextFont 
                        cache.Text.Outline = Config.Esp.TextOutline
                        cache.Text.Visible = true
                    end
                else 
                    cache.Text.Visible = false 
                end
            
            if not genHidden then
                if Config.Esp.Box3D and cache.Corners then
                    local allOn = true
                    for c=1,8 do
                        local sc, o = WTS(cache.Corners[c])
                        if not o or not sc then
                            allOn = false
                            break
                        end
                        sharedBoxPts[c] = roundVec2(sc)
                    end

                    if allOn then
                        local boxCol = Config.Esp.BoxColor
                        local boxOp = Config.Esp.BoxOpacity
                        for l=1,12 do
                            local e, line = BoxEdges[l], cache.Lines[l]
                            line.From = sharedBoxPts[e[1]]
                            line.To = sharedBoxPts[e[2]]
                            if line.Color ~= boxCol then line.Color = boxCol end
                            if line.Transparency ~= boxOp then line.Transparency = boxOp end
                            if not line.Visible then line.Visible = true end
                        end
                    else
                        for l=1,12 do cache.Lines[l].Visible = false end
                    end
                else
                    for l=1,12 do cache.Lines[l].Visible = false end
                end
            end
            end -- closes: if Config.Esp.Activate and distSq <= maxSq then
        else
            cache.Text.Visible = false
            if cache.Lines then
                for l=1,12 do cache.Lines[l].Visible = false end
            end
        end
    end
end

-- menu settings
UILib:SetWatermarkEnabled(false)
UILib:SetMenuTitle("Violence District")
UILib:SetMenuSize(Vector2_new(550, 560))
UILib:CenterMenu()

local MainTab = UILib:Tab("Main")
local SkillSec = MainTab:Section("Auto-Skillcheck")
SkillSec:Toggle("Auto Skill Check", Config.AutoSkillCheck.Activate, function(v) Config.AutoSkillCheck.Activate = v; configDirty = true end)
SkillSec:Slider("Reaction Delay", Config.AutoSkillCheck.Delay, 0.01, 0.0, 0.14, "s", function(v) Config.AutoSkillCheck.Delay = v; configDirty = true end)

local VisTab = UILib:Tab("Visuals")
local MasterSec = VisTab:Section("Master")
MasterSec:Toggle("Master ESP", Config.Esp.Activate, function(v) Config.Esp.Activate = v; configDirty = true end)
MasterSec:Slider("Render Distance", Config.Esp.MaxDistance, 50, 50, 5000, " studs", function(v) Config.Esp.MaxDistance = v; configDirty = true end)

MasterSec:Dropdown("ESP Font", {"System"}, {"System", "SystemBold", "UI", "Minecraft", "Monospace", "Pixel", "Fortnite"}, false, function(v)
    if v and v[1] and fontMapping[v[1]] then Config.Esp.TextFont = fontMapping[v[1]] end
    configDirty = true
end)
MasterSec:Toggle("Text Outline", Config.Esp.TextOutline, function(v) Config.Esp.TextOutline = v; configDirty = true end)

local EspSec = VisTab:Section("Generators ESP")
local tTog = EspSec:Toggle("Text", Config.Esp.Text, function(v) Config.Esp.Text = v; configDirty = true end)
tTog:AddColorpicker("Color", Config.Esp.TextColor, false, function(c) Config.Esp.TextColor = c; configDirty = true end)
local bTog = EspSec:Toggle("Box", Config.Esp.Box3D, function(v) Config.Esp.Box3D = v; configDirty = true end)
bTog:AddColorpicker("Color", Config.Esp.BoxColor, false, function(c) Config.Esp.BoxColor = c; configDirty = true end)
EspSec:Toggle("Show Progress %",    Config.Esp.GenProgress, function(v) Config.Esp.GenProgress = v; configDirty = true end)
EspSec:Toggle("Show Status Text",   Config.Esp.GenStatus,   function(v) Config.Esp.GenStatus   = v; configDirty = true end)
EspSec:Toggle("Show Bar",           Config.Esp.GenBar,      function(v) Config.Esp.GenBar       = v; configDirty = true end)
EspSec:Toggle("Hide Completed",     Config.Esp.GenHideDone, function(v) Config.Esp.GenHideDone  = v; configDirty = true end)

local SelfSec = VisTab:Section("Self ESP")
SelfSec:Toggle("Include Me", Config.Esp.Self, function(v) Config.Esp.Self = v; configDirty = true end, false, "shows you in killer/survivor esp groups")

local KillerSec = VisTab:Section("Killer ESP")
local kNameTog = KillerSec:Toggle("Name", Config.Esp.KillerName, function(v) Config.Esp.KillerName = v; configDirty = true end)
kNameTog:AddColorpicker("Color", Config.Esp.KillerColor, false, function(c) Config.Esp.KillerColor = c; configDirty = true end)
KillerSec:Toggle("3D Circle", Config.Esp.KillerCircle, function(v) Config.Esp.KillerCircle = v; configDirty = true end)
local kTracerTog = KillerSec:Toggle("Look Tracer", Config.Esp.LookTracer, function(v) Config.Esp.LookTracer = v; configDirty = true end)
kTracerTog:AddColorpicker("Start Color", Config.Esp.TracerColor, false, function(c) Config.Esp.TracerColor = c; configDirty = true end)
local kTracerGradTog = KillerSec:Toggle("Tracer End Color", true, function() end)
kTracerGradTog:AddColorpicker("Color 2", Config.Esp.TracerColor2, false, function(c) Config.Esp.TracerColor2 = c; configDirty = true end)
KillerSec:Slider("Tracer Length", Config.Esp.TracerLength, 1, 1, 10, "", function(v) Config.Esp.TracerLength = v; configDirty = true end)

local SurvSec = VisTab:Section("Survivor ESP")
local sNameTog = SurvSec:Toggle("Name", Config.Esp.SurvivorName, function(v) Config.Esp.SurvivorName = v; configDirty = true end)
sNameTog:AddColorpicker("Color", Config.Esp.SurvivorColor, false, function(c) Config.Esp.SurvivorColor = c; configDirty = true end)
SurvSec:Toggle("3D Circle", Config.Esp.SurvivorCircle, function(v) Config.Esp.SurvivorCircle = v; configDirty = true end)

-- ==============================================================
-- VEILBOT WITH SUBTAB SYSTEM
-- ==============================================================
local VeilTab = UILib:Tab("VeilBOT")

-- 1. ALT SEKME: COMBAT
local VeilCombatSub = VeilTab:SubTab("Combat")

local vCombat = VeilCombatSub:Section("Combat & Pierce")
local VeilAimTog = vCombat:Toggle("Aimbot Active", Config.Veil.AimActive, function(v) Config.Veil.AimActive = v; configDirty = true end)
VeilAimTog:AddKeybind(Config.Veil.AimKey, Config.Veil.AimMode, true, function(keyId, mode)
    local kName = UILib:_KeyIDToName(keyId)
    if kName then Config.Veil.AimKey = kName end
    Config.Veil.AimMode = mode
    configDirty = true
end)

local VeilPierceTog = vCombat:Toggle("Pierce Active", Config.Veil.PierceActive, function(v) Config.Veil.PierceActive = v; configDirty = true end, true, "fast pierce mode")
VeilPierceTog:AddKeybind(Config.Veil.PierceKey, Config.Veil.PierceMode, false, function(keyId, mode)
    local kName = UILib:_KeyIDToName(keyId)
    if kName then Config.Veil.PierceKey = kName end
    configDirty = true
end)

local CancelTog = vCombat:Toggle("Manual Cancel Key", false, function() end, false, "cancel if stuck")
CancelTog:AddKeybind(Config.Veil.CancelKey, "Toggle", false, function(keyId, mode)
    local kName = UILib:_KeyIDToName(keyId)
    if kName then Config.Veil.CancelKey = kName end
    configDirty = true
end)

vCombat:Dropdown("Aim Target", {Config.Veil.Target}, {"HumanoidRootPart", "Head"}, false, function(v) Config.Veil.Target = v[1]; configDirty = true end)
vCombat:Slider("Smoothness", Config.Veil.Smooth, 0.1, 1.0, 20.0, "", function(v) Config.Veil.Smooth = v; configDirty = true end)
vCombat:Slider("Max Distance", Config.Veil.MaxDist, 50, 50, 3000, " studs", function(v) Config.Veil.MaxDist = v; configDirty = true end)

local vTrigger = VeilCombatSub:Section("Triggerbot")
vTrigger:Toggle("Triggerbot Active", Config.Veil.TriggerActive, function(v) Config.Veil.TriggerActive = v; configDirty = true end)
vTrigger:Slider("Min Charge Normal", Config.Veil.TriggerMinCharge, 0.1, 0.3, 3.0, "s", function(v) Config.Veil.TriggerMinCharge = v; configDirty = true end)
vTrigger:Slider("Min Charge Pierce", Config.Veil.TriggerMinChargePierce, 0.1, 0.3, 3.0, "s", function(v) Config.Veil.TriggerMinChargePierce = v; configDirty = true end)
vTrigger:Slider("Trigger Delay", Config.Veil.TriggerDelay, 0.01, 0.0, 0.5, "s", function(v) Config.Veil.TriggerDelay = v; configDirty = true end)


-- 2. ALT SEKME: VISUALS
local VeilVisualsSub = VeilTab:SubTab("Visuals")

local vVis = VeilVisualsSub:Section("Cross & Line")
vVis:Toggle("Lock Line", Config.Veil.LockLine, function(v) Config.Veil.LockLine = v; configDirty = true end)
vVis:Toggle("Show Crosses", Config.Veil.EspCross, function(v) Config.Veil.EspCross = v; configDirty = true end)
vVis:Slider("Cross Size", Config.Veil.CrossSize, 1, 2, 30, "px", function(v) Config.Veil.CrossSize = v; configDirty = true end)
vVis:Slider("Thickness", Config.Veil.Thickness, 1, 1, 5, "px", function(v) Config.Veil.Thickness = v; configDirty = true end)
vVis:Toggle("Sticky Aim", Config.Veil.StickyAim, function(v) Config.Veil.StickyAim = v; configDirty = true end)
vVis:Slider("Sticky Threshold", Config.Veil.StickyThresh, 10, 50, 500, "px", function(v) Config.Veil.StickyThresh = v; configDirty = true end)
vVis:Slider("Hit Threshold", Config.Veil.HitThresh, 1, 2, 25, "px", function(v) Config.Veil.HitThresh = v; configDirty = true end)

local cOk = vVis:Toggle("Color Normal", true, function() end)
cOk:AddColorpicker("Ok", Config.Veil.ColorOk, true, function(c) Config.Veil.ColorOk = c; configDirty = true end)
local cPierce = vVis:Toggle("Color Pierce", true, function() end)
cPierce:AddColorpicker("Pierce", Config.Veil.ColorPierce, true, function(c) Config.Veil.ColorPierce = c; configDirty = true end)
local cHit = vVis:Toggle("Color In Range", true, function() end)
cHit:AddColorpicker("Hit", Config.Veil.ColorHit, true, function(c) Config.Veil.ColorHit = c; configDirty = true end)
local cApprox = vVis:Toggle("Color Approx", true, function() end)
cApprox:AddColorpicker("Approx", Config.Veil.ColorApprox, true, function(c) Config.Veil.ColorApprox = c; configDirty = true end)

-- Charge Indicator section
local vCharge = VeilVisualsSub:Section("Charge Indicator")

-- Main toggle
vCharge:Toggle("Show Indicator", Config.Veil.ChargeBar, function(v) Config.Veil.ChargeBar = v; configDirty = true end)

-- Display mode
vCharge:Dropdown("Display Mode", {Config.Veil.ChargeMode}, {"Bar", "Percent"}, false, function(v) Config.Veil.ChargeMode = v[1]; configDirty = true end)

-- Visual sizing & position (only relevant for Bar mode, still shown for Percent Y offset)
vCharge:Slider("Bar Width",   Config.Veil.ChargeBarW,    5,  50, 300, "px", function(v) Config.Veil.ChargeBarW    = v; configDirty = true end)
vCharge:Slider("Bar Height",  Config.Veil.ChargeBarH,    1,   4,  20, "px", function(v) Config.Veil.ChargeBarH    = v; configDirty = true end)
vCharge:Slider("Y Offset",    Config.Veil.ChargeBarOffY, 1,  10, 150, "px", function(v) Config.Veil.ChargeBarOffY = v; configDirty = true end)

-- ==============================================================

-- survivor tab
local AbyssSec = MainTab:Section("Abysswalker - Dark Severance")
AbyssSec:Toggle("Auto Crouch", Config.Survi.AbyssDodge, function(v)
    Config.Survi.AbyssDodge = v
    configDirty = true
end)
AbyssSec:Slider("Range (studs)", Config.Survi.DodgeDist, 5, 5, 150, "", function(v)
    Config.Survi.DodgeDist = v
    configDirty = true
end)
AbyssSec:Slider("Reaction Delay", Config.Survi.DodgeDelay, 0.01, 0.0, 0.3, "s", function(v)
    Config.Survi.DodgeDelay = v
    configDirty = true
end)
AbyssSec:Slider("Crouch Duration", Config.Survi.DodgeHold, 0.05, 0.1, 3.0, "s", function(v)
    Config.Survi.DodgeHold = v
    configDirty = true
end)
local waveToggle = AbyssSec:Toggle("Wave ESP", Config.Survi.WaveEsp, function(v)
    Config.Survi.WaveEsp = v
    configDirty = true
end)
waveToggle:AddColorpicker("Color", Config.Survi.WaveColor, false, function(c)
    Config.Survi.WaveColor = c
    configDirty = true
end)

UILib:CreateSettingsTab("Settings")

local menuItems = UILib._tree["Settings"]._items["Menu"]._items
menuItems[1].label = "Menu key"
table.remove(menuItems, 4)
table.remove(menuItems, 3)
table.remove(menuItems, 2)

if UILib._tree["Settings"] and UILib._tree["Settings"]._items["Theming"] then
    UILib._theming.accent = Config.Esp.BoxColor
end

UILib:RegisterActivity(function()
    if not Config.AutoSkillCheck.Activate then return "Skill: Off" end
    return "Skill Delay: " .. tostring(Config.AutoSkillCheck.Delay) .. "s"
end)

local m1WasHeld = false
local pierceStartTime = nil
local triggerChargeStart = nil
local triggerLockTime = nil
local aimTargets = {}
local aimTargetCount = 0

local function hasSpearEquipped()
    local char = Player.Character
    if not char then return false end
    return char:FindFirstChild("Spear1") ~= nil
end

-- veil logic
local function HandleVeilInputs()
    local m1Held = UILib:_IsKeyHeld('m1')

    -- triggerbot charge tracking
    if m1Held and not m1WasHeld then
        if hasSpearEquipped() then
            triggerChargeStart = os_clock()
        end
    end
    if not m1Held then
        triggerChargeStart = nil
        triggerLockTime = nil
    end

    -- pierce m1 tracking
    if Config.Veil.PierceActive then
        if m1Held and not m1WasHeld then pierceStartTime = os_clock() end
        if m1WasHeld and not m1Held then
            pierceStartTime = nil   -- solo resetea timer, NO desactiva pierce
        end
        -- 7s max hold timeout
        if pierceStartTime and (os_clock() - pierceStartTime) >= 7 then
            VeilPierceTog:Set(false)
            pierceStartTime = nil
        end
    else
        pierceStartTime = nil
    end
    m1WasHeld = m1Held
    
    -- aimbot key
    local aimKey = Config.Veil.AimKey
    if aimKey then
        if Config.Veil.AimMode == 'Hold' then
            local held = UILib:_IsKeyHeld(aimKey)
            if held ~= Config.Veil.AimActive then VeilAimTog:Set(held) end
        elseif Config.Veil.AimMode == 'Toggle' and UILib:_IsKeyPressed(aimKey) then
            VeilAimTog:Set(not Config.Veil.AimActive)
        end
    end
    
    -- pierce conflict handling
    local pKey = Config.Veil.PierceKey
    local cKey = Config.Veil.CancelKey
    
    -- same key toggle mode
    if pKey == cKey then
        if pKey and UILib:_IsKeyPressed(pKey) then
            VeilPierceTog:Set(not Config.Veil.PierceActive)
        end
    else
        -- diff keys handling
        if pKey and UILib:_IsKeyPressed(pKey) then
            if not Config.Veil.PierceActive then VeilPierceTog:Set(true) end
        end
        if cKey and UILib:_IsKeyPressed(cKey) then
            if Config.Veil.PierceActive then VeilPierceTog:Set(false) end
        end
    end
end


-- interpolated aim position in 3D world
local _aimWx, _aimWy, _aimWz = nil, nil, nil
local _lockedTarget = nil  -- locked player name
local _lastAimTime = nil

local function RenderVeilAimbot(pls)
    HandleVeilInputs()
    
    local cam = workspace.CurrentCamera
    local cX = cam and cam.ViewportSize.X / 2 or 960
    local cY = cam and cam.ViewportSize.Y / 2 or 540
    
    local showEsp = Config.Veil.EspActive and Config.Veil.EspCross and cam

    -- hide crosses if esp off
    if not showEsp then
        for i=1, #veilObjs do hideVeilObj(veilObjs[i]) end
    end

    if not cam then
        veilLockLine.Visible = false
        return
    end

    local ox, oy, oz = cam.Position.X, cam.Position.Y, cam.Position.Z
    local idx = 0
    aimTargetCount = 0

    local pierce = Config.Veil.PierceActive
    local colOk = pierce and Config.Veil.ColorPierce or Config.Veil.ColorOk
    local tgtName = Config.Veil.Target
    local maxSq = Config.Veil.MaxDist * Config.Veil.MaxDist

    for i=1, #pls do
        local p = pls[i]
        -- never lock self using names
        local pChar = p.Character
        if p.Name ~= Player.Name and pChar then
            local pr = pChar:FindFirstChild(tgtName) or pChar:FindFirstChild("HumanoidRootPart")
            if pr then
                local tp = pr.Position
                local dx, dz = tp.X - ox, tp.Z - oz
                local dSq = dx*dx + dz*dz

                -- sqrt bypass
                if dSq <= maxSq then
                    local px, aimY, pz, ok, approx = calcPrediction(ox, oy, oz, pr)

                    if ok and aimY and (not approx or Config.Veil.ShowApprox) then
                        local sc, on = WTS(Vector3_new(px, aimY, pz))
                        if on and sc then
                            local sx, sy = sc.X, sc.Y
                            local dScr = math_sqrt((sx - cX)^2 + (sy - cY)^2)

                            -- esp cross drawing
                            local col = colOk
                            if approx then col = Config.Veil.ColorApprox
                            elseif Config.Veil.ShowHit and dScr <= Config.Veil.HitThresh then col = Config.Veil.ColorHit end

                            local realDist = math_sqrt(dSq)

                            if showEsp then
                                idx = idx + 1
                                local o = getVeilObj(idx)

                                drawVeilCross(o, sx, sy, col)
                                o.txt.Position = Vector2_new(sx, sy + Config.Veil.CrossSize + 4)
                                o.txt.Text = approx and (math_floor(realDist).."m ~") or (math_floor(realDist).."m")
                                if o.txt.Color ~= col then o.txt.Color = col end
                                o.txt.Visible = true
                            end

                            -- aimbot pool
                            aimTargetCount = aimTargetCount + 1
                            local tData = aimTargets[aimTargetCount] or {}
                            tData.sx, tData.sy, tData.dScr, tData.color, tData.wx, tData.wy, tData.wz, tData.name = sx, sy, dScr, col, px, aimY, pz, p.Name
                            tData.dist = realDist
                            aimTargets[aimTargetCount] = tData
                        end
                    end
                end
            end
        end
    end

    if showEsp then
        for i=idx+1, #veilObjs do hideVeilObj(veilObjs[i]) end
    end

    local needsScan = Config.Veil.AimActive or Config.Veil.TriggerActive
    if needsScan and aimTargetCount > 0 then

        local best, bd = nil, 1/0

        if Config.Veil.StickyAim and _lockedTarget then
            -- check if locked target is still valid this frame
            for i=1, aimTargetCount do
                local td = aimTargets[i]
                if td.name == _lockedTarget then
                    -- still alive and in range, keep it
                    if td.dScr <= Config.Veil.StickyThresh then
                        best = td
                    end
                    break
                end
            end
        end

        -- sticky didnt find valid target, pick closest to center
        if not best then
            for i=1, aimTargetCount do
                local td = aimTargets[i]
                if td.dScr < bd then bd = td.dScr; best = td end
            end
            _lockedTarget = best and best.name or nil
        end

        if best then
            local sm = Config.Veil.Smooth
            local now = os_clock()
            
            if Config.Veil.AimActive then
                if sm <= 1 then
                    _aimWx, _aimWy, _aimWz = best.wx, best.wy, best.wz
                else
                    local dt = _lastAimTime and (now - _lastAimTime) or (1/60)
                    local t = dt * 60 / sm
                    if t > 1 then t = 1 end
                    if _aimWx then
                        _aimWx = _aimWx + (best.wx - _aimWx) * t
                        _aimWy = _aimWy + (best.wy - _aimWy) * t
                        _aimWz = _aimWz + (best.wz - _aimWz) * t
                    else
                        _aimWx, _aimWy, _aimWz = best.wx, best.wy, best.wz
                    end
                end
                _lastAimTime = now
                cam.lookAt(cam.Position, Vector3_new(_aimWx, _aimWy, _aimWz))
            else
                _lastAimTime = nil
            end

            -- triggerbot: m1 held + charge ready + cross on hitbox = release
            if Config.Veil.TriggerActive and hasSpearEquipped() then
                local m1Held = UILib:_IsKeyHeld("m1")
                if m1Held and triggerChargeStart then
                    local minCharge = Config.Veil.PierceActive
                        and Config.Veil.TriggerMinChargePierce
                        or  Config.Veil.TriggerMinCharge
                    if (now - triggerChargeStart) >= minCharge then
                        if best and best.dScr <= Config.Veil.HitThresh then
                            mouse1release()
                            triggerChargeStart = nil
                            triggerLockTime    = nil
                        end
                    end
                end
            end

            if Config.Veil.LockLine then
                veilLockLine.From = Vector2_new(cX, cY)
                veilLockLine.To = Vector2_new(best.sx, best.sy)
                if veilLockLine.Color ~= best.color then veilLockLine.Color = best.color end
                local T = Config.Veil.Thickness
                if veilLockLine.Thickness ~= T then veilLockLine.Thickness = T end
                veilLockLine.Visible = true
            else
                veilLockLine.Visible = false
            end
        else
            veilLockLine.Visible = false
        end
    else
        veilLockLine.Visible = false
        _aimWx, _aimWy, _aimWz = nil, nil, nil
        _lockedTarget = nil
        _lastAimTime = nil
    end
end

-- one-time cleanup when local player loses killer tag
local function CleanupVeilState()
    _aimWx, _aimWy, _aimWz = nil, nil, nil
    _lockedTarget = nil
    _lastAimTime = nil
    pierceStartTime = nil
    triggerChargeStart = nil
    triggerLockTime = nil
    m1WasHeld = false
    aimTargetCount = 0
    if Config.Veil.AimActive then VeilAimTog:Set(false) end
    if Config.Veil.PierceActive then VeilPierceTog:Set(false) end
    for i = 1, #veilObjs do hideVeilObj(veilObjs[i]) end
    veilLockLine.Visible = false
end

UILib:Notification("ANY BUGS > @nonzvia ", 10)
UILib:Notification("ANY BUGS > @nonzvia ", 10)
UILib:Notification("ANY BUGS > @nonzvia ", 10)


-- auto dodge dark severance
task_spawn(function()
    local dodgeCooldown  = 0
    local prevPos        = nil
    local prevTime       = os_clock()
    local speedHistory   = {0,0,0,0,0}
    local histIdx        = 1
    local dashTriggered  = false

    while true do
        task_wait(0.05)

        if _isLocalKiller or not Config.Survi.AbyssDodge then
            prevPos = nil
            dashTriggered = false
            for i = 1, 5 do speedHistory[i] = 0 end
            task_wait(0.3)
            continue
        end

        local abyss = nil
        for _, p in ipairs(Players:GetPlayers()) do
            if p.Team and p.Team.Name == "Killer" then
                local char = p.Character
                if char then
                    local isAbyss = false
                    if char.Name:lower():find("abyss") then
                        isAbyss = true
                    else
                        local ok2, rs = pcall(function() return game:GetService("ReplicatedStorage") end)
                        if ok2 and rs then
                            local abyssFolder = rs:FindFirstChild("Killers") and rs.Killers:FindFirstChild("Abysswalker")
                            if abyssFolder then isAbyss = true end
                        else
                            if not _rsFailLogged then
                                print("[AbyssDodge] ReplicatedStorage unavailable, falling back to char name detection only")
                                _rsFailLogged = true
                            end
                        end
                    end
                    if isAbyss then abyss = p end
                end
                break
            end
        end

        if not abyss or not abyss.Character then
            prevPos = nil
            dashTriggered = false
            continue
        end

        local aHRP = abyss.Character:FindFirstChild("HumanoidRootPart")
        local myHRP = Player.Character and Player.Character:FindFirstChild("HumanoidRootPart")
        if not aHRP or not myHRP then
            prevPos = nil
            continue
        end

        -- speed calc
        local now = os_clock()
        local dt = now - prevTime
        local speed = 0
        if prevPos and dt > 0 then
            local dx = aHRP.Position.X - prevPos.X
            local dz = aHRP.Position.Z - prevPos.Z
            speed = math_sqrt(dx*dx + dz*dz) / dt
        end
        prevPos = aHRP.Position
        prevTime = now

        -- rolling avg 5 frames
        speedHistory[histIdx] = speed
        histIdx = (histIdx % 5) + 1
        local avgSpeed = 0
        for i = 1, 5 do avgSpeed = avgSpeed + speedHistory[i] end
        avgSpeed = avgSpeed / 5

        -- dist to killer
        local dxK = aHRP.Position.X - myHRP.Position.X
        local dzK = aHRP.Position.Z - myHRP.Position.Z
        local dist = math_sqrt(dxK*dxK + dzK*dzK)

        -- auto dodge
        if avgSpeed > 28 and not dashTriggered then
            dashTriggered = true
            if dist <= Config.Survi.DodgeDist and os_clock() > dodgeCooldown and isrbxactive() then
                task_spawn(function()
                    if Config.Survi.DodgeDelay > 0 then task_wait(Config.Survi.DodgeDelay) end
                    if not isrbxactive() then return end -- recheck after delay
                    local key = Config.Survi.DodgeKey
                    local code = (key == "c" or key == "C") and 67 or 17
                    pcall(function()
                        keypress(code)
                        task_wait(Config.Survi.DodgeHold)
                        keyrelease(code)
                    end)
                    dodgeCooldown = os_clock() + 1.5
                    if Config.Debug then
                        print("[AbyssDodge] Crouching! dist=" .. math_floor(dist) .. " avgSpd=" .. math_floor(avgSpeed))
                    end
                end)
            end
        elseif avgSpeed < 20 then
            dashTriggered = false
        end
    end
end)

-- wave esp
local waveLines = {}
local trackedWaves = {}

local function getWaveLine(i)
    if not waveLines[i] then
        local l = Drawing_new("Line")
        l.Thickness = 2
        l.Visible = false
        waveLines[i] = l
    end
    return waveLines[i]
end

-- wave scanner thread
task_spawn(function()
    while true do
        task_wait(0.5)
        if not Config.Survi.WaveEsp then
            if next(trackedWaves) then
                for k in pairs(trackedWaves) do trackedWaves[k] = nil end
            end
            continue
        end
        local fresh = {}
        local children = workspace:GetChildren()
        for i = 1, #children do
            local obj = children[i]
            if obj.Name == "Wave" and obj:IsA("Model") and obj.Parent then
                fresh[obj] = true
            end
        end
        trackedWaves = fresh
    end
end)

local function RenderWaveEsp()
    local idx = 0
    if Config.Survi.WaveEsp then
        local cam = workspace.CurrentCamera
        if cam then
            for obj in pairs(trackedWaves) do
                if not obj.Parent then
                    trackedWaves[obj] = nil
                    continue
                end
                local pp = obj:FindFirstChildWhichIsA("BasePart")
                if pp then
                    local pos = pp.Position
                    local pts = GetCorners3D(pp, pos)
                    if not pts or #pts == 0 then continue end

                    local allOn = true
                    for j = 1, 8 do
                        local sc, on = WTS(pts[j])
                        if not on or not sc then allOn = false break end
                        sharedBoxPts[j] = roundVec2(sc)
                    end
                    if allOn then
                        local wCol = Config.Survi.WaveColor
                        for j = 1, #BoxEdges do
                            local e = BoxEdges[j]
                            idx = idx + 1
                            local l = getWaveLine(idx)
                            l.From = sharedBoxPts[e[1]]
                            l.To = sharedBoxPts[e[2]]
                            if l.Color ~= wCol then l.Color = wCol end
                            if not l.Visible then l.Visible = true end
                        end
                    end
                end
            end
        end
    end
    for i = idx + 1, #waveLines do
        waveLines[i].Visible = false
    end
end

-- main loop
while true do
    local ok, err = pcall(function()
        UILib:Step()

        -- killer role check via team
        _wasLocalKiller = _isLocalKiller
        _isLocalKiller = false
        local myTeam = Player and Player.Team
        if myTeam and myTeam.Name == "Killer" then
            _isLocalKiller = true
        end

        -- any team change: refresh stale refs + reset state
        if _wasLocalKiller ~= _isLocalKiller then
            PlayerGui = Player:FindFirstChild("PlayerGui")
            hasClicked = false
            clickPending = false
            lastMap = nil
            LastCacheTime = 0
            if not _isLocalKiller then
                CleanupVeilState()
            end
        end

        if not isrbxactive() then return end
        local pls = Players:GetPlayers()

        if not _isLocalKiller and Config.AutoSkillCheck.Activate then Autogen() end
        RenderGens()
        RenderPlayers(pls)
        if _isLocalKiller then
            RenderVeilAimbot(pls)
        end
        -- charge bar
        do
            local m1NowHeld = UILib:_IsKeyHeld("m1")
            local showCharge = Config.Veil.ChargeBar and _isLocalKiller and m1NowHeld and triggerChargeStart ~= nil and hasSpearEquipped()
            if showCharge then
                local cam = workspace.CurrentCamera
                local cX  = cam and cam.ViewportSize.X / 2 or 960
                local cY  = cam and cam.ViewportSize.Y / 2 or 540
                -- time-based charge (hardcoded 1s full charge)
                local charge = math_clamp((os_clock() - triggerChargeStart) / 1.0, 0, 1)
                local ready  = charge >= 1
                local fillCol = ready
                    and Color3.fromRGB(80, 255, 80)
                    or  Config.Veil.ColorOk

                if Config.Veil.ChargeMode == "Bar" then
                    local W  = Config.Veil.ChargeBarW
                    local H  = Config.Veil.ChargeBarH
                    local bx = cX - W / 2
                    local by = cY + Config.Veil.ChargeBarOffY

                    chargeBg.Position = Vector2_new(bx - 1, by - 1)
                    chargeBg.Size     = Vector2_new(W + 2, H + 2)
                    chargeBg.Visible  = true

                    local fw = math_floor(W * charge)
                    if fw < 2 then fw = 2 end
                    chargeFill.Position = Vector2_new(bx, by)
                    chargeFill.Size     = Vector2_new(fw, H)
                    if chargeFill.Color ~= fillCol then chargeFill.Color = fillCol end
                    chargeFill.Visible = true
                    chargeTxt.Visible  = false
                else  -- "Percent"
                    chargeBg.Visible   = false
                    chargeFill.Visible = false
                    chargeTxt.Text     = math_floor(charge * 100) .. "%"
                    chargeTxt.Position = Vector2_new(cX, cY + Config.Veil.ChargeBarOffY)
                    if chargeTxt.Color ~= fillCol then chargeTxt.Color = fillCol end
                    chargeTxt.Visible = true
                end
            else
                chargeBg.Visible   = false
                chargeFill.Visible = false
                chargeTxt.Visible  = false
            end
        end
        RenderWaveEsp()
        if configDirty then
            local now = os_clock()
            if now - lastSaveTime >= 30 then
                SaveConfig()
                lastSaveTime = now
                configDirty = false
            end
        end
    end)
    if not ok then warn("[VeilBot] " .. tostring(err)) end
    task_wait()
end
