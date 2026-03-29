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
local Color3_fromRGB = Color3.fromRGB
local Color3_new = Color3.new
local Drawing_new = Drawing.new
local os_clock = os.clock
local task_spawn = task.spawn
local task_wait = task.wait
local keypress = keypress
local keyrelease = keyrelease
local mem_read = memory_read
local WTS = WorldToScreen

local Players = game:GetService("Players")

-- paths
local WorkspacePath = "C:/matcha/workspace/"
local LibPath = WorkspacePath .. "library.lua"
local FolderPath = WorkspacePath .. "ViolenceDistrict/"
local ModuleFolder = FolderPath .. "Modules/"

-- folders
if not isfolder(WorkspacePath) then makefolder(WorkspacePath) end
if not isfolder(FolderPath) then makefolder(FolderPath) end
if not isfolder(ModuleFolder) then makefolder(ModuleFolder) end

-- ui lib
if not isfile(LibPath) then
    local src = game:HttpGet("https://raw.githubusercontent.com/catowice/p/refs/heads/main/library.lua")
    if src and type(src) == "string" and #src > 100 then writefile(LibPath, src) end
end
local UILib = require(LibPath)

local Player = Players.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")

-- mouse fix
local successMouse, CachedMouse = pcall(function() return Player:GetMouse() end)
UILib._GetMousePos = function(self)
    if successMouse and CachedMouse then return Vector2_new(CachedMouse.X, CachedMouse.Y) end
    return Vector2_new(0, 0)
end

-- mem lib
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

-- fast distance
local function GetDistance(v1, v2)
    local dx, dy, dz = v1.X - v2.X, v1.Y - v2.Y, v1.Z - v2.Z
    return math_sqrt(dx*dx + dy*dy + dz*dz)
end

-- blur fix
local function roundVec2(v)
    return Vector2_new(math_floor(v.X + 0.5), math_floor(v.Y + 0.5))
end

local BoxEdges = {{1,2}, {3,4}, {1,3}, {2,4}, {5,6}, {7,8}, {5,7}, {6,8}, {1,5}, {2,6}, {3,7}, {4,8}}

local function GetCorners3D(part, pos)
    local sx, sy, sz = part.Size.X/2, part.Size.Y/2, part.Size.Z/2
    local m = MemoryManager.GetRotationMatrix(part)
    local r = m and Vector3_new(m[0], m[3], m[6]) * sx or Vector3_new(sx, 0, 0)
    local u = m and Vector3_new(m[1], m[4], m[7]) * sy or Vector3_new(0, sy, 0)
    local b = m and Vector3_new(m[2], m[5], m[8]) * sz or Vector3_new(0, 0, sz)
    return {pos-r+u+b, pos+r+u+b, pos-r-u+b, pos+r-u+b, pos-r+u-b, pos+r+u-b, pos-r-u-b, pos+r-u-b}
end

local hasClicked = false

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
            if not hasClicked then
                hasClicked = true
                task_spawn(function()
                    if Config.AutoSkillCheck.Delay > 0 then
                        task_wait(Config.AutoSkillCheck.Delay)
                    end
                    keypress(32)
                    task_wait(0.02)
                    keyrelease(32)
                end)
            end
        else
            hasClicked = false
        end
    else
        hasClicked = false
    end
end

-- draw cache
local PlayerDrawings = {}
local GenCache = {}
local LastCacheTime = 0

