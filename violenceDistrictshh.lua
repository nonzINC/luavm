-- config setup
-- activate: ac kapa
-- maxdistance: esp ve aimbot max calisma mesafesi
-- textfont: yazi tipi, ui falan filan
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
    },
    -- veil bot settings
    Veil = {
        AimActive = false, -- aimbot toggle
        AimKey = 'm4', -- aimbot key
        AimMode = 'Hold', -- aim mode
        Target = "HumanoidRootPart", -- aim target
        Smooth = 5.0, -- smoothing
        MaxDist = 1500, -- max calc dist

        PierceActive = false, -- pierce active state
        PierceKey = 'q', -- pierce key
        PierceMode = 'Toggle', -- pierce mode
        CancelKey = 'q', -- cancel key

        SpeedNormal = 400, -- normal spear speed
        SpeedPierce = 460, -- pierce spear speed
        
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
    },
    Debug = false,
}

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
local WTS = WorldToScreen

-- wait for players service so external vm doesnt panic
local Players
repeat
    Players = game:GetService("Players")
    task_wait()
until Players

-- matcha paths
local WorkspacePath = "C:/matcha/workspace/"
local LibPath = WorkspacePath .. "library.lua"
local FolderPath = WorkspacePath .. "ViolenceDistrict/"
local ModuleFolder = FolderPath .. "Modules/"

-- folder checks
if not isfolder(WorkspacePath) then makefolder(WorkspacePath) end
if not isfolder(FolderPath) then makefolder(FolderPath) end
if not isfolder(ModuleFolder) then makefolder(ModuleFolder) end

-- load ui lib
if not isfile(LibPath) then
    local src = game:HttpGet("https://raw.githubusercontent.com/catowice/p/refs/heads/main/library.lua")
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

local fontMapping = {
    System = Drawing.Fonts.System,
    SystemBold = Drawing.Fonts.SystemBold,
    UI = Drawing.Fonts.UI,
    Minecraft = Drawing.Fonts.Minecraft,
    Monospace = Drawing.Fonts.Monospace,
    Pixel = Drawing.Fonts.Pixel,
    Fortnite = Drawing.Fonts.Fortnite
}

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
                    keypress(32)
                    task_wait(0.02)
                    keyrelease(32)
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
    g = (type(g) == "number" and g > 0) and g or 196.2
    return g * Config.Veil.GravityMult
end

