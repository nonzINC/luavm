-- improved version of nulares ui lib for personal usage
    UILib = {
        _font_face = Drawing.Fonts.UI,
        _font_size = 13,
        _font_name = 'UI',
        _font_list = {'UI', 'System', 'SystemBold', 'Monospace', 'Minecraft', 'Pixel', 'Fortnite'},
        _font_face_by_name = {
            UI         = Drawing.Fonts.UI,
            System     = Drawing.Fonts.System,
            SystemBold = Drawing.Fonts.SystemBold,
            Monospace  = Drawing.Fonts.Monospace,
            Minecraft  = Drawing.Fonts.Minecraft,
            Pixel      = Drawing.Fonts.Pixel,
            Fortnite   = Drawing.Fonts.Fortnite,
        },
        _drawings = {},
        _base_alpha = {},
        _tree = {},
        _tab_order = {},
        _menu_open = true,
        _menu_toggled_at = 0,
        _watermark_enabled = true,
        _indicator_enabled = false,
        _indicator_label   = "",
        _indicator_active  = false,
        _indicator_pos     = nil,  -- Vector2 or nil (nil = top-center default)
        _indicator_drag    = nil,  -- offset Vector2 while dragging
        _indicator_drag_origin = nil,  -- pos at drag-start, used to detect real-move vs bare-click
        _indicator_drag_end_cb = nil,  -- fn(pos) called after drag release with movement
        _notifications = {},
        _notifications_spawned = 0,
        _open_tab = nil,
        _tab_change_at = 0,
        _inputs = {['m1']={id=0x01,held=false,click=false},['m2']={id=0x02,held=false,click=false},['mb']={id=0x04,held=false,click=false},['unbound']={id=0x08,held=false,click=false},['tab']={id=0x09,held=false,click=false},['enter']={id=0x0D,held=false,click=false},['shift']={id=0x10,held=false,click=false},['ctrl']={id=0x11,held=false,click=false},['alt']={id=0x12,held=false,click=false},['pause']={id=0x13,held=false,click=false},['capslock']={id=0x14,held=false,click=false},['esc']={id=0x1B,held=false,click=false},['space']={id=0x20,held=false,click=false},['pageup']={id=0x21,held=false,click=false},['pagedown']={id=0x22,held=false,click=false},['end']={id=0x23,held=false,click=false},['home']={id=0x24,held=false,click=false},['left']={id=0x25,held=false,click=false},['up']={id=0x26,held=false,click=false},['right']={id=0x27,held=false,click=false},['down']={id=0x28,held=false,click=false},['insert']={id=0x2D,held=false,click=false},['delete']={id=0x2E,held=false,click=false},['0']={id=0x30,held=false,click=false},['1']={id=0x31,held=false,click=false},['2']={id=0x32,held=false,click=false},['3']={id=0x33,held=false,click=false},['4']={id=0x34,held=false,click=false},['5']={id=0x35,held=false,click=false},['6']={id=0x36,held=false,click=false},['7']={id=0x37,held=false,click=false},['8']={id=0x38,held=false,click=false},['9']={id=0x39,held=false,click=false},['a']={id=0x41,held=false,click=false},['b']={id=0x42,held=false,click=false},['c']={id=0x43,held=false,click=false},['d']={id=0x44,held=false,click=false},['e']={id=0x45,held=false,click=false},['f']={id=0x46,held=false,click=false},['g']={id=0x47,held=false,click=false},['h']={id=0x48,held=false,click=false},['i']={id=0x49,held=false,click=false},['j']={id=0x4A,held=false,click=false},['k']={id=0x4B,held=false,click=false},['l']={id=0x4C,held=false,click=false},['m']={id=0x4D,held=false,click=false},['n']={id=0x4E,held=false,click=false},['o']={id=0x4F,held=false,click=false},['p']={id=0x50,held=false,click=false},['q']={id=0x51,held=false,click=false},['r']={id=0x52,held=false,click=false},['s']={id=0x53,held=false,click=false},['t']={id=0x54,held=false,click=false},['u']={id=0x55,held=false,click=false},['v']={id=0x56,held=false,click=false},['w']={id=0x57,held=false,click=false},['x']={id=0x58,held=false,click=false},['y']={id=0x59,held=false,click=false},['z']={id=0x5A,held=false,click=false},['numpad0']={id=0x60,held=false,click=false},['numpad1']={id=0x61,held=false,click=false},['numpad2']={id=0x62,held=false,click=false},['numpad3']={id=0x63,held=false,click=false},['numpad4']={id=0x64,held=false,click=false},['numpad5']={id=0x65,held=false,click=false},['numpad6']={id=0x66,held=false,click=false},['numpad7']={id=0x67,held=false,click=false},['numpad8']={id=0x68,held=false,click=false},['numpad9']={id=0x69,held=false,click=false},['multiply']={id=0x6A,held=false,click=false},['add']={id=0x6B,held=false,click=false},['separator']={id=0x6C,held=false,click=false},['subtract']={id=0x6D,held=false,click=false},['decimal']={id=0x6E,held=false,click=false},['divide']={id=0x6F,held=false,click=false},['f1']={id=0x70,held=false,click=false},['f2']={id=0x71,held=false,click=false},['f3']={id=0x72,held=false,click=false},['f4']={id=0x73,held=false,click=false},['f5']={id=0x74,held=false,click=false},['f6']={id=0x75,held=false,click=false},['f7']={id=0x76,held=false,click=false},['f8']={id=0x77,held=false,click=false},['f9']={id=0x78,held=false,click=false},['f10']={id=0x79,held=false,click=false},['f11']={id=0x7A,held=false,click=false},['f12']={id=0x7B,held=false,click=false},['numlock']={id=0x90,held=false,click=false},['scrolllock']={id=0x91,held=false,click=false},['lshift']={id=0xA0,held=false,click=false},['rshift']={id=0xA1,held=false,click=false},['lctrl']={id=0xA2,held=false,click=false},['rctrl']={id=0xA3,held=false,click=false},['lalt']={id=0xA4,held=false,click=false},['ralt']={id=0xA5,held=false,click=false},['semicolon']={id=0xBA,held=false,click=false},['plus']={id=0xBB,held=false,click=false},['comma']={id=0xBC,held=false,click=false},['minus']={id=0xBD,held=false,click=false},['period']={id=0xBE,held=false,click=false},['slash']={id=0xBF,held=false,click=false},['tilde']={id=0xC0,held=false,click=false},['lbracket']={id=0xDB,held=false,click=false},['backslash']={id=0xDC,held=false,click=false},['rbracket']={id=0xDD,held=false,click=false},['quote']={id=0xDE,held=false,click=false}},
        _slider_drag = nil,
        _range_slider_drag = nil,
        _range_slider_handle = nil,
        _menu_drag = nil,
        _input_ctx = nil,
        _button_held = nil,
        _overwrite_menu_key = false,
        _menu_key = 'f1',
        _active_dropdown = nil,
        _active_colorpicker = nil,
        _copied_color = nil,
        _menu_fade_done = false,
        _section_fade_done = false,
        _anim_state = {},
        _last_step_at = 0,
        _frame_dt = 16/1000,

        title = 'UILib v2',
        _custom_title_enabled = false,
        _custom_title = '',
        w = 720,
        h = 600,
        x = 120,
        y = 120,
        _padding = 10,
        _sidebar_w = 140,
        _topbar_h = 34,
        _tab_btn_h = 32,
        _row_h = 22,
        _columns = 2,
        _column_gap = 18,
        _background_alpha = 92/100,
        _ui_body_corner = 5, 
        -- bg image
        -- master kill switch. set to false and the bg-image feature behaves as if it never existed:
        -- settings section is not created, render path is skipped, opacity pass is skipped.
        _bg_image_feature_enabled = true,
        _bg_image_enabled = false, -- true when a valid image is loaded
        _bg_image_url = '',        -- remembered url (for cache key + display)
        _bg_image_data = nil,      -- raw bytes from httpget, fed to Drawing.Image.Data
        _bg_image_alpha = 1.0,     -- 0..1, multiplied by _background_alpha at draw time
        _bg_image_cache_dir = 'C:/matcha/workspace/nonzviAss/photos',
        _bg_image_apply_token = 0, -- bumped on every Apply/Clear so stale fetches are ignored
        _bg_image_fetching = false, -- true while an Apply HttpGet is in flight (prevents parallel fetches)
        _bg_image_subsystem_dead = false, -- set true if Drawing.new('Image') pcall fails; stops per-frame retry
        -- NOTE: _bg_image_data holds raw image bytes (potentially multi-MB). consumers MUST NOT serialize this field.
        _draw_data_cache = {}, -- tracks last .Data assigned per drawId (readback unreliable)
        _glow_enabled = false,
        _glow_color = nil,
        _glow_mode = 'Static',
        _glow_last_mode = nil,
        -- per-mode settings
        _glow_s_intensity = 50,
        _glow_s_radius = 10,
        _glow_b_speed = 2,
        _glow_b_intensity = 70,
        _glow_b_radius = 14,
        _glow_r_worm = 40,
        _glow_r_speed = 3,
        _glow_r_radius = 9,
        _glow_r_intensity = 50,
        _glow_s_smooth = 15,
        _glow_b_smooth = 15,
        _text_outline_enabled = false, -- library-wide Drawing.Text outline flag
        _theming = {
            accent = Color3.fromRGB(203, 166, 247),
            unsafe = Color3.fromRGB(255, 215, 64),
            body = Color3.fromRGB(17, 17, 27),
            text = Color3.fromRGB(205, 214, 244),
            subtext = Color3.fromRGB(127, 132, 156),
            border1 = Color3.fromRGB(69, 71, 90),
            border0 = Color3.fromRGB(49, 50, 68),
            surface1 = Color3.fromRGB(49, 50, 68),
            surface0 = Color3.fromRGB(30, 30, 46),
            crust = Color3.fromRGB(11, 11, 18),
        },
    }

    -- utils
    local function clamp(x, a, b)
        if x > b then return b elseif x < a then return a else return x end
    end

    -- format slider value based on step precision to avoid float noise
    local function formatStep(value, step)
        if type(value) ~= 'number' then return '0' end
        step = tonumber(step) or 1
        if step <= 0 then step = 1 end
        if step >= 1 and math.floor(step) == step then
            return tostring(math.floor(value + 0.5))
        end
        -- count decimals in step; handle scientific notation like "1e-05"
        local s = tostring(step)
        local decimals = 0
        local dot = s:find('%.')
        if dot then
            decimals = #s - dot
            -- strip trailing exponent if any
            local ePos = s:find('[eE]')
            if ePos and ePos > dot then decimals = ePos - dot - 1 end
        end
        local ePos = s:find('[eE]')
        if ePos then
            local expStr = s:sub(ePos + 1)
            local expNum = tonumber(expStr)
            if expNum and expNum < 0 then
                decimals = math.max(decimals, -expNum)
            end
        end
        if decimals > 6 then decimals = 6 end
        if decimals < 0 then decimals = 0 end
        local mult = 10 ^ decimals
        local rounded = math.floor(value * mult + 0.5) / mult
        local fmt = string.format('%%.%df', decimals)
        return string.format(fmt, rounded)
    end

    local function rgbToHsv(r, g, b)
        local maxv = math.max(r, g, b)
        local minv = math.min(r, g, b)
        local h, s, v = 0, 0, maxv
        local d = maxv - minv
        if maxv ~= 0 then s = d / maxv end
        if d == 0 then
            h = 0
        else
            if maxv == r then
                h = (g - b) / d
                if g < b then h = h + 6 end
            elseif maxv == g then
                h = (b - r) / d + 2
            elseif maxv == b then
                h = (r - g) / d + 4
            end
            h = h / 6
        end
        return h, s, v
    end

    -- textbox input maps (hoisted)
    local _charMap = {
        space=' ',period='.',comma=',',slash='/',semicolon=';',minus='-',
        quote='\'',lbracket='[',rbracket=']',backslash='\\',plus='=',tilde='`',
        -- numpad support
        numpad0='0',numpad1='1',numpad2='2',numpad3='3',numpad4='4',
        numpad5='5',numpad6='6',numpad7='7',numpad8='8',numpad9='9',
        multiply='*',add='+',subtract='-',decimal='.',divide='/',
    }
    local _shiftMap = {['1']='!',['2']='@',['3']='#',['4']='$',['5']='%',['6']='^',['7']='&',['8']='*',['9']='(',['0']=')',['-']='_',['=']='+',['[']='{',[']']='}',[';']=':',['\'']='"',[',']='<',['.']='>',['/']='?',['\\']='|',['`']='~'}

    UILib._inputs['m4'] = {id=0x05, held=false, click=false}
    UILib._inputs['m5'] = {id=0x06, held=false, click=false}

    do
        function UILib:_KeyIDToName(keyId)
            for keyName, key in pairs(self._inputs) do
                if key.id == keyId then return keyName end
            end
            return nil
        end

        function UILib:_IsKeyPressed(keycode)
            return self._inputs[keycode] and self._inputs[keycode].click or false
        end

        function UILib:_IsKeyHeld(keycode)
            return self._inputs[keycode] and self._inputs[keycode].held or false
        end

        function UILib:_GetScreenSize()
            local screenSize = Vector2.new(1920, 1080)
            local camera = workspace.CurrentCamera
            if camera and camera.ViewportSize then screenSize = camera.ViewportSize end
            return screenSize
        end

        function UILib:_GetMousePos()
            local mousePos = Vector2.new()
            local myPlayer = game:GetService('Players').LocalPlayer
            if myPlayer then
                local myMouse = myPlayer:GetMouse()
                if myMouse then mousePos = Vector2.new(myMouse.X, myMouse.Y) end
            end
            return mousePos
        end

        function UILib:_IsMouseWithinBounds(origin, size)
            local mp = self:_GetMousePos()
            return mp.x >= origin.x and mp.x <= origin.x + size.x and mp.y >= origin.y and mp.y <= origin.y + size.y
        end
    end

    do
        function UILib:_GetFontRatio(fontFace)
            fontFace = fontFace or self._font_face
            -- rough per-font avg char-width ratios, err on the wide side to avoid clipping
            if fontFace == Drawing.Fonts.UI then return 0.53846 end
            if fontFace == Drawing.Fonts.System then return 0.55 end
            if fontFace == Drawing.Fonts.SystemBold then return 0.58 end
            if fontFace == Drawing.Fonts.Monospace then return 0.60 end
            if fontFace == Drawing.Fonts.Minecraft then return 0.60 end
            if fontFace == Drawing.Fonts.Pixel then return 0.55 end
            if fontFace == Drawing.Fonts.Fortnite then return 0.58 end
            return 0.58
        end

        function UILib:_GetTextBounds(text, fontFace, fontSize)
            fontFace = fontFace or self._font_face
            fontSize = fontSize or self._font_size
            return Vector2.new(#text * fontSize * self:_GetFontRatio(fontFace), fontSize)
        end

        function UILib:_Lerp(a, b, t)
            return a + (b - a) * t
        end

        function UILib:_LerpColor(a, b, t)
            return Color3.new(
                self:_Lerp(a.R, b.R, t),
                self:_Lerp(a.G, b.G, t),
                self:_Lerp(a.B, b.B, t)
            )
        end

        function UILib:_StepAnim(key, target, speed)
            local current = self._anim_state[key]
            if current == nil then
                current = target
            else
                local alpha = clamp((self._frame_dt or (16/1000)) * (speed or 16), 0, 1)
                current = current + (target - current) * alpha
                if math.abs(target - current) < 0.001 then
                    current = target
                end
            end
            self._anim_state[key] = current
            return current
        end

        function UILib:_SetAnim(key, value)
            self._anim_state[key] = value
            return value
        end

        function UILib:_ResolveMenuFadeOpacity()
            if self._menu_fade_done then
                return self._menu_open and 1 or 0, 1
            end
            local t = clamp((os.clock() - self._menu_toggled_at) / 0.3, 0, 1)
            local eased = t * t * (3 - 2 * t)
            local target = self._menu_open and 1 or 0
            local startOp = self._menu_fade_start_opacity
            if startOp == nil then
                startOp = self._menu_open and 0 or 1
            end
            return startOp + (target - startOp) * eased, t
        end

        function UILib:_GetCenteredTextPos(origin, size, text, fontFace, fontSize)
            local textSize = self:_GetTextBounds(text or '', fontFace, fontSize)
            return Vector2.new(origin.x + size.x / 2, origin.y + math.floor((size.y - textSize.y) / 2) - 1)
        end

        -- truncate string with ellipsis so it fits within maxWidth pixels
        function UILib:_TruncateText(text, maxWidth, fontFace, fontSize)
            if not text or text == '' then return '' end
            if self:_GetTextBounds(text, fontFace, fontSize).x <= maxWidth then return text end
            for i = #text, 1, -1 do
                local sub = text:sub(1, i) .. '...'
                if self:_GetTextBounds(sub, fontFace, fontSize).x <= maxWidth then
                    return sub
                end
            end
            return '...'
        end


        function UILib:_Draw(drawId, drawType, drawColor, drawZIndex, ...)
            local draw = self._drawings[drawId]

            if drawType == 'rect' then
                if not draw then
                    self._drawings[drawId] = Drawing.new('Square')
                    return self:_Draw(drawId, drawType, drawColor, drawZIndex, ...)
                end
                local rectPosition, rectSize, rectFilled = ...
                draw.Position = rectPosition
                draw.Size = rectSize
                if draw.Filled ~= rectFilled then draw.Filled = rectFilled end
            elseif drawType == 'text' then
                if not draw then
                    self._drawings[drawId] = Drawing.new('Text')
                    return self:_Draw(drawId, drawType, drawColor, drawZIndex, ...)
                end
                local textPosition, textContent, _, textAlign, textSize, textFontFace = ...
                if textAlign == 'center' then
                    if not draw.Center then draw.Center = true end
                else
                    if draw.Center then draw.Center = false end
                end
                draw.Position = textPosition
                if draw.Text ~= textContent then draw.Text = textContent end
                local wantOutline = self._text_outline_enabled == true
                if draw.Outline ~= wantOutline then draw.Outline = wantOutline end
                local resolvedFont = textFontFace or self._font_face
                if draw.Font ~= resolvedFont then draw.Font = resolvedFont end
                local resolvedSize = textSize or self._font_size
                if draw.Size ~= resolvedSize then draw.Size = resolvedSize end
            elseif drawType == 'line' then
                if not draw then
                    self._drawings[drawId] = Drawing.new('Line')
                    return self:_Draw(drawId, drawType, drawColor, drawZIndex, ...)
                end
                local lineFrom, lineTo, lineThickness = ...
                draw.From = lineFrom
                draw.To = lineTo
                local resolvedThickness = lineThickness or 1
                if draw.Thickness ~= resolvedThickness then draw.Thickness = resolvedThickness end
            elseif drawType == 'triangle' then
                if not draw then
                    self._drawings[drawId] = Drawing.new('Triangle')
                    return self:_Draw(drawId, drawType, drawColor, drawZIndex, ...)
                end
                local triangleFilled, trianglePointA, trianglePointB, trianglePointC = ...
                if draw.Filled ~= triangleFilled then draw.Filled = triangleFilled end
                draw.PointA = trianglePointA
                draw.PointB = trianglePointB
                draw.PointC = trianglePointC
            elseif drawType == 'circle' then
                if not draw then
                    self._drawings[drawId] = Drawing.new('Circle')
                    return self:_Draw(drawId, drawType, drawColor, drawZIndex, ...)
                end
                local circlePosition, circleRadius, circleFilled, circleThickness, circleSides = ...
                draw.Position = circlePosition
                if draw.Radius ~= circleRadius then draw.Radius = circleRadius end
                if draw.Filled ~= circleFilled then draw.Filled = circleFilled end
                local resolvedThickness = circleThickness or 1
                local resolvedSides = circleSides or 18
                if draw.Thickness ~= resolvedThickness then draw.Thickness = resolvedThickness end
                if draw.NumSides ~= resolvedSides then draw.NumSides = resolvedSides end
            elseif drawType == 'image' then
                if not draw then
                    -- pcall-guard because Drawing.new('Image') is the only path we don't fully trust;
                    -- if matcha ever breaks Image support, don't take the whole menu down with us
                    local okCreate, newDraw = pcall(Drawing.new, 'Image')
                    if not okCreate or not newDraw then
                        -- permanent disable: matcha Image type broken, don't retry every frame/Apply
                        self._bg_image_enabled = false
                        self._bg_image_subsystem_dead = true
                        return
                    end
                    self._drawings[drawId] = newDraw
                    -- new drawing instance -> invalidate stale data cache entry
                    self._draw_data_cache[drawId] = nil
                    return self:_Draw(drawId, drawType, drawColor, drawZIndex, ...)
                end
                local imgPos, imgSize, imgData, imgRounding = ...
                -- set data first so native image dimensions can't override our forced size
                -- track via own cache bc matcha .Data readback is unreliable (nil-read = per-frame rewrite = lag)
                if imgData and self._draw_data_cache[drawId] ~= imgData then
                    draw.Data = imgData
                    self._draw_data_cache[drawId] = imgData
                end
                draw.Position = imgPos
                draw.Size = imgSize -- force stretch to ui box regardless of source ratio
                if imgRounding and draw.Rounding ~= imgRounding then draw.Rounding = imgRounding end
                if draw.ZIndex ~= drawZIndex then draw.ZIndex = drawZIndex end
                if not draw.Visible then draw.Visible = true end
                return
            elseif drawType == 'gradient' then
                local args = {...}
                if #args == 4 then
                    local firstColor = args[4]
                    local tintColor = self._theming.crust
                    table.insert(args, Color3.new(
                        self:_Lerp(firstColor.R, tintColor.R, 0.5),
                        self:_Lerp(firstColor.G, tintColor.G, 0.5),
                        self:_Lerp(firstColor.B, tintColor.B, 0.5)
                    ))
                end
                local gradientDirection = args[1]
                local gradientOrigin = args[2]
                local gradientSize = args[3]
                local numSegments = (#args - 3) - 1
                local lod = 26
                for i = 4, #args-1 do
                    local currentColor = args[i]
                    local nextColor = args[i+1]
                    local segmentLengthX = gradientSize.x / numSegments
                    local segmentLengthY = gradientSize.y / numSegments
                    for j = 1, lod do
                        local t = (j-1) / (lod-1)
                        local targetColor = Color3.new(
                            self:_Lerp(currentColor.R, nextColor.R, t),
                            self:_Lerp(currentColor.G, nextColor.G, t),
                            self:_Lerp(currentColor.B, nextColor.B, t)
                        )
                        local targetAlpha = self:_Lerp(currentColor.A or 1, nextColor.A or 1, t)
                        local segmentPosition, segmentSize
                        if gradientDirection == 'horizontal' then
                            segmentSize = Vector2.new(segmentLengthX / lod, gradientSize.y)
                            segmentPosition = Vector2.new(
                                gradientOrigin.x + (i-4) * segmentLengthX + (j-1) * segmentSize.x,
                                gradientOrigin.y
                            )
                        elseif gradientDirection == 'vertical' then
                            segmentSize = Vector2.new(gradientSize.x, segmentLengthY / lod)
                            segmentPosition = Vector2.new(
                                gradientOrigin.x,
                                gradientOrigin.y + (i-4) * segmentLengthY + (j-1) * segmentSize.y
                            )
                        end
                        local segmentDrawId = drawId .. '_' .. tostring(i) .. '_' .. tostring(j)
                        self:_Draw(segmentDrawId, 'rect', targetColor, drawZIndex, segmentPosition, segmentSize, true)
                        self:_SetOpacity(segmentDrawId, targetAlpha)
                    end
                end
                return
            end

            if draw.Color ~= drawColor then draw.Color = drawColor end
            if draw.ZIndex ~= drawZIndex then draw.ZIndex = drawZIndex end
            if not draw.Visible then
                -- apply fade multiplier when making visible (prevents 1-frame flash)
                local mul = self._menu_fade_mul
                if mul and mul < 1 and drawId:sub(1, 5) == 'menu_' then
                    draw.Transparency = self._base_alpha[drawId] or mul
                end
                draw.Visible = true
            end
        end

        function UILib:_RemoveDraw(drawId)
            local drawObject = self._drawings[drawId]
            if drawObject then
                drawObject:Remove()
                self._drawings[drawId] = nil
                self._base_alpha[drawId] = nil
                self._draw_data_cache[drawId] = nil
            end
        end

        function UILib:_Undraw(drawId)
            local drawObject = self._drawings[drawId]
            if drawObject then drawObject.Visible = false end
        end

        function UILib:_SetOpacity(drawId, opacity)
            local drawObject = self._drawings[drawId]
            if drawObject then
                self._base_alpha[drawId] = opacity
                -- inline fade: menu_ drawings get multiplied by fade factor
                local mul = self._menu_fade_mul
                if mul and mul < 1 and drawId:sub(1, 5) == 'menu_' then
                    drawObject.Transparency = opacity * mul
                else
                    drawObject.Transparency = opacity
                end
            end
        end

        function UILib:_RemoveDrawStartsWith(drawId)
            local len = #drawId
            local toRemove = {}
            for drawName, drawObject in pairs(self._drawings) do
                if drawName:sub(1, len) == drawId then
                    drawObject:Remove()
                    toRemove[#toRemove + 1] = drawName
                end
            end
            local ba = self._base_alpha
            local dc = self._draw_data_cache
            for i = 1, #toRemove do
                local name = toRemove[i]
                self._drawings[name] = nil
                ba[name] = nil
                dc[name] = nil
            end
        end

        function UILib:_UndrawStartsWith(drawId)
            local len = #drawId
            for drawName, drawObject in pairs(self._drawings) do
                if drawName:sub(1, len) == drawId then
                    drawObject.Visible = false
                end
            end
        end

        function UILib:_SetOpacityStartsWith(drawId, opacity)
            local len = #drawId
            local ba = self._base_alpha
            local mul = self._menu_fade_mul
            local applyMul = mul and mul < 1
            for drawName, drawObject in pairs(self._drawings) do
                if drawName:sub(1, len) == drawId then
                    ba[drawName] = opacity
                    if applyMul and drawName:sub(1, 5) == 'menu_' then
                        drawObject.Transparency = opacity * mul
                    else
                        drawObject.Transparency = opacity
                    end
                end
            end
        end

        -- fetch + cache bg image bytes. returns ok, bytes_or_err
        -- recursively create nested folders (matcha makefolder doesn't auto-create parents)
        function UILib:_EnsureFolder(path)
            if not isfolder or not makefolder then return end
            local acc = ''
            for segment in string.gmatch(path, '[^/]+') do
                acc = (acc == '' and segment) or (acc .. '/' .. segment)
                -- drive-root segments like "C:" may make isfolder/makefolder throw on matcha,
                -- so pcall both. if we aren't certain folder exists (crash/nil/false), try to create.
                local okExists, exists = pcall(isfolder, acc)
                local definitelyExists = okExists and exists == true
                if not definitelyExists then pcall(makefolder, acc) end
            end
        end

        function UILib:_LoadBgImage(url)
            if type(url) ~= 'string' or #url < 4 then return false, 'bad url' end
            -- simple non-crypto hash for cache key
            local h = 2166136261
            for i = 1, #url do
                h = bit32.bxor(h, string.byte(url, i))
                h = (h * 16777619) % 4294967296
            end
            local cacheDir = self._bg_image_cache_dir
            -- try to keep file extension from url so files look sane in the folder
            -- strip query (?foo=bar) and fragment (#frag) first so cdn urls with ?width=100 still match
            local urlNoQuery = string.match(url, '^([^?#]+)') or url
            local ext = string.match(urlNoQuery, '%.([%w]+)$')
            if ext then ext = string.lower(ext) end
            if not ext or #ext > 5 then ext = 'bin' end
            local cachePath = cacheDir .. '/' .. string.format('%x', math.floor(h)) .. '.' .. ext
            self:_EnsureFolder(cacheDir)
            local MAX_BYTES = 10 * 1024 * 1024
            if isfile and isfile(cachePath) then
                local readOk, cachedBytes = pcall(readfile, cachePath)
                if readOk and type(cachedBytes) == 'string' and #cachedBytes > 16 and #cachedBytes <= MAX_BYTES then
                    return true, cachedBytes
                end
            end
            local ok, bytes = pcall(function() return game:HttpGet(url) end)
            if not ok or type(bytes) ~= 'string' or #bytes < 16 then
                return false, 'fetch failed'
            end
            -- cap at 10MB - bigger images trigger long sync decode on draw.Data assign -> ui freeze
            if #bytes > MAX_BYTES then
                return false, string.format('image too large (%.1f MB, max 10 MB)', #bytes / 1048576)
            end
            pcall(writefile, cachePath, bytes)
            return true, bytes
        end

        -- apply fade as multiplier on stored base alphas (preserves per-element alpha relationships)
        function UILib:_ApplyMenuFade(multiplier)
            local ba = self._base_alpha
            for drawName, drawObject in pairs(self._drawings) do
                if drawName:sub(1, 5) == 'menu_' then
                    drawObject.Transparency = (ba[drawName] or 1) * multiplier
                end
            end
        end
    end

    do
        function UILib:_SpawnColorpicker(position, label, value, callback)
            self:_RemoveColorpicker()
            local h, s, v = 0, 0, 0
            if value then h, s, v = rgbToHsv(value.R, value.G, value.B) end
            local item = {
                position = position or Vector2.new(self.x + self.w + self._padding, self.y),
                label = label,
                callback = callback,
                _h = h or 0,
                _s = s or 0,
                _v = v or 0,
                _spawned_at = os.clock()
            }
            self._active_colorpicker = item
        end

        function UILib:_RemoveColorpicker()
            self._active_colorpicker = nil
            self:_UndrawStartsWith('colorpicker_')
        end

        function UILib:_SpawnDropdown(position, width, value, choices, multi, callback, previewFonts, previewColors, hoverCallback, cancelCallback)
            self:_RemoveDropdown()
            -- normalize value to always be a table (avoids table.find/concat crash)
            if type(value) ~= 'table' then
                if value ~= nil then value = {tostring(value)} else value = {} end
            end
            choices = choices or {}
            local item = {
                position = position or Vector2.new(0, 0),
                width = width or 120,
                value = value,
                choices = choices,
                multi = multi,
                callback = callback,
                previewFonts = previewFonts,
                previewColors = previewColors,
                _hoverCallback = hoverCallback,
                _cancelCallback = cancelCallback,
                _last_hover = nil,
                _committed = false,
                _page_offset = 0,
                _spawned_at = os.clock()
            }
            self._active_dropdown = item
        end

        function UILib:_RemoveDropdown()
            self._active_dropdown = nil
            self:_UndrawStartsWith('dropdown_')
        end

        function UILib:_ResolveColumnValue(column, fallback)
            local resolved = nil
            if type(column) == 'string' then
                local lowered = string.lower(column)
                if lowered == 'left' or lowered == 'l' then
                    resolved = 1
                elseif lowered == 'right' or lowered == 'r' then
                    resolved = 2
                end
            else
                resolved = tonumber(column)
                if resolved then
                    resolved = math.floor(resolved + 0.5)
                end
            end

            if resolved then
                if resolved < 1 then resolved = 1 end
                if resolved > self._columns then resolved = self._columns end
                return resolved
            end

            return fallback
        end

        function UILib:_GetSectionRef(tabName, sectionName)
            local tabData = self._tree[tabName]
            return tabData and tabData._items[sectionName] or nil
        end

        function UILib:_GetItemRef(tabName, sectionName, itemId)
            local sectionRef = self:_GetSectionRef(tabName, sectionName)
            return sectionRef and sectionRef._items[itemId] or nil
        end

        function UILib:_MakeItemHandle(tabName, sectionName, itemId, handle)
            handle = handle or {}

            local function getItem()
                return self:_GetItemRef(tabName, sectionName, itemId)
            end

            local function getDefaultColumn()
                local sectionRef = self:_GetSectionRef(tabName, sectionName)
                return (sectionRef and sectionRef._column) or 1
            end

            handle.SetColumn = function(_, newColumn)
                local itemRef = getItem()
                if itemRef then
                    itemRef._column = self:_ResolveColumnValue(newColumn, itemRef._column or getDefaultColumn())
                end
                return handle
            end
            handle.SetSide = handle.SetColumn
            handle.SetHidden = function(_, hidden)
                local itemRef = getItem()
                if itemRef then itemRef._hidden = hidden end
                return handle
            end
            handle.SetYOffset = function(_, newOffset)
                local itemRef = getItem()
                if itemRef then
                    itemRef._y_offset = tonumber(newOffset) or 0
                end
                return handle
            end
            handle.MoveY = function(_, delta)
                local itemRef = getItem()
                if itemRef then
                    itemRef._y_offset = (tonumber(itemRef._y_offset) or 0) + (tonumber(delta) or 0)
                end
                return handle
            end
            handle.SetLayout = function(_, newColumn, newOffset)
                if newColumn ~= nil then
                    handle:SetColumn(newColumn)
                end
                if newOffset ~= nil then
                    handle:SetYOffset(newOffset)
                end
                return handle
            end
            handle.GetLayout = function(_)
                local itemRef = getItem()
                if not itemRef then return nil end
                return {
                    column = itemRef._column or getDefaultColumn(),
                    y_offset = itemRef._y_offset or 0,
                }
            end

            return handle
        end

        -- widget factories
        function UILib:_Toggle(tabName, sectionName, label, value, callback, unsafe, tooltip)
            local itemId = #self._tree[tabName]._items[sectionName]._items + 1
            local item = {
                type_ = 'toggle',
                label = label,
                value = value,
                callback = callback,
                unsafe = unsafe or false,
                tooltip = tooltip,
                _y_offset = 0,
            }
            table.insert(self._tree[tabName]._items[sectionName]._items, item)

            local handle = self:_MakeItemHandle(tabName, sectionName, itemId, {})
            handle.Set = function(_, newValue)
                    self._tree[tabName]._items[sectionName]._items[itemId].value = newValue
                    if self._tree[tabName]._items[sectionName]._items[itemId].callback then
                        self._tree[tabName]._items[sectionName]._items[itemId].callback(newValue)
                    end
                end
            handle.AddKeybind = function(_, value, mode, canChange, callback)
                    local kb = {
                        value = value,
                        callback = callback,
                        mode = mode or 'Hold',
                        canChange = canChange ~= false,
                        _listening = false,
                        _listening_start = 0
                    }
                    self._tree[tabName]._items[sectionName]._items[itemId].keybind = kb
                    return {
                        Set = function(_, newValue, newMode)
                            local m = newMode or self._tree[tabName]._items[sectionName]._items[itemId].keybind.mode
                            self._tree[tabName]._items[sectionName]._items[itemId].keybind.value = newValue
                            self._tree[tabName]._items[sectionName]._items[itemId].keybind.mode = m
                            if self._tree[tabName]._items[sectionName]._items[itemId].keybind.callback then
                                self._tree[tabName]._items[sectionName]._items[itemId].keybind.callback(newValue, m)
                            end
                        end
                    }
                end
            handle.AddColorpicker = function(_, label, value, overwrite, callback)
                    local cp = {
                        label = label,
                        value = value or self._theming.accent,
                        overwrite = overwrite,
                        callback = callback
                    }
                    self._tree[tabName]._items[sectionName]._items[itemId].colorpicker = cp
                    return {
                        Set = function(_, newValue)
                            local cpItem = self._tree[tabName]._items[sectionName]._items[itemId].colorpicker
                            -- guard nil: passing nil to a drawing Color field crashes Matcha
                            newValue = newValue or cpItem.value or self._theming.accent
                            cpItem.value = newValue
                            if cpItem.callback then
                                cpItem.callback(newValue)
                            end
                        end
                    }
                end
            return handle
        end

        function UILib:_Slider(tabName, sectionName, label, value, step, min, max, suffix, callback, tooltip)
            local itemId = #self._tree[tabName]._items[sectionName]._items + 1
            -- guard against invalid step/min/max that would crash rendering
            step = tonumber(step) or 1
            if step <= 0 then step = 1 end
            min = tonumber(min) or 0
            max = tonumber(max) or 1
            if max <= min then max = min + 1 end
            value = tonumber(value) or min
            if value < min then value = min elseif value > max then value = max end
            -- snap initial value to step grid so drag and stored value stay consistent
            value = min + math.floor(((value - min) / step) + 0.5) * step
            if value > max then value = max end
            local item = {
                type_ = 'slider',
                label = label,
                value = value,
                step = step,
                min = min,
                max = max,
                suffix = suffix or '',
                callback = callback,
                tooltip = tooltip,
                _active = true,
                _y_offset = 0,
            }
            table.insert(self._tree[tabName]._items[sectionName]._items, item)
            local handle = self:_MakeItemHandle(tabName, sectionName, itemId, {})
            handle.Set = function(_, newValue)
                    local it = self._tree[tabName]._items[sectionName]._items[itemId]
                    newValue = tonumber(newValue) or it.min
                    -- clamp to valid range
                    if newValue < it.min then newValue = it.min end
                    if newValue > it.max then newValue = it.max end
                    -- snap to step grid to match drag behavior
                    if it.step and it.step > 0 then
                        newValue = it.min + math.floor(((newValue - it.min) / it.step) + 0.5) * it.step
                        if newValue > it.max then newValue = it.max end
                    end
                    it.value = newValue
                    if it.callback then it.callback(newValue) end
                end
            handle.SetActive = function(_, active)
                    local it = self._tree[tabName]._items[sectionName]._items[itemId]
                    it._active = (active ~= false)
                end
            return handle
        end

        function UILib:_RangeSlider(tabName, sectionName, label, valueLow, valueHigh, step, min, max, suffix, callback, tooltip)
            local itemId = #self._tree[tabName]._items[sectionName]._items + 1
            -- guard against invalid step/min/max that would crash rendering
            step = tonumber(step) or 1
            if step <= 0 then step = 1 end
            min = tonumber(min) or 0
            max = tonumber(max) or 1
            if max <= min then max = min + 1 end
            local function snap(v)
                v = tonumber(v) or min
                if v < min then v = min end
                if v > max then v = max end
                v = min + math.floor(((v - min) / step) + 0.5) * step
                if v > max then v = max end
                if v < min then v = min end
                return v
            end
            valueLow  = snap(valueLow)
            valueHigh = snap(valueHigh)
            if valueLow > valueHigh then valueLow, valueHigh = valueHigh, valueLow end
            local item = {
                type_ = 'range_slider',
                label = label,
                valueLow = valueLow,
                valueHigh = valueHigh,
                step = step,
                min = min,
                max = max,
                suffix = suffix or '',
                callback = callback,
                tooltip = tooltip,
                _active = true,
                _drag_handle = nil, -- "low" | "high" | nil
                _y_offset = 0,
            }
            table.insert(self._tree[tabName]._items[sectionName]._items, item)
            local handle = self:_MakeItemHandle(tabName, sectionName, itemId, {})
            handle.Set = function(_, lo, hi)
                    local it = self._tree[tabName]._items[sectionName]._items[itemId]
                    local function s(v)
                        v = tonumber(v) or it.min
                        if v < it.min then v = it.min end
                        if v > it.max then v = it.max end
                        if it.step and it.step > 0 then
                            v = it.min + math.floor(((v - it.min) / it.step) + 0.5) * it.step
                            if v > it.max then v = it.max end
                        end
                        return v
                    end
                    lo = s(lo); hi = s(hi)
                    if lo > hi then lo, hi = hi, lo end
                    it.valueLow = lo
                    it.valueHigh = hi
                    if it.callback then it.callback(lo, hi) end
                end
            handle.SetActive = function(_, active)
                    local it = self._tree[tabName]._items[sectionName]._items[itemId]
                    it._active = (active ~= false)
                end
            return handle
        end

        function UILib:_Dropdown(tabName, sectionName, label, value, choices, multi, callback, tooltip, previewFonts, previewColors, hoverCallback, cancelCallback)
            local itemId = #self._tree[tabName]._items[sectionName]._items + 1
            -- normalize value to always be a table of strings (avoids table.find / table.concat crashes)
            if type(value) ~= 'table' then
                if value ~= nil then value = {tostring(value)} else value = {} end
            end
            choices = choices or {}
            local item = {
                type_ = 'dropdown',
                label = label,
                value = value,
                choices = choices,
                multi = multi,
                callback = callback,
                tooltip = tooltip,
                previewFonts = previewFonts,
                previewColors = previewColors,
                hoverCallback = hoverCallback,
                cancelCallback = cancelCallback,
                _y_offset = 0,
            }
            table.insert(self._tree[tabName]._items[sectionName]._items, item)
            local handle = self:_MakeItemHandle(tabName, sectionName, itemId, {})
            handle.Set = function(_, newValue)
                    local it = self._tree[tabName]._items[sectionName]._items[itemId]
                    if type(newValue) ~= 'table' then
                        if newValue ~= nil then newValue = {tostring(newValue)} else newValue = {} end
                    end
                    it.value = newValue
                    if it.callback then it.callback(newValue) end
                end
            handle.UpdateChoices = function(_, newChoices)
                    local it = self._tree[tabName]._items[sectionName]._items[itemId]
                    it.choices = newChoices or {}
                    -- filter stale selections that are no longer in choices list
                    if type(it.value) == 'table' then
                        local filtered = {}
                        for _, v in ipairs(it.value) do
                            if table.find(it.choices, v) then
                                filtered[#filtered + 1] = v
                            end
                        end
                        it.value = filtered
                    end
                end
            return handle
        end

        function UILib:_Button(tabName, sectionName, label, callback)
            local itemId = #self._tree[tabName]._items[sectionName]._items + 1
            local item = {
                type_ = 'button',
                label = label,
                callback = callback,
                _y_offset = 0,
            }
            table.insert(self._tree[tabName]._items[sectionName]._items, item)
            return self:_MakeItemHandle(tabName, sectionName, itemId, {})
        end

        function UILib:_Textbox(tabName, sectionName, label, value, callback)
            local itemId = #self._tree[tabName]._items[sectionName]._items + 1
            local item = {
                type_ = 'textbox',
                label = label,
                value = value,
                callback = callback,
                _y_offset = 0,
            }
            table.insert(self._tree[tabName]._items[sectionName]._items, item)
            local handle = self:_MakeItemHandle(tabName, sectionName, itemId, {})
            handle.Set = function(_, newValue)
                    self._tree[tabName]._items[sectionName]._items[itemId].value = newValue
                    if self._tree[tabName]._items[sectionName]._items[itemId].callback then
                        self._tree[tabName]._items[sectionName]._items[itemId].callback(newValue)
                    end
                end
            return handle
        end

        -- non-interactive status/info text; Set() rewrites the label in place
        function UILib:_Label(tabName, sectionName, label)
            local itemId = #self._tree[tabName]._items[sectionName]._items + 1
            local item = {
                type_ = 'label',
                label = tostring(label or ''),
                _y_offset = 0,
            }
            table.insert(self._tree[tabName]._items[sectionName]._items, item)
            local handle = self:_MakeItemHandle(tabName, sectionName, itemId, {})
            handle.Set = function(_, newLabel)
                self._tree[tabName]._items[sectionName]._items[itemId].label = tostring(newLabel or '')
            end
            return handle
        end

        function UILib:_Section(tabName, sectionName, _subTabName, column)
            local tabData = self._tree[tabName]
            local sectionData = tabData._items[sectionName]
            local resolvedColumn = nil
            if column ~= nil then
                resolvedColumn = self:_ResolveColumnValue(column, sectionData and sectionData._column or tabData._next_column or 1)
            elseif sectionData then
                resolvedColumn = sectionData._column or 1
            else
                resolvedColumn = tabData._next_column or 1
                tabData._next_column = resolvedColumn >= self._columns and 1 or (resolvedColumn + 1)
            end

            if not sectionData then
                sectionData = {
                    _items = {},
                    _column = resolvedColumn,
                    _y_offset = 0,
                }
                tabData._items[sectionName] = sectionData
                table.insert(tabData._section_order, sectionName)
                tabData._section_count = tabData._section_count + 1
            elseif column ~= nil then
                sectionData._column = resolvedColumn
            end
            -- build a dropdown preloaded with the font list and a preview map.
            -- accepts a plain string value and forwards a plain string to the callback,
            -- unlike the raw Section:Dropdown which uses a table of strings.
            local function buildFontDropdown(label, currentFont, callback, opts)
                opts = opts or {}
                local choices = opts.choices or self._font_list
                local usePreview = opts.preview ~= false
                local tooltip = opts.tooltip
                local previewFonts = nil
                if usePreview then
                    previewFonts = {}
                    for _, fn in ipairs(choices) do
                        previewFonts[fn] = self._font_face_by_name[fn]
                    end
                end
                local wrapped = function(newValue)
                    local picked = (type(newValue) == 'table') and newValue[1] or newValue
                    if callback then callback(picked) end
                end
                return self:_Dropdown(tabName, sectionName, label, { currentFont or choices[1] }, choices, false, wrapped, tooltip, previewFonts, nil, nil, nil)
            end

            local sectionApi
            local function makeLane(defaultColumn)
                return {
                    Toggle = function(_, ...)
                        local itemHandle = self:_Toggle(tabName, sectionName, ...)
                        itemHandle:SetColumn(defaultColumn)
                        return itemHandle
                    end,
                    Slider = function(_, ...)
                        local itemHandle = self:_Slider(tabName, sectionName, ...)
                        itemHandle:SetColumn(defaultColumn)
                        return itemHandle
                    end,
                    RangeSlider = function(_, ...)
                        local itemHandle = self:_RangeSlider(tabName, sectionName, ...)
                        itemHandle:SetColumn(defaultColumn)
                        return itemHandle
                    end,
                    Dropdown = function(_, ...)
                        local itemHandle = self:_Dropdown(tabName, sectionName, ...)
                        itemHandle:SetColumn(defaultColumn)
                        return itemHandle
                    end,
                    FontDropdown = function(_, label, currentFont, callback, opts)
                        local itemHandle = buildFontDropdown(label, currentFont, callback, opts)
                        itemHandle:SetColumn(defaultColumn)
                        return itemHandle
                    end,
                    Button = function(_, ...)
                        local itemHandle = self:_Button(tabName, sectionName, ...)
                        itemHandle:SetColumn(defaultColumn)
                        return itemHandle
                    end,
                    Textbox = function(_, ...)
                        local itemHandle = self:_Textbox(tabName, sectionName, ...)
                        itemHandle:SetColumn(defaultColumn)
                        return itemHandle
                    end,
                }
            end

            sectionApi = {
                Toggle = function(_, ...) return self:_Toggle(tabName, sectionName, ...) end,
                Slider = function(_, ...) return self:_Slider(tabName, sectionName, ...) end,
                RangeSlider = function(_, ...) return self:_RangeSlider(tabName, sectionName, ...) end,
                Dropdown = function(_, ...) return self:_Dropdown(tabName, sectionName, ...) end,
                FontDropdown = function(_, label, currentFont, callback, opts)
                    return buildFontDropdown(label, currentFont, callback, opts)
                end,
                Button = function(_, ...) return self:_Button(tabName, sectionName, ...) end,
                Textbox = function(_, ...) return self:_Textbox(tabName, sectionName, ...) end,
                Label = function(_, ...) return self:_Label(tabName, sectionName, ...) end,
                SetColumn = function(_, newColumn)
                    local ref = self:_GetSectionRef(tabName, sectionName)
                    if ref then
                        ref._column = self:_ResolveColumnValue(newColumn, ref._column or 1)
                    end
                    return sectionApi
                end,
                SetYOffset = function(_, newOffset)
                    local ref = self:_GetSectionRef(tabName, sectionName)
                    if ref then
                        ref._y_offset = tonumber(newOffset) or 0
                    end
                    return sectionApi
                end,
                MoveY = function(_, delta)
                    local ref = self:_GetSectionRef(tabName, sectionName)
                    if ref then
                        ref._y_offset = (tonumber(ref._y_offset) or 0) + (tonumber(delta) or 0)
                    end
                    return sectionApi
                end,
                SetLayout = function(_, newColumn, newOffset)
                    if newColumn ~= nil then
                        sectionApi:SetColumn(newColumn)
                    end
                    if newOffset ~= nil then
                        sectionApi:SetYOffset(newOffset)
                    end
                    return sectionApi
                end,
                Left = function(_)
                    return makeLane(1)
                end,
                Right = function(_)
                    return makeLane(2)
                end,
            }
            return sectionApi
        end

        -- menu api
        function UILib:GetMenuSize()
            return Vector2.new(self.w, self.h)
        end

        function UILib:SetWatermarkEnabled(value)
            self._watermark_enabled = value
        end

        -- screen-locked status indicator pill (top-center). pulls theme colors only.
        -- caller pushes state every frame; lib handles draw + cleanup + drag
        function UILib:UpdateIndicator(enabled, label, active)
            self._indicator_enabled = enabled == true
            self._indicator_label   = label or ""
            self._indicator_active  = active == true
        end

        -- pos: Vector2 / {x,y} table / nil (nil = reset to top-center default)
        function UILib:SetIndicatorPosition(pos)
            if pos == nil then
                self._indicator_pos = nil
                return
            end
            if type(pos) == 'table' then
                local x = pos.X or pos.x
                local y = pos.Y or pos.y
                if type(x) == 'number' and type(y) == 'number' then
                    self._indicator_pos = Vector2.new(x, y)
                end
            end
        end

        function UILib:OnIndicatorDragEnd(cb)
            self._indicator_drag_end_cb = cb
        end

        function UILib:SetMenuTitle(newTitle)
            self.title = newTitle
        end

        function UILib:SetMenuPosition(newPos)
            self.x = newPos.x or self.x
            self.y = newPos.y or self.y
        end

        function UILib:SetMenuSize(newSize)
            self.w = newSize.x or self.w
            self.h = newSize.y or self.h
        end

        function UILib:CenterMenu()
            local screenSize = self:_GetScreenSize()
            local menuSize = self:GetMenuSize()
            self:SetMenuPosition(Vector2.new(screenSize.x/2 - menuSize.x/2, screenSize.y/2 - menuSize.y/2))
        end

        function UILib:Notification(text, time)
            local item = {
                text = tostring(text or ''),
                time = tonumber(time) or 3,
                _id = self._notifications_spawned,
                _spawned_at = os.clock()
            }
            table.insert(self._notifications, item)
            self._notifications_spawned = self._notifications_spawned + 1
        end

        function UILib:Tab(tabName, options)
            local sidebarGroup = nil
            local sidebarGroupTitle = nil
            if type(options) == 'table' then
                sidebarGroup = options.sidebarGroup or options.group
                sidebarGroupTitle = options.sidebarGroupTitle or options.groupTitle
            elseif options ~= nil then
                sidebarGroup = tostring(options)
            end

            if not self._tree[tabName] then
                self._tree[tabName] = {
                    _items = {},
                    _section_order = {},
                    _section_count = 0,
                    _next_column = 1,
                    _sidebar_group = sidebarGroup,
                    _sidebar_group_title = sidebarGroupTitle,
                }
                table.insert(self._tab_order, tabName)
            elseif options ~= nil then
                self._tree[tabName]._sidebar_group = sidebarGroup
                if type(options) == 'table' then
                    self._tree[tabName]._sidebar_group_title = sidebarGroupTitle
                end
            end
            if not self._open_tab then self._open_tab = tabName end

            local parentLib = self
            local tabObj
            tabObj = {
                Section = function(_, sectionName, column)
                    return parentLib:_Section(tabName, sectionName, nil, column)
                end,
                SubTab = function(_, _subTabName)
                    -- first subtab: pull parent out of sidebar, becomes group header only
                    if not parentLib._tree[tabName]._has_subtabs then
                        parentLib._tree[tabName]._has_subtabs = true
                        for i = #parentLib._tab_order, 1, -1 do
                            if parentLib._tab_order[i] == tabName then
                                table.remove(parentLib._tab_order, i)
                                break
                            end
                        end
                    end
                    local subKey = tabName .. ">" .. _subTabName
                    local subTab = parentLib:Tab(subKey, {
                        sidebarGroup = tabName,
                        sidebarGroupTitle = tabName,
                    })
                    parentLib._tree[subKey]._display_name = _subTabName
                    -- if open tab was parent, switch to first subtab
                    if parentLib._open_tab == tabName then
                        parentLib._open_tab = subKey
                    end
                    return subTab
                end,
                SetSidebarGroup = function(_, newGroup, newTitle)
                    local tabRef = parentLib._tree[tabName]
                    if tabRef then
                        local parsedGroup = newGroup
                        local parsedTitle = newTitle
                        if type(newGroup) == 'table' then
                            parsedGroup = newGroup.sidebarGroup or newGroup.group
                            parsedTitle = newGroup.sidebarGroupTitle or newGroup.groupTitle
                        end
                        tabRef._sidebar_group = parsedGroup and tostring(parsedGroup) or nil
                        if parsedTitle ~= nil then
                            tabRef._sidebar_group_title = parsedTitle and tostring(parsedTitle) or nil
                        end
                    end
                    return tabObj
                end,
                GetSidebarGroup = function(_)
                    local tabRef = parentLib._tree[tabName]
                    return tabRef and tabRef._sidebar_group or nil
                end,
                SetSidebarGroupTitle = function(_, newTitle)
                    local tabRef = parentLib._tree[tabName]
                    if tabRef then
                        tabRef._sidebar_group_title = newTitle and tostring(newTitle) or nil
                    end
                    return tabObj
                end,
                GetSidebarGroupTitle = function(_)
                    local tabRef = parentLib._tree[tabName]
                    return tabRef and tabRef._sidebar_group_title or nil
                end
            }
            return tabObj
        end

        function UILib:CreateSettingsTab(customName, options)
            -- guard against double init which would duplicate all widgets
            if self._settings_tab_created then
                return self._settings_tab_ref, self._settings_menu_section_ref, self._settings_theming_section_ref, self._settings_item_refs
            end
            self._settings_tab_created = true
            options = options or {}
            local showWatermark = options.watermark ~= false
            local showBackgroundAlpha = options.backgroundAlpha ~= false
            local showCustomTitle = options.customTitle ~= false
            local showTheming = options.theming ~= false
            local menuKeyLabel = options.menuKeyLabel or 'Ov. menu key'
            local settingsTab = self:Tab(customName or 'Menu')
            local settingsRefs = {}

            local menuSection = settingsTab:Section('Menu', 'left')
            local menuKey = menuSection:Toggle(menuKeyLabel, self._overwrite_menu_key, function(newValue)
                self._overwrite_menu_key = newValue
            end)
            settingsRefs.menuKey = menuKey
            menuKey:AddKeybind(self._menu_key, 'Hold', false, function(newValue)
                if newValue and self._inputs[newValue] then
                    self._menu_key = newValue
                end
            end)
            if showWatermark then
                settingsRefs.watermark = menuSection:Toggle('Watermark', self._watermark_enabled, function(newValue)
                    self:SetWatermarkEnabled(newValue)
                end)
            end
            if showCustomTitle then
                settingsRefs.customTitleEnabled = menuSection:Toggle('Custom menu title', self._custom_title_enabled, function(newValue)
                    self._custom_title_enabled = newValue
                end)
                self._custom_title = self.title
                settingsRefs.menuTitle = menuSection:Textbox('Menu title', self.title, function(newValue)
                    self._custom_title = newValue
                end)
            end

            -- background image section
            local showBgImage = options.backgroundImage ~= false and self._bg_image_feature_enabled ~= false
            if showBgImage then
                local bgSection = settingsTab:Section('Background Image', 'left')
                self:_EnsureFolder(self._bg_image_cache_dir)

                -- scan dir for .txt files — each holds one image url
                local function listPhotoFiles()
                    local out = {}
                    local ok, files = pcall(listfiles, self._bg_image_cache_dir)
                    if not ok or type(files) ~= 'table' then return out end
                    for i = 1, #files do
                        local full = tostring(files[i])
                        local name = full:match('[^/\\]+$') or full
                        local ext = name:match('%.([%w]+)$')
                        if ext and string.lower(ext) == 'txt' then
                            out[#out + 1] = name
                        end
                    end
                    return out
                end

                local photoFiles = listPhotoFiles()
                local noFilesLabel = '(empty — drop a .txt with an image url in ' .. self._bg_image_cache_dir .. ')'
                if #photoFiles == 0 then photoFiles = {noFilesLabel} end

                local defaultChoice = photoFiles[1]
                local remembered = self._bg_image_url or ''
                for i = 1, #photoFiles do
                    if photoFiles[i] == remembered then defaultChoice = remembered break end
                end

                local photoDropdown = bgSection:Dropdown('Photo file', {defaultChoice}, photoFiles, false, function(newValue)
                    if type(newValue) ~= 'table' or not newValue[1] then return end
                    local filename = newValue[1]
                    if filename == noFilesLabel then return end
                    if self._bg_image_subsystem_dead then
                        self:Notification('Image subsystem unavailable', 3)
                        return
                    end
                    -- validate BEFORE mutating state so a bad pick doesn't cancel an in-flight fetch
                    local ext = (filename:match('%.([%w]+)$') or ''):lower()
                    if ext ~= 'txt' then
                        self:Notification('Only .txt url pointers supported — got .' .. ext, 4)
                        return
                    end
                    if self._bg_image_fetching then
                        self:Notification('Fetch already in progress', 2)
                        return
                    end
                    -- commit state only after all guards pass
                    self._bg_image_url = filename
                    self._bg_image_apply_token = (self._bg_image_apply_token or 0) + 1
                    local myToken = self._bg_image_apply_token
                    local fullPath = self._bg_image_cache_dir .. '/' .. filename
                    self._bg_image_fetching = true
                    -- watchdog: if fetch hasn't finished in 20s, free the lock so the user isn't stuck
                    task.delay(20, function()
                        if self._bg_image_apply_token == myToken and self._bg_image_fetching then
                            self._bg_image_apply_token = (self._bg_image_apply_token or 0) + 1
                            self._bg_image_fetching = false
                            self:Notification('Fetch timed out for ' .. filename .. ' (20s)', 4)
                        end
                    end)
                    task.spawn(function()
                        local okRead, contents = pcall(readfile, fullPath)
                        if self._bg_image_apply_token ~= myToken then self._bg_image_fetching = false return end
                        if not okRead or type(contents) ~= 'string' or #contents == 0 then
                            self._bg_image_fetching = false
                            self:Notification('Failed to read ' .. filename, 4)
                            return
                        end
                        -- first non-empty, non-whitespace line
                        local url = nil
                        for line in contents:gmatch('[^\r\n]+') do
                            local trimmed = line:match('^%s*(.-)%s*$')
                            if trimmed and #trimmed >= 4 then url = trimmed break end
                        end
                        if not url then
                            self._bg_image_fetching = false
                            self:Notification(filename .. ' has no valid url', 4)
                            return
                        end
                        pcall(notify, 'Photo loading...', 'meoware', 3)
                        local t0 = os.clock()
                        local okLoad, bytes = self:_LoadBgImage(url)
                        self._bg_image_fetching = false
                        if self._bg_image_apply_token ~= myToken then return end
                        if okLoad and bytes then
                            local elapsed = os.clock() - t0
                            self:Notification(string.format('Loaded %s in %.1fs (%d KB)', filename, elapsed, math.floor(#bytes / 1024)), 3)
                            -- yield one frame so notification paints before synchronous draw.Data decode hitch
                            task.wait()
                            if self._bg_image_apply_token ~= myToken then return end
                            -- assign AFTER post-yield token recheck so stale/aborted fetches leave _bg_image_data untouched
                            self._bg_image_data = bytes
                            self._bg_image_enabled = true
                            if options.onBgImageChange then options.onBgImageChange(filename, self._bg_image_alpha) end
                        else
                            local reason = (type(bytes) == 'string' and bytes) or 'unknown error'
                            self:Notification('Fetch failed for ' .. filename .. ' (' .. reason .. ')', 4)
                        end
                    end)
                end)
                settingsRefs.bgImagePhoto = photoDropdown

                settingsRefs.bgImageAlpha = bgSection:Slider('Image opacity', math.floor((self._bg_image_alpha or 1) * 100 + 0.5), 1, 0, 100, '%', function(newValue)
                    self._bg_image_alpha = clamp((tonumber(newValue) or 100) / 100, 0, 1)
                    if options.onBgImageAlphaChange then options.onBgImageAlphaChange(self._bg_image_alpha) end
                end)

                bgSection:Button('Refresh list', function()
                    local updated = listPhotoFiles()
                    local count = #updated
                    if count == 0 then updated = {noFilesLabel} end
                    photoDropdown:UpdateChoices(updated)
                    self:Notification('Found ' .. tostring(count) .. ' file' .. (count == 1 and '' or 's'), 2)
                end)

                bgSection:Button('Clear', function()
                    self._bg_image_apply_token = (self._bg_image_apply_token or 0) + 1
                    self._bg_image_enabled = false
                    self._bg_image_data = nil
                    self._bg_image_url = ''
                    self._draw_data_cache['menu_bg_image'] = nil
                    self:_RemoveDraw('menu_bg_image')
                    if options.onBgImageChange then options.onBgImageChange('', self._bg_image_alpha) end
                    self:Notification('Bg image cleared', 2)
                end)
            end

            local themingSection = nil
            if showTheming then
                themingSection = settingsTab:Section('Theming', 'right')
                if showBackgroundAlpha then
                    settingsRefs.backgroundAlpha = themingSection:Slider('Background opacity', math.floor(self._background_alpha * 100 + 0.5), 1, 5, 100, '%', function(newValue)
                        self._background_alpha = clamp((tonumber(newValue) or 100) / 100, 5/100, 1)
                        if options.onAlphaChange then options.onAlphaChange(self._background_alpha) end
                    end)
                    -- UI cornering
                end
                local themes = {'Catppuccin', 'Gamesense', 'Bloodmoon', 'Seaside', 'Ember', 'Synthwave', 'Matcha', 'Femboy'}
                -- per-theme bg+fg color preview so each dropdown row looks like that theme
                local themePreviewColors = {
                    ['Catppuccin']  = {bg = Color3.fromRGB(17, 17, 27),    fg = Color3.fromRGB(205, 214, 244)},
                    ['Gamesense']   = {bg = Color3.fromRGB(6, 6, 6),       fg = Color3.fromRGB(180, 180, 180)},
                    ['Bloodmoon']   = {bg = Color3.fromRGB(22, 10, 12),    fg = Color3.fromRGB(250, 200, 205)},
                    ['Seaside']     = {bg = Color3.fromRGB(12, 32, 55),    fg = Color3.fromRGB(225, 240, 248)},
                    ['Ember']       = {bg = Color3.fromRGB(22, 14, 10),    fg = Color3.fromRGB(245, 215, 180)},
                    ['Synthwave']   = {bg = Color3.fromRGB(30, 20, 50),    fg = Color3.fromRGB(245, 235, 255)},
                    ['Matcha']      = {bg = Color3.fromRGB(240, 248, 232), fg = Color3.fromRGB(45, 80, 50)},
                    ['Femboy']      = {bg = Color3.fromRGB(254, 247, 252), fg = Color3.fromRGB(60, 35, 85)},
                }
                local themingTextColor, themingBodyColor, themingAccentColor, themingSubtextColor, themingBorder0Color, themingBorder1Color, themingSurface0Color, themingSurface1Color, themingCrustColor
                local glowColorRef
                local themeSnapshot = nil
                local function snapshotTheme()
                    return {
                        text     = self._theming.text,
                        body     = self._theming.body,
                        accent   = self._theming.accent,
                        subtext  = self._theming.subtext,
                        border0  = self._theming.border0,
                        border1  = self._theming.border1,
                        surface0 = self._theming.surface0,
                        surface1 = self._theming.surface1,
                        crust    = self._theming.crust,
                        glow     = self._glow_color,
                    }
                end
                local function restoreSnapshot(snap)
                    if not snap then return end
                    themingTextColor:Set(snap.text)
                    themingBodyColor:Set(snap.body)
                    themingAccentColor:Set(snap.accent)
                    themingSubtextColor:Set(snap.subtext)
                    themingBorder0Color:Set(snap.border0)
                    themingBorder1Color:Set(snap.border1)
                    themingSurface0Color:Set(snap.surface0)
                    themingSurface1Color:Set(snap.surface1)
                    themingCrustColor:Set(snap.crust)
                    if glowColorRef and snap.glow then glowColorRef:Set(snap.glow) end
                end
                local function applyTheme(theme)
                    local gc = glowColorRef
                    if theme == 'Catppuccin' then
                        themingAccentColor:Set(Color3.fromRGB(203, 166, 247))
                        themingBodyColor:Set(Color3.fromRGB(17, 17, 27))
                        themingTextColor:Set(Color3.fromRGB(205, 214, 244))
                        themingSubtextColor:Set(Color3.fromRGB(127, 132, 156))
                        themingBorder1Color:Set(Color3.fromRGB(69, 71, 90))
                        themingBorder0Color:Set(Color3.fromRGB(49, 50, 68))
                        themingSurface1Color:Set(Color3.fromRGB(49, 50, 68))
                        themingSurface0Color:Set(Color3.fromRGB(30, 30, 46))
                        themingCrustColor:Set(Color3.fromRGB(11, 11, 18))
                        if gc then gc:Set(Color3.fromRGB(180, 140, 255)) end
                    elseif theme == 'Gamesense' then
                        themingAccentColor:Set(Color3.fromRGB(114, 178, 21))
                        themingBodyColor:Set(Color3.fromRGB(6, 6, 6))
                        themingTextColor:Set(Color3.fromRGB(180, 180, 180))
                        themingSubtextColor:Set(Color3.fromRGB(80, 80, 80))
                        themingBorder1Color:Set(Color3.fromRGB(60, 60, 60))
                        themingBorder0Color:Set(Color3.fromRGB(40, 40, 40))
                        themingSurface1Color:Set(Color3.fromRGB(30, 30, 30))
                        themingSurface0Color:Set(Color3.fromRGB(18, 18, 18))
                        themingCrustColor:Set(Color3.fromRGB(0, 0, 0))
                        if gc then gc:Set(Color3.fromRGB(90, 200, 0)) end
                    elseif theme == 'Bloodmoon' then
                        themingAccentColor:Set(Color3.fromRGB(235, 28, 52))
                        themingBodyColor:Set(Color3.fromRGB(22, 10, 12))
                        themingTextColor:Set(Color3.fromRGB(250, 200, 205))
                        themingSubtextColor:Set(Color3.fromRGB(180, 95, 105))
                        themingBorder1Color:Set(Color3.fromRGB(125, 30, 45))
                        themingBorder0Color:Set(Color3.fromRGB(78, 20, 28))
                        themingSurface1Color:Set(Color3.fromRGB(70, 22, 32))
                        themingSurface0Color:Set(Color3.fromRGB(42, 15, 20))
                        themingCrustColor:Set(Color3.fromRGB(12, 6, 8))
                        if gc then gc:Set(Color3.fromRGB(255, 30, 60)) end
                    elseif theme == 'Seaside' then
                        themingAccentColor:Set(Color3.fromRGB(64, 195, 200))
                        themingBodyColor:Set(Color3.fromRGB(12, 32, 55))
                        themingTextColor:Set(Color3.fromRGB(225, 240, 248))
                        themingSubtextColor:Set(Color3.fromRGB(115, 160, 185))
                        themingBorder1Color:Set(Color3.fromRGB(40, 95, 125))
                        themingBorder0Color:Set(Color3.fromRGB(25, 60, 90))
                        themingSurface1Color:Set(Color3.fromRGB(32, 72, 105))
                        themingSurface0Color:Set(Color3.fromRGB(18, 45, 72))
                        themingCrustColor:Set(Color3.fromRGB(6, 18, 35))
                        if gc then gc:Set(Color3.fromRGB(50, 220, 230)) end
                    elseif theme == 'Ember' then
                        themingAccentColor:Set(Color3.fromRGB(252, 115, 30))
                        themingBodyColor:Set(Color3.fromRGB(22, 14, 10))
                        themingTextColor:Set(Color3.fromRGB(245, 215, 180))
                        themingSubtextColor:Set(Color3.fromRGB(170, 125, 82))
                        themingBorder1Color:Set(Color3.fromRGB(115, 55, 25))
                        themingBorder0Color:Set(Color3.fromRGB(70, 35, 18))
                        themingSurface1Color:Set(Color3.fromRGB(60, 32, 18))
                        themingSurface0Color:Set(Color3.fromRGB(38, 22, 13))
                        themingCrustColor:Set(Color3.fromRGB(12, 7, 5))
                        if gc then gc:Set(Color3.fromRGB(255, 120, 20)) end
                    elseif theme == 'Synthwave' then
                        themingAccentColor:Set(Color3.fromRGB(255, 60, 180))
                        themingBodyColor:Set(Color3.fromRGB(30, 20, 50))
                        themingTextColor:Set(Color3.fromRGB(245, 235, 255))
                        themingSubtextColor:Set(Color3.fromRGB(155, 115, 200))
                        themingBorder1Color:Set(Color3.fromRGB(110, 60, 165))
                        themingBorder0Color:Set(Color3.fromRGB(70, 40, 115))
                        themingSurface1Color:Set(Color3.fromRGB(60, 35, 110))
                        themingSurface0Color:Set(Color3.fromRGB(40, 25, 75))
                        themingCrustColor:Set(Color3.fromRGB(15, 10, 35))
                        if gc then gc:Set(Color3.fromRGB(255, 50, 200)) end
                    elseif theme == 'Matcha' then
                        themingAccentColor:Set(Color3.fromRGB(127, 176, 105))
                        themingBodyColor:Set(Color3.fromRGB(240, 248, 232))
                        themingTextColor:Set(Color3.fromRGB(45, 80, 50))
                        themingSubtextColor:Set(Color3.fromRGB(115, 150, 110))
                        themingBorder1Color:Set(Color3.fromRGB(175, 210, 165))
                        themingBorder0Color:Set(Color3.fromRGB(200, 225, 190))
                        themingSurface1Color:Set(Color3.fromRGB(220, 238, 208))
                        themingSurface0Color:Set(Color3.fromRGB(232, 244, 220))
                        themingCrustColor:Set(Color3.fromRGB(155, 190, 140))
                        if gc then gc:Set(Color3.fromRGB(100, 190, 80)) end
                    elseif theme == 'Femboy' then
                        themingAccentColor:Set(Color3.fromRGB(200, 50, 120))
                        themingBodyColor:Set(Color3.fromRGB(254, 247, 252))
                        themingTextColor:Set(Color3.fromRGB(60, 35, 85))
                        themingSubtextColor:Set(Color3.fromRGB(125, 95, 155))
                        themingBorder1Color:Set(Color3.fromRGB(220, 180, 215))
                        themingBorder0Color:Set(Color3.fromRGB(235, 200, 225))
                        themingSurface1Color:Set(Color3.fromRGB(245, 215, 235))
                        themingSurface0Color:Set(Color3.fromRGB(250, 230, 240))
                        themingCrustColor:Set(Color3.fromRGB(140, 100, 160))
                        if gc then gc:Set(Color3.fromRGB(220, 60, 140)) end
                    end
                end
                local themingTheme = themingSection:Dropdown('Theme', {themes[1]}, themes, false, function(newValue)
                    if not newValue then return end
                    local theme = newValue[1]
                    applyTheme(theme)
                    themeSnapshot = nil
                    if options.onPresetChange then options.onPresetChange(theme) end
                end, nil, nil, themePreviewColors, function(hoveredTheme)
                    -- hover preview: snapshot first hover, apply hovered theme
                    if not hoveredTheme then return end
                    if not themeSnapshot then themeSnapshot = snapshotTheme() end
                    applyTheme(hoveredTheme)
                end, function()
                    -- cancel: restore snapshot if dismissed without selection
                    if themeSnapshot then
                        restoreSnapshot(themeSnapshot)
                        themeSnapshot = nil
                    end
                end)

                local themingText = themingSection:Toggle('Text color')
                themingTextColor = themingText:AddColorpicker('Text color', self._theming.text, true, function(newValue)
                    self._theming.text = newValue
                    if options.onColorChange then options.onColorChange('text', newValue) end
                end)
                local themingBody = themingSection:Toggle('Body color')
                themingBodyColor = themingBody:AddColorpicker('Body color', self._theming.body, true, function(newValue)
                    self._theming.body = newValue
                    if options.onColorChange then options.onColorChange('body', newValue) end
                end)
                local themingAccent = themingSection:Toggle('Accent color')
                themingAccentColor = themingAccent:AddColorpicker('Accent color', self._theming.accent, true, function(newValue)
                    self._theming.accent = newValue
                    if options.onColorChange then options.onColorChange('accent', newValue) end
                end)
                local themingSubtext = themingSection:Toggle('Subtext color')
                themingSubtextColor = themingSubtext:AddColorpicker('Subtext color', self._theming.subtext, true, function(newValue)
                    self._theming.subtext = newValue
                    if options.onColorChange then options.onColorChange('subtext', newValue) end
                end)
                local themingBorder0 = themingSection:Toggle('Border 0 color')
                themingBorder0Color = themingBorder0:AddColorpicker('Border 0 color', self._theming.border0, true, function(newValue)
                    self._theming.border0 = newValue
                    if options.onColorChange then options.onColorChange('border0', newValue) end
                end)
                local themingBorder1 = themingSection:Toggle('Border 1 color')
                themingBorder1Color = themingBorder1:AddColorpicker('Border 1 color', self._theming.border1, true, function(newValue)
                    self._theming.border1 = newValue
                    if options.onColorChange then options.onColorChange('border1', newValue) end
                end)
                local themingSurface0 = themingSection:Toggle('Surface 0 color')
                themingSurface0Color = themingSurface0:AddColorpicker('Surface 0 color', self._theming.surface0, true, function(newValue)
                    self._theming.surface0 = newValue
                    if options.onColorChange then options.onColorChange('surface0', newValue) end
                end)
                local themingSurface1 = themingSection:Toggle('Surface 1 color')
                themingSurface1Color = themingSurface1:AddColorpicker('Surface 1 color', self._theming.surface1, true, function(newValue)
                    self._theming.surface1 = newValue
                    if options.onColorChange then options.onColorChange('surface1', newValue) end
                end)
                local themingCrust = themingSection:Toggle('Crust color')
                themingCrustColor = themingCrust:AddColorpicker('Crust color', self._theming.crust, true, function(newValue)
                    self._theming.crust = newValue
                    if options.onColorChange then options.onColorChange('crust', newValue) end
                end)

                -- font family picker, previews each choice in its own font
                local fontPreviewMap = {}
                for _, fontName in ipairs(self._font_list) do
                    fontPreviewMap[fontName] = self._font_face_by_name[fontName]
                end
                local themingFont = themingSection:Dropdown('Font', {self._font_name}, self._font_list, false, function(newValue)
                    if type(newValue) ~= 'table' or not newValue[1] then return end
                    local faceName = newValue[1]
                    local face = self._font_face_by_name[faceName]
                    if face then
                        self._font_face = face
                        self._font_name = faceName
                    end
                    if options.onFontChange then options.onFontChange(faceName) end
                end, 'font family used across the ui', fontPreviewMap)

                local themingOutline = themingSection:Toggle('Text outline', self._text_outline_enabled, function(newValue)
                    self._text_outline_enabled = newValue == true
                    if options.onOutlineChange then options.onOutlineChange(self._text_outline_enabled) end
                end, false, 'dark outline behind all library text for readability')

                -- glow settings (left column)
                local glowSection = settingsTab:Section('Glow', 'left')
                local glowToggle = glowSection:Toggle('Glow', self._glow_enabled, function(newValue)
                    self._glow_enabled = newValue
                end)
                glowColorRef = glowToggle:AddColorpicker('Glow color', self._glow_color or self._theming.accent, false, function(newValue)
                    self._glow_color = newValue
                end)

                -- mode select sits right under the toggle
                local glowSIntensity, glowSRadius
                local glowBSpeed, glowBIntensity, glowBRadius
                local glowRWorm, glowRSpeed, glowRRadius, glowRIntensity

                -- forward decl for dynamic-visibility sliders
                local function updateGlowSliderVisibility(mode)
                    local isS = mode == 'Static'
                    local isB = mode == 'Breathe'
                    local isR = mode == 'Rotate'
                    glowSIntensity:SetHidden(not isS)
                    glowSRadius:SetHidden(not isS)
                    glowBSpeed:SetHidden(not isB)
                    glowBIntensity:SetHidden(not isB)
                    glowBRadius:SetHidden(not isB)
                    glowRWorm:SetHidden(not isR)
                    glowRSpeed:SetHidden(not isR)
                    glowRRadius:SetHidden(not isR)
                    glowRIntensity:SetHidden(not isR)
                end

                glowSection:Dropdown('Glow animation', {self._glow_mode}, {'Static', 'Breathe', 'Rotate'}, false, function(newValue)
                    if newValue and newValue[1] then
                        self._glow_mode = newValue[1]
                        updateGlowSliderVisibility(newValue[1])
                    end
                end)

                -- per-mode sliders (hidden/shown on mode change)
                glowSIntensity = glowSection:Slider('Intensity', self._glow_s_intensity, 1, 1, 100, '%', function(v) self._glow_s_intensity = v end)
                glowSRadius = glowSection:Slider('Radius', self._glow_s_radius, 1, 1, 20, 'px', function(v) self._glow_s_radius = v end)
                glowBSpeed = glowSection:Slider('Speed', self._glow_b_speed, 1, 1, 5, 's', function(v) self._glow_b_speed = v end)
                glowBIntensity = glowSection:Slider('Max intensity', self._glow_b_intensity, 1, 1, 100, '%', function(v) self._glow_b_intensity = v end)
                glowBRadius = glowSection:Slider('Max radius', self._glow_b_radius, 1, 1, 20, 'px', function(v) self._glow_b_radius = v end)
                glowRWorm = glowSection:Slider('Worm size', self._glow_r_worm, 1, 10, 100, '%', function(v) self._glow_r_worm = v end)
                glowRSpeed = glowSection:Slider('Speed', self._glow_r_speed, 1, 1, 10, '', function(v) self._glow_r_speed = v end)
                glowRRadius = glowSection:Slider('Glow radius', self._glow_r_radius, 1, 1, 20, 'px', function(v) self._glow_r_radius = v end)
                glowRIntensity = glowSection:Slider('Worm glow intensity', self._glow_r_intensity, 1, 1, 100, '%', function(v) self._glow_r_intensity = v end)

                updateGlowSliderVisibility(self._glow_mode)

                settingsRefs.font = themingFont
                settingsRefs.theme = themingTheme
                settingsRefs.textOutline = themingOutline
                settingsRefs.themingColors = {
                    text     = themingTextColor,
                    body     = themingBodyColor,
                    accent   = themingAccentColor,
                    subtext  = themingSubtextColor,
                    border0  = themingBorder0Color,
                    border1  = themingBorder1Color,
                    surface0 = themingSurface0Color,
                    surface1 = themingSurface1Color,
                    crust    = themingCrustColor,
                }
                -- no themingTheme:Set here; dropdown already shows Catppuccin and
                -- self._theming is already seeded with Catppuccin defaults. firing
                -- :Set would stomp consumer-restored config via the callback chain
            end
            -- cache refs so CreateSettingsTab re-entry returns the same objects
            self._settings_tab_ref = settingsTab
            self._settings_menu_section_ref = menuSection
            self._settings_theming_section_ref = themingSection
            self._settings_item_refs = settingsRefs
            return settingsTab, menuSection, themingSection, settingsRefs
        end

        -- stub: activity registry dropped in v2, preserved for api compat
        function UILib:RegisterActivity(_activity)
            return { Remove = function(_) end }
        end

        function UILib:Unload()
            self:_RemoveDrawStartsWith('')
            -- full state reset so library can be re-used safely without ghost state
            self._tree = {}
            self._tab_order = {}
            self._open_tab = nil
            self._notifications = {}
            self._notifications_spawned = 0
            self._slider_drag = nil
            self._range_slider_drag = nil
            self._range_slider_handle = nil
            self._menu_drag = nil
            self._input_ctx = nil
            self._button_held = nil
            self._active_dropdown = nil
            self._active_colorpicker = nil
            self._indicator_enabled = false
            self._indicator_drag = nil
            self._indicator_drag_origin = nil
            self._indicator_drag_end_cb = nil
            self._menu_open = true
            self._menu_toggled_at = 0
            self._menu_fade_done = false
            self._menu_fade_start_opacity = nil
            self._section_fade_done = false
            self._custom_title_enabled = false
            self._custom_title = ''
            self._settings_tab_created = false
            self._settings_tab_ref = nil
            self._settings_menu_section_ref = nil
            self._settings_theming_section_ref = nil
            self._settings_item_refs = nil
            self._anim_state = {}
            self._base_alpha = {}
            self._draw_data_cache = {}
            -- bg image state: release multi-MB bytes + reset flags per Unload contract
            self._bg_image_enabled = false
            self._bg_image_data = nil
            self._bg_image_url = ''
            self._bg_image_alpha = 1.0
            self._bg_image_apply_token = 0
            self._bg_image_fetching = false
            self._bg_image_subsystem_dead = false
            self._glow_last_mode = nil
            self._glow_rot_count = 0
            self._last_cleared_inactive_for = nil
            self._last_step_at = 0
            self._frame_dt = 16/1000
            -- user-configurable state reset so reload loaders don't carry ghost values
            self._copied_color = nil
            self._overwrite_menu_key = false
            self._menu_key = 'f1'
            self._watermark_enabled = true
            self._menu_fade_mul = nil
            self._background_alpha = 92/100
            self._glow_enabled = false
            self._glow_color = nil
            self._glow_mode = 'Static'
            self._glow_s_intensity = 50
            self._glow_s_radius = 10
            self._glow_s_smooth = 15
            self._glow_b_speed = 2
            self._glow_b_intensity = 70
            self._glow_b_radius = 14
            self._glow_b_smooth = 15
            self._glow_r_worm = 40
            self._glow_r_speed = 3
            self._glow_r_radius = 9
            self._glow_r_intensity = 50
            self._font_face = Drawing.Fonts.UI
            self._font_name = 'UI'
            self._font_size = 13
            self._text_outline_enabled = false
            self._theming = {
                accent   = Color3.fromRGB(203, 166, 247),
                unsafe   = Color3.fromRGB(255, 215, 64),
                body     = Color3.fromRGB(17, 17, 27),
                text     = Color3.fromRGB(205, 214, 244),
                subtext  = Color3.fromRGB(127, 132, 156),
                border1  = Color3.fromRGB(69, 71, 90),
                border0  = Color3.fromRGB(49, 50, 68),
                surface1 = Color3.fromRGB(49, 50, 68),
                surface0 = Color3.fromRGB(30, 30, 46),
                crust    = Color3.fromRGB(11, 11, 18),
            }
            setrobloxinput(true)
        end

        function UILib:Step()
            local menuTitle = tostring(self._custom_title_enabled and self._custom_title or self.title or 'UILib')
            local stepNow = os.clock()
            if self._last_step_at == 0 then
                self._frame_dt = 16/1000
            else
                self._frame_dt = clamp(stepNow - self._last_step_at, 0, 0.05)
            end
            self._last_step_at = stepNow

            -- compute fade multiplier once per frame (used inline by _SetOpacity)
            local menuOpacityEarly = self:_ResolveMenuFadeOpacity()
            self._menu_fade_mul = menuOpacityEarly

            -- input processing
            setrobloxinput(menuOpacityEarly <= 0.001)
            for keycode, inputData in pairs(self._inputs) do
                local interacted = iskeypressed(inputData.id)
                if isrbxactive() and interacted then
                    if inputData.held == false and inputData.click == false then
                        self._inputs[keycode].click = true
                    else
                        self._inputs[keycode].click = false
                    end
                    self._inputs[keycode].held = true
                else
                    self._inputs[keycode].click = false
                    self._inputs[keycode].held = false
                end
            end

            local clickFrame = self:_IsKeyPressed('m1')
            local mouseHeld = self:_IsKeyHeld('m1')
            local ctxFrame = self:_IsKeyPressed('m2')
            local resolvedMenuKey = (self._overwrite_menu_key and self._menu_key) or 'f1'
            if not self._inputs[resolvedMenuKey] then resolvedMenuKey = 'f1' end
            local menuKeyPressed = self:_IsKeyPressed(resolvedMenuKey)

            if menuKeyPressed then
                local currentOpacity = self:_ResolveMenuFadeOpacity()
                self._menu_fade_start_opacity = currentOpacity
                self._menu_open = not self._menu_open
                self._menu_toggled_at = os.clock()
                self._menu_fade_done = false
            end
            -- refresh multiplier after toggle (state changed)
            local menuOpacityRefresh = self:_ResolveMenuFadeOpacity()
            self._menu_fade_mul = menuOpacityRefresh
            setrobloxinput(menuOpacityRefresh <= 0.001)

            -- watermark (glass pill)
            local watermarkPos = Vector2.new(20, 20)
            local watermarkContent = menuTitle
            local watermarkTextSize = self:_GetTextBounds(watermarkContent)
            local watermarkSize = Vector2.new(watermarkTextSize.x + self._padding * 2 + 14, watermarkTextSize.y + self._padding + 2)
            if self._watermark_enabled then
                -- body
                self:_Draw('watermark_body', 'rect', self._theming.body, 100, watermarkPos, watermarkSize, true)
                self:_SetOpacity('watermark_body', clamp(self._background_alpha + 0.02, 5/100, 1))
                -- outer crust
                self:_Draw('watermark_crust', 'rect', self._theming.crust, 101, watermarkPos, watermarkSize, false)
                -- inner border
                self:_Draw('watermark_border', 'rect', self._theming.border1, 101, watermarkPos + Vector2.new(1, 1), watermarkSize - Vector2.new(2, 2), false)
                local watermarkDotCenter = watermarkPos + Vector2.new(self._padding + 1, watermarkSize.y / 2 + 1)
                self:_Draw('watermark_dot_ring', 'circle', self._theming.border1, 102, watermarkDotCenter, 5, false, 1, 18)
                self:_Draw('watermark_dot', 'circle', self._theming.accent, 103, watermarkDotCenter, 2, true, 1, 18)
                -- text
                self:_Draw('watermark_text', 'text', self._theming.text, 103, watermarkPos + Vector2.new(self._padding + 12, self._padding/2), watermarkContent, true)
            else
                self:_UndrawStartsWith('watermark_')
            end

            -- screen-locked status indicator pill (theme-colored, draggable)
            if self._indicator_enabled then
                local indLabel = self._indicator_label ~= '' and self._indicator_label or 'STATUS'
                local indActive = self._indicator_active
                local indTextSize = self:_GetTextBounds(indLabel, nil, 13)
                local indW = indTextSize.x + self._padding * 2 + 14
                local indH = indTextSize.y + self._padding + 2
                local indScreen = self:_GetScreenSize()
                local indMaxX = indScreen.x - indW
                local indMaxY = indScreen.y - indH

                -- resolve position: saved (clamped to current screen) or default top-center
                local indPos
                if self._indicator_pos then
                    indPos = Vector2.new(
                        clamp(self._indicator_pos.x, 0, indMaxX),
                        clamp(self._indicator_pos.y, 0, indMaxY)
                    )
                else
                    indPos = Vector2.new(math.floor(indMaxX / 2), 8)
                end

                -- drag handling (start when clicked inside, no other drag active)
                local indMousePos = self:_GetMousePos()
                local indMouseHeld = self:_IsKeyHeld('m1')
                local indClickFrame = self:_IsKeyPressed('m1')
                if indClickFrame and not self._indicator_drag and not self._menu_drag and not self._slider_drag and not self._range_slider_drag
                   and self:_IsMouseWithinBounds(indPos, Vector2.new(indW, indH)) then
                    -- cache start pos so drag-end can detect a real move vs a bare click
                    self._indicator_drag = Vector2.new(indMousePos.x - indPos.x, indMousePos.y - indPos.y)
                    self._indicator_drag_origin = indPos
                end
                if indMouseHeld and self._indicator_drag then
                    local nx = clamp(indMousePos.x - self._indicator_drag.x, 0, indMaxX)
                    local ny = clamp(indMousePos.y - self._indicator_drag.y, 0, indMaxY)
                    self._indicator_pos = Vector2.new(nx, ny)
                    indPos = self._indicator_pos
                elseif self._indicator_drag and not indMouseHeld then
                    local origin = self._indicator_drag_origin
                    self._indicator_drag = nil
                    self._indicator_drag_origin = nil
                    -- only fire callback if the pill actually moved
                    if self._indicator_drag_end_cb and self._indicator_pos and origin
                       and (self._indicator_pos.x ~= origin.x or self._indicator_pos.y ~= origin.y) then
                        pcall(self._indicator_drag_end_cb, self._indicator_pos)
                    end
                end

                local indBorderCol = indActive and self._theming.accent or self._theming.border1
                local indDotCol    = indActive and self._theming.accent or self._theming.subtext
                local indTextCol   = indActive and self._theming.text   or self._theming.subtext
                -- body
                self:_Draw('indicator_body', 'rect', self._theming.body, 105, indPos, Vector2.new(indW, indH), true)
                self:_SetOpacity('indicator_body', clamp(self._background_alpha + 0.02, 5/100, 1))
                -- outer crust
                self:_Draw('indicator_crust', 'rect', self._theming.crust, 106, indPos, Vector2.new(indW, indH), false)
                -- inner border (state-colored)
                self:_Draw('indicator_border', 'rect', indBorderCol, 106, indPos + Vector2.new(1, 1), Vector2.new(indW, indH) - Vector2.new(2, 2), false)
                -- state dot
                local indDotCenter = indPos + Vector2.new(self._padding + 1, indH / 2 + 1)
                self:_Draw('indicator_dot_ring', 'circle', self._theming.border1, 107, indDotCenter, 5, false, 1, 18)
                self:_Draw('indicator_dot', 'circle', indDotCol, 108, indDotCenter, 2, true, 1, 18)
                -- label
                self:_Draw('indicator_text', 'text', indTextCol, 108, indPos + Vector2.new(self._padding + 12, self._padding/2), indLabel, true, nil, 13)
            else
                self:_UndrawStartsWith('indicator_')
                self._indicator_drag = nil
                self._indicator_drag_origin = nil
            end

            -- notifications (glass cards, stacked)
            local notificationsOrigin = watermarkPos + (self._watermark_enabled and Vector2.new(0, watermarkSize.y + self._padding) or Vector2.new(0, 0))
            local totalNotificationsHeight = 0
            local notifIdx = 1
            while notifIdx <= #self._notifications do
                local notification = self._notifications[notifIdx]
                local shouldFade = os.clock() > notification._spawned_at + notification.time
                local notificationText = notification.text
                local notificationTextSize = self:_GetTextBounds(notificationText)

                local t = math.max(0, math.min(notification._spawned_at - os.clock() + (shouldFade and notification.time + 1 or 1), 1))
                local notificationFade = math.abs((shouldFade and 0 or 1) - (t * t * (3 - 2 * t)))

                local notificationDrawId = 'notification_' .. notification._id
                local notificationSize = Vector2.new(notificationTextSize.x + self._padding * 2 + 8, notificationTextSize.y + self._padding + 4)
                local notificationOrigin = notificationsOrigin + Vector2.new((-notificationSize.x - 50) * (1 - notificationFade), totalNotificationsHeight)

                local progressPercent = math.min((os.clock() - notification._spawned_at)/notification.time, 1)

                -- body glass
                self:_Draw(notificationDrawId .. '_body', 'rect', self._theming.body, 100, notificationOrigin, notificationSize, true)
                -- accent stripe left
                self:_Draw(notificationDrawId .. '_accent', 'rect', self._theming.accent, 102, notificationOrigin, Vector2.new(3, notificationSize.y), true)
                -- outer crust
                self:_Draw(notificationDrawId .. '_crust', 'rect', self._theming.crust, 101, notificationOrigin, notificationSize, false)
                -- inner border
                self:_Draw(notificationDrawId .. '_border', 'rect', self._theming.border1, 101, notificationOrigin + Vector2.new(1, 1), notificationSize - Vector2.new(2, 2), false)
                -- progress bar bottom
                self:_Draw(notificationDrawId .. '_progress', 'rect', self._theming.accent, 103, notificationOrigin + Vector2.new(3, notificationSize.y - 2), Vector2.new((notificationSize.x - 5) * progressPercent, 2), true)
                -- text
                self:_Draw(notificationDrawId .. '_text', 'text', self._theming.text, 103, notificationOrigin + Vector2.new(self._padding + 6, self._padding/2 + 1), notificationText, true)
                self:_SetOpacityStartsWith(notificationDrawId, notificationFade)
                -- re-apply glass body alpha on top of fade
                self:_SetOpacity(notificationDrawId .. '_body', clamp(self._background_alpha + 0.03, 5/100, 1) * notificationFade)

                totalNotificationsHeight = totalNotificationsHeight + (notificationTextSize.y + self._padding * 2 + 6) * notificationFade

                if os.clock() - 1 > notification._spawned_at + notification.time then
                    self:_RemoveDrawStartsWith(notificationDrawId)
                    table.remove(self._notifications, notifIdx)
                else
                    notifIdx = notifIdx + 1
                end
            end

            if self._menu_open then
                -- keep menu on-screen even if window was resized while closed
                local ssGuard = self:_GetScreenSize()
                if self.x < -self.w + 60 then self.x = -self.w + 60 end
                if self.x > ssGuard.x - 60 then self.x = ssGuard.x - 60 end
                if self.y < 0 then self.y = 0 end
                if self.y > ssGuard.y - self._topbar_h then self.y = ssGuard.y - self._topbar_h end

                -- drag
                if mouseHeld and self._menu_drag then
                    local mousePos = self:_GetMousePos()
                    local ss = self:_GetScreenSize()
                    self.x = clamp(mousePos.x - self._menu_drag.x, -self.w + 60, ss.x - 60)
                    self.y = clamp(mousePos.y - self._menu_drag.y, 0, ss.y - self._topbar_h)
                else
                    self._menu_drag = nil
                end

                -- esc closes open popups
                if self:_IsKeyPressed('esc') then
                    if self._active_dropdown then
                        if self._active_dropdown._cancelCallback then self._active_dropdown._cancelCallback() end
                        self:_RemoveDropdown()
                    end
                    if self._active_colorpicker then
                        self:_RemoveColorpicker()
                    end
                end

                -- active dropdown popup
                local dropdown = self._active_dropdown
                if dropdown then
                    local dropdownFade = 1 - (dropdown._spawned_at - (os.clock() - 0.25)) / 0.25

                    -- cap visible items to keep popup reasonable
                    local maxVisible = 10
                    local totalChoices = #dropdown.choices
                    local pageOffset = dropdown._page_offset or 0
                    if pageOffset >= totalChoices or pageOffset < 0 then pageOffset = 0 end
                    dropdown._page_offset = pageOffset
                    local visibleChoices = math.min(totalChoices - pageOffset, maxVisible)
                    local hasMorePages = totalChoices > maxVisible

                    -- clamp popup to screen
                    local screenSize = self:_GetScreenSize()
                    local estimatedH = visibleChoices * (self._font_size + self._padding) + self._padding * 2 + (hasMorePages and (self._font_size + self._padding) or 0)
                    local estimatedW = dropdown.width + self._padding * 2
                    local clampedX = math.min(dropdown.position.x, screenSize.x - estimatedW - 4)
                    local clampedY = math.min(dropdown.position.y, screenSize.y - estimatedH - 4)
                    if clampedX < 4 then clampedX = 4 end
                    if clampedY < 4 then clampedY = 4 end
                    dropdown.position = Vector2.new(clampedX, clampedY)

                    local shouldCancel = true
                    local dropdownOrigin = dropdown.position
                    local totalHeight = self._padding
                    local currentHover = nil
                    for i = 1, visibleChoices do
                        local choice = dropdown.choices[pageOffset + i]
                        local choiceFoundIndex = table.find(dropdown.value, choice)
                        local choiceFont = dropdown.previewFonts and dropdown.previewFonts[choice] or nil
                        local choicePreview = dropdown.previewColors and dropdown.previewColors[choice] or nil
                        local labelSize = self:_GetTextBounds(choice, choiceFont)
                        local choiceOrigin = Vector2.new(dropdownOrigin.x + self._padding, dropdownOrigin.y + totalHeight)
                        local choiceSize = Vector2.new(dropdown.width, labelSize.y)
                        -- expand hit area to include the padding gap for easier clicking
                        local choiceHitOrigin = Vector2.new(choiceOrigin.x - 4, choiceOrigin.y - self._padding/2)
                        local choiceHitSize = Vector2.new(choiceSize.x + 8, choiceSize.y + self._padding)

                        local isHoveringChoice = self:_IsMouseWithinBounds(choiceHitOrigin, choiceHitSize)
                        if isHoveringChoice then currentHover = choice end
                        if isHoveringChoice and clickFrame then
                            shouldCancel = not dropdown.multi
                            if dropdown.multi then
                                if choiceFoundIndex then
                                    table.remove(dropdown.value, choiceFoundIndex)
                                else
                                    table.insert(dropdown.value, choice)
                                end
                            else
                                dropdown.value = {choice}
                            end
                            dropdown._committed = true
                            if dropdown.callback then dropdown.callback(dropdown.value) end
                        end

                        local choiceColor
                        if choicePreview then
                            -- preview mode: paint row with theme's own bg and use theme's text color
                            self:_Draw('dropdown_preview_' .. tostring(i), 'rect', choicePreview.bg, 901, choiceHitOrigin, choiceHitSize, true)
                            if isHoveringChoice or choiceFoundIndex then
                                self:_Draw('dropdown_preview_brd_' .. tostring(i), 'rect', self._theming.accent, 902, choiceHitOrigin, choiceHitSize, false)
                            else
                                self:_Undraw('dropdown_preview_brd_' .. tostring(i))
                            end
                            choiceColor = choicePreview.fg
                        else
                            self:_Undraw('dropdown_preview_' .. tostring(i))
                            self:_Undraw('dropdown_preview_brd_' .. tostring(i))
                            if choiceFoundIndex then
                                choiceColor = self._theming.accent
                            elseif isHoveringChoice then
                                choiceColor = self._theming.text
                            else
                                choiceColor = self._theming.subtext
                            end
                        end
                        local truncChoice = self:_TruncateText(choice, dropdown.width - 4, choiceFont)
                        self:_Draw('dropdown_choice_' .. tostring(i), 'text', choiceColor, 903, choiceOrigin, truncChoice, true, 'left', nil, choiceFont)

                        -- thin left accent line for selected rows
                        if choiceFoundIndex then
                            local selLinePos = Vector2.new(choiceHitOrigin.x + 1, choiceHitOrigin.y + 2)
                            local selLineSize = Vector2.new(1, choiceHitSize.y - 4)
                            self:_Draw('dropdown_sel_line_' .. tostring(i), 'rect', choiceColor, 904, selLinePos, selLineSize, true)
                        else
                            self:_Undraw('dropdown_sel_line_' .. tostring(i))
                        end

                        totalHeight = totalHeight + labelSize.y + self._padding
                    end

                    -- pager: click to advance to next page; on last page, click wraps back to first
                    if hasMorePages then
                        local visibleEnd = pageOffset + visibleChoices
                        local hasNext = visibleEnd < totalChoices
                        local remaining = totalChoices - visibleEnd
                        local moreText = hasNext
                            and ('next ' .. tostring(math.min(maxVisible, remaining)) .. ' →')
                            or '← back to start'
                        local moreOrigin = Vector2.new(dropdownOrigin.x + self._padding, dropdownOrigin.y + totalHeight)
                        local moreSize = self:_GetTextBounds(moreText, nil, 11)
                        local moreHitOrigin = Vector2.new(moreOrigin.x - 4, moreOrigin.y - self._padding/2)
                        local moreHitSize = Vector2.new(dropdown.width + 8, moreSize.y + self._padding)
                        local isHoveringMore = self:_IsMouseWithinBounds(moreHitOrigin, moreHitSize)
                        local moreColor = isHoveringMore and self._theming.text or self._theming.subtext
                        self:_Draw('dropdown_more', 'text', moreColor, 902, moreOrigin, moreText, true, 'left', 11)
                        if isHoveringMore and clickFrame then
                            dropdown._page_offset = hasNext and visibleEnd or 0
                            shouldCancel = false
                            clickFrame = false
                        end
                        totalHeight = totalHeight + self._font_size + self._padding
                    else
                        self:_Undraw('dropdown_more')
                    end

                    -- cleanup stale choice drawings from larger previous lists
                    for i = visibleChoices + 1, visibleChoices + 30 do
                        self:_Undraw('dropdown_choice_' .. tostring(i))
                        self:_Undraw('dropdown_preview_' .. tostring(i))
                        self:_Undraw('dropdown_preview_brd_' .. tostring(i))
                        self:_Undraw('dropdown_sel_line_' .. tostring(i))
                    end

                    local popSize = Vector2.new(dropdown.width + self._padding * 2, totalHeight)
                    -- body
                    self:_Draw('dropdown_body', 'rect', self._theming.body, 900, dropdownOrigin, popSize, true)
                    -- crust and border
                    self:_Draw('dropdown_crust', 'rect', self._theming.crust, 901, dropdownOrigin, popSize, false)
                    self:_Draw('dropdown_border', 'rect', self._theming.border1, 901, dropdownOrigin + Vector2.new(1, 1), popSize - Vector2.new(2, 2), false)
                    local dropdownFadeAlpha = clamp(dropdownFade, 0, 1)
                    self:_SetOpacityStartsWith('dropdown_', dropdownFadeAlpha)
                    self:_SetOpacity('dropdown_body', clamp(self._background_alpha + 0.03, 5/100, 1) * dropdownFadeAlpha)

                    -- fire hover callback when the hovered row changes
                    if currentHover ~= dropdown._last_hover then
                        dropdown._last_hover = currentHover
                        if dropdown._hoverCallback then dropdown._hoverCallback(currentHover) end
                    end

                    if clickFrame and shouldCancel then
                        if not dropdown._committed and dropdown._cancelCallback then
                            dropdown._cancelCallback()
                        end
                        self:_RemoveDropdown()
                    end
                    clickFrame = false
                end

                -- active colorpicker popup
                local colorpicker = self._active_colorpicker
                if colorpicker then
                    local colorpickerFade = 1 - (colorpicker._spawned_at - (os.clock() - 0.25)) / 0.25

                    -- clamp popup to screen
                    local cpScreenSize = self:_GetScreenSize()
                    local cpW, cpH = 220, 220
                    local cpX = math.min(colorpicker.position.x, cpScreenSize.x - cpW - 4)
                    local cpY = math.min(colorpicker.position.y, cpScreenSize.y - cpH - 4)
                    if cpX < 4 then cpX = 4 end
                    if cpY < 4 then cpY = 4 end
                    colorpicker.position = Vector2.new(cpX, cpY)

                    local shouldCancel = true
                    local colorpickerSize = Vector2.new(cpW, cpH)
                    local colorpickerOrigin = colorpicker.position
                    local colorpickerTitle = tostring(colorpicker.label or 'Color')
                    local colorpickerTitleSize = self:_GetTextBounds(colorpickerTitle)

                    -- body glass
                    self:_Draw('colorpicker_body', 'rect', self._theming.body, 900, colorpickerOrigin, colorpickerSize, true)
                    self:_Draw('colorpicker_crust', 'rect', self._theming.crust, 901, colorpickerOrigin, colorpickerSize, false)
                    self:_Draw('colorpicker_border', 'rect', self._theming.border1, 901, colorpickerOrigin + Vector2.new(1, 1), colorpickerSize - Vector2.new(2, 2), false)
                    self:_Draw('colorpicker_title', 'text', self._theming.text, 902, colorpickerOrigin + Vector2.new(self._padding, self._padding/2 + 2), colorpickerTitle, true)

                    local palleteContentPos = colorpickerOrigin + Vector2.new(self._padding, self._padding + colorpickerTitleSize.y + 6)
                    local palleteContentSize = colorpickerSize - Vector2.new(self._padding * 2, self._padding * 2 + colorpickerTitleSize.y + 6)

                    local mousePos = self:_GetMousePos()
                    local palleteSize = palleteContentSize
                    local hueSize = Vector2.new(palleteSize.x, 10)
                    palleteSize = palleteSize - Vector2.new(0, hueSize.y + self._padding)
                    local palletePos = palleteContentPos
                    local huePos = palletePos + Vector2.new(0, palleteSize.y + self._padding)

                    -- drag state machine: once started, continues until mouse released even when outside bounds
                    if not mouseHeld then
                        colorpicker._drag_target = nil
                    end
                    if mouseHeld and not colorpicker._drag_target then
                        if self:_IsMouseWithinBounds(huePos, hueSize) then
                            colorpicker._drag_target = 'hue'
                        elseif self:_IsMouseWithinBounds(palletePos, palleteSize) then
                            colorpicker._drag_target = 'palette'
                        end
                    end
                    if colorpicker._drag_target == 'hue' and mouseHeld then
                        local cx = clamp((mousePos.x - huePos.x) / hueSize.x, 0, 0.9999)
                        colorpicker._h = cx
                        shouldCancel = false
                    elseif colorpicker._drag_target == 'palette' and mouseHeld then
                        local sx = clamp((mousePos.x - palletePos.x) / palleteSize.x, 0, 1)
                        local vy = clamp((mousePos.y - palletePos.y) / palleteSize.y, 0, 1)
                        colorpicker._s = sx
                        colorpicker._v = 1 - vy
                        shouldCancel = false
                    end
                    -- also treat any click within the popup body as a non-cancel
                    if self:_IsMouseWithinBounds(colorpickerOrigin, colorpickerSize) then
                        shouldCancel = false
                    end

                    -- only apply opacity during fade-in (matches the v1 working colorpicker pattern).
                    -- after fade completes each draw keeps its own last-set alpha: gradient segments
                    -- retain their per-segment targetAlpha (set inside _Draw), non-gradient draws stay
                    -- at the final fade value (~= 1). per-frame overriding races with Matcha's drawing
                    -- backend and causes an intermittent black flash over the SV palette.
                    if colorpickerFade < 1.1 then
                        local colorpickerFadeAlpha = clamp(colorpickerFade, 0, 1)
                        self:_SetOpacityStartsWith('colorpicker_', colorpickerFadeAlpha)
                        self:_SetOpacity('colorpicker_body', clamp(self._background_alpha + 0.03, 5/100, 1) * colorpickerFadeAlpha)
                    end

                    local hueColor = Color3.fromHSV(colorpicker._h, 1, 1)
                    self:_Draw('colorpicker_pallete_color', 'gradient', nil, 903, 'horizontal', palletePos, palleteSize, Color3.fromRGB(255, 255, 255), hueColor)
                    self:_Draw('colorpicker_pallete_fade', 'gradient', nil, 904, 'vertical', palletePos, palleteSize, {R=0, G=0, B=0, A=0}, {R=0, G=0, B=0, A=1})
                    self:_Draw('colorpicker_pallete_hue', 'gradient', nil, 903, 'horizontal', huePos, hueSize,
                        Color3.fromRGB(255, 0, 0),
                        Color3.fromRGB(255, 255, 0),
                        Color3.fromRGB(0, 255, 0),
                        Color3.fromRGB(0, 255, 255),
                        Color3.fromRGB(0, 0, 255),
                        Color3.fromRGB(255, 0, 255),
                        Color3.fromRGB(255, 0, 0)
                    )

                    local newColor = Color3.fromHSV(colorpicker._h, colorpicker._s, colorpicker._v)
                    -- only fire callback if color actually changed (avoids per-frame callback spam)
                    local lc = colorpicker._last_color
                    if not lc or lc.R ~= newColor.R or lc.G ~= newColor.G or lc.B ~= newColor.B then
                        colorpicker._last_color = newColor
                        if colorpicker.callback then colorpicker.callback(newColor) end
                    end

                    -- palette cursor (small crosshair: outer + inner squares), clamped to stay on-palette
                    local cursorX = palletePos.x + palleteSize.x * colorpicker._s - 3
                    local cursorY = palletePos.y + palleteSize.y * (1 - colorpicker._v) - 3
                    if cursorX < palletePos.x then cursorX = palletePos.x end
                    if cursorX > palletePos.x + palleteSize.x - 6 then cursorX = palletePos.x + palleteSize.x - 6 end
                    if cursorY < palletePos.y then cursorY = palletePos.y end
                    if cursorY > palletePos.y + palleteSize.y - 6 then cursorY = palletePos.y + palleteSize.y - 6 end
                    self:_Draw('colorpicker_palette_cursor_out', 'rect', Color3.fromRGB(0, 0, 0), 912, Vector2.new(cursorX, cursorY), Vector2.new(6, 6), false)
                    self:_Draw('colorpicker_palette_cursor_in', 'rect', Color3.fromRGB(255, 255, 255), 913, Vector2.new(cursorX + 1, cursorY + 1), Vector2.new(4, 4), false)

                    -- hue bar marker (thin vertical line), clamped to bar bounds
                    local hueCursorX = huePos.x + hueSize.x * colorpicker._h
                    if hueCursorX < huePos.x + 1 then hueCursorX = huePos.x + 1 end
                    if hueCursorX > huePos.x + hueSize.x - 1 then hueCursorX = huePos.x + hueSize.x - 1 end
                    self:_Draw('colorpicker_hue_cursor_out', 'rect', Color3.fromRGB(0, 0, 0), 912, Vector2.new(hueCursorX - 1, huePos.y - 1), Vector2.new(3, hueSize.y + 2), false)
                    self:_Draw('colorpicker_hue_cursor_in', 'rect', Color3.fromRGB(255, 255, 255), 913, Vector2.new(hueCursorX, huePos.y), Vector2.new(1, hueSize.y), true)

                    -- current color preview swatch (top-right of popup)
                    local previewSize = Vector2.new(24, colorpickerTitleSize.y + 2)
                    local previewPos = Vector2.new(colorpickerOrigin.x + colorpickerSize.x - previewSize.x - self._padding, colorpickerOrigin.y + self._padding - 1)
                    self:_Draw('colorpicker_preview', 'rect', newColor, 904, previewPos, previewSize, true)
                    self:_Draw('colorpicker_preview_border', 'rect', self._theming.crust, 905, previewPos, previewSize, false)

                    -- hex code below preview
                    local hex = string.format('#%02X%02X%02X', math.floor(newColor.R * 255 + 0.5), math.floor(newColor.G * 255 + 0.5), math.floor(newColor.B * 255 + 0.5))
                    local hexSize = self:_GetTextBounds(hex, nil, 11)
                    self:_Draw('colorpicker_hex', 'text', self._theming.subtext, 905, Vector2.new(previewPos.x + previewSize.x - hexSize.x, previewPos.y + previewSize.y + 4), hex, true, 'left', 11)

                    if clickFrame and shouldCancel then
                        self:_RemoveColorpicker()
                    end
                    clickFrame = false
                end

                -- menu frame (glassmorphism sidebar)
                local tooltipPending = nil
                local sidebarW = self._sidebar_w
                local topbarH = self._topbar_h

                -- UI body rounding (always active via slider) + optional extra from static/breathe glow
                local uiCorner = 5
                local bodyCorner = 5

                -- neon glow
                local glowMode = self._glow_mode or 'Static'
                -- clean up on mode change
                if glowMode ~= self._glow_last_mode then
                    self:_UndrawStartsWith('menu_glow_')
                    self._glow_rot_count = 0
                    self._glow_last_mode = glowMode
                end
                if self._glow_enabled then
                    local glowColor = self._glow_color or self._theming.accent
                    local mx, my, mw, mh = self.x, self.y, self.w, self.h
                    local now = os.clock()

                    if glowMode == 'Rotate' then
                        -- smooth 360 rotation: each edge split into segments
                        local glowPeak = (self._glow_r_intensity or 50) / 100
                        local layers = self._glow_r_radius or 9
                        local segs = 18
                        local totalSegs = segs * 4
                        local speed = self._glow_r_speed or 3
                        local wormW = (self._glow_r_worm or 40) / 200
                        if wormW < 0.05 then wormW = 0.05 end
                        local phase = ((now * speed) % 6.28318) / 6.28318
                        local segCount = 0

                        for gi = 1, layers do
                            local layerAlpha = (1 - (gi - 1) / layers) * glowPeak
                            local edgeW = mw + gi * 2
                            local edgeH = mh + gi * 2 - 2
                            local segW = edgeW / segs
                            local segH = edgeH / segs

                            for edge = 0, 3 do
                                for si = 0, segs - 1 do
                                    segCount = segCount + 1
                                    local t = (edge * segs + si + 0.5) / totalSegs
                                    -- signed circular distance (positive = behind worm, negative = ahead)
                                    local rawDiff = t - phase
                                    if rawDiff > 0.5 then rawDiff = rawDiff - 1 end
                                    if rawDiff < -0.5 then rawDiff = rawDiff + 1 end
                                    -- asymmetric: leading edge sharp, trailing tail long
                                    local diff
                                    if rawDiff < 0 then
                                        diff = -rawDiff / (wormW * 0.3)  -- ahead: sharp falloff
                                    else
                                        diff = rawDiff / wormW           -- behind: long tail
                                    end
                                    local bright = 0.08 + 0.92 * ((diff < 1) and (1 - diff) * (1 - diff) or 0)

                                    local sx, sy, sw, sh
                                    if edge == 0 then
                                        sx = mx - gi + si * segW
                                        sy = my - gi
                                        sw = math.floor(segW + 1)
                                        sh = 1
                                    elseif edge == 1 then
                                        sx = mx + mw + gi - 1
                                        sy = my - gi + 1 + si * segH
                                        sw = 1
                                        sh = math.floor(segH + 1)
                                    elseif edge == 2 then
                                        sx = mx - gi + (segs - 1 - si) * segW
                                        sy = my + mh + gi - 1
                                        sw = math.floor(segW + 1)
                                        sh = 1
                                    else
                                        sx = mx - gi
                                        sy = my - gi + 1 + (segs - 1 - si) * segH
                                        sw = 1
                                        sh = math.floor(segH + 1)
                                    end

                                    local sid = 'menu_glow_r' .. tostring(segCount)
                                    self:_Draw(sid, 'rect', glowColor, 0, Vector2.new(sx, sy), Vector2.new(sw, sh), true)
                                    self:_SetOpacity(sid, layerAlpha * bright)
                                end
                            end
                        end
                        -- cleanup excess from previous frame
                        local prevMax = self._glow_rot_count or 0
                        for i = segCount + 1, prevMax do
                            self:_Undraw('menu_glow_r' .. tostring(i))
                        end
                        self._glow_rot_count = segCount
                    else
                        local effectiveRadius, glowPeak, peakMul, cornerSmooth
                        if glowMode == 'Static' then
                            effectiveRadius = self._glow_s_radius or 10
                            glowPeak = (self._glow_s_intensity or 50) / 100
                            peakMul = 1
                            cornerSmooth = self._glow_s_smooth or 15
                        elseif glowMode == 'Breathe' then
                            effectiveRadius = self._glow_b_radius or 14
                            glowPeak = (self._glow_b_intensity or 70) / 100
                            cornerSmooth = self._glow_b_smooth or 15
                            local speed = self._glow_b_speed or 2
                            local freq = (speed > 0) and (6.28318 / speed) or 1
                            local raw = math.sin(now * freq) * 0.5 + 0.5
                            local smooth = raw * raw * (3 - 2 * raw)
                            peakMul = 0.3 + 0.7 * smooth
                        else
                            effectiveRadius = 10
                            glowPeak = 0.5
                            peakMul = 1
                            cornerSmooth = 15
                        end
                        local cornerStep = (cornerSmooth or 15) / 15
                        for gi = 1, effectiveRadius do
                            local glowAlpha = (1 - (gi - 1) / effectiveRadius) * glowPeak * peakMul
                            local id = 'menu_glow_' .. tostring(gi)
                            self:_Draw(id, 'rect', glowColor, 0, Vector2.new(mx - gi, my - gi), Vector2.new(mw + gi * 2, mh + gi * 2), false)
                            -- glow rings follow body rounding (bodyCorner) with parallel offset per layer
                            local sq = self._drawings[id]
                            local targetCorner = bodyCorner > 0 and math.floor(bodyCorner + gi * cornerStep + 0.5) or 0
                            if sq and sq.Corner ~= targetCorner then sq.Corner = targetCorner end
                            self:_SetOpacity(id, glowAlpha)
                        end
                        for gi = effectiveRadius + 1, 20 do
                            self:_Undraw('menu_glow_' .. tostring(gi))
                        end
                    end
                else
                    self:_UndrawStartsWith('menu_glow_')
                    self._glow_rot_count = 0
                end

                -- main body fill (glass) - fallback layer beneath bg image
                self:_Draw('menu_body', 'rect', self._theming.body, 0, Vector2.new(self.x, self.y), Vector2.new(self.w, self.h), true)

                -- bg image layer - follows bodyCorner rounding
                if self._bg_image_feature_enabled and self._bg_image_enabled and self._bg_image_data then
                    self:_Draw('menu_bg_image', 'image', nil, 1, Vector2.new(self.x, self.y), Vector2.new(self.w, self.h), self._bg_image_data, bodyCorner)
                else
                    self:_Undraw('menu_bg_image')
                end

                -- overlay (glass sheen) - thin lighter layer on top of body/image
                self:_Draw('menu_overlay', 'rect', self._theming.surface1, 2, Vector2.new(self.x, self.y), Vector2.new(self.w, self.h), true)

                -- outer + inner menu border
                self:_Draw('menu_border_out', 'rect', self._theming.crust, 20, Vector2.new(self.x - 2, self.y - 2), Vector2.new(self.w + 4, self.h + 4), false)
                self:_Draw('menu_border_in', 'rect', self._theming.border1, 20, Vector2.new(self.x - 1, self.y - 1), Vector2.new(self.w + 2, self.h + 2), false)

                -- apply UI cornering to body + overlay + borders + topbar/sidebar bg (all body-colored fills).
                -- topbar_bg and sidebar_bg get rounded too so their square corners don't poke past the rounded body.
                -- corner must not exceed half of min dimension or Matcha Drawing.Square can render broken.
                -- inner border offset 1px -> corner - 1 to stay parallel.
                do
                    local innerCorner = math.max(0, bodyCorner - 1)
                    local topbarCap  = math.max(0, math.floor(topbarH / 2))
                    local sidebarCap = math.max(0, math.floor((sidebarW - 1) / 2))
                    local targets = {
                        menu_body       = bodyCorner,
                        menu_overlay    = bodyCorner,
                        menu_border_out = bodyCorner,
                        menu_border_in  = innerCorner,
                        menu_topbar_bg  = 0,
                        menu_sidebar_bg = 0,
                    }
                    for id, c in pairs(targets) do
                        local d = self._drawings[id]
                        if d and d.Corner ~= c then d.Corner = c end
                    end
                end
                -- top accent line (2px)
                do
                    local acY   = self.y + 1
                    local inset = bodyCorner + 1
                    local acX   = self.x + inset
                    local acW   = self.w - inset * 2
                    local fadeW = math.min(bodyCorner * 3, acW * 0.15)
                    local ac    = self._theming.accent
                    local cFull = {R=ac.R, G=ac.G, B=ac.B, A=1}
                    local cFade = {R=ac.R, G=ac.G, B=ac.B, A=0}
                    self:_Draw('menu_accent_top_l', 'gradient', nil, 21, 'horizontal',
                        Vector2.new(acX, acY), Vector2.new(fadeW, 2), cFade, cFull)
                    self:_Draw('menu_accent_top_c', 'rect', ac, 21,
                        Vector2.new(acX + fadeW, acY), Vector2.new(acW - fadeW * 2, 2), true)
                    self:_Draw('menu_accent_top_r', 'gradient', nil, 21, 'horizontal',
                        Vector2.new(acX + acW - fadeW, acY), Vector2.new(fadeW, 2), cFull, cFade)
                end


                -- topbar
                local topbarPos = Vector2.new(self.x, self.y)
                local topbarSize = Vector2.new(self.w, topbarH)
                self:_Draw('menu_topbar_bg', 'rect', self._theming.surface0, 6, topbarPos, Vector2.new(self.w, topbarH), true)
                do
                    local divY  = self.y + topbarH
                    local inset = bodyCorner * 2 + 2
                    local divX  = self.x + inset
                    local divW  = self.w - inset * 2
                    local fadeW = math.min(bodyCorner * 4, divW * 0.18)
                    local bc    = self._theming.border1
                    local cFull = {R=bc.R, G=bc.G, B=bc.B, A=1}
                    local cFade = {R=bc.R, G=bc.G, B=bc.B, A=0}
                    self:_Draw('menu_topbar_div_l', 'gradient', nil, 7, 'horizontal',
                        Vector2.new(divX, divY), Vector2.new(fadeW, 1), cFade, cFull)
                    self:_Draw('menu_topbar_div_c', 'rect', bc, 7,
                        Vector2.new(divX + fadeW, divY), Vector2.new(divW - fadeW * 2, 1), true)
                    self:_Draw('menu_topbar_div_r', 'gradient', nil, 7, 'horizontal',
                        Vector2.new(divX + divW - fadeW, divY), Vector2.new(fadeW, 1), cFull, cFade)
                end
                local menuDotCenter = Vector2.new(self.x + self._padding + 7, self.y + topbarH / 2 + 1)
                self:_Draw('menu_topbar_dot_ring', 'circle', self._theming.border1, 8, menuDotCenter, 5, false, 1, 18)
                self:_Draw('menu_topbar_dot', 'circle', self._theming.accent, 9, menuDotCenter, 2, true, 1, 18)
                self:_Draw('menu_topbar_title', 'text', self._theming.text, 8, Vector2.new(self.x + self._padding + 20, self.y + topbarH/2 - 7), menuTitle, true)

                -- sidebar
                local sidebarPos = Vector2.new(self.x + 1, self.y + topbarH + 1)
                local sidebarSize = Vector2.new(sidebarW - 1, self.h - topbarH - 2)
                self:_Draw('menu_sidebar_bg', 'rect', self._theming.surface0, 6, sidebarPos, sidebarSize, true)
                -- vertical separator between sidebar and content
                self:_Draw('menu_sidebar_sep', 'rect', self._theming.border1, 7, Vector2.new(self.x + sidebarW, self.y + topbarH + 1), Vector2.new(1, self.h - topbarH - 2), true)

                -- content area bounds
                local contentX = self.x + sidebarW + 1
                local contentY = self.y + topbarH + 1
                local contentW = self.w - sidebarW - 2
                local contentH = self.h - topbarH - 2
                local contentPad = 14

                -- sidebar tab buttons
                local tabCount = #self._tab_order
                local tabAreaStartY = sidebarPos.y + 12
                local tabAreaEndY = sidebarPos.y + sidebarSize.y - 12
                local tabBtnH = self._tab_btn_h
                local tabBtnGap = 4
                local tabGroupHeaderH = 16
                local visibleTabs = {}
                local tabCursorY = tabAreaStartY

                for i = 1, tabCount do
                    local tabName = self._tab_order[i]
                    local tabData = self._tree[tabName]
                    local sidebarGroup = tabData and tabData._sidebar_group or nil
                    local prevGrouped = false
                    local nextGrouped = false
                    if sidebarGroup then
                        if i > 1 then
                            local prevTabName = self._tab_order[i - 1]
                            local prevTabData = self._tree[prevTabName]
                            prevGrouped = prevTabData and prevTabData._sidebar_group == sidebarGroup or false
                        end
                        if i < tabCount then
                            local nextTabName = self._tab_order[i + 1]
                            local nextTabData = self._tree[nextTabName]
                            nextGrouped = nextTabData and nextTabData._sidebar_group == sidebarGroup or false
                        end
                    end

                    local groupTitle = nil
                    local isFirstGrouped = sidebarGroup and not prevGrouped
                    if isFirstGrouped then
                        for groupIndex = i, tabCount do
                            local groupTabName = self._tab_order[groupIndex]
                            local groupTabData = self._tree[groupTabName]
                            if not groupTabData or groupTabData._sidebar_group ~= sidebarGroup then
                                break
                            end
                            if groupTabData._sidebar_group_title and groupTabData._sidebar_group_title ~= '' then
                                groupTitle = tostring(groupTabData._sidebar_group_title)
                                break
                            end
                        end
                    end

                    local groupTitleText = nil
                    local groupHeaderHeight = 0
                    if groupTitle then
                        groupTitleText = self:_TruncateText(groupTitle, sidebarW - 38, nil, 10)
                        if groupTitleText and groupTitleText ~= '' then
                            groupHeaderHeight = tabGroupHeaderH
                        else
                            groupTitleText = nil
                        end
                    end

                    local btnPos = Vector2.new(sidebarPos.x + 8, tabCursorY + groupHeaderHeight)
                    local btnSize = Vector2.new(sidebarW - 17, tabBtnH)
                    if btnPos.y + btnSize.y > tabAreaEndY then
                        break
                    end

                    table.insert(visibleTabs, {
                        drawId = 'menu_tab_' .. tostring(#visibleTabs + 1),
                        name = tabName,
                        data = tabData,
                        index = i,
                        sidebarGroup = sidebarGroup,
                        btnPos = btnPos,
                        btnSize = btnSize,
                        headerY = tabCursorY,
                        headerText = groupTitleText,
                    })

                    tabCursorY = btnPos.y + btnSize.y + tabBtnGap
                end

                local visibleTabCount = #visibleTabs
                for visibleIndex = 1, visibleTabCount do
                    local layout = visibleTabs[visibleIndex]
                    local tabName = layout.name
                    local tabData = layout.data
                    local isOpen = self._open_tab == tabName
                    local tabDrawId = layout.drawId
                    local btnPos = layout.btnPos
                    local btnSize = layout.btnSize
                    local sidebarGroup = layout.sidebarGroup
                    local prevLayout = visibleIndex > 1 and visibleTabs[visibleIndex - 1] or nil
                    local nextLayout = visibleIndex < visibleTabCount and visibleTabs[visibleIndex + 1] or nil
                    local prevGrouped = prevLayout and prevLayout.sidebarGroup == sidebarGroup or false
                    local nextGrouped = nextLayout and nextLayout.sidebarGroup == sidebarGroup or false
                    local showGroupBracket = sidebarGroup and (prevGrouped or nextGrouped or layout.headerText ~= nil)

                    local isHoveringTab = self:_IsMouseWithinBounds(btnPos, btnSize)
                    local tabOpenAnim = self:_StepAnim(tabDrawId .. '_open_anim', isOpen and 1 or 0, 18)
                    local tabHoverAnim = self:_StepAnim(tabDrawId .. '_hover_anim', (isHoveringTab and not isOpen) and 1 or 0, 18)
                    local tabBgAlpha = math.max(tabOpenAnim, tabHoverAnim * 0.9)
                    if tabBgAlpha > 0.01 then
                        local tabBgColor = self:_LerpColor(self._theming.border0, self._theming.surface1, tabOpenAnim)
                        self:_Draw(tabDrawId .. '_bg', 'rect', tabBgColor, 8, btnPos, btnSize, true)
                        self:_SetOpacity(tabDrawId .. '_bg', tabBgAlpha)
                    else
                        self:_Undraw(tabDrawId .. '_bg')
                    end
                    if tabOpenAnim > 0.01 then
                        local stripW = math.max(1, math.floor(3 * tabOpenAnim + 0.5))
                        self:_Draw(tabDrawId .. '_strip', 'rect', self._theming.accent, 10, btnPos, Vector2.new(stripW, btnSize.y), true)
                        self:_SetOpacity(tabDrawId .. '_strip', tabOpenAnim)
                        self:_Draw(tabDrawId .. '_border', 'rect', self._theming.border1, 9, btnPos, btnSize, false)
                        self:_SetOpacity(tabDrawId .. '_border', tabOpenAnim)
                    else
                        self:_Undraw(tabDrawId .. '_strip')
                        self:_Undraw(tabDrawId .. '_border')
                    end

                    local labelColor = self:_LerpColor(self._theming.subtext, self._theming.text, clamp(tabOpenAnim + tabHoverAnim * 0.85, 0, 1))
                    if showGroupBracket then
                        local openTabData = self._open_tab and self._tree[self._open_tab] or nil
                        local groupActive = openTabData and openTabData._sidebar_group == sidebarGroup or false
                        local bracketColor = isOpen and self._theming.text or (groupActive and self._theming.text or self._theming.border1)
                        local bracketX = btnPos.x + 8
                        local bracketTopY = layout.headerText and (layout.headerY + 7) or (btnPos.y + 6)
                        local bracketBottomY = btnPos.y + btnSize.y - 6
                        local verticalFromY = prevGrouped and (btnPos.y - math.floor(tabBtnGap / 2)) or bracketTopY
                        local verticalToY = nextGrouped and (btnPos.y + btnSize.y + math.floor(tabBtnGap / 2)) or bracketBottomY
                        self:_Draw(tabDrawId .. '_group_vert', 'line', bracketColor, 11, Vector2.new(bracketX, verticalFromY), Vector2.new(bracketX, verticalToY), 1)

                        if layout.headerText then
                            local headerTextColor = groupActive and self._theming.text or self._theming.subtext
                            local headerTextSize = self:_GetTextBounds(layout.headerText, nil, 10)
                            local headerTextX = bracketX + 10
                            local headerLineLeftToX = headerTextX - 4
                            local headerLineRightFromX = headerTextX + headerTextSize.x + 6
                            local headerLineRightToX = btnPos.x + btnSize.x - 6
                            self:_Draw(tabDrawId .. '_group_header_l', 'line', bracketColor, 11, Vector2.new(bracketX, bracketTopY), Vector2.new(headerLineLeftToX, bracketTopY), 1)
                            if headerLineRightToX > headerLineRightFromX then
                                self:_Draw(tabDrawId .. '_group_header_r', 'line', bracketColor, 11, Vector2.new(headerLineRightFromX, bracketTopY), Vector2.new(headerLineRightToX, bracketTopY), 1)
                            else
                                self:_Undraw(tabDrawId .. '_group_header_r')
                            end
                            self:_Draw(tabDrawId .. '_group_title', 'text', headerTextColor, 11, Vector2.new(headerTextX, bracketTopY - 7), layout.headerText, true, 'left', 10)
                            self:_Undraw(tabDrawId .. '_group_top')
                        else
                            self:_Undraw(tabDrawId .. '_group_header_l')
                            self:_Undraw(tabDrawId .. '_group_header_r')
                            self:_Undraw(tabDrawId .. '_group_title')
                            if not prevGrouped then
                                self:_Draw(tabDrawId .. '_group_top', 'line', bracketColor, 11, Vector2.new(bracketX, bracketTopY), Vector2.new(bracketX + 5, bracketTopY), 1)
                            else
                                self:_Undraw(tabDrawId .. '_group_top')
                            end
                        end
                        if not nextGrouped then
                            self:_Draw(tabDrawId .. '_group_bottom', 'line', bracketColor, 11, Vector2.new(bracketX, bracketBottomY), Vector2.new(bracketX + 5, bracketBottomY), 1)
                        else
                            self:_Undraw(tabDrawId .. '_group_bottom')
                        end
                    else
                        self:_Undraw(tabDrawId .. '_group_vert')
                        self:_Undraw(tabDrawId .. '_group_top')
                        self:_Undraw(tabDrawId .. '_group_bottom')
                        self:_Undraw(tabDrawId .. '_group_header_l')
                        self:_Undraw(tabDrawId .. '_group_header_r')
                        self:_Undraw(tabDrawId .. '_group_title')
                    end
                    local labelOffsetX = showGroupBracket and 22 or 14
                    local displayName = tabData._display_name or tabName
                    local truncTabName = self:_TruncateText(displayName, btnSize.x - labelOffsetX - 8)
                    self:_Draw(tabDrawId .. '_text', 'text', labelColor, 11, btnPos + Vector2.new(labelOffsetX, btnSize.y/2 - 7), truncTabName, true)

                    if clickFrame and isHoveringTab then
                        if not isOpen then
                            self._open_tab = tabName
                            self._tab_change_at = os.clock()
                            self._section_fade_done = false
                            self._input_ctx = nil
                            self:_RemoveDropdown()
                            self:_RemoveColorpicker()
                        end
                        clickFrame = false
                    end
                end
                -- cleanup tabs that shouldn't render (overflow or shrunk order)
                for i = visibleTabCount + 1, visibleTabCount + 20 do
                    self:_UndrawStartsWith('menu_tab_' .. tostring(i) .. '_')
                end

                -- "+N more" sidebar indicator if tabs overflow
                if tabCount > visibleTabCount then
                    local moreText = '+' .. tostring(tabCount - visibleTabCount) .. ' more'
                    self:_Draw('menu_sidebar_more', 'text', self._theming.subtext, 11, Vector2.new(sidebarPos.x + 14, tabAreaEndY - 4), moreText, true, 'left', 10)
                else
                    self:_Undraw('menu_sidebar_more')
                end

                -- tab content fade
                if not self._section_fade_done then
                    local st = clamp((os.clock() - self._tab_change_at) / 0.25, 0, 1)
                    self:_SetOpacityStartsWith('menu_section_', st * st * (3 - 2 * st))
                    self:_SetOpacityStartsWith('menu_widget_', st * st * (3 - 2 * st))
                    if st >= 1 then self._section_fade_done = true end
                end

                -- render active tab content
                local tabContent = self._tree[self._open_tab]
                local openTabIdx = 0
                for i, n in ipairs(self._tab_order) do if n == self._open_tab then openTabIdx = i break end end

                -- hide non-active tabs' widgets — only on tab change to avoid per-frame full-table sweep
                if self._last_cleared_inactive_for ~= self._open_tab then
                    for i = 1, tabCount do
                        if i ~= openTabIdx then
                            self:_UndrawStartsWith('menu_section_' .. tostring(i) .. '_')
                            self:_UndrawStartsWith('menu_widget_' .. tostring(i) .. '_')
                        end
                    end
                    self._last_cleared_inactive_for = self._open_tab
                end

                if tabContent then
                    local contentBottom = contentY + contentH - contentPad
                    local columnGap = self._column_gap
                    local totalColumns = self._columns
                    local usableContentW = contentW - contentPad * 2 - columnGap * (totalColumns - 1)
                    local widgetW = math.floor(usableContentW / totalColumns)
                    local columnX = {}
                    local columnCursorY = {}
                    for col = 1, totalColumns do
                        columnX[col] = contentX + contentPad + (col - 1) * (widgetW + columnGap)
                        columnCursorY[col] = contentY + contentPad
                    end
                    local furthestCursorY = contentY + contentPad

                    for sIdx = 1, #tabContent._section_order do
                        local sectionName = tabContent._section_order[sIdx]
                        local sectionContent = tabContent._items[sectionName]
                        local sectionColumn = self:_ResolveColumnValue(sectionContent._column, 1) or 1
                        local sectionDrawId = 'menu_section_' .. tostring(openTabIdx) .. '_' .. tostring(sIdx)
                        local sectionUsedColumns = {}
                        local sectionVisualBottomY = {}
                        if #sectionContent._items > 0 then
                            for _, sectionItem in ipairs(sectionContent._items) do
                                local itemColumn = self:_ResolveColumnValue(sectionItem._column, sectionColumn) or sectionColumn
                                sectionUsedColumns[itemColumn] = true
                            end
                        else
                            sectionUsedColumns[sectionColumn] = true
                        end

                        -- section header: upper label + divider line
                        local headerText = string.upper(sectionName)
                        local headerSize = self:_GetTextBounds(headerText, nil, 11)
                        for col = 1, totalColumns do
                            local sectionColumnDrawId = sectionDrawId .. '_c' .. tostring(col)
                            if sectionUsedColumns[col] then
                                local widgetX = columnX[col]
                                local cursorY = columnCursorY[col] + (tonumber(sectionContent._y_offset) or 0)
                                if cursorY + headerSize.y < contentBottom then
                                    self:_Draw(sectionColumnDrawId .. '_title', 'text', self._theming.subtext, 12, Vector2.new(widgetX, cursorY), headerText, true, 'left', 11)
                                    local lineY = cursorY + math.floor(headerSize.y / 2) - 1
                                    self:_Draw(sectionColumnDrawId .. '_line', 'line', self._theming.border1, 12, Vector2.new(widgetX + headerSize.x + 8, lineY), Vector2.new(widgetX + widgetW, lineY), 1)
                                else
                                    self:_Undraw(sectionColumnDrawId .. '_title')
                                    self:_Undraw(sectionColumnDrawId .. '_line')
                                end
                                local headerEndY = cursorY + headerSize.y + 8
                                if headerEndY > columnCursorY[col] then
                                    columnCursorY[col] = headerEndY
                                end
                                sectionVisualBottomY[col] = columnCursorY[col]
                                if columnCursorY[col] > furthestCursorY then
                                    furthestCursorY = columnCursorY[col]
                                end
                            else
                                self:_Undraw(sectionColumnDrawId .. '_title')
                                self:_Undraw(sectionColumnDrawId .. '_line')
                            end
                        end

                        -- render widgets in this section
                        for sectionItemIter, sectionItem in ipairs(sectionContent._items) do
                            local sectionItemId = 'menu_widget_' .. tostring(openTabIdx) .. '_' .. tostring(sIdx) .. '_' .. tostring(sectionItemIter)
                            -- skip hidden items (no drawing, no height)
                            if sectionItem._hidden then
                                self:_UndrawStartsWith(sectionItemId)
                            else

                            local itemType = sectionItem.type_
                            local itemValue = sectionItem.value
                            local itemCallback = sectionItem.callback
                            local itemColumn = self:_ResolveColumnValue(sectionItem._column, sectionColumn) or sectionColumn
                            local flowCursorY = columnCursorY[itemColumn]
                            local widgetX = columnX[itemColumn]
                            local cursorY = flowCursorY + (tonumber(sectionItem._y_offset) or 0)
                            sectionUsedColumns[itemColumn] = true

                            -- skip rendering if past content bottom.
                            -- per-type heights: toggle/button = 26, slider/dropdown/textbox = 34
                            local overflowCheck
                            local baseAdvance
                            if itemType == 'toggle' or itemType == 'button' then
                                overflowCheck = 26
                                baseAdvance = 26
                            elseif itemType == 'label' then
                                overflowCheck = 20
                                baseAdvance = 20
                            else
                                overflowCheck = 34
                                baseAdvance = 34
                            end
                            if cursorY + overflowCheck > contentBottom then
                                self:_UndrawStartsWith(sectionItemId .. '_')
                                if contentBottom + 1 > furthestCursorY then
                                    furthestCursorY = contentBottom + 1
                                end
                            else

                            if itemType == 'toggle' then
                                local rowH = self._row_h
                                local rowPos = Vector2.new(widgetX, cursorY)
                                local labelPos = rowPos + Vector2.new(0, rowH/2 - 7)

                                local itemKeybind = sectionItem.keybind
                                local itemColorpicker = sectionItem.colorpicker

                                -- pill switch
                                local pillW = 26
                                local labelCenterY = labelPos.y + 6 -- visual center of the 12-13px label row, widgets anchor here
                                local pillH = 14
                                local rightEdge = widgetX + widgetW
                                local pillX = rightEdge - pillW
                                local pillY = labelCenterY - pillH / 2

                                -- keybind slot to the left of pill (if any)
                                if itemKeybind then
                                    local keybindText = itemKeybind._listening and '...' or (tostring(itemKeybind.value or '...')):upper()
                                    local keybindLabelSize = self:_GetTextBounds(keybindText, nil, 11)
                                    local kbW = keybindLabelSize.x + 8
                                    local kbH = 14
                                    local kbX = pillX - kbW - 8
                                    local kbY = labelCenterY - kbH / 2

                                    -- hit area padded for easier clicking
                                    local isHoveringKb = self:_IsMouseWithinBounds(Vector2.new(kbX - 2, rowPos.y), Vector2.new(kbW + 4, rowH))
                                    if isHoveringKb then
                                        if clickFrame then
                                            itemKeybind._listening = true
                                            itemKeybind._listening_start = os.clock()
                                            clickFrame = false
                                        elseif ctxFrame and itemKeybind.canChange then
                                            self:_SpawnDropdown(self:_GetMousePos(), 60, {itemKeybind.mode}, {'Hold', 'Toggle', 'Always'}, false, function(newValue)
                                                itemKeybind.mode = newValue[1]
                                                if itemKeybind.callback then
                                                    -- pass key name (string) for consistency with other callback sites
                                                    itemKeybind.callback(itemKeybind.value, newValue[1])
                                                end
                                            end)
                                            ctxFrame = false
                                        end
                                    end

                                    if itemKeybind._listening then
                                        -- auto timeout after 10 seconds of listening to avoid sticky state
                                        if os.clock() - itemKeybind._listening_start > 10 then
                                            itemKeybind._listening = false
                                        else
                                            for keyName, keyInfo in pairs(self._inputs) do
                                                if self:_IsKeyPressed(keyName) then
                                                    -- debounce the initial m1 click that opened the listen, and any mouse button used to initiate
                                                    local isMouseBtn = keyName == 'm1' or keyName == 'm2' or keyName == 'mb' or keyName == 'm4' or keyName == 'm5'
                                                    if (not isMouseBtn) or os.clock() - itemKeybind._listening_start > 0.2 then
                                                        local newValue = keyName ~= 'unbound' and keyName or nil
                                                        -- always pass key name (string) or nil to callback for consistency
                                                        if itemKeybind.callback then
                                                            itemKeybind.callback(newValue, itemKeybind.mode)
                                                        end
                                                        itemKeybind.value = newValue
                                                        itemKeybind._listening = false
                                                        -- consume the click so consumer code reading the same key this
                                                        -- frame doesn't also fire (e.g. autoparry Toggle mode would flip
                                                        -- on the bind press otherwise)
                                                        if self._inputs[keyName] then
                                                            self._inputs[keyName].click = false
                                                        end
                                                        break
                                                    end
                                                end
                                            end
                                        end
                                    end

                                    self:_Draw(sectionItemId .. '_kb_bg', 'rect', self._theming.surface0, 12, Vector2.new(kbX, kbY), Vector2.new(kbW, kbH), true)
                                    self:_Draw(sectionItemId .. '_kb_border', 'rect', self._theming.border0, 13, Vector2.new(kbX, kbY), Vector2.new(kbW, kbH), false)
                                    local kbColor = itemKeybind.value and self._theming.text or self._theming.subtext
                                    -- Matcha Drawing.Text with Center=true centers both X and Y around Position (per matchDocumentation.md)
                                    local kbTextPos = Vector2.new(kbX + kbW / 2, kbY + kbH / 2)
                                    self:_Draw(sectionItemId .. '_kb_text', 'text', kbColor, 14, kbTextPos, keybindText, true, 'center', 11)
                                end

                                -- colorpicker swatch (left of pill, or replacing pill if overwrite)
                                if itemColorpicker then
                                    local swatchW = 16
                                    local swatchH = 14
                                    local swatchX, swatchY
                                    if itemColorpicker.overwrite then
                                        swatchW = 20
                                        swatchX = rightEdge - swatchW
                                        swatchY = labelCenterY - swatchH / 2
                                    else
                                        swatchX = (itemKeybind and (pillX - 26 - ((self:_GetTextBounds(itemKeybind._listening and '...' or (tostring(itemKeybind.value or '...')):upper(), nil, 11)).x + 8) - 4) or (pillX - swatchW - 8))
                                        swatchY = labelCenterY - swatchH / 2
                                    end

                                    local isHoveringCp = self:_IsMouseWithinBounds(Vector2.new(swatchX - 2, rowPos.y), Vector2.new(swatchW + 4, rowH))
                                    if isHoveringCp then
                                        if clickFrame then
                                            self:_SpawnColorpicker(nil, itemColorpicker.label, itemColorpicker.value, function(newValue)
                                                itemColorpicker.value = newValue
                                                if itemColorpicker.callback then itemColorpicker.callback(newValue) end
                                            end)
                                            clickFrame = false
                                        elseif ctxFrame then
                                            self:_SpawnDropdown(self:_GetMousePos(), 60, {}, {'Copy', 'Paste'}, false, function(newValue)
                                                if newValue[1] == 'Copy' then
                                                    self._copied_color = itemColorpicker.value
                                                elseif newValue[1] == 'Paste' then
                                                    if self._copied_color then
                                                        itemColorpicker.value = self._copied_color
                                                        if itemColorpicker.callback then itemColorpicker.callback(self._copied_color) end
                                                    else
                                                        self:Notification('Color clipboard is empty!', 5)
                                                    end
                                                end
                                            end)
                                            ctxFrame = false
                                        end
                                    end

                                    local swatchColor = itemColorpicker.value or self._theming.accent
                                    self:_Draw(sectionItemId .. '_cp_bg', 'rect', swatchColor, 12, Vector2.new(swatchX, swatchY), Vector2.new(swatchW, swatchH), true)
                                    self:_Draw(sectionItemId .. '_cp_border', 'rect', self._theming.crust, 13, Vector2.new(swatchX, swatchY), Vector2.new(swatchW, swatchH), false)
                                end

                                -- draw pill (unless colorpicker overwrite)
                                local labelColor = sectionItem.unsafe and self._theming.unsafe or (itemValue and self._theming.text or self._theming.subtext)
                                if not itemColorpicker or not itemColorpicker.overwrite then
                                    -- click hit: pill area extended for comfort
                                    local hitPos = Vector2.new(pillX - 10, rowPos.y)
                                    local hitSize = Vector2.new(pillW + 14, rowH)
                                    local isHoveringToggle = self:_IsMouseWithinBounds(hitPos, hitSize)
                                    local toggleAnim = self:_StepAnim(sectionItemId .. '_toggle_anim', itemValue and 1 or 0, 18)
                                    local toggleHoverAnim = self:_StepAnim(sectionItemId .. '_toggle_hover_anim', isHoveringToggle and 1 or 0, 18)

                                    local pillBaseColor = self:_LerpColor(self._theming.surface1, self._theming.border1, toggleHoverAnim * 0.75)
                                    local pillColor = self:_LerpColor(pillBaseColor, self._theming.accent, toggleAnim)
                                    self:_Draw(sectionItemId .. '_pill_bg', 'rect', pillColor, 12, Vector2.new(pillX, pillY), Vector2.new(pillW, pillH), true)
                                    self:_Draw(sectionItemId .. '_pill_border', 'rect', self._theming.crust, 13, Vector2.new(pillX, pillY), Vector2.new(pillW, pillH), false)
                                    -- knob
                                    local knobSize = pillH - 4
                                    local knobTravel = pillW - knobSize - 4
                                    local knobX = pillX + 2 + knobTravel * toggleAnim
                                    local knobY = pillY + 2
                                    self:_Draw(sectionItemId .. '_pill_knob', 'rect', self._theming.text, 14, Vector2.new(knobX, knobY), Vector2.new(knobSize, knobSize), true)

                                    if clickFrame and isHoveringToggle then
                                        local newValue = not itemValue
                                        sectionItem.value = newValue
                                        if itemCallback then itemCallback(newValue) end
                                        clickFrame = false
                                    end
                                    if not sectionItem.unsafe then
                                        labelColor = self:_LerpColor(self._theming.subtext, self._theming.text, clamp(toggleAnim + toggleHoverAnim * 0.35, 0, 1))
                                    end
                                else
                                    labelColor = self._theming.text
                                end

                                -- compute label available width and truncate if necessary
                                local labelAvailW = (pillX - 10) - widgetX
                                if itemKeybind then
                                    local kbW = self:_GetTextBounds(itemKeybind._listening and '...' or (tostring(itemKeybind.value or '...')):upper(), nil, 11).x + 8
                                    labelAvailW = labelAvailW - kbW - 10
                                end
                                if itemColorpicker and not itemColorpicker.overwrite then
                                    labelAvailW = labelAvailW - 22
                                end
                                if itemColorpicker and itemColorpicker.overwrite then
                                    labelAvailW = (widgetX + widgetW - 22) - widgetX - 4
                                end
                                if sectionItem.tooltip then labelAvailW = labelAvailW - 18 end
                                local truncatedLabel = self:_TruncateText(sectionItem.label, labelAvailW)

                                -- tooltip hint
                                local labelSize = self:_GetTextBounds(truncatedLabel)
                                if sectionItem.tooltip then
                                    local hintPos = Vector2.new(labelPos.x + labelSize.x + 6, labelPos.y + 1)
                                    local hintSize = self:_GetTextBounds('?', nil, 11)
                                    local hitboxPad = 4
                                    local hintHit = Vector2.new(hintPos.x - hitboxPad, hintPos.y - hitboxPad)
                                    local hintHitSize = Vector2.new(hintSize.x + hitboxPad * 2 + 6, hintSize.y + hitboxPad * 2)
                                    if self:_IsMouseWithinBounds(hintHit, hintHitSize) then
                                        tooltipPending = {
                                            text = sectionItem.tooltip,
                                            anchor = Vector2.new(hintPos.x + 14, hintPos.y - 4),
                                        }
                                    end
                                    self:_Draw(sectionItemId .. '_hint_bg', 'rect', self._theming.surface1, 12, hintPos + Vector2.new(-2, 0), Vector2.new(hintSize.x + 4, hintSize.y + 2), true)
                                    self:_Draw(sectionItemId .. '_hint_border', 'rect', self._theming.border0, 13, hintPos + Vector2.new(-2, 0), Vector2.new(hintSize.x + 4, hintSize.y + 2), false)
                                    self:_Draw(sectionItemId .. '_hint', 'text', self._theming.text, 14, hintPos, '?', true, 'left', 11)
                                end

                                self:_Draw(sectionItemId .. '_label', 'text', labelColor, 12, labelPos, truncatedLabel, true)
                                cursorY = cursorY + rowH + 4

                            elseif itemType == 'slider' then
                                local rowH = 30
                                local rowPos = Vector2.new(widgetX, cursorY)
                                local trackH = 4
                                local trackPos = Vector2.new(widgetX, rowPos.y + 18)
                                local trackSize = Vector2.new(widgetW, trackH)
                                local isActive = (sectionItem._active ~= false)

                                -- interaction (gated when passive)
                                local newValue = itemValue
                                local hitPos = Vector2.new(trackPos.x - 4, trackPos.y - 6)
                                local hitSize = Vector2.new(trackSize.x + 8, trackSize.y + 12)
                                if mouseHeld and isActive then
                                    if self:_IsMouseWithinBounds(hitPos, hitSize) and clickFrame then
                                        self._slider_drag = sectionItemId
                                        clickFrame = false
                                    end
                                    if self._slider_drag == sectionItemId then
                                        local mouseX = self:_GetMousePos().x - trackPos.x
                                        local percent = clamp(mouseX / trackSize.x, 0, 1)
                                        newValue = sectionItem.min + (sectionItem.max - sectionItem.min) * percent
                                        local sStep = sectionItem.step
                                        if sStep and sStep > 0 then
                                            -- snap relative to min so step grid always includes min/max boundary
                                            newValue = sectionItem.min + math.floor(((newValue - sectionItem.min) / sStep) + 0.5) * sStep
                                        end
                                        newValue = clamp(newValue, sectionItem.min, sectionItem.max)
                                    end
                                else
                                    if self._slider_drag == sectionItemId then self._slider_drag = nil end
                                end

                                if newValue ~= itemValue then
                                    sectionItem.value = newValue
                                    itemValue = newValue
                                    if itemCallback then itemCallback(newValue) end
                                end

                                -- guard against min==max (div by zero -> NaN) that would crash drawing at NaN pos
                                local sliderRange = (sectionItem.max or 1) - (sectionItem.min or 0)
                                local fillPercent = 0
                                if sliderRange > 0 then
                                    fillPercent = (itemValue - (sectionItem.min or 0)) / sliderRange
                                end
                                fillPercent = clamp(fillPercent, 0, 1)
                                local animatedFillPercent
                                if self._slider_drag == sectionItemId then
                                    animatedFillPercent = self:_SetAnim(sectionItemId .. '_slider_fill_anim', fillPercent)
                                else
                                    animatedFillPercent = self:_StepAnim(sectionItemId .. '_slider_fill_anim', fillPercent, 22)
                                end

                                -- color palette w passive dim
                                local fillCol  = isActive and self._theming.accent or self:_LerpColor(self._theming.accent, self._theming.surface1, 0.5)
                                local knobActiveCol = isActive and self._theming.text   or self:_LerpColor(self._theming.text, self._theming.subtext, 0.6)
                                local valCol   = fillCol
                                local labelCol = isActive and self._theming.text or self._theming.subtext

                                -- track bg
                                self:_Draw(sectionItemId .. '_track_bg', 'rect', self._theming.surface1, 12, trackPos, trackSize, true)
                                -- track fill
                                if animatedFillPercent > 0.002 then
                                    self:_Draw(sectionItemId .. '_track_fill', 'rect', fillCol, 13, trackPos, Vector2.new(trackSize.x * animatedFillPercent, trackH), true)
                                else
                                    self:_Undraw(sectionItemId .. '_track_fill')
                                end
                                -- track border
                                self:_Draw(sectionItemId .. '_track_border', 'rect', self._theming.crust, 14, trackPos, trackSize, false)
                                -- knob (accent when dragging), clamped so it doesnt overshoot track at extremes
                                local knobX = trackPos.x + trackSize.x * animatedFillPercent - 3
                                if knobX < trackPos.x then knobX = trackPos.x end
                                if knobX > trackPos.x + trackSize.x - 6 then knobX = trackPos.x + trackSize.x - 6 end
                                local knobY = trackPos.y - 3
                                local knobColor = (self._slider_drag == sectionItemId) and fillCol or knobActiveCol
                                self:_Draw(sectionItemId .. '_knob', 'rect', knobColor, 15, Vector2.new(knobX, knobY), Vector2.new(6, 10), true)
                                self:_Draw(sectionItemId .. '_knob_border', 'rect', self._theming.crust, 16, Vector2.new(knobX, knobY), Vector2.new(6, 10), false)

                                -- label + value
                                local valText = formatStep(itemValue, sectionItem.step) .. (sectionItem.suffix or '')
                                local valSize = self:_GetTextBounds(valText)
                                local sliderLabel = self:_TruncateText(sectionItem.label, widgetW - valSize.x - 10)
                                self:_Draw(sectionItemId .. '_label', 'text', labelCol, 12, Vector2.new(widgetX, rowPos.y), sliderLabel, true)
                                self:_Draw(sectionItemId .. '_value', 'text', valCol, 12, Vector2.new(widgetX + widgetW - valSize.x, rowPos.y), valText, true)

                                cursorY = cursorY + rowH + 4

                            elseif itemType == 'range_slider' then
                                local rowH = 30
                                local rowPos = Vector2.new(widgetX, cursorY)
                                local trackH = 4
                                local trackPos = Vector2.new(widgetX, rowPos.y + 18)
                                local trackSize = Vector2.new(widgetW, trackH)
                                local isActive = (sectionItem._active ~= false)
                                local sMin = sectionItem.min or 0
                                local sMax = sectionItem.max or 1
                                local sStep = sectionItem.step
                                local rng = sMax - sMin
                                if rng <= 0 then rng = 1 end

                                local function snapVal(v)
                                    v = tonumber(v) or sMin
                                    if v < sMin then v = sMin end
                                    if v > sMax then v = sMax end
                                    if sStep and sStep > 0 then
                                        v = sMin + math.floor(((v - sMin) / sStep) + 0.5) * sStep
                                        if v > sMax then v = sMax end
                                        if v < sMin then v = sMin end
                                    end
                                    return v
                                end

                                local lowVal  = snapVal(sectionItem.valueLow)
                                local highVal = snapVal(sectionItem.valueHigh)

                                -- interaction (gated when passive)
                                local hitPos = Vector2.new(trackPos.x - 4, trackPos.y - 6)
                                local hitSize = Vector2.new(trackSize.x + 8, trackSize.y + 12)
                                if mouseHeld and isActive then
                                    local mxNow = self:_GetMousePos().x
                                    if self:_IsMouseWithinBounds(hitPos, hitSize) and clickFrame and not self._slider_drag and not self._range_slider_drag then
                                        -- pick handle nearest to click x; tiebreak by mouse side when stacked
                                        local lowX  = trackPos.x + trackSize.x * ((lowVal  - sMin) / rng)
                                        local highX = trackPos.x + trackSize.x * ((highVal - sMin) / rng)
                                        local pick
                                        if lowX == highX then
                                            pick = (mxNow >= lowX) and 'high' or 'low'
                                        elseif math.abs(mxNow - lowX) < math.abs(mxNow - highX) then
                                            pick = 'low'
                                        else
                                            pick = 'high'
                                        end
                                        self._range_slider_drag = sectionItemId
                                        self._range_slider_handle = pick
                                        clickFrame = false
                                    end
                                    if self._range_slider_drag == sectionItemId then
                                        local mouseX = mxNow - trackPos.x
                                        local percent = clamp(mouseX / trackSize.x, 0, 1)
                                        local v = sMin + (sMax - sMin) * percent
                                        v = snapVal(v)
                                        if self._range_slider_handle == 'low' then
                                            lowVal = v
                                            if lowVal > highVal then
                                                lowVal, highVal = highVal, lowVal
                                                self._range_slider_handle = 'high'
                                            end
                                        else
                                            highVal = v
                                            if highVal < lowVal then
                                                lowVal, highVal = highVal, lowVal
                                                self._range_slider_handle = 'low'
                                            end
                                        end
                                    end
                                else
                                    if self._range_slider_drag == sectionItemId then
                                        self._range_slider_drag = nil
                                        self._range_slider_handle = nil
                                    end
                                end

                                if lowVal ~= sectionItem.valueLow or highVal ~= sectionItem.valueHigh then
                                    sectionItem.valueLow  = lowVal
                                    sectionItem.valueHigh = highVal
                                    if itemCallback then itemCallback(lowVal, highVal) end
                                end

                                local pctLow  = clamp((lowVal  - sMin) / rng, 0, 1)
                                local pctHigh = clamp((highVal - sMin) / rng, 0, 1)
                                local animLow  = self:_StepAnim(sectionItemId .. '_range_low_anim',  pctLow,  22)
                                local animHigh = self:_StepAnim(sectionItemId .. '_range_high_anim', pctHigh, 22)

                                local fillCol  = isActive and self._theming.accent or self:_LerpColor(self._theming.accent, self._theming.surface1, 0.5)
                                local knobCol  = isActive and self._theming.text   or self:_LerpColor(self._theming.text, self._theming.subtext, 0.6)
                                local valCol   = fillCol
                                local labelCol = isActive and self._theming.text or self._theming.subtext

                                -- track bg
                                self:_Draw(sectionItemId .. '_rs_track_bg', 'rect', self._theming.surface1, 12, trackPos, trackSize, true)
                                -- inner fill (between handles)
                                local fillX = trackPos.x + trackSize.x * animLow
                                local fillW = trackSize.x * (animHigh - animLow)
                                if fillW > 0.5 then
                                    self:_Draw(sectionItemId .. '_rs_fill', 'rect', fillCol, 13, Vector2.new(fillX, trackPos.y), Vector2.new(fillW, trackH), true)
                                else
                                    self:_Undraw(sectionItemId .. '_rs_fill')
                                end
                                self:_Draw(sectionItemId .. '_rs_track_border', 'rect', self._theming.crust, 14, trackPos, trackSize, false)

                                -- low knob
                                local lowKnobX = trackPos.x + trackSize.x * animLow - 3
                                if lowKnobX < trackPos.x then lowKnobX = trackPos.x end
                                if lowKnobX > trackPos.x + trackSize.x - 6 then lowKnobX = trackPos.x + trackSize.x - 6 end
                                local lowKnobCol = (self._range_slider_drag == sectionItemId and self._range_slider_handle == 'low') and fillCol or knobCol
                                self:_Draw(sectionItemId .. '_rs_knob_low', 'rect', lowKnobCol, 15, Vector2.new(lowKnobX, trackPos.y - 3), Vector2.new(6, 10), true)
                                self:_Draw(sectionItemId .. '_rs_knob_low_b', 'rect', self._theming.crust, 16, Vector2.new(lowKnobX, trackPos.y - 3), Vector2.new(6, 10), false)

                                -- high knob
                                local highKnobX = trackPos.x + trackSize.x * animHigh - 3
                                if highKnobX < trackPos.x then highKnobX = trackPos.x end
                                if highKnobX > trackPos.x + trackSize.x - 6 then highKnobX = trackPos.x + trackSize.x - 6 end
                                local highKnobCol = (self._range_slider_drag == sectionItemId and self._range_slider_handle == 'high') and fillCol or knobCol
                                self:_Draw(sectionItemId .. '_rs_knob_high', 'rect', highKnobCol, 15, Vector2.new(highKnobX, trackPos.y - 3), Vector2.new(6, 10), true)
                                self:_Draw(sectionItemId .. '_rs_knob_high_b', 'rect', self._theming.crust, 16, Vector2.new(highKnobX, trackPos.y - 3), Vector2.new(6, 10), false)

                                -- label + value (low - high)
                                local sfx = sectionItem.suffix or ''
                                local valText = formatStep(lowVal, sStep) .. sfx .. ' - ' .. formatStep(highVal, sStep) .. sfx
                                local valSize = self:_GetTextBounds(valText)
                                local sliderLabel = self:_TruncateText(sectionItem.label, widgetW - valSize.x - 10)
                                self:_Draw(sectionItemId .. '_rs_label', 'text', labelCol, 12, Vector2.new(widgetX, rowPos.y), sliderLabel, true)
                                self:_Draw(sectionItemId .. '_rs_value', 'text', valCol, 12, Vector2.new(widgetX + widgetW - valSize.x, rowPos.y), valText, true)

                                cursorY = cursorY + rowH + 4

                            elseif itemType == 'dropdown' then
                                local rowH = 32
                                local rowPos = Vector2.new(widgetX, cursorY)
                                local boxH = 18
                                local boxPos = Vector2.new(widgetX, rowPos.y + 14)
                                local boxSize = Vector2.new(widgetW, boxH)

                                local isHovering = self:_IsMouseWithinBounds(boxPos, boxSize)
                                if clickFrame and isHovering then
                                    self:_SpawnDropdown(Vector2.new(boxPos.x, boxPos.y + boxSize.y + 2), boxSize.x - self._padding * 2 - 4, itemValue, sectionItem.choices, sectionItem.multi, function(newValue)
                                        sectionItem.value = newValue
                                        if itemCallback then itemCallback(newValue) end
                                    end, sectionItem.previewFonts, sectionItem.previewColors, sectionItem.hoverCallback, sectionItem.cancelCallback)
                                    clickFrame = false
                                end

                                -- box (accent border on hover)
                                local boxBorderColor = isHovering and self._theming.accent or self._theming.border0
                                self:_Draw(sectionItemId .. '_box_bg', 'rect', self._theming.surface0, 12, boxPos, boxSize, true)
                                self:_Draw(sectionItemId .. '_box_border', 'rect', self._theming.crust, 13, boxPos, boxSize, false)
                                self:_Draw(sectionItemId .. '_box_border_in', 'rect', boxBorderColor, 14, boxPos + Vector2.new(1, 1), boxSize - Vector2.new(2, 2), false)
                                -- arrow triangle
                                local arrowCenter = Vector2.new(boxPos.x + boxSize.x - 10, boxPos.y + boxSize.y/2)
                                self:_Draw(sectionItemId .. '_arrow', 'triangle', self._theming.text, 14, true,
                                    arrowCenter + Vector2.new(0, 3),
                                    arrowCenter + Vector2.new(4, -2),
                                    arrowCenter + Vector2.new(-4, -2)
                                )

                                -- value text
                                local displayedValue = table.concat(itemValue or {}, ', ')
                                if displayedValue == '' then displayedValue = '-' end
                                local valueSize = self:_GetTextBounds(displayedValue)
                                if valueSize.x > boxSize.x - 24 then
                                    local valueLen = (type(itemValue) == 'table') and #itemValue or 0
                                    local multiText = tostring(valueLen) .. ' item' .. (valueLen == 1 and '' or 's')
                                    if self:_GetTextBounds(multiText).x < valueSize.x then
                                        displayedValue = multiText
                                    else
                                        displayedValue = self:_TruncateText(displayedValue, boxSize.x - 24)
                                    end
                                end
                                self:_Draw(sectionItemId .. '_value', 'text', self._theming.text, 14, boxPos + Vector2.new(6, boxSize.y/2 - 7), displayedValue, true)

                                -- label
                                local dropdownLabel = self:_TruncateText(sectionItem.label, widgetW - 4)
                                self:_Draw(sectionItemId .. '_label', 'text', self._theming.text, 12, Vector2.new(widgetX, rowPos.y), dropdownLabel, true)

                                cursorY = cursorY + rowH + 2

                            elseif itemType == 'button' then
                                local rowH = 22
                                local btnPos = Vector2.new(widgetX, cursorY)
                                local btnSize = Vector2.new(widgetW, rowH)

                                local isHovering = self:_IsMouseWithinBounds(btnPos, btnSize)
                                if mouseHeld then
                                    if isHovering and clickFrame then
                                        self._button_held = sectionItemId
                                        clickFrame = false
                                        if itemCallback then itemCallback() end
                                    end
                                else
                                    if self._button_held == sectionItemId then self._button_held = nil end
                                end

                                local isPressed = self._button_held == sectionItemId
                                local buttonHoverAnim = self:_StepAnim(sectionItemId .. '_button_hover_anim', (isHovering and not isPressed) and 1 or 0, 18)
                                local buttonPressAnim = self:_StepAnim(sectionItemId .. '_button_press_anim', isPressed and 1 or 0, 24)
                                local bgBaseColor = self:_LerpColor(self._theming.surface0, self._theming.surface1, buttonHoverAnim)
                                local bgColor = self:_LerpColor(bgBaseColor, self._theming.accent, buttonPressAnim)
                                local textColor = self:_LerpColor(self._theming.text, self._theming.body, buttonPressAnim)
                                local borderColor = self:_LerpColor(self._theming.border1, self._theming.accent, clamp(buttonHoverAnim * 0.45 + buttonPressAnim, 0, 1))
                                self:_Draw(sectionItemId .. '_bg', 'rect', bgColor, 12, btnPos, btnSize, true)
                                self:_Draw(sectionItemId .. '_border', 'rect', borderColor, 13, btnPos, btnSize, false)
                                self:_Draw(sectionItemId .. '_border_in', 'rect', self._theming.crust, 14, btnPos + Vector2.new(1, 1), btnSize - Vector2.new(2, 2), false)
                                local btnLabel = self:_TruncateText(sectionItem.label, btnSize.x - 16)
                                -- Center=true centers around Position on both axes, so pass raw rect center (matches keybind fix)
                                local btnTextPos = Vector2.new(btnPos.x + btnSize.x / 2, btnPos.y + btnSize.y / 2)
                                self:_Draw(sectionItemId .. '_text', 'text', textColor, 14, btnTextPos, btnLabel, true, 'center')

                                cursorY = cursorY + rowH + 4

                            elseif itemType == 'textbox' then
                                local rowH = 32
                                local rowPos = Vector2.new(widgetX, cursorY)
                                local inputH = 18
                                local inputPos = Vector2.new(widgetX, rowPos.y + 14)
                                local inputSize = Vector2.new(widgetW, inputH)

                                local isHovering = self:_IsMouseWithinBounds(inputPos, inputSize)
                                local isTyping = self._input_ctx == sectionItemId

                                local cursor = math.floor(os.clock() * 2) % 2 == 0 and '|' or ' '
                                local raw = itemValue or ''
                                local placeholder = '...'
                                local displayedValue = isTyping and (raw .. cursor) or ((raw ~= '' and raw) or placeholder)
                                local valueColor = isTyping and self._theming.text or ((raw ~= '') and self._theming.text or self._theming.subtext)

                                if self:_GetTextBounds(displayedValue).x > inputSize.x - 12 then
                                    for i = 1, #displayedValue do
                                        local sub = displayedValue:sub(i)
                                        if self:_GetTextBounds(sub).x <= inputSize.x - 12 then
                                            displayedValue = sub
                                            break
                                        end
                                    end
                                end

                                if self:_IsKeyPressed('m1') then
                                    if isHovering then
                                        self._input_ctx = sectionItemId
                                        clickFrame = false
                                    elseif isTyping then
                                        -- close typing but let click propagate to other widgets in same frame
                                        self._input_ctx = nil
                                        self:_RemoveDropdown()
                                        isTyping = false
                                    end
                                elseif ctxFrame then
                                    if isHovering then
                                        self:_SpawnDropdown(self:_GetMousePos(), 70, {}, {'Copy', 'Paste', 'Clear'}, false, function(newValue)
                                            if newValue[1] == 'Copy' then
                                                setclipboard(tostring(itemValue or ''))
                                                self:Notification('Text copied to clipboard', 5)
                                            elseif newValue[1] == 'Paste' then
                                                local ok, clip = pcall(function() return getclipboard and getclipboard() end)
                                                if ok and type(clip) == 'string' and #clip > 0 then
                                                    sectionItem.value = clip
                                                    if sectionItem.callback then sectionItem.callback(clip) end
                                                    self:Notification('Pasted from clipboard', 3)
                                                else
                                                    self:Notification('Clipboard empty or unavailable', 4)
                                                end
                                            elseif newValue[1] == 'Clear' then
                                                sectionItem.value = ''
                                                if sectionItem.callback then sectionItem.callback('') end
                                            end
                                        end)
                                        ctxFrame = false
                                    end
                                end

                                if isTyping then
                                    local newValue = raw
                                    local shiftCtx = self:_IsKeyHeld('shift')
                                    local changed = false
                                    for char, _ in pairs(self._inputs) do
                                        if self:_IsKeyPressed(char) then
                                            local mapped = _charMap[char] or char
                                            if mapped == 'enter' then
                                                self._input_ctx = nil
                                                isTyping = false
                                                break
                                            elseif mapped == 'esc' then
                                                -- cancel typing without modifying value
                                                self._input_ctx = nil
                                                isTyping = false
                                                break
                                            elseif mapped == 'unbound' then
                                                -- backspace
                                                if #newValue > 0 then
                                                    newValue = newValue:sub(1, -2)
                                                    changed = true
                                                end
                                            elseif mapped then
                                                if #mapped == 1 then
                                                    if shiftCtx and _shiftMap[mapped] then
                                                        mapped = _shiftMap[mapped]
                                                    elseif shiftCtx then
                                                        mapped = mapped:upper()
                                                    end
                                                    newValue = newValue .. mapped
                                                    changed = true
                                                end
                                            end
                                        end
                                    end
                                    if changed then
                                        sectionItem.value = newValue
                                        if sectionItem.callback then sectionItem.callback(newValue) end
                                    end
                                end

                                -- input box draw
                                self:_Draw(sectionItemId .. '_input_bg', 'rect', self._theming.surface0, 12, inputPos, inputSize, true)
                                self:_Draw(sectionItemId .. '_input_border', 'rect', self._theming.crust, 13, inputPos, inputSize, false)
                                local borderColor
                                if isTyping then
                                    borderColor = self._theming.accent
                                elseif isHovering then
                                    borderColor = self._theming.border1
                                else
                                    borderColor = self._theming.border0
                                end
                                self:_Draw(sectionItemId .. '_input_border_in', 'rect', borderColor, 14, inputPos + Vector2.new(1, 1), inputSize - Vector2.new(2, 2), false)
                                self:_Draw(sectionItemId .. '_input', 'text', valueColor, 14, inputPos + Vector2.new(6, inputSize.y/2 - 7), displayedValue, true)
                                -- label
                                local tbLabel = self:_TruncateText(sectionItem.label, widgetW - 4)
                                self:_Draw(sectionItemId .. '_label', 'text', self._theming.text, 12, Vector2.new(widgetX, rowPos.y), tbLabel, true)

                                cursorY = cursorY + rowH + 2

                            elseif itemType == 'label' then
                                local rowH = 18
                                local lblText = self:_TruncateText(tostring(sectionItem.label or ''), widgetW)
                                self:_Draw(sectionItemId .. '_text', 'text', self._theming.subtext, 12, Vector2.new(widgetX, cursorY + 2), lblText, true)
                                cursorY = cursorY + rowH + 2
                            end
                            end -- overflow guard
                            local nextFlowY = flowCursorY + baseAdvance
                            if nextFlowY > columnCursorY[itemColumn] then
                                columnCursorY[itemColumn] = nextFlowY
                            end
                            local visualEndY = cursorY
                            if cursorY + overflowCheck <= contentBottom and visualEndY > furthestCursorY then
                                furthestCursorY = visualEndY
                            end
                            if cursorY + overflowCheck <= contentBottom then
                                local currentSectionVisualBottom = sectionVisualBottomY[itemColumn] or columnCursorY[itemColumn]
                                if visualEndY > currentSectionVisualBottom then
                                    sectionVisualBottomY[itemColumn] = visualEndY
                                end
                            end
                            if columnCursorY[itemColumn] > furthestCursorY then
                                furthestCursorY = columnCursorY[itemColumn]
                            end

                            end -- end _hidden else
                        end

                        for usedColumn, _ in pairs(sectionUsedColumns) do
                            local sectionVisualBottom = sectionVisualBottomY[usedColumn]
                            if sectionVisualBottom and sectionVisualBottom > columnCursorY[usedColumn] then
                                columnCursorY[usedColumn] = sectionVisualBottom
                            end
                            columnCursorY[usedColumn] = columnCursorY[usedColumn] + 8
                            if columnCursorY[usedColumn] > furthestCursorY then
                                furthestCursorY = columnCursorY[usedColumn]
                            end
                        end
                    end

                    -- cleanup sections beyond the current list
                    for sIdx = #tabContent._section_order + 1, #tabContent._section_order + 20 do
                        self:_UndrawStartsWith('menu_section_' .. tostring(openTabIdx) .. '_' .. tostring(sIdx))
                        self:_UndrawStartsWith('menu_widget_' .. tostring(openTabIdx) .. '_' .. tostring(sIdx) .. '_')
                    end

                    -- overflow indicator
                    if furthestCursorY > contentBottom then
                        local hintText = '▼ more'
                        local hintSize = self:_GetTextBounds(hintText, nil, 10)
                        local hintX = contentX + contentW - hintSize.x - 8
                        local hintY = contentY + contentH - 14
                        self:_Draw('menu_overflow_hint', 'text', self._theming.subtext, 18, Vector2.new(hintX, hintY), hintText, true, 'left', 10)
                    else
                        self:_Undraw('menu_overflow_hint')
                    end
                end

                -- tooltip (drawn after all items so z-order is clean)
                if tooltipPending then
                    local tooltipText = tooltipPending.text
                    local tooltipSize = self:_GetTextBounds(tooltipText)
                    local tooltipBoxSize = tooltipSize + Vector2.new(self._padding * 2, self._padding - 2)
                    local tooltipOrigin = tooltipPending.anchor
                    -- clamp to screen bounds
                    local screenSize = self:_GetScreenSize()
                    if tooltipOrigin.x + tooltipBoxSize.x > screenSize.x - 4 then
                        tooltipOrigin = Vector2.new(screenSize.x - tooltipBoxSize.x - 4, tooltipOrigin.y)
                    end
                    if tooltipOrigin.y + tooltipBoxSize.y > screenSize.y - 4 then
                        tooltipOrigin = Vector2.new(tooltipOrigin.x, screenSize.y - tooltipBoxSize.y - 4)
                    end
                    if tooltipOrigin.x < 4 then tooltipOrigin = Vector2.new(4, tooltipOrigin.y) end
                    if tooltipOrigin.y < 4 then tooltipOrigin = Vector2.new(tooltipOrigin.x, 4) end
                    self:_Draw('menu_tooltip_body', 'rect', self._theming.body, 1000, tooltipOrigin, tooltipBoxSize, true)
                    self:_SetOpacity('menu_tooltip_body', 1)
                    self:_Draw('menu_tooltip_crust', 'rect', self._theming.crust, 1001, tooltipOrigin, tooltipBoxSize, false)
                    self:_Draw('menu_tooltip_border', 'rect', self._theming.border1, 1002, tooltipOrigin + Vector2.new(1, 1), tooltipBoxSize - Vector2.new(2, 2), false)
                    self:_Draw('menu_tooltip_text', 'text', self._theming.text, 1003, tooltipOrigin + Vector2.new(self._padding, self._padding/2 - 1), tooltipText, true)
                else
                    self:_UndrawStartsWith('menu_tooltip')
                end

                -- drag start: topbar only (indicator captures first if overlap)
                if clickFrame and not self._menu_drag and not self._indicator_drag and self:_IsMouseWithinBounds(Vector2.new(self.x, self.y), Vector2.new(self.w, topbarH)) then
                    local mousePos = self:_GetMousePos()
                    self._menu_drag = Vector2.new(mousePos.x - self.x, mousePos.y - self.y)
                end

            else
                self:_RemoveColorpicker()
                self:_RemoveDropdown()
                self._input_ctx = nil
                self._menu_drag = nil
                self._slider_drag = nil
                self._range_slider_drag = nil
                self._range_slider_handle = nil
                self._button_held = nil
                -- clear any sticky keybind listening state so menu open doesnt resume capture
                for _, tabData in pairs(self._tree) do
                    for _, sectionData in pairs(tabData._items) do
                        for _, item in ipairs(sectionData._items) do
                            if item.keybind and item.keybind._listening then
                                item.keybind._listening = false
                            end
                        end
                    end
                end
            end

            local menuOpacity, menuFadeProgress = self:_ResolveMenuFadeOpacity()

            -- set base alphas for glass elements (independent of fade)
            if menuOpacity > 0 then
                local bgAlpha = clamp(self._background_alpha or 1, 5/100, 1)
                self:_SetOpacityStartsWith('menu_body', bgAlpha)
                self:_SetOpacityStartsWith('menu_overlay', bgAlpha * 0.12)
                self:_SetOpacityStartsWith('menu_topbar_bg', clamp(bgAlpha + 0.04, 0, 1))
                self:_SetOpacityStartsWith('menu_sidebar_bg', clamp(bgAlpha + 0.03, 0, 1))
                if self._bg_image_feature_enabled and self._bg_image_enabled and self._bg_image_data then
                    -- independent of bg opacity so transparent menu doesn't hide the photo
                    self:_SetOpacity('menu_bg_image', clamp(self._bg_image_alpha or 1, 0, 1))
                end
            end

            -- apply fade multiplier on top of base alphas (preserves gradients, glass, etc.)
            if not self._menu_fade_done then
                self:_ApplyMenuFade(menuOpacity)
                if menuFadeProgress >= 1 then
                    self._menu_fade_done = true
                    self._menu_fade_start_opacity = self._menu_open and 1 or 0
                    if not self._menu_open then
                        self:_UndrawStartsWith('menu_')
                    end
                end
            end
        end

        function UILib:ShowDemoMenu()
            self:Unload()
            self:SetMenuSize(Vector2.new(720, 480))
            self:CenterMenu()
            self:SetMenuTitle('UILib v2 — Full Demo')

            local combat = self:Tab('Combat')
            local aimbot = combat:Section('Aimbot')
            local enabled = aimbot:Toggle('Enabled', false, nil, false, 'Master aimbot switch')
            enabled:AddKeybind('unbound', 'Hold', true)
            local silent = aimbot:Toggle('Silent aim', true)
            silent:AddColorpicker('Hit color', Color3.fromRGB(255, 80, 120))
            local autoWall = aimbot:Toggle('Auto wall (unsafe)', false, nil, true, 'Unsafe features may get you banned')
            autoWall:AddKeybind('v', 'Toggle', true)
            local overwriteColor = aimbot:Toggle('Crosshair color')
            overwriteColor:AddColorpicker('Crosshair', Color3.fromRGB(0, 255, 128), true)
            local fov = aimbot:Slider('FOV', 90, 1, 1, 360, 'deg')
            local smooth = aimbot:Slider('Smoothness', 2.5, 0.1, 0.1, 10, 'x')
            local hitbox = aimbot:Dropdown('Hitbox', {'Head','Chest'}, {'Head','Neck','Chest','Stomach','Pelvis','Arms','Legs'}, true)
            aimbot:Dropdown('Priority', {'Distance'}, {'Distance','Health','FOV','Threat'}, false)
            aimbot:Button('Reset settings', function()
                enabled:Set(false); silent:Set(false); fov:Set(90); smooth:Set(2.5); hitbox:Set({'Head'})
                self:Notification('Settings reset', 3)
            end)

            local accuracy = combat:Section('Accuracy')
            local animOn = false
            accuracy:Toggle('Live meter', false, function(v) animOn = v end)
            local meterSlider = accuracy:Slider('Meter', 0, 1, -100, 100, '%')
            accuracy:Slider('Prediction', 0.5, 0.05, 0, 2, 's')
            local targetBox = accuracy:Textbox('Target filter', '')
            accuracy:Textbox('Ignore list', '')
            accuracy:Button('Clear filter', function() targetBox:Set('') end)

            local vis = self:Tab('Visuals')
            local esp = vis:Section('ESP')
            local espOn = esp:Toggle('Enabled', false)
            espOn:AddColorpicker('Color', Color3.fromRGB(0, 200, 255))
            espOn:AddKeybind('unbound', 'Toggle', true)
            esp:Toggle('Box', true); esp:Toggle('Name', true); esp:Toggle('Health bar', false)
            esp:Toggle('Distance', false); esp:Toggle('Skeleton', false); esp:Toggle('Tracers', false)
            esp:Slider('Max distance', 500, 10, 10, 2000, 'm')
            esp:Slider('Text size', 13, 1, 8, 24, 'px')
            esp:Dropdown('Style', {'Corner'}, {'Corner','Full','Outline','Rounded','Glow','Neon','Minimal','Cyber'}, false)
            esp:Dropdown('Flags', {'Armor','Weapon'}, {'Armor','Weapon','Ammo','Reload','Scoped','Bot','AFK','VIP'}, true)

            local world = vis:Section('World')
            world:Toggle('Night mode', false); world:Toggle('No fog', false); world:Toggle('Fullbright', false)
            world:Slider('FOV changer', 70, 1, 40, 120, 'deg')
            world:Dropdown('Skybox', {'Default'}, {'Default','Night','Sunset','Space','Custom'}, false)

            local misc = self:Tab('Misc')
            local movement = misc:Section('Movement')
            movement:Toggle('Bunnyhop', false); movement:Toggle('Auto strafe', false)
            movement:Slider('Jump height', 16, 1, 10, 100, 'u')
            movement:Slider('Walk speed', 16, 1, 1, 50, 'u/s')
            movement:Button('Teleport home', function() self:Notification('Teleport sent', 3) end)

            local automation = misc:Section('Automation')
            automation:Toggle('Auto heal', false); automation:Toggle('Auto reload', false)
            automation:Slider('Heal threshold', 50, 5, 10, 100, '%')
            automation:Dropdown('Pickup priority', {'Nearest'}, {'Nearest','Rarest','Best weapon','Ammo first'}, false)

            local config = self:Tab('Config')
            local profiles = config:SubTab('Profiles')
            local profSection = profiles:Section('Manage')
            profSection:Textbox('Profile name', 'default')
            profSection:Button('Save', function() self:Notification('Profile saved', 3) end)
            profSection:Button('Load', function() self:Notification('Profile loaded', 3) end)
            profSection:Dropdown('Active profile', {'default'}, {'default','rage','legit','hvh','casual'}, false)

            local layout = self:Tab('Layout')
            local leftRight = layout:Section('Columns')
            local ll = leftRight:Left()
            ll:Toggle('Left toggle 1', false); ll:Toggle('Left toggle 2', true)
            ll:Slider('Left slider', 50, 1, 0, 100, '%')
            ll:Button('Left button', function() self:Notification('Left!', 2) end)
            local rr = leftRight:Right()
            rr:Toggle('Right toggle 1', true); rr:Toggle('Right toggle 2', false)
            rr:Slider('Right slider', 75, 1, 0, 100, '%')
            rr:Dropdown('Right dropdown', {'A'}, {'A','B','C','D','E'}, false)

            local overflow = layout:Section('Overflow Test')
            for i = 1, 15 do overflow:Toggle('Item #'..tostring(i), i%3==0) end

            local _, menuSettings = self:CreateSettingsTab('Settings', {
                watermark = true, backgroundAlpha = true, customTitle = true,
                backgroundImage = true, theming = true,
                onAlphaChange   = function(a) self:Notification(string.format('BG opacity: %d%%', math.floor(a*100)), 2) end,
                onBgImageChange = function(f) self:Notification(f~='' and 'Foto: '..f or 'Foto temizlendi', 3) end,
                onPresetChange  = function(t) self:Notification('Tema: '..t, 3) end,
                onFontChange    = function(f) self:Notification('Font: '..f, 3) end,
            })

            local shouldDie = false
            menuSettings:Button('Unload', function() shouldDie = true end)
            menuSettings:Button('Fire notification', function()
                self:Notification('Test: '..tostring(math.floor(os.clock())), 5)
            end)
            menuSettings:Button('Center menu', function()
                self:CenterMenu(); self:Notification('Menu ortalandi', 2)
            end)

            self:Notification('UILib v2 demo yuklendi', 5)

            while not shouldDie do
                if animOn then meterSlider:Set(math.floor(math.sin(os.clock()*3)*100)) end
                self:Step()
            end

            self:Unload()
            return true
        end
    end