local function RenderPlayers()
    -- hide if esp off
    if not Config.Esp.Activate then
        for _, cache in pairs(PlayerDrawings) do
            cache.Name.Visible = false
            for i=1,5 do cache.LookLines[i].Visible = false end
            for l=1, Config.Esp.CircleSegments do cache.CircleLines[l].Visible = false end
        end
        return
    end

    local cam = workspace.CurrentCamera
    -- matcha cam fix
    local camPos = cam and cam.Position or Vector3_new(0, 0, 0)
    
    -- active plrs
    local activePlayers = {}
    local playerList = Players:GetPlayers()

    for i = 1, #playerList do
        local plr = playerList[i]
        local plrName = plr.Name
        if not plrName then continue end
        
        activePlayers[plrName] = true

        -- filter self
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
            local dist = GetDistance(pos, camPos)
            
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
            
            -- dist check
            if dist > Config.Esp.MaxDistance then
                cache.Name.Visible = false
                for j=1,5 do cache.LookLines[j].Visible = false end
                for l=1, Config.Esp.CircleSegments do cache.CircleLines[l].Visible = false end
                continue
            end
            
            local name3d = pos + Vector3_new(0, 4.5, 0)
            local namePos, nOn = WTS(name3d)

            local circleTog = isKiller and Config.Esp.KillerCircle or Config.Esp.SurvivorCircle
            local nameTog = isKiller and Config.Esp.KillerName or Config.Esp.SurvivorName
            local espCol = isKiller and Config.Esp.KillerColor or Config.Esp.SurvivorColor

            -- name esp
            if nameTog and nOn then
                cache.Name.Position = roundVec2(namePos)
                cache.Name.Text = plrName
                cache.Name.Color = espCol
                cache.Name.Font = Config.Esp.TextFont 
                cache.Name.Outline = Config.Esp.TextOutline
                cache.Name.Visible = true
            else
                cache.Name.Visible = false
            end

            -- circle esp
            if circleTog then
                local radius = Config.Esp.CircleRadius
                local segments = Config.Esp.CircleSegments
                local pts = {}
                local allOn = true
                
                for j = 1, segments do
                    local mults = CircleMults[j]
                    local offset3d = Vector3_new(mults.x * radius, -3, mults.z * radius)
                    local sc, on = WTS(pos + offset3d)
                    
                    if not on then allOn = false end
                    pts[j] = roundVec2(sc)
                end
                
                if allOn then
                    for j = 1, segments do
                        local nextIdx = (j % segments) + 1
                        local line = cache.CircleLines[j]
                        line.From = pts[j]
                        line.To = pts[nextIdx]
                        line.Color = espCol
                        line.Visible = true
                    end
                else
                    for l=1, segments do cache.CircleLines[l].Visible = false end
                end
            else
                for l=1, Config.Esp.CircleSegments do cache.CircleLines[l].Visible = false end
            end

            -- tracer
            if isKiller and Config.Esp.LookTracer then
                local primPtr = mem_read("uintptr_t", hrp.Address + 0x148)
                if type(primPtr) == "number" and primPtr > 0x100000 then
                    local r02 = mem_read("float", primPtr + 0xC8)
                    local r12 = mem_read("float", primPtr + 0xD4)
                    local r22 = mem_read("float", primPtr + 0xE0)
                    if type(r02) == "number" and type(r12) == "number" and type(r22) == "number" then
                        local lookVec = Vector3_new(-r02, -r12, -r22)
                        
                        local segments = 5
                        local tracerOrigin = pos + Vector3_new(0, -3, 0) + (lookVec * Config.Esp.CircleRadius)
                        local prevPos = tracerOrigin
                        local prevScreen, prevOn = WTS(prevPos)
                        if prevOn then prevScreen = roundVec2(prevScreen) end
                        
                        local c1 = Config.Esp.TracerColor
                        local c2 = Config.Esp.TracerColor2
                        -- lerp diff cache
                        local dr, dg, db = c2.R - c1.R, c2.G - c1.G, c2.B - c1.B
                        
                        for j=1, segments do
                            local t = j / segments
                            local current3d = tracerOrigin + (lookVec * (Config.Esp.TracerLength * t))
                            local currScreen, currOn = WTS(current3d)
                            if currOn then currScreen = roundVec2(currScreen) end
                            
                            local line = cache.LookLines[j]
                            if currOn and prevOn then
                                line.From = prevScreen
                                line.To = currScreen
                                line.Color = Color3_new(c1.R + dr * t, c1.G + dg * t, c1.B + db * t)
                                line.Visible = true
                            else
                                line.Visible = false
                            end
                            
                            prevPos = current3d
                            prevScreen = currScreen
                            prevOn = currOn
                        end
                    else 
                        for j=1,5 do cache.LookLines[j].Visible = false end
                    end
                else 
                    for j=1,5 do cache.LookLines[j].Visible = false end
                end
            else 
                for j=1,5 do cache.LookLines[j].Visible = false end
            end
        elseif PlayerDrawings[plrName] then
            -- garbage collect cache
            PlayerDrawings[plrName].Name:Remove()
            for j=1,5 do PlayerDrawings[plrName].LookLines[j]:Remove() end
            for l=1, Config.Esp.CircleSegments do PlayerDrawings[plrName].CircleLines[l]:Remove() end
            PlayerDrawings[plrName] = nil
        end
    end
    
    -- clear left players
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
    if not map then return end
    
    local currentGens = {}
    local desc = map:GetDescendants()
    for i = 1, #desc do
        local obj = desc[i]
        if obj.Name == "Generator" then
            local p = obj:IsA("Model") and (obj.PrimaryPart or obj:FindFirstChildWhichIsA("BasePart")) or (obj:IsA("BasePart") and obj)
            if p then currentGens[p] = true end
        end
    end
    
    -- flush dead gens
    for part, cache in pairs(GenCache) do
        if not currentGens[part] or not part.Parent then
            cache.Text:Remove()
            for l=1,12 do cache.Lines[l]:Remove() end
            GenCache[part] = nil
        end
    end
    
    -- update live gens
    for part in pairs(currentGens) do
        local pos = part.Position
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
    
    for part, cache in pairs(GenCache) do
        local dist = GetDistance(cache.CachedPos, camPos)
        
        if Config.Esp.Activate and dist <= Config.Esp.MaxDistance then
            local cp, on = WTS(cache.CachedPos)
            if on and Config.Esp.Text then
                cache.Text.Position = roundVec2(cp)
                cache.Text.Color = Config.Esp.TextColor
                cache.Text.Transparency = Config.Esp.TextOpacity
                cache.Text.Font = Config.Esp.TextFont 
                cache.Text.Outline = Config.Esp.TextOutline
                cache.Text.Visible = true
            else 
                cache.Text.Visible = false 
            end
            
            if Config.Esp.Box3D then
                local pts, allOn = {}, true
                for c=1,8 do 
                    local sc, o = WTS(cache.Corners[c]) 
                    pts[c] = roundVec2(sc) 
                    if not o then allOn = false end 
                end
                
                if allOn then
                    for l=1,12 do
                        local e, line = BoxEdges[l], cache.Lines[l]
                        line.From, line.To, line.Color, line.Transparency, line.Visible = pts[e[1]], pts[e[2]], Config.Esp.BoxColor, Config.Esp.BoxOpacity, true
                    end
                else 
                    for l=1,12 do cache.Lines[l].Visible = false end 
                end
            else 
                for l=1,12 do cache.Lines[l].Visible = false end 
            end
        else
            cache.Text.Visible = false
            for l=1,12 do cache.Lines[l].Visible = false end
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

