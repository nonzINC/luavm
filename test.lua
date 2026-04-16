---------- globals ----------
local math_floor = math.floor
local math_clamp = math.clamp
local math_max = math.max
local math_min = math.min
local string_format = string.format
local string_sub = string.sub
local string_len = string.len
local string_char = string.char
local table_insert = table.insert
local table_remove = table.remove
local os_time = os.time
local os_date = os.date
local os_clock = os.clock
local tostring = tostring
local tonumber = tonumber
local pcall = pcall
local ipairs = ipairs
local pairs = pairs
local type = type

local Drawing_new = Drawing.new
local V2 = Vector2.new
local C3 = Color3.fromRGB
local C3n = Color3.new

local isrbxactive = isrbxactive
local iskeypressed = iskeypressed
local ismouse1pressed = ismouse1pressed

local Players = game:GetService("Players")
local lp = Players.LocalPlayer
local pmouse = lp:GetMouse()
local cam = workspace.CurrentCamera

---------- palette (exact gamesense hex values) ----------
local CLR = {
    bg          = C3(22, 22, 21),
    titlebar    = C3(29, 29, 28),     -- title bar area (94,94,94 @ 0.9 transp over bg)
    comp        = C3(26, 26, 26),
    border      = C3(100, 100, 100),
    accent      = C3(49, 255, 66),
    text        = C3(228, 228, 228),
    dim         = C3(168, 168, 168),
    muted       = C3(136, 136, 136),
    placeholder = C3(100, 100, 100),
    sep         = C3(54, 54, 54),
    ton         = C3(28, 173, 26),
    toff        = C3(174, 23, 25),
    strack      = C3(41, 41, 41),
    sfill       = C3(50, 255, 67),
    hover       = C3(39, 39, 39),
    notif       = C3(21, 21, 20),
    white       = C3(255, 255, 255),
    stroke      = C3(99, 99, 99),     -- UIStroke color on notifs
}

---------- layout (exact gamesense px values) ----------
local WIN_W, WIN_H = 380, 436
local TITLE_H  = 44
local TAB_Y    = 56
local TAB_W    = 65
local TAB_H    = 23
local CONT_Y   = 82
local CONT_H   = WIN_H - CONT_Y - 4
local CW       = 350
local CX_PAD   = 15
local CPAD     = 6

local BTN_H   = 30
local TOG_H   = 30
local SLD_H   = 43
local LBL_H   = 22
local TBX_H   = 30
local NOTIF_W  = 295
local NOTIF_H  = 80

local FNT       = Drawing.Fonts.Monospace
local FS        = 14
local FS_SM     = 12
local FS_T      = 18
local CWR       = 0.60
local LERP_SPD  = 10     -- color lerp speed (higher = faster, ~0.2s feel)
local STROKE_OP = 0.25   -- UIStroke-like outline opacity

---------- delta time ----------
local _clock = os_clock()
local _dt = 0.016

---------- mouse ----------
local M = { x = 0, y = 0, down = false, click = false, rel = false, _p = false }
local function mUpdate()
    M.x = pmouse.X
    M.y = pmouse.Y
    local d = ismouse1pressed()
    M.click = d and not M._p
    M.rel = not d and M._p
    M._p = d
    M.down = d
end

---------- key press ----------
local _ks, _kt = {}, {}
local function kp(vk)
    local n = iskeypressed(vk)
    local w = _ks[vk]
    _ks[vk] = n
    if n and not w then _kt[vk] = os_clock() + 0.4; return true end
    if n and w and _kt[vk] and os_clock() > _kt[vk] then _kt[vk] = os_clock() + 0.05; return true end
    if not n then _kt[vk] = nil end
    return false
end

---------- vk char map ----------
local VKC = {}
for i = 0, 25 do VKC[0x41 + i] = { string_char(97 + i), string_char(65 + i) } end
local _ns = { ")", "!", "@", "#", "$", "%", "^", "&", "*", "(" }
for i = 0, 9 do VKC[0x30 + i] = { tostring(i), _ns[i + 1] } end
VKC[0xBE] = { ".", ">" }  VKC[0xBC] = { ",", "<" }  VKC[0xBD] = { "-", "_" }
VKC[0xBB] = { "=", "+" }  VKC[0xBA] = { ";", ":" }  VKC[0xDE] = { "'", '"' }
VKC[0xBF] = { "/", "?" }  VKC[0xDB] = { "[", "{" }  VKC[0xDD] = { "]", "}" }
VKC[0xDC] = { "\\", "|" }

---------- utils ----------
local function inR(mx, my, x, y, w, h)
    return mx >= x and mx <= x + w and my >= y and my <= y + h
end
local function tw(s, sz)
    return string_len(s) * (sz or FS) * CWR
end
local function gt()
    return os_date("%H:%M:%S", os_time())
end
local function hideList(t)
    for i = 1, #t do t[i].Visible = false end
end
local function showList(t)
    for i = 1, #t do t[i].Visible = true end
end
-- color lerp (Color3:Lerp is broken in matcha)
local function lerpC(a, b, t)
    return C3n(a.R + (b.R - a.R) * t, a.G + (b.G - a.G) * t, a.B + (b.B - a.B) * t)
