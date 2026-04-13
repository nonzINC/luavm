local MemoryManager = {}

local memory_read = memory_read
local Vector3_new = Vector3.new
local pcall       = pcall
local type        = type
local tonumber    = tonumber

local OFFSETS_URL = "https://offsets.ntgetwritewatch.workers.dev/offsets.json"

local OFF
do
    local HttpService = game:GetService("HttpService")
    local body = game:HttpGet(OFFSETS_URL)
    local parsed = HttpService:JSONDecode(body)

    local function asHex(v)
        if type(v) == "number" then return v end
        if type(v) == "string" then
            local n = tonumber(v)
            if n then return n end
            return tonumber((v:gsub("^0x", "")), 16)
        end
        return nil
    end

    local p = asHex(parsed.Primitive)
    local c = asHex(parsed.CFrame)
    local r = asHex(parsed.FrameRotation)
    assert(p and c and r, "MemoryManager: offset fetch missing fields")

    OFF = { Primitive = p, CFrame = c, FrameRotation = r }
end

MemoryManager.Offsets = OFF

local function resolveAddr(v)
    if type(v) == "number" then
        return (v > 4096) and v or nil
    end
    if type(v) == "table" or type(v) == "userdata" then
        local okA, addr = pcall(function() return v.Address end)
        if okA and type(addr) == "number" and addr > 4096 then return addr end
    end
    return nil
end

-- m[0..2]=right, m[3..5]=up, m[6..8]=-look
function MemoryManager.GetRotationMatrix(part)
    local addr = resolveAddr(part)
    if not addr then return nil end

    local okPrim, prim = pcall(memory_read, "uintptr_t", addr + OFF.Primitive)
    if not okPrim or type(prim) ~= "number" or prim <= 4096 then return nil end

    local base = prim + OFF.CFrame
    local m = {}
    for i = 0, 8 do
        local okR, v = pcall(memory_read, "float", base + i * 4)
        if not okR or type(v) ~= "number" then return nil end
        m[i] = v
    end
    return m
end

function MemoryManager.GetLookVector(part)
    local m = MemoryManager.GetRotationMatrix(part)
    if not m then return nil end
    return Vector3_new(-m[2], -m[5], -m[8])
end

function MemoryManager.GetRightVector(part)
    local m = MemoryManager.GetRotationMatrix(part)
    if not m then return nil end
    return Vector3_new(m[0], m[3], m[6])
end

function MemoryManager.GetUpVector(part)
    local m = MemoryManager.GetRotationMatrix(part)
    if not m then return nil end
    return Vector3_new(m[1], m[4], m[7])
end

function MemoryManager.GetGuiObjectRotation(addrOrInstance)
    local addr = resolveAddr(addrOrInstance)
    if not addr then return nil end
    local ok, rot = pcall(memory_read, "float", addr + OFF.FrameRotation)
    if not ok or type(rot) ~= "number" then return nil end
    return rot
end

return MemoryManager