-- master settings
local MasterSec = VisTab:Section("Master")
MasterSec:Toggle("Master ESP", Config.Esp.Activate, function(v) Config.Esp.Activate = v end)
MasterSec:Slider("Render Distance", Config.Esp.MaxDistance, 50, 50, 5000, " studs", function(v) Config.Esp.MaxDistance = v end)

-- fonts
local fontMapping = {
    ["System"] = Drawing.Fonts.System,
    ["SystemBold"] = Drawing.Fonts.SystemBold,
    ["UI"] = Drawing.Fonts.UI,
    ["Minecraft"] = Drawing.Fonts.Minecraft,
    ["Monospace"] = Drawing.Fonts.Monospace,
    ["Pixel"] = Drawing.Fonts.Pixel,
    ["Fortnite"] = Drawing.Fonts.Fortnite
}

MasterSec:Dropdown("ESP Font", {"System"}, {"System", "SystemBold", "UI", "Minecraft", "Monospace", "Pixel", "Fortnite"}, false, function(v)
    if v and v[1] and fontMapping[v[1]] then
        Config.Esp.TextFont = fontMapping[v[1]]
    end
end)

MasterSec:Toggle("Text Outline", Config.Esp.TextOutline, function(v) Config.Esp.TextOutline = v end)

-- left col
local EspSec = VisTab:Section("Generators ESP")
local tTog = EspSec:Toggle("Text", Config.Esp.Text, function(v) Config.Esp.Text = v end)
tTog:AddColorpicker("Color", Config.Esp.TextColor, false, function(c) Config.Esp.TextColor = c end)
local bTog = EspSec:Toggle("Box", Config.Esp.Box3D, function(v) Config.Esp.Box3D = v end)
bTog:AddColorpicker("Color", Config.Esp.BoxColor, false, function(c) Config.Esp.BoxColor = c end)