end
-- framerate-independent lerp factor
local function lerpT()
    return math_min(_dt * LERP_SPD, 1)
end
local function merge(def, opt)
    opt = opt or {}
    for k, v in pairs(def) do
        if opt[k] == nil then opt[k] = v end
    end
    return opt
end

---------- drawing constructors ----------
local _allD = {}

-- filled square
local function sq(c, z)
    local d = Drawing_new("Square")
    d.Filled = true; d.Visible = false
    d.Color = c or CLR.bg
    d.Size = V2(0, 0); d.Position = V2(0, 0)
    d.Transparency = 1; d.ZIndex = z or 1
    _allD[#_allD + 1] = d
    return d
end

-- outline square (UIStroke simulation)
local function sqo(c, op, z)
    local d = Drawing_new("Square")
    d.Filled = false; d.Visible = false
    d.Thickness = 1
    d.Color = c or CLR.border
    d.Size = V2(0, 0); d.Position = V2(0, 0)
    d.Transparency = op or STROKE_OP
    d.ZIndex = z or 1
    _allD[#_allD + 1] = d
    return d
end

-- text
local function tx(c, sz, z)
    local d = Drawing_new("Text")
    d.Visible = false; d.Color = c or CLR.text
    d.Text = ""; d.Size = sz or FS
    d.Position = V2(0, 0); d.Font = FNT
    d.Center = false; d.Outline = false
    d.Transparency = 1; d.ZIndex = z or 1
    _allD[#_allD + 1] = d
    return d
end

-- line
local function ln(c, thick, z)
    local d = Drawing_new("Line")
    d.Visible = false; d.Color = c or CLR.sep
    d.From = V2(0, 0); d.To = V2(0, 0)
    d.Thickness = thick or 1
    d.Transparency = 1; d.ZIndex = z or 1
    _allD[#_allD + 1] = d
    return d
end

-- triangle
local function tri(c, z)
    local d = Drawing_new("Triangle")
    d.Filled = true; d.Visible = false
    d.Color = c or CLR.text
    d.PointA = V2(0, 0); d.PointB = V2(0, 0); d.PointC = V2(0, 0)
    d.Transparency = 1; d.ZIndex = z or 1
    _allD[#_allD + 1] = d
    return d
end

---------- LIBRARY ----------
local Library = {
    _gui = nil,
    _notifs = {},
    _wm = nil,
    _wmEnabled = true,
    _focusTB = nil,
    _capSlider = nil,
    _unloaded = false,
    _vp = cam.ViewportSize,
}

--============================--
--        NOTIFICATIONS       --
--============================--

function Library:Notify(opts)
    opts = merge({ Description = "Notification", Duration = 5 }, opts)

    local n = {
        bg    = sq(CLR.notif, 50),
        bord  = sqo(CLR.stroke, 0.4, 51),  -- notif UIStroke more visible than component
        tg    = tx(CLR.white, 16, 52),
        ts_   = tx(CLR.accent, 16, 52),
        desc  = tx(CLR.dim, FS, 52),
        stamp = tx(CLR.muted, FS_SM, 52),
        state = "in",
        alpha = 0,
        dur   = opts.Duration,
        text  = opts.Description,
        _start = os_clock(),
        _draws = {},
    }
    n.tg.Text = "game"
    n.ts_.Text = "sense"
    n.desc.Text = opts.Description
    n.stamp.Text = gt()
    n._draws = { n.bg, n.bord, n.tg, n.ts_, n.desc, n.stamp }
    table_insert(self._notifs, n)
end

function Library:_stepNotifs()
    local vp = self._vp
    local now = os_clock()
    local baseX = vp.X - NOTIF_W - 25
    local baseY = vp.Y - 25

    for i = #self._notifs, 1, -1 do
        local n = self._notifs[i]
        local elapsed = now - n._start

        -- state machine (0.5s fade to match gamesense tween duration)
        if n.state == "in" then
            n.alpha = math_clamp(elapsed / 0.5, 0, 1)
            if n.alpha >= 1 then n.state = "show"; n._start = now end
        elseif n.state == "show" then
            if elapsed >= n.dur then n.state = "out"; n._start = now end
        elseif n.state == "out" then
            n.alpha = math_clamp(1 - elapsed / 0.5, 0, 1)
            if n.alpha <= 0 then n.state = "dead" end
        end

        if n.state == "dead" then
            for _, d in ipairs(n._draws) do d.Visible = false; pcall(d.Remove, d) end
            table_remove(self._notifs, i)
        else
            -- stack: count alive below this index for correct stacking
            local below = 0
            for j = i + 1, #self._notifs do
                if self._notifs[j].state ~= "dead" then below = below + 1 end
            end
            local ny = baseY - NOTIF_H - (below * (NOTIF_H + 6))
            local nx = baseX

            -- slide from right (ease out feel via alpha^0.7 for position)
            if n.state == "in" then
                local ease = n.alpha * n.alpha * (3 - 2 * n.alpha) -- smoothstep
                nx = baseX + (1 - ease) * (NOTIF_W + 30)
            elseif n.state == "out" then
                local ease = n.alpha * n.alpha * (3 - 2 * n.alpha)
                nx = baseX + (1 - ease) * (NOTIF_W + 30)
            end

            -- bg
            n.bg.Position = V2(nx, ny)
            n.bg.Size = V2(NOTIF_W, NOTIF_H)
            n.bg.Transparency = n.alpha
            n.bg.Visible = true

            -- outline border
            n.bord.Position = V2(nx, ny)
            n.bord.Size = V2(NOTIF_W, NOTIF_H)
            n.bord.Transparency = n.alpha * 0.4
            n.bord.Visible = true

            -- title "game" + "sense"
            local ttx = nx + 9
            local tty = ny + 8
            n.tg.Position = V2(ttx, tty)
            n.tg.Transparency = n.alpha
            n.tg.Visible = true
            n.ts_.Position = V2(ttx + tw("game", 16), tty)
            n.ts_.Transparency = n.alpha
            n.ts_.Visible = true

            -- desc
            n.desc.Position = V2(ttx, tty + 24)
            n.desc.Transparency = n.alpha
            n.desc.Visible = true

            -- timestamp bottom right
            n.stamp.Position = V2(nx + NOTIF_W - tw(n.stamp.Text, FS_SM) - 9, ny + NOTIF_H - 18)
            n.stamp.Transparency = n.alpha
            n.stamp.Visible = true
        end
    end
end

--============================--
--         WATERMARK          --
--============================--

function Library:_initWatermark()
    self._wm = {
        bg    = sq(CLR.notif, 61),
        bord  = sqo(CLR.stroke, 0.3, 62),
        full  = tx(CLR.white, FS_SM, 63),
        sense = tx(CLR.accent, FS_SM, 63),
        _draws = {},
    }
    self._wm._draws = { self._wm.bg, self._wm.bord, self._wm.full, self._wm.sense }
end

function Library:_stepWatermark()
    if not self._wm then return end
    if not self._wmEnabled then hideList(self._wm._draws); return end

    local vp = self._vp
    local name = lp.Name or "player"
    local time = gt()
    local fullStr = "gamesense | " .. name .. " | " .. time
    local strW = tw(fullStr, FS_SM)
    local padX, padY = 8, 6
    local bgW = strW + padX * 2
    local bgH = FS_SM + padY * 2
    local bx = vp.X - bgW - 15
    local by = 15

    local wm = self._wm
    wm.bg.Position = V2(bx, by)
    wm.bg.Size = V2(bgW, bgH)
    wm.bg.Visible = true

    wm.bord.Position = V2(bx, by)
    wm.bord.Size = V2(bgW, bgH)
    wm.bord.Visible = true

    wm.full.Position = V2(bx + padX, by + padY)
    wm.full.Text = fullStr
    wm.full.Visible = true

    -- "sense" overlay in green
    wm.sense.Position = V2(bx + padX + tw("game", FS_SM), by + padY)
    wm.sense.Text = "sense"
    wm.sense.Visible = true
end

--============================--
--      WINDOW / GUI          --
--============================--

function Library:New(opts)
    opts = merge({ Name = "gamesense.lua", Padding = 6 }, opts)
    CPAD = opts.Padding

    local vp = cam.ViewportSize
    self._vp = vp

    -- parse title for gamesense coloring
    local titleFull = opts.Name
    local hasGS = string_sub(titleFull, 1, 9) == "gamesense"
    local titleRest = hasGS and string_sub(titleFull, 10) or nil

    -- window drawings
    local d = {
        bord     = sqo(CLR.border, 1, 1),    -- window border (outline)
        bg       = sq(CLR.bg, 2),              -- window fill
        titleBg  = sq(CLR.titlebar, 3),        -- subtle title bar tint
        sep      = ln(CLR.sep, 1, 5),
        closeL1  = ln(CLR.muted, 1, 5),        -- X line 1
        closeL2  = ln(CLR.muted, 1, 5),        -- X line 2
    }

    -- close button animation state
    local _closeCur = CLR.muted
    local _closeTgt = CLR.muted

    -- title texts
    if hasGS then
        d.tGame  = tx(CLR.white, FS_T, 4)
        d.tSense = tx(CLR.accent, FS_T, 4)
        d.tRest  = tx(CLR.white, FS_T, 4)
        d.tGame.Text = "game"
        d.tSense.Text = "sense"
        d.tRest.Text = titleRest or ""
    else
        d.tFull = tx(CLR.white, FS_T, 4)
        d.tFull.Text = titleFull
    end

    -- collect draws
    local wdraws = { d.bord, d.bg, d.titleBg, d.sep, d.closeL1, d.closeL2 }
    if hasGS then
        wdraws[#wdraws + 1] = d.tGame
        wdraws[#wdraws + 1] = d.tSense
        wdraws[#wdraws + 1] = d.tRest
    else
        wdraws[#wdraws + 1] = d.tFull
    end

    local gui = {
        _x = math_floor(vp.X / 2 - WIN_W / 2),
        _y = math_floor(vp.Y / 2 - WIN_H / 2),
        _visible = true,
        _dragging = false,
        _dragOx = 0, _dragOy = 0,
        _tabs = {},
        _activeTab = nil,
        _d = d,
        _wdraws = wdraws,
        _allTabBtnDraws = {},
        _hasGS = hasGS,
    }

    self._gui = gui
    self:_initWatermark()
    self:Notify({ Description = "gamesense.lua has been loaded.", Duration = 4 })

    ---------- GUI methods ----------

    function gui:Destroy()
        Library._gui = nil
        Library._focusTB = nil
        Library._capSlider = nil
        for _, dr in ipairs(self._wdraws) do pcall(dr.Remove, dr) end
        for _, dr in ipairs(self._allTabBtnDraws) do pcall(dr.Remove, dr) end
        for _, tab in ipairs(self._tabs) do
            for _, dr in ipairs(tab._compDraws) do pcall(dr.Remove, dr) end
        end
        if Library._wm then
            for _, dr in ipairs(Library._wm._draws) do pcall(dr.Remove, dr) end
            Library._wm = nil
        end
    end

    function gui:_setTab(tab)
        if self._activeTab == tab then return end
        if self._activeTab then
            self._activeTab._active = false
            hideList(self._activeTab._compDraws)
        end
        self._activeTab = tab
        tab._active = true
    end

    function gui:_render()
        local x, y = self._x, self._y

        -- window border (outline overlay)
        d.bord.Position = V2(x - 1, y - 1)
        d.bord.Size = V2(WIN_W + 2, WIN_H + 2)

        -- window bg
        d.bg.Position = V2(x, y)
        d.bg.Size = V2(WIN_W, WIN_H)

        -- title bar subtle tint
        d.titleBg.Position = V2(x + 1, y + 1)
        d.titleBg.Size = V2(WIN_W - 2, TITLE_H - 1)

        -- title text
        local ttx = x + 15
        local tty = y + math_floor((TITLE_H - FS_T) / 2)
        if self._hasGS then
            d.tGame.Position = V2(ttx, tty)
            d.tSense.Position = V2(ttx + tw("game", FS_T), tty)
            d.tRest.Position = V2(ttx + tw("gamesense", FS_T), tty)
        else
            d.tFull.Position = V2(ttx, tty)
        end

        -- separator
        d.sep.From = V2(x, y + TITLE_H)
        d.sep.To = V2(x + WIN_W, y + TITLE_H)

        -- close X (two crossing lines)
        local cx = x + WIN_W - 24
        local cy = y + math_floor(TITLE_H / 2) - 5
        local cs = 10
        d.closeL1.From = V2(cx, cy)
        d.closeL1.To = V2(cx + cs, cy + cs)
        d.closeL2.From = V2(cx + cs, cy)
        d.closeL2.To = V2(cx, cy + cs)

        -- animate close button color
        local t = lerpT()
        _closeCur = lerpC(_closeCur, _closeTgt, t)
        d.closeL1.Color = _closeCur
        d.closeL2.Color = _closeCur

        showList(self._wdraws)
    end

    function gui:_step(active)
        if not self._visible then
            hideList(self._wdraws)
            hideList(self._allTabBtnDraws)
            if self._activeTab then hideList(self._activeTab._compDraws) end
            return
        end

        local mx, my = M.x, M.y

        -- drag
        if self._dragging then
            if M.down then
                self._x = mx - self._dragOx
                self._y = my - self._dragOy
            else
                self._dragging = false
            end
        end

        -- captured slider
        if Library._capSlider then
            if M.down then
                Library._capSlider:_dragUpdate(mx)
            else
                Library._capSlider = nil
            end
        end

        -- close hover
        local cx = self._x + WIN_W - 24
        local cy = self._y + math_floor(TITLE_H / 2) - 5
        local closeHov = active and inR(mx, my, cx - 2, cy - 2, 14, 14)
        _closeTgt = closeHov and CLR.accent or CLR.muted

        -- render window
        self:_render()

        -- render tab buttons
        local tbx = self._x + CX_PAD
        local tby = self._y + TAB_Y
        local t = lerpT()
        for _, tab in ipairs(self._tabs) do
            tab._bx = tbx
            tab._by = tby

            -- bg
            tab._btnBg.Position = V2(tbx, tby)
            tab._btnBg.Size = V2(TAB_W, TAB_H)
            tab._btnBg.Visible = true

            -- UIStroke outline
            tab._btnStroke.Position = V2(tbx, tby)
            tab._btnStroke.Size = V2(TAB_W, TAB_H)
            tab._btnStroke.Visible = true

            -- text centered
            local ttxp = tbx + math_floor((TAB_W - tw(tab._name, FS_SM)) / 2)
            local ttyp = tby + math_floor((TAB_H - FS_SM) / 2)
            tab._btnTx.Position = V2(ttxp, ttyp)
            tab._btnTx.Visible = true

            -- color animation
            if active then
                local hov = inR(mx, my, tbx, tby, TAB_W, TAB_H)
                if tab._active then
                    tab._txTgt = CLR.accent
                elseif hov then
                    tab._txTgt = CLR.accent
                else
                    tab._txTgt = CLR.text
                end
            end
            tab._txCur = lerpC(tab._txCur, tab._txTgt, t)
            tab._btnTx.Color = tab._txCur

            tbx = tbx + TAB_W + 6
        end

        -- active tab components
        local consumed = false
        if self._activeTab then
            local contentX = self._x + CX_PAD
            local contentY = self._y + CONT_Y
            local comps = self._activeTab._comps
            for ci = 1, #comps do
                local comp = comps[ci]
                local compY = contentY + comp._yoff
                local compB = compY + comp._height

                if compB < contentY or compY > contentY + CONT_H then
                    hideList(comp._draws)
                else
                    comp:_render(contentX, compY, t)
                    showList(comp._draws)
                    if comp._type == "textbox" and not comp._focused then
                        comp._cursor.Visible = false
                    end
                    if active and not consumed then
                        consumed = comp:_interact(mx, my, contentX, compY) or false
                    end
                end
            end
        end

        if not active then return end

        -- close button click
        if M.click and closeHov then
            self._visible = false
            Library:Notify({ Description = "Press K to re-open.", Duration = 3 })
            return
        end

        -- tab clicks
        if M.click and not consumed then
            for _, tab in ipairs(self._tabs) do
                if inR(mx, my, tab._bx, tab._by, TAB_W, TAB_H) then
                    self:_setTab(tab)
                    consumed = true
                    break
                end
            end
        end

        -- start drag
        if M.click and not consumed and not self._dragging then
            if inR(mx, my, self._x, self._y, WIN_W, TITLE_H) then
                self._dragging = true
                self._dragOx = mx - self._x
                self._dragOy = my - self._y
            end
        end
    end

    --============================--
    --          TABS              --
    --============================--

    function gui:CreateTab(tabOpts)
        tabOpts = merge({ Name = "Tab" }, tabOpts)

        local tab = {
            _name      = tabOpts.Name,
            _active    = false,
            _bx = 0, _by = 0,
            _comps     = {},
            _compDraws = {},
            _nextY     = 0,
            _btnBg     = sq(CLR.comp, 6),
            _btnStroke = sqo(CLR.border, STROKE_OP, 7),
            _btnTx     = tx(CLR.text, FS_SM, 8),
            _txCur     = CLR.text,
            _txTgt     = CLR.text,
        }
        tab._btnTx.Text = tabOpts.Name

        local btnDraws = { tab._btnBg, tab._btnStroke, tab._btnTx }
        for _, d_ in ipairs(btnDraws) do
            gui._allTabBtnDraws[#gui._allTabBtnDraws + 1] = d_
        end

        table_insert(gui._tabs, tab)
        if #gui._tabs == 1 then gui:_setTab(tab) end

        --============================--
        --         BUTTON             --
        --============================--

        function tab:Button(bOpts)
            bOpts = merge({ Name = "Button", Callback = function() end }, bOpts)

            local btn = {
                _type = "button", _height = BTN_H, _yoff = tab._nextY,
                _name = bOpts.Name, _cb = bOpts.Callback, _draws = {},
                _bg     = sq(CLR.comp, 11),
                _stroke = sqo(CLR.border, STROKE_OP, 12),
                _tx     = tx(CLR.text, FS, 13),
                _arrow  = tri(CLR.text, 13),
                -- anim
                _txCur = CLR.text, _txTgt = CLR.text,
                _bgCur = CLR.comp, _bgTgt = CLR.comp,
            }
            btn._tx.Text = bOpts.Name
            btn._draws = { btn._bg, btn._stroke, btn._tx, btn._arrow }
            for _, d_ in ipairs(btn._draws) do tab._compDraws[#tab._compDraws + 1] = d_ end
            tab._nextY = tab._nextY + BTN_H + CPAD
            table_insert(tab._comps, btn)

            function btn:_render(cx, cy, t)
                self._bg.Position = V2(cx, cy)
                self._bg.Size = V2(CW, BTN_H)
                self._stroke.Position = V2(cx, cy)
                self._stroke.Size = V2(CW, BTN_H)
                self._tx.Position = V2(cx + 9, cy + math_floor((BTN_H - FS) / 2))
                -- right-pointing triangle arrow
                local ax = cx + CW - 16
                local ay = cy + math_floor(BTN_H / 2)
                self._arrow.PointA = V2(ax, ay - 5)
                self._arrow.PointB = V2(ax, ay + 5)
                self._arrow.PointC = V2(ax + 6, ay)
                -- animate colors
                self._txCur = lerpC(self._txCur, self._txTgt, t)
                self._bgCur = lerpC(self._bgCur, self._bgTgt, t)
                self._tx.Color = self._txCur
                self._arrow.Color = self._txCur
                self._bg.Color = self._bgCur
            end

            function btn:_interact(mx, my, cx, cy)
                local hov = inR(mx, my, cx, cy, CW, BTN_H)
                if hov and M.down then
                    self._txTgt = CLR.accent
                    self._bgTgt = CLR.hover
                elseif hov then
                    self._txTgt = CLR.accent
                    self._bgTgt = CLR.comp
                else
                    self._txTgt = CLR.text
                    self._bgTgt = CLR.comp
                end
                if hov and M.click then
                    local ok, err = pcall(self._cb)
                    if not ok then
                        Library:Notify({
                            Description = string_format("(%s) callback error", self._name),
                            Duration = 5
                        })
                    end
                    return true
                end
                return false
            end

            function btn:SetText(t_)
                self._name = t_; self._tx.Text = t_
            end
            function btn:SetCallback(fn)
                self._cb = fn or function() end
            end

            return btn
        end

        --============================--
        --         LABEL              --
        --============================--

        function tab:Label(lOpts)
            lOpts = merge({ Message = "Label" }, lOpts)

            local lbl = {
                _type = "label", _height = LBL_H, _yoff = tab._nextY,
                _draws = {},
                _tx = tx(CLR.muted, FS, 13),
            }
            lbl._tx.Text = lOpts.Message
            lbl._draws = { lbl._tx }
            for _, d_ in ipairs(lbl._draws) do tab._compDraws[#tab._compDraws + 1] = d_ end
            tab._nextY = tab._nextY + LBL_H + CPAD
            table_insert(tab._comps, lbl)

            function lbl:_render(cx, cy)
                self._tx.Position = V2(cx + 9, cy + math_floor((LBL_H - FS) / 2))
            end
            function lbl:_interact() return false end
            function lbl:SetText(t_) self._tx.Text = t_ end

            return lbl
        end

        --============================--
        --         TOGGLE             --
        --============================--

        function tab:Toggle(tOpts)
            tOpts = merge({ Name = "Toggle", State = false, Callback = function() end }, tOpts)

            local tog = {
                _type = "toggle", _height = TOG_H, _yoff = tab._nextY,
                _state = tOpts.State, _cb = tOpts.Callback, _draws = {},
                _bg     = sq(CLR.comp, 11),
                _stroke = sqo(CLR.border, STROKE_OP, 12),
                _tx     = tx(CLR.text, FS, 13),
                _ind    = sq(tOpts.State and CLR.ton or CLR.toff, 13),
                -- anim (indicator color lerp)
                _indCur = tOpts.State and CLR.ton or CLR.toff,
                _indTgt = tOpts.State and CLR.ton or CLR.toff,
            }
            tog._tx.Text = tOpts.Name
            tog._draws = { tog._bg, tog._stroke, tog._tx, tog._ind }
            for _, d_ in ipairs(tog._draws) do tab._compDraws[#tab._compDraws + 1] = d_ end
            tab._nextY = tab._nextY + TOG_H + CPAD
            table_insert(tab._comps, tog)

            function tog:_render(cx, cy, t)
                self._bg.Position = V2(cx, cy)
                self._bg.Size = V2(CW, TOG_H)
                self._stroke.Position = V2(cx, cy)
                self._stroke.Size = V2(CW, TOG_H)
                self._tx.Position = V2(cx + 9, cy + math_floor((TOG_H - FS) / 2))
                -- indicator 18x18 (exact gamesense size)
                self._ind.Position = V2(cx + CW - 26, cy + math_floor((TOG_H - 18) / 2))
                self._ind.Size = V2(18, 18)
                -- animate indicator color
                self._indTgt = self._state and CLR.ton or CLR.toff
                self._indCur = lerpC(self._indCur, self._indTgt, t)
                self._ind.Color = self._indCur
            end

            function tog:_interact(mx, my, cx, cy)
                local hov = inR(mx, my, cx, cy, CW, TOG_H)
                if hov and M.click then
                    self._state = not self._state
                    self._cb(self._state)
                    return true
                end
                return false
            end

            function tog:SetValue(b) self._state = b end
            function tog:GetValue() return self._state end

            return tog
        end

        --============================--
        --         SLIDER             --
        --============================--

        function tab:Slider(sOpts)
            sOpts = merge({
                Name = "Slider", Min = 0, Max = 100,
                Default = 50, Step = 1, Callback = function() end
            }, sOpts)

            local trackW = 333     -- exact gamesense track width
            local trackH = 7

            local stepStr = tostring(sOpts.Step)
            local dec = stepStr:match("%.(%d+)$")
            local decP = dec and #dec or 0
            local fmt = "%." .. decP .. "f"

            local sld = {
                _type = "slider", _height = SLD_H, _yoff = tab._nextY,
                _min = sOpts.Min, _max = sOpts.Max, _step = sOpts.Step,
                _val = sOpts.Default, _default = sOpts.Default,
                _cb = sOpts.Callback, _fmt = fmt,
                _trackW = trackW, _draws = {},
                _bg     = sq(CLR.comp, 11),
                _stroke = sqo(CLR.border, STROKE_OP, 12),
                _tx     = tx(CLR.text, FS, 13),
                _valTx  = tx(CLR.text, FS, 13),
                _track  = sq(CLR.strack, 13),
                _fill   = sq(CLR.sfill, 14),
                _trackX = 0, _trackY = 0,
            }
            sld._tx.Text = sOpts.Name
            sld._valTx.Text = string_format(fmt, sOpts.Default)
            sld._draws = { sld._bg, sld._stroke, sld._tx, sld._valTx, sld._track, sld._fill }
            for _, d_ in ipairs(sld._draws) do tab._compDraws[#tab._compDraws + 1] = d_ end
            tab._nextY = tab._nextY + SLD_H + CPAD
            table_insert(tab._comps, sld)

            function sld:_render(cx, cy)
                self._bg.Position = V2(cx, cy)
                self._bg.Size = V2(CW, SLD_H)
                self._stroke.Position = V2(cx, cy)
                self._stroke.Size = V2(CW, SLD_H)
                self._tx.Position = V2(cx + 9, cy + 4)
                local valStr = self._valTx.Text
                self._valTx.Position = V2(cx + CW - tw(valStr, FS) - 9, cy + 4)
                -- track
                local tx_ = cx + 9
                local ty_ = cy + 28
                self._trackX = tx_
                self._trackY = ty_
                self._track.Position = V2(tx_, ty_)
                self._track.Size = V2(trackW, trackH)
                -- fill
                local range = self._max - self._min
                local pct = range > 0 and (self._val - self._min) / range or 0
                self._fill.Position = V2(tx_, ty_)
                self._fill.Size = V2(math_floor(trackW * pct), trackH)
            end

            function sld:_interact(mx, my, cx, cy)
                -- click value text = reset
                local valHit = inR(mx, my, cx + CW - 60, cy + 2, 58, 20)
                if valHit and M.click then
                    self:SetValue(self._default)
                    return true
                end
                -- click track = start drag
                local trackHit = inR(mx, my, self._trackX, self._trackY - 2, trackW, trackH + 4)
                if trackHit and M.click then
                    Library._capSlider = self
                    self:_dragUpdate(mx)
                    return true
                end
                return false
            end

            function sld:_dragUpdate(mx)
                local pct = math_clamp((mx - self._trackX) / self._trackW, 0, 1)
                local raw = (self._max - self._min) * pct + self._min
                local stepped = math_floor((raw / self._step) + 0.5) * self._step
                local clamped = math_clamp(stepped, self._min, self._max)
                clamped = tonumber(string_format(self._fmt, clamped)) or clamped
                self._val = clamped
                self._valTx.Text = string_format(self._fmt, clamped)
                self._cb(clamped)
            end

            function sld:SetValue(v)
                v = math_clamp(v, self._min, self._max)
                self._val = v
                self._valTx.Text = string_format(self._fmt, v)
                self._cb(v)
            end
            function sld:GetValue() return self._val end

            return sld
        end

        --============================--
        --        TEXTBOX             --
        --============================--

        function tab:Textbox(tbOpts)
            tbOpts = merge({ Placeholder = "Enter text...", Callback = function() end }, tbOpts)

            local tbx = {
                _type = "textbox", _height = TBX_H, _yoff = tab._nextY,
                _placeholder = tbOpts.Placeholder, _cb = tbOpts.Callback,
                _buf = "", _focused = false, _draws = {},
                _bg     = sq(CLR.comp, 11),
                _stroke = sqo(CLR.border, STROKE_OP, 12),
                _tx     = tx(CLR.placeholder, FS, 13),
                _cursor = ln(CLR.accent, 1, 13),
                -- anim
                _bordCur = CLR.border, _bordTgt = CLR.border,
            }
            tbx._tx.Text = tbOpts.Placeholder
            tbx._draws = { tbx._bg, tbx._stroke, tbx._tx, tbx._cursor }
            for _, d_ in ipairs(tbx._draws) do tab._compDraws[#tab._compDraws + 1] = d_ end
            tab._nextY = tab._nextY + TBX_H + CPAD
            table_insert(tab._comps, tbx)

            function tbx:_render(cx, cy, t)
                self._bg.Position = V2(cx, cy)
                self._bg.Size = V2(CW, TBX_H)
                self._stroke.Position = V2(cx, cy)
                self._stroke.Size = V2(CW, TBX_H)
                -- animate border color
                self._bordTgt = self._focused and CLR.accent or CLR.border
                self._bordCur = lerpC(self._bordCur, self._bordTgt, t)
                self._stroke.Color = self._bordCur
                self._stroke.Transparency = self._focused and 0.8 or STROKE_OP
                -- text
                local display = self._buf
                if string_len(display) == 0 and not self._focused then
                    display = self._placeholder
                    self._tx.Color = CLR.placeholder
                else
                    self._tx.Color = CLR.text
                end
                self._tx.Position = V2(cx + 9, cy + math_floor((TBX_H - FS) / 2))
                self._tx.Text = display
                -- cursor blink
                if self._focused then
                    local blink = math_floor(os_clock() * 2) % 2 == 0
                    local curX = cx + 9 + tw(self._buf, FS) + 2
                    local curY = cy + 6
                    self._cursor.From = V2(curX, curY)
                    self._cursor.To = V2(curX, curY + TBX_H - 12)
                    self._cursor.Visible = blink
                else
                    self._cursor.Visible = false
                end
            end

            function tbx:_interact(mx, my, cx, cy)
                local hov = inR(mx, my, cx, cy, CW, TBX_H)
                if M.click then
                    if hov then
                        if Library._focusTB and Library._focusTB ~= self then
                            Library._focusTB:_unfocus(true)
                        end
                        self._focused = true
                        Library._focusTB = self
                        return true
                    elseif self._focused then
                        self:_unfocus(true)
                        return true
                    end
                end
                return false
            end

            function tbx:_unfocus(submit)
                self._focused = false
                if Library._focusTB == self then Library._focusTB = nil end
                if submit and string_len(self._buf) > 0 then self._cb(self._buf) end
            end

            function tbx:SetValue(t_) self._buf = t_ or "" end
            function tbx:GetValue() return self._buf end

            return tbx
        end

        return tab
    end

    return gui
end

--============================--
--          STEP              --
--============================--

function Library:Step()
    if self._unloaded then return end

    -- delta time
    local now = os_clock()
    _dt = math_min(now - _clock, 0.1)
    _clock = now

    self._vp = cam.ViewportSize
    mUpdate()

    local active = isrbxactive()

    -- toggle key (K) — skip if textbox focused
    if self._gui and active and not self._focusTB and kp(0x4B) then
        self._gui._visible = not self._gui._visible
        if not self._gui._visible then
            self:Notify({ Description = "Press K to re-open.", Duration = 3 })
        end
    end

    if self._gui then self._gui:_step(active) end

    -- textbox keyboard input
    if self._focusTB and active then
        local tb = self._focusTB
        local shift = iskeypressed(0x10)
        for vk, chars in pairs(VKC) do
            if kp(vk) then
                tb._buf = tb._buf .. (shift and chars[2] or chars[1])
            end
        end
        if kp(0x20) then tb._buf = tb._buf .. " " end
        if kp(0x08) and string_len(tb._buf) > 0 then
            tb._buf = string_sub(tb._buf, 1, -2)
        end
        if kp(0x0D) then tb:_unfocus(true) end
        if kp(0x1B) then tb:_unfocus(false) end
    end

    self:_stepNotifs()
    self:_stepWatermark()
end

--============================--
--         UNLOAD             --
--============================--

function Library:Unload()
    self._unloaded = true
    self._gui = nil
    self._focusTB = nil
    self._capSlider = nil
    self._notifs = {}
    for i = 1, #_allD do pcall(_allD[i].Remove, _allD[i]) end
    _allD = {}
end

--============================--
--        DEMO MENU           --
--============================--

-- demo menu usage:
-- local Library = loadstring(game:HttpGet("url/gamesenseUI.lua"))()
-- local Window = Library:ShowDemoMenu()
-- while true do Library:Step(); task_wait() end
function Library:ShowDemoMenu()
    local Window = self:New({ Name = "gamesense.lua", Padding = 6 })

    -- tab 1: all components
    local Tab1 = Window:CreateTab({ Name = "Main" })

    local statusLabel = Tab1:Label({ Message = "Status: idle" })

    Tab1:Button({
        Name = "Print Hello",
        Callback = function()
            statusLabel:SetText("Status: hello printed")
        end
    })

    Tab1:Button({
        Name = "Reset Status",
        Callback = function()
            statusLabel:SetText("Status: idle")
        end
    })

    local espToggle = Tab1:Toggle({
        Name = "Enable ESP",
        State = false,
        Callback = function(v)
            statusLabel:SetText("ESP: " .. tostring(v))
        end
    })

    Tab1:Toggle({
        Name = "Show Names",
        State = true,
        Callback = function(v)
            statusLabel:SetText("Names: " .. tostring(v))
        end
    })

    local fovSlider = Tab1:Slider({
        Name = "FOV Radius",
        Min = 30, Max = 500, Default = 120, Step = 5,
        Callback = function(v)
            statusLabel:SetText("FOV: " .. tostring(v))
        end
    })

    Tab1:Slider({
        Name = "Smoothing",
        Min = 0, Max = 1, Default = 0.5, Step = 0.05,
        Callback = function(v)
            statusLabel:SetText("Smooth: " .. tostring(v))
        end
    })

    Tab1:Textbox({
        Placeholder = "Enter target name...",
        Callback = function(t)
            statusLabel:SetText("Target: " .. t)
        end
    })

    -- tab 2: settings
    local Tab2 = Window:CreateTab({ Name = "Config" })

    Tab2:Label({ Message = "Visual Settings" })

    Tab2:Toggle({
        Name = "Watermark",
        State = true,
        Callback = function(v)
            self._wmEnabled = v
        end
    })

    Tab2:Slider({
        Name = "Menu Alpha",
        Min = 0, Max = 100, Default = 100, Step = 5,
        Callback = function() end
    })

    Tab2:Button({
        Name = "Unload UI",
        Callback = function()
            self:Unload()
        end
    })

    Tab2:Label({ Message = "Press K to toggle menu" })

    -- tab 3: about
    local Tab3 = Window:CreateTab({ Name = "About" })

    Tab3:Label({ Message = "gamesense.lua" })
    Tab3:Label({ Message = "Drawing API port for Matcha" })
    Tab3:Label({ Message = "Original: focat69/gamesense" })

    self:Notify({ Description = "Demo menu loaded!", Duration = 3 })

    return Window
end

return Library