-- ultra optimized prediction
local function calcPrediction(ox, oy, oz, part)
    local tp = part.Position
    local tv = part.AssemblyLinearVelocity or part.Velocity or Vector3_new(0,0,0)
    
    local dx = tp.X - ox
    local dz = tp.Z - oz
    local hDist = math_sqrt(dx*dx + dz*dz)
    
    local v = Config.Veil.PierceActive and Config.Veil.SpeedPierce or Config.Veil.SpeedNormal
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
                cache.Name.Text = plrName
                cache.Name.Color = espCol
                cache.Name.Font = Config.Esp.TextFont 
                cache.Name.Outline = Config.Esp.TextOutline
                cache.Name.Visible = true
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
                        line.Color = espCol
                        line.Visible = true
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
                                line.Color = Color3_new(c1.R + dr * t, c1.G + dg * t, c1.B + db * t)
                                line.Visible = true
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
        return
    end

    local currentGens = {}
    local genCount = 0
    local desc = map:GetDescendants()
    for i = 1, #desc do
        local obj = desc[i]
        if obj.Name == "Generator" then
            local p = obj:IsA("Model") and (obj.PrimaryPart or obj:FindFirstChildWhichIsA("BasePart")) or (obj:IsA("BasePart") and obj)
            if p then currentGens[p] = true; genCount = genCount + 1 end
        end
    end

    for part, cache in pairs(GenCache) do
        if not currentGens[part] or not part.Parent then
            cache.Text:Remove()
            for l=1,12 do cache.Lines[l]:Remove() end
            GenCache[part] = nil
        end
    end
    
    for part in pairs(currentGens) do
        local pos = part.Position
        if not pos then continue end 
        
        local cache = GenCache[part]
        
        if not cache then
            local text = Drawing_new("Text")
            text.Text, text.Size, text.Center = "Generator", 14, true
            local lines = {}
            for l=1, 12 do lines[l] = Drawing_new("Line"); lines[l].Thickness = 1 end
            GenCache[part] = {Text=text, Lines=lines, Corners=GetCorners3D(part, pos), CachedPos=pos}
        elseif pos ~= cache.CachedPos then
            cache.Corners = GetCorners3D(part, pos)
            cache.CachedPos = pos
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
        if not cache.CachedPos then continue end
        
        local dx, dy, dz = cache.CachedPos.X - camPos.X, cache.CachedPos.Y - camPos.Y, cache.CachedPos.Z - camPos.Z
        local distSq = dx*dx + dy*dy + dz*dz
        
        if Config.Esp.Activate and distSq <= maxSq then
            local cp, on = WTS(cache.CachedPos)
            if on and cp and Config.Esp.Text then
                cache.Text.Position = roundVec2(cp)
                cache.Text.Color = Config.Esp.TextColor
                cache.Text.Transparency = Config.Esp.TextOpacity
                cache.Text.Font = Config.Esp.TextFont 
                cache.Text.Outline = Config.Esp.TextOutline
                cache.Text.Visible = true
            else 
                cache.Text.Visible = false 
            end
            
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
                    for l=1,12 do
                        local e, line = BoxEdges[l], cache.Lines[l]
                        line.From, line.To, line.Color, line.Transparency, line.Visible = sharedBoxPts[e[1]], sharedBoxPts[e[2]], Config.Esp.BoxColor, Config.Esp.BoxOpacity, true
                    end
                else 
                    for l=1,12 do cache.Lines[l].Visible = false end 
                end
            else 
                for l=1,12 do cache.Lines[l].Visible = false end 
            end
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
UILib:SetMenuSize(Vector2_new(520, 480))
UILib:CenterMenu()

local MainTab = UILib:Tab("Main")
local SkillSec = MainTab:Section("Auto-Skillcheck")
SkillSec:Toggle("Auto Skill Check", Config.AutoSkillCheck.Activate, function(v) Config.AutoSkillCheck.Activate = v end)
SkillSec:Slider("Reaction Delay", Config.AutoSkillCheck.Delay, 0.01, 0.0, 0.14, "s", function(v) Config.AutoSkillCheck.Delay = v end)

local VisTab = UILib:Tab("Visuals")
local MasterSec = VisTab:Section("Master")
MasterSec:Toggle("Master ESP", Config.Esp.Activate, function(v) Config.Esp.Activate = v end)
MasterSec:Slider("Render Distance", Config.Esp.MaxDistance, 50, 50, 5000, " studs", function(v) Config.Esp.MaxDistance = v end)

MasterSec:Dropdown("ESP Font", {"System"}, {"System", "SystemBold", "UI", "Minecraft", "Monospace", "Pixel", "Fortnite"}, false, function(v)
    if v and v[1] and fontMapping[v[1]] then Config.Esp.TextFont = fontMapping[v[1]] end
end)
MasterSec:Toggle("Text Outline", Config.Esp.TextOutline, function(v) Config.Esp.TextOutline = v end)

local EspSec = VisTab:Section("Generators ESP")
local tTog = EspSec:Toggle("Text", Config.Esp.Text, function(v) Config.Esp.Text = v end)
tTog:AddColorpicker("Color", Config.Esp.TextColor, false, function(c) Config.Esp.TextColor = c end)
local bTog = EspSec:Toggle("Box", Config.Esp.Box3D, function(v) Config.Esp.Box3D = v end)
bTog:AddColorpicker("Color", Config.Esp.BoxColor, false, function(c) Config.Esp.BoxColor = c end)