local SelfSec = VisTab:Section("Self ESP")
SelfSec:Toggle("Include Me", Config.Esp.Self, function(v) Config.Esp.Self = v end, false, "shows you in killer/survivor esp groups")

-- right col
local KillerSec = VisTab:Section("Killer ESP")
local kNameTog = KillerSec:Toggle("Name", Config.Esp.KillerName, function(v) Config.Esp.KillerName = v end)
kNameTog:AddColorpicker("Color", Config.Esp.KillerColor, false, function(c) Config.Esp.KillerColor = c end)
local kBoxTog = KillerSec:Toggle("3D Circle", Config.Esp.KillerCircle, function(v) Config.Esp.KillerCircle = v end)

-- tracer picker
local kTracerTog = KillerSec:Toggle("Look Tracer", Config.Esp.LookTracer, function(v) Config.Esp.LookTracer = v end)
kTracerTog:AddColorpicker("Start Color", Config.Esp.TracerColor, false, function(c) Config.Esp.TracerColor = c end)

local kTracerGradTog = KillerSec:Toggle("Tracer End Color", true, function() end)
kTracerGradTog:AddColorpicker("Color 2", Config.Esp.TracerColor2, false, function(c) Config.Esp.TracerColor2 = c end)

KillerSec:Slider("Tracer Length", Config.Esp.TracerLength, 1, 1, 10, "", function(v) Config.Esp.TracerLength = v end)

local SurvSec = VisTab:Section("Survivor ESP")
local sNameTog = SurvSec:Toggle("Name", Config.Esp.SurvivorName, function(v) Config.Esp.SurvivorName = v end)
sNameTog:AddColorpicker("Color", Config.Esp.SurvivorColor, false, function(c) Config.Esp.SurvivorColor = c end)
SurvSec:Toggle("3D Circle", Config.Esp.SurvivorCircle, function(v) Config.Esp.SurvivorCircle = v end)

UILib:CreateSettingsTab("Settings")

-- ui tree fix
local menuItems = UILib._tree["Settings"]._items["Menu"]._items
menuItems[1].label = "Menu key"
table.remove(menuItems, 4)
table.remove(menuItems, 3)
table.remove(menuItems, 2)

-- pink theme
if UILib._tree["Settings"] and UILib._tree["Settings"]._items["Theming"] then
    UILib._theming.accent = Config.Esp.BoxColor
end

-- state
UILib:RegisterActivity(function()
    if not Config.AutoSkillCheck.Activate then return "Skill: Off" end
    return "Skill Delay: " .. tostring(Config.AutoSkillCheck.Delay) .. "s"
end)

UILib:Notification("femboys hmu pls", 5)
math.randomseed(os.time())

-- main loop
while true do
    UILib:Step() 
    if Config.AutoSkillCheck.Activate then Autogen() end
    RenderGens()
    RenderPlayers()
    task_wait() 
end