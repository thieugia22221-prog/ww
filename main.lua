--==================================================
-- MAIN.LUA - STANDARD LOADER
--==================================================

repeat task.wait() until game:IsLoaded()

-- Services
local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")

local player = Players.LocalPlayer

--==================================================
-- API CONFIG (BẮT BUỘC)
--==================================================
local API_BASE = "https://join-server.pages.dev" -- CHỈ DOMAIN, KHÔNG ?xxx

--==================================================
-- HELPER
--==================================================
local function post(endpoint, data)
    local ok, res = pcall(function()
        return game:HttpPost(
            API_BASE .. endpoint,
            HttpService:JSONEncode(data),
            Enum.HttpContentType.ApplicationJson
        )
    end)

    if not ok then
        warn("[API ERROR]", res)
        return nil
    end

    return res
end

--==================================================
-- PAYLOAD (TRÁNH LỖI Missing payload)
--==================================================
local payload = {
    placeId = game.PlaceId,
    jobId = game.JobId,
    userId = player.UserId,
    username = player.Name
}

--==================================================
-- CHECK API
--==================================================
do
    local ok, res = pcall(function()
        return game:HttpGet(API_BASE .. "/health")
    end)

    if not ok then
        warn("❌ API không truy cập được")
        return
    end
end

--==================================================
-- MAIN REQUEST
--==================================================
local response = post("/items/simple", payload)

if not response then
    warn("❌ Không nhận được response từ API")
    return
end

--==================================================
-- HANDLE RESPONSE
--==================================================
local data
pcall(function()
    data = HttpService:JSONDecode(response)
end)

if not data then
    warn("❌ Response không phải JSON")
    return
end

print("✅ API RESPONSE:", data)

-- Ví dụ xử lý data
if data.success then
    print("🎉 Thành công")
else
    warn("⚠️ API trả lỗi:", data.message)
end