local SelfSec = VisTab:Section("Self ESP")
SelfSec:Toggle("Include Me", Config.Esp.Self, function(v) Config.Esp.Self = v end, false, "shows you in killer/survivor esp groups")

local KillerSec = VisTab:Section("Killer ESP")
local kNameTog = KillerSec:Toggle("Name", Config.Esp.KillerName, function(v) Config.Esp.KillerName = v end)
kNameTog:AddColorpicker("Color", Config.Esp.KillerColor, false, function(c) Config.Esp.KillerColor = c end)
KillerSec:Toggle("3D Circle", Config.Esp.KillerCircle, function(v) Config.Esp.KillerCircle = v end)
local kTracerTog = KillerSec:Toggle("Look Tracer", Config.Esp.LookTracer, function(v) Config.Esp.LookTracer = v end)
kTracerTog:AddColorpicker("Start Color", Config.Esp.TracerColor, false, function(c) Config.Esp.TracerColor = c end)
local kTracerGradTog = KillerSec:Toggle("Tracer End Color", true, function() end)
kTracerGradTog:AddColorpicker("Color 2", Config.Esp.TracerColor2, false, function(c) Config.Esp.TracerColor2 = c end)
KillerSec:Slider("Tracer Length", Config.Esp.TracerLength, 1, 1, 10, "", function(v) Config.Esp.TracerLength = v end)

local SurvSec = VisTab:Section("Survivor ESP")
local sNameTog = SurvSec:Toggle("Name", Config.Esp.SurvivorName, function(v) Config.Esp.SurvivorName = v end)
sNameTog:AddColorpicker("Color", Config.Esp.SurvivorColor, false, function(c) Config.Esp.SurvivorColor = c end)
SurvSec:Toggle("3D Circle", Config.Esp.SurvivorCircle, function(v) Config.Esp.SurvivorCircle = v end)

local VeilTab = UILib:Tab("VeilBOT")

local vCombat = VeilTab:Section("Combat & Pierce")
local VeilAimTog = vCombat:Toggle("Aimbot Active", Config.Veil.AimActive, function(v) Config.Veil.AimActive = v end)
VeilAimTog:AddKeybind(Config.Veil.AimKey, Config.Veil.AimMode, true, function(keyId, mode)
    local kName = UILib:_KeyIDToName(keyId)
    if kName then Config.Veil.AimKey = kName end
    Config.Veil.AimMode = mode
end)

local VeilPierceTog = vCombat:Toggle("Pierce Active", Config.Veil.PierceActive, function(v) Config.Veil.PierceActive = v end, true, "fast pierce mode")
VeilPierceTog:AddKeybind(Config.Veil.PierceKey, Config.Veil.PierceMode, false, function(keyId, mode)
    local kName = UILib:_KeyIDToName(keyId)
    if kName then Config.Veil.PierceKey = kName end
end)

local CancelTog = vCombat:Toggle("Manual Cancel Key", false, function() end, false, "cancel if stuck")
CancelTog:AddKeybind(Config.Veil.CancelKey, "Toggle", false, function(keyId, mode)
    local kName = UILib:_KeyIDToName(keyId)
    if kName then Config.Veil.CancelKey = kName end
end)

vCombat:Dropdown("Aim Target", {Config.Veil.Target}, {"HumanoidRootPart", "Head"}, false, function(v) Config.Veil.Target = v[1] end)
vCombat:Slider("Smoothness", Config.Veil.Smooth, 0.1, 1.0, 20.0, "", function(v) Config.Veil.Smooth = v end)
vCombat:Slider("Max Distance", Config.Veil.MaxDist, 50, 50, 3000, "s", function(v) Config.Veil.MaxDist = v end)

local vSpeed = VeilTab:Section("dont touch if dont know whats it")
vSpeed:Slider("Speed Normal", Config.Veil.SpeedNormal, 10, 100, 1000, "", function(v) Config.Veil.SpeedNormal = v end)
vSpeed:Slider("Speed Pierce", Config.Veil.SpeedPierce, 10, 100, 1000, "", function(v) Config.Veil.SpeedPierce = v end)

local vVis = VeilTab:Section("Cross & Line")
vVis:Toggle("Lock Line", Config.Veil.LockLine, function(v) Config.Veil.LockLine = v end)
vVis:Toggle("Show Crosses", Config.Veil.EspCross, function(v) Config.Veil.EspCross = v end)
vVis:Slider("Cross Size", Config.Veil.CrossSize, 1, 2, 30, "px", function(v) Config.Veil.CrossSize = v end)
vVis:Slider("Thickness", Config.Veil.Thickness, 1, 1, 5, "px", function(v) Config.Veil.Thickness = v end)

local cOk = vVis:Toggle("Color Normal")
cOk:AddColorpicker("Ok", Config.Veil.ColorOk, true, function(c) Config.Veil.ColorOk = c end)
local cPierce = vVis:Toggle("Color Pierce")
cPierce:AddColorpicker("Pierce", Config.Veil.ColorPierce, true, function(c) Config.Veil.ColorPierce = c end)
local cHit = vVis:Toggle("Color In Range")
cHit:AddColorpicker("Hit", Config.Veil.ColorHit, true, function(c) Config.Veil.ColorHit = c end)
local cApprox = vVis:Toggle("Color Approx")
cApprox:AddColorpicker("Approx", Config.Veil.ColorApprox, true, function(c) Config.Veil.ColorApprox = c end)


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
local aimTargets = {}
local aimTargetCount = 0

-- veil logic
local function HandleVeilInputs()
    -- skip m1 track if pierce not active
    if Config.Veil.PierceActive then
        local m1Held = UILib:_IsKeyHeld('m1')
        -- spear throw tracking
        if m1WasHeld and not m1Held then
            VeilPierceTog:Set(false)
        end
        m1WasHeld = m1Held
    else
        m1WasHeld = false
    end
    
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

local function RenderVeilAimbot(pls)
    HandleVeilInputs()
    
    local cam = workspace.CurrentCamera
    local mPos = UILib:_GetMousePos()
    local mX, mY = mPos.X, mPos.Y
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

                            if showEsp then
                                idx = idx + 1
                                local o = getVeilObj(idx)

                                drawVeilCross(o, sx, sy, col)
                                o.txt.Position = Vector2_new(sx, sy + Config.Veil.CrossSize + 4)
                                local realDist = math_sqrt(dSq)
                                o.txt.Text = approx and (math_floor(realDist).."m ~") or (math_floor(realDist).."m")
                                if o.txt.Color ~= col then o.txt.Color = col end
                                o.txt.Visible = true
                            end

                            -- aimbot pool
                            aimTargetCount = aimTargetCount + 1
                            local tData = aimTargets[aimTargetCount] or {}
                            tData.sx, tData.sy, tData.dScr, tData.color = sx, sy, dScr, col
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
    
    -- aimbot snap logic
    if Config.Veil.AimActive and aimTargetCount > 0 then
        local best, bd = nil, 1/0
        for i=1, aimTargetCount do
            local t = aimTargets[i]
            local d = t.dScr
            if d < bd then bd = d; best = t end
        end
        
        if best then
            local sm = Config.Veil.Smooth < 0.1 and 0.1 or Config.Veil.Smooth
            mousemoverel((best.sx - mX) / sm, (best.sy - mY) / sm)
            -- lock line from center to target
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
    end
end

UILib:Notification("Not finished yet, so early beta.", 10)

-- main loop
while true do
    UILib:Step() 
    local pls = Players:GetPlayers()
    if Config.AutoSkillCheck.Activate then Autogen() end
    RenderGens()
    RenderPlayers(pls)
    RenderVeilAimbot(pls)
    task_wait() 
end
