--# MAIN
local ffi = require "ffi"
local anti_aim = require ("gamesense/antiaim_funcs") or error("Failed to load antiaim_funcs | https://gamesense.pub/forums/viewtopic.php?id=29665")
local clipboard = require("gamesense/clipboard") or error("Failed to load clipboard | https://gamesense.pub/forums/viewtopic.php?id=28678")
local base64 = require("gamesense/base64") or error("Failed to load base64 | https://gamesense.pub/forums/viewtopic.php?id=21619")
local ent = require("gamesense/entity")
local bit = require("bit")
local bitband = bit.band
local screen_size, local_player = { client.screen_size() }, ent.get_local_player
local x, y = client.screen_size()
lerp = function(a, b, t)
    return a + (b - a) * t
end
RGBAtoHEX = function(redArg, greenArg, blueArg, alphaArg)
    return string.format('%.2x%.2x%.2x%.2x', redArg, greenArg, blueArg, alphaArg)
end

local function table_contains(table, element)
    for _, value in pairs(table) do
        if value == element then
            return true
        end
    end
    return false
end
local notification = function(x, y, r, g, b, r2, g2, b2, a2, font, text, r3, g3, b3, a3)
    local size = renderer.measure_text(font, text)
    -- Rect Up
    renderer.rectangle(x - size/2, y, size, 1, r2, g2, b2, a2)
    -- Rect Down
    renderer.rectangle(x - size/2, y + 22, size, 1, r2, g2, b2, a2)
    -- Rect Middle
    renderer.rectangle(x - size/2, y + 1, size, 21, r2, g2, b2, a2)
    renderer.rectangle(x - size/2 - 1, y + 2, 1, 19, r2, g2, b2, a2)
    renderer.rectangle(x - size/2 - 2, y + 3, 1, 17, r2, g2, b2, a2)
    renderer.rectangle(x - size/2 + size, y + 2, 1, 19, r2, g2, b2, a2)
    renderer.rectangle(x - size/2 + size + 1, y + 3, 1, 17, r2, g2, b2, a2)
        -- Color
        renderer.rectangle(x - size/2, y - 1, size, 1, r, g, b ,255)
        renderer.rectangle(x - size/2 - 1, y, 1, 1, r, g, b ,255)
        renderer.rectangle(x - size/2 + size, y, 1, 1, r, g, b ,255)
        renderer.rectangle(x - size/2 - 2, y + 1, 1, 1, r, g, b ,255)
        renderer.rectangle(x - size/2 + size + 1, y + 1, 1, 1, r, g, b ,255)
        renderer.rectangle(x - size/2 + size + 2, y + 2, 1, 5, r, g, b ,255)
        renderer.rectangle(x - size/2 - 3, y + 2, 1, 5, r, g, b ,255)
        renderer.rectangle(x - size/2 + size + 2, y + 7, 1, 3, r, g, b, 225)
        renderer.rectangle(x - size/2 - 3, y + 7, 1, 3, r, g, b, 225)
        renderer.rectangle(x - size/2 + size + 2, y + 10, 1, 3, r, g, b, 175)
        renderer.rectangle(x - size/2 - 3, y + 10, 1, 3, r, g, b, 175)
        renderer.rectangle(x - size/2 + size + 2, y + 13, 1, 3, r, g, b, 125)
        renderer.rectangle(x - size/2 - 3, y + 13, 1, 3, r, g, b, 125)
        renderer.rectangle(x - size/2 + size + 2, y + 16, 1, 5, r, g, b, 75)
        renderer.rectangle(x - size/2 - 3, y + 16, 1, 5, r, g, b, 75)
        renderer.rectangle(x - size/2 - 1, y + 22, 1, 1, r, g, b ,65)
        renderer.rectangle(x - size/2 + size, y + 22, 1, 1, r, g, b ,65)
        renderer.rectangle(x - size/2 - 2, y + 21, 1, 1, r, g, b ,65)
        renderer.rectangle(x - size/2 + size + 1, y + 21, 1, 1, r, g, b ,65)
        renderer.rectangle(x - size/2, y + 23, size, 1, r, g, b ,65)
    -- Pixel Up
    renderer.rectangle(x - size/2 - 2, y + 2, 1, 1, r2, g2, b2, a2)
    renderer.rectangle(x - size/2 - 1, y + 1, 1, 1, r2, g2, b2, a2)

    renderer.rectangle(x - size/2 + size, y + 1, 1, 1, r2, g2, b2, a2)
    renderer.rectangle(x - size/2 + size + 1, y + 2, 1, 1, r2, g2, b2, a2)
    -- Pixel Down
    renderer.rectangle(x - size/2 - 1, y + 21, 1, 1, r2, g2, b2, a2)
    renderer.rectangle(x - size/2 - 2, y + 20, 1, 1, r2, g2, b2, a2)
    renderer.rectangle(x - size/2 + size, y + 21, 1, 1, r2, g2, b2, a2)
    renderer.rectangle(x - size/2 + size + 1, y + 20, 1, 1, r2, g2, b2, a2)
    -- Text
    renderer.text(x - size/2, y + 5, r3, g3, b3, a3, font, 0, text)
end
local welcomer = false
local welcomervector = 0
local welcomertime = 0
local welcomerlist = {}
table.insert(welcomerlist, " Welcome to Actimel.dev ")
local function welcomerfunc()
    if welcomertime >= 0 and welcomertime < 740 then
        welcomertime = welcomertime + 1
    end
    if welcomertime == 10 then
        welcomer = true
    elseif welcomertime == 700 then
        welcomer = false
    elseif welcomertime == 740 then
        table.remove(welcomerlist, 1)
    end
    if welcomer == true then
        welcomervector = lerp(welcomervector,0,globals.frametime() * 15)
    else
        welcomervector = lerp(welcomervector,200,globals.frametime() * 15)
    end
    if #welcomerlist == 1 then
        notification(x/2, y/1.2 + welcomervector, 142,165,229, 25,25,25,100, "nil",welcomerlist[1], 255,255,255,255)
    end
end

local refs = {
	enable = ui.reference("AA", "Anti-aimbot angles", "Enabled"),
	pitch = ui.reference("AA", "Anti-aimbot angles", "pitch"),
    yawjitter = { ui.reference("AA", "Anti-aimbot angles", "yaw jitter") },
	yawbase = ui.reference("AA", "Anti-aimbot angles", "Yaw base"),
    bodyyaw = { ui.reference("AA", "Anti-aimbot angles", "Body yaw") },
	yaw = { ui.reference("AA", "Anti-aimbot angles", "Yaw") },
    --fakeyaw = ui.reference("AA", "anti-aimbot angles", "Fake yaw limit"),
    freestand = { ui.reference("AA", "anti-aimbot angles", "freestanding") },
    fsbodyyaw = ui.reference("AA", "anti-aimbot angles", "Freestanding body yaw"),
    edgeyaw = ui.reference("AA", "Anti-aimbot angles", "Edge yaw"),
    roll = ui.reference("AA", "Anti-aimbot angles", "roll"),
    slow = { ui.reference("AA", "Other", "Slow motion") },
    minimum_damage = ui.reference("RAGE", "Aimbot", "Minimum damage"),
    dt = {ui.reference("RAGE", "aimbot", "Double tap")},
    baim = ui.reference("RAGE", "aimbot", "Force body aim"),
    safepint = ui.reference("RAGE", "Aimbot", "Force safe point"),
    --dt2 = ui.reference("RAGE", "Other", "Double tap mode"),
    fd = ui.reference("RAGE", "Other", "Duck peek assist"),
    qp = {ui.reference("RAGE", "Other", "Quick peek assist")},
    os = {ui.reference("AA", "Other", "On shot anti-aim")},
    ping = {ui.reference("MISC", "Miscellaneous", "Ping spike")},
    legmovement = ui.reference("AA", "other", "leg movement"),
    playerlist_ref = ui.reference("players", "players", "player list"),
    override_baim_ref = ui.reference("players", "adjustments", "Override prefer body aim"),
    override_safepoint_ref = ui.reference("players", "adjustments", "Override safe point"),
}


--# Menu

local menu = {

    enable = ui.new_combobox("AA", "Anti-aimbot angles", "\a848484BB[\aAEB9E2FFActimel\a848484BB] \aFFFFFFBBSwitcher", "Disable", "Enable"),
    label = ui.new_label("AA", "Anti-aimbot angles", " "),
    tab = ui.new_combobox("AA", "Anti-aimbot angles", "\a848484BB[\aAEB9E2FFActimel\a848484BB] \aFFFFFFBBSelect category", "Information", "Anti-Aim", "Ragebot", "Visuals", "Misc"),
    infolabel1 = ui.new_label("AA", "Anti-aimbot angles", "» Welcome to Actimel.dev"),
    infolabel2 = ui.new_label("AA", "Anti-aimbot angles", "» Build: BETA 1.0.0"),
    emptylabel1 = ui.new_label("AA", "Anti-aimbot angles", " "),
    ragebot_label = ui.new_label("AA", "Anti-aimbot angles", "\aAEB9E2FF------------------{ \aFFFFFFBBRagebot\aAEB9E2FF }-----------------"),
    visuals_label = ui.new_label("AA", "Anti-aimbot angles", "\aAEB9E2FF-------------------{ \aFFFFFFBBVisuals\aAEB9E2FF }------------------"),
    misc_label = ui.new_label("AA", "Anti-aimbot angles", "\aAEB9E2FF--------------------{ \aFFFFFFBBMisc\aAEB9E2FF }--------------------"),
    b_prediction = ui.new_combobox("AA", "Anti-aimbot angles", "\a848484BB[\aAEB9E2FFRage\a848484BB] \aFFFFFFBBBetter prediction", "Off", "Instant"),
    f_baim = ui.new_multiselect("AA", "Anti-aimbot angles", "\a848484BB[\aAEB9E2FFRage\a848484BB] \aFFFFFFBBBody Prefers", "HP lower than X", "After X misses"),
    f_baimmis = ui.new_slider("AA", "Anti-aimbot angles", "\a848484BB[\aAEB9E2FFBody\a848484BB] \aFFFFFFBBAfter X misses", 1, 8, 2, true, "x"),
    f_baimmishp = ui.new_slider("AA", "Anti-aimbot angles", "\a848484BB[\aAEB9E2FFBody\a848484BB] \aFFFFFFBBLower than X", 2, 100, 50, true, "hp"),
    sp_baim = ui.new_multiselect("AA", "Anti-aimbot angles", "\a848484BB[\aAEB9E2FFRage\a848484BB] \aFFFFFFBBSafepoint Prefers", "HP lower than X", "After X misses"),
    sp_baimmis = ui.new_slider("AA", "Anti-aimbot angles", "\a848484BB[\aAEB9E2FFSafepoint\a848484BB] \aFFFFFFBBAfter X misses", 1, 8, 2, true, "x"),
    sp_baimmishp = ui.new_slider("AA", "Anti-aimbot angles", "\a848484BB[\aAEB9E2FFSafepoint\a848484BB] \aFFFFFFBBLower than X", 2, 100, 50, true, "hp"),
    animfix = ui.new_combobox("AA", "Anti-aimbot angles", "\a848484BB[\aAEB9E2FFClient-Side\a848484BB] \aFFFFFFBBAnimations breaker", "Off", "Classic", "Modern"),
    forcedefensive = ui.new_combobox("AA", "Anti-aimbot angles", "\a848484BB[\aAEB9E2FFClient-Side\a848484BB] \aFFFFFFBBForce defensive", "Off", "On"),
    Manualaa = ui.new_combobox("AA", "Anti-aimbot angles", "\a848484BB[\aAEB9E2FFAnti-Aim\a848484BB] \aFFFFFFBBManual anti-aim", "Off", "On"),
    AntiHit = ui.new_combobox("AA", "Anti-aimbot angles", "\a848484BB[\aAEB9E2FFAnti-Aim\a848484BB] \aFFFFFFBBAnti-Hit Exploit", "Off", "On"),
    killsay = ui.new_combobox("AA", "Anti-aimbot angles", "\a848484BB[\aAEB9E2FFChat\a848484BB] \aFFFFFFBBKillsay", "Off", "English", "Russian"),
    binds_label = ui.new_label("AA", "Anti-aimbot angles", "\aAEB9E2FF--------------------{ \aFFFFFFBBBinds\aAEB9E2FF }--------------------"),
    freestandinghotkey = ui.new_hotkey("AA", "Anti-aimbot angles", "\a848484BB[\aAEB9E2FFBind\a848484BB] \aFFFFFFBBFreestanding"),
    Manualaaleft = ui.new_hotkey("AA", "Anti-aimbot angles", "\a848484BB[\aAEB9E2FFBind\a848484BB] \aFFFFFFBBManual left"),
    Manualaaright = ui.new_hotkey("AA", "Anti-aimbot angles", "\a848484BB[\aAEB9E2FFBind\a848484BB] \aFFFFFFBBManual right"),
    dmgindicator = ui.new_combobox("AA", "Anti-aimbot angles", "\a848484BB[\aAEB9E2FFScreen\a848484BB] \aFFFFFFBBDamage indicator", "Off", "On"),
    watermark = ui.new_combobox("AA", "Anti-aimbot angles", "\a848484BB[\aAEB9E2FFScreen\a848484BB] \aFFFFFFBBWatermark", "Off", "Down center", "Modern"),
    indicators = ui.new_combobox("AA", "Anti-aimbot angles", "\a848484BB[\aAEB9E2FFScreen\a848484BB] \aFFFFFFBBIndicators", "Off", "Modern", "Acatel"),
    aimbotlogs = ui.new_multiselect("AA", "Anti-aimbot angles", "\a848484BB[\aAEB9E2FFScreen\a848484BB] \aFFFFFFBBAimbot logs", "Console", "Under crosshair"),
    color_label = ui.new_label("AA", "Anti-aimbot angles", "\aAEB9E2FF--------------------{ \aFFFFFFBBColors\aAEB9E2FF }-----------------"),
    indicatorscolorlabel = ui.new_label("AA", "Anti-aimbot angles", "\a848484BB[\aAEB9E2FFColor\a848484BB] \aFFFFFFBBIndicators Color"),
    indicatorscolor = ui.new_color_picker("AA", "Anti-aimbot angles", "Ind", 255,255,255,255),
    watermarkcolorlabel = ui.new_label("AA", "Anti-aimbot angles", "\a848484BB[\aAEB9E2FFColor\a848484BB] \aFFFFFFBBWatermark color"),
    watermarkcolor = ui.new_color_picker("AA", "Anti-aimbot angles", "Water", 255,255,255,255),
    aimbotlogscolorlabel = ui.new_label("AA", "Anti-aimbot angles", "\a848484BB[\aAEB9E2FFColor\a848484BB] \aFFFFFFBBLogs hit color"),
    aimbotlogscolor = ui.new_color_picker("AA", "Anti-aimbot angles", "Hit", 142,165,229,80),
    aimbotlogscolorlabel2 = ui.new_label("AA", "Anti-aimbot angles", "\a848484BB[\aAEB9E2FFColor\a848484BB] \aFFFFFFBBLogs miss color"),
    aimbotlogscolor2 = ui.new_color_picker("AA", "Anti-aimbot angles", "Miss", 209,136,136,80),


}

--# Anti-aim

Antiaim = {}

local var = {
    player_states = {"Standing", "Moving", "Jumping", "Jumping-Duck", "Crouching", "Slowwalk"},
	player_states_idx = {["Standing"] = 1, ["Moving"] = 2, ["Jumping"] = 3, ["Jumping-Duck"] = 4, ["Crouching"] = 5, ["Slowwalk"] = 6},
    p_state = 0
}


Antiaim[0] = {
    Condition = ui.new_combobox("AA", "Anti-aimbot angles", "\a848484BB[\aAEB9E2FFAnti-Aim\a848484BB] \aFFFFFFBBCondition:", var.player_states),
}


for i = 1,6 do 
	Antiaim[i] ={
        Pitch = ui.new_combobox("AA", "Anti-aimbot angles", "\a848484BB[\aAEB9E2FF"..string.sub(var.player_states[i],1,1).."\a848484BB] \aFFFFFFBBPitch\n" ..var.player_states[i], "Off", "Default", "Up", "Down", "Minimal", "Random"),
        YawBase = ui.new_combobox("AA", "Anti-aimbot angles", "\a848484BB[\aAEB9E2FF"..string.sub(var.player_states[i],1,1).."\a848484BB] \aFFFFFFBBYaw Base\n" ..var.player_states[i] , "At targets", "Local view"),
        Yaw = ui.new_combobox("AA", "Anti-aimbot angles", "\a848484BB[\aAEB9E2FF"..string.sub(var.player_states[i],1,1).."\a848484BB] \aFFFFFFBBYaw\n" ..var.player_states[i] , "180", "Static", "5-Way"),
        YawLeft = ui.new_slider("AA", "Anti-aimbot angles", "\a848484BB[\aAEB9E2FF"..string.sub(var.player_states[i],1,1).."\a848484BB] \aFFFFFFBBYaw Add Left\n" ..var.player_states[i] , -180, 180, 0),
        YawRight = ui.new_slider("AA", "Anti-aimbot angles", "\a848484BB[\aAEB9E2FF"..string.sub(var.player_states[i],1,1).."\a848484BB] \aFFFFFFBBYaw Add Right\n" ..var.player_states[i] , -180, 180, 0),
        f_way1 = ui.new_slider("AA", "Anti-aimbot angles", "\a848484BB[\aAEB9E2FF1\a848484BB] \aFFFFFFBB5-Way Yaw\n" ..var.player_states[i] , -180, 180, 0),
        f_way2 = ui.new_slider("AA", "Anti-aimbot angles", "\a848484BB[\aAEB9E2FF2\a848484BB] \aFFFFFFBB5-Way Yaw\n" ..var.player_states[i] , -180, 180, 0),
        f_way3 = ui.new_slider("AA", "Anti-aimbot angles", "\a848484BB[\aAEB9E2FF3\a848484BB] \aFFFFFFBB5-Way Yaw\n" ..var.player_states[i] , -180, 180, 0),
        f_way4 = ui.new_slider("AA", "Anti-aimbot angles", "\a848484BB[\aAEB9E2FF4\a848484BB] \aFFFFFFBB5-Way Yaw\n" ..var.player_states[i] , -180, 180, 0),
        f_way5 = ui.new_slider("AA", "Anti-aimbot angles", "\a848484BB[\aAEB9E2FF5\a848484BB] \aFFFFFFBB5-Way Yaw\n" ..var.player_states[i] , -180, 180, 0),
        Jitter = ui.new_combobox("AA", "Anti-aimbot angles", "\a848484BB[\aAEB9E2FF"..string.sub(var.player_states[i],1,1).."\a848484BB] \aFFFFFFBBJitter Type\n" ..var.player_states[i] , "Off", "Center", "Offset", "Random"),
        JitterOffset = ui.new_slider("AA", "Anti-aimbot angles", "\a848484BB[\aAEB9E2FF"..string.sub(var.player_states[i],1,1).."\a848484BB] \aFFFFFFBBJitter Offset Left\n" ..var.player_states[i] , -180, 180, 0),
        BodyYaw = ui.new_combobox("AA", "Anti-aimbot angles", "\a848484BB[\aAEB9E2FF"..string.sub(var.player_states[i],1,1).."\a848484BB] \aFFFFFFBBBody Yaw\n" ..var.player_states[i] , "Off", "Anti-Bruteforce", "Jitter", "Static"),
        BodyYawValue = ui.new_slider("AA", "Anti-aimbot angles", "\n" ..var.player_states[i] , -180, 180, 0),
        Fakelimitl = ui.new_slider("AA", "Anti-aimbot angles", "\a848484BB[\aAEB9E2FF"..string.sub(var.player_states[i],1,1).."\a848484BB] \aFFFFFFBBFake limit Left\n" ..var.player_states[i] , 0, 60, 0),
        Fakelimitr = ui.new_slider("AA", "Anti-aimbot angles", "\a848484BB[\aAEB9E2FF"..string.sub(var.player_states[i],1,1).."\a848484BB] \aFFFFFFBBFake limit Right\n" ..var.player_states[i] , 0, 60, 0),
        emptylabel3 = ui.new_label("AA", "Anti-aimbot angles", " "),
	}
end
local function choking(cmd)
    local Choke = false

    if cmd.allow_send_packet == false or globals.chokedcommands() > 1 then
        Choke = true
    else
        Choke = false
    end

    return Choke
end
local tbl = {}
tbl.defensive = 0
tbl.checker = 0
client.set_event_callback("paint_ui", function()
    if not ui.get(refs.dt[2]) then
        tbl.defensive = 1
    end
	local local_player = entity.get_local_player()
	if not entity.is_alive(entity.get_local_player()) then return end
    local tickbase = entity.get_prop(entity.get_local_player(), "m_nTickBase")
    tbl.checker = math.max(tickbase, tbl.checker or 0)
    tbl.defensive = math.abs(tickbase - tbl.checker)
end)
up_abuse = function(cmd)            
    if (tbl.defensive > 3 and tbl.defensive < 14) and ui.get(menu.AntiHit) == "On" and (var.p_state == 3 or var.p_state == 4) and not ui.get(refs.fd) and ui.get(refs.dt[2]) then
        ui.set(refs.pitch,"Up")
        ui.set(refs.yaw[1], "Spin")
        ui.set(refs.yaw[2], 60)
        ui.set(refs.yawjitter[1], "Off")
        ui.set(refs.yawjitter[2], 0)
        ui.set(refs.bodyyaw[1], "Off")
        ui.set(refs.bodyyaw[2], 0)
    else
        return
    end
end

local current_stage = 1
local function antiaim_enable(cmd)
    local plocal = entity.get_local_player()
    local player_inverter = entity.get_prop(plocal, "m_flPoseParameter", 11) * 120 - 60 <= 0 and true or false

	local vx, vy, vz = entity.get_prop(plocal, "m_vecVelocity")

	local p_still = math.sqrt(vx ^ 2 + vy ^ 2) < 2
	local on_ground = bit.band(entity.get_prop(plocal, "m_fFlags"), 1) == 1
    local crouching = bit.band(entity.get_prop(plocal, "m_fFlags"), 1) == 1 and bit.band(entity.get_prop(plocal, "m_fFlags"), 4) == 4
    local air_crouch = bit.band(entity.get_prop(plocal, "m_fFlags"), 1) == 0 and bit.band(entity.get_prop(plocal, "m_fFlags"), 4) == 4
	local p_slow = ui.get(refs.slow[1]) and ui.get(refs.slow[2])
    if p_still == true and on_ground == true then
	    var.p_state = 1
    end
    if p_still == false and on_ground == true then
	    var.p_state = 2
    end
    if on_ground == false then
	    var.p_state = 3
    end
    if air_crouch == true then
	    var.p_state = 4
    end
    if crouching == true then
	    var.p_state = 5
    end
    if p_slow == true then
	    var.p_state = 6
    end
    --ui.set(refs.freestand[1],"Default")
    if ui.get(menu.freestandinghotkey) then
        ui.set(refs.freestand[2],"Always On")
    else
        ui.set(refs.freestand[2],"On Hotkey")
    end

    if ui.get(menu.enable) == "Enable" then
        
        if ui.get(menu.Manualaa) == "On" then
            if ui.get(menu.Manualaaleft) then
                ui.set(refs.yawbase, "Local view")
                ui.set(refs.yaw[2], -90)
                ui.set(refs.yawjitter[2], 0)
            elseif ui.get(menu.Manualaaright) then
                ui.set(refs.yawbase, "Local view")
                ui.set(refs.yaw[2], 90)
                ui.set(refs.yawjitter[2], 0)
                ui.set(refs.bodyyaw[1], "Off")
            end
        end
    if not ui.get(menu.Manualaaleft) and not ui.get(menu.Manualaaright) then
        if ui.get(Antiaim[var.p_state].Yaw) == "5-Way" then
            ui.set(refs.yaw[1], "180")
            local five_ways = {ui.get(Antiaim[var.p_state].f_way1), ui.get(Antiaim[var.p_state].f_way2), ui.get(Antiaim[var.p_state].f_way3), ui.get(Antiaim[var.p_state].f_way4), ui.get(Antiaim[var.p_state].f_way5)}
            if cmd.command_number % 4 > 1 and choking(cmd) == false then
                current_stage = current_stage + 1
            end
            if current_stage == 6 then
                current_stage = 1
            end
            ui.set(refs.yaw[2], five_ways[current_stage])
        end
        ui.set(refs.enable, true)
        ui.set(refs.pitch, ui.get(Antiaim[var.p_state].Pitch))
        ui.set(refs.yawbase, ui.get(Antiaim[var.p_state].YawBase))
        if ui.get(Antiaim[var.p_state].Yaw) ~= "5-Way" then
            ui.set(refs.yaw[1], ui.get(Antiaim[var.p_state].Yaw))
        end
        ui.set(refs.yawjitter[1], ui.get(Antiaim[var.p_state].Jitter))
        ui.set(refs.yawjitter[2], ui.get(Antiaim[var.p_state].JitterOffset))
        ui.set(refs.bodyyaw[2], ui.get(Antiaim[var.p_state].BodyYawValue))
        if ui.get(Antiaim[var.p_state].BodyYaw) == "Anti-Bruteforce" then
            ui.set(refs.bodyyaw[1], "Opposite")
        elseif ui.get(Antiaim[var.p_state].BodyYaw) == "Jitter" then
            ui.set(refs.bodyyaw[1], "Jitter")
        elseif ui.get(Antiaim[var.p_state].BodyYaw) == "Static" then
            ui.set(refs.bodyyaw[1], "Static")
        elseif ui.get(Antiaim[var.p_state].BodyYaw) == "Off" then
            ui.set(refs.bodyyaw[1], "Off")
        end
        if player_inverter == true then
            if ui.get(Antiaim[var.p_state].Yaw) ~= "5-Way" then
                ui.set(refs.yaw[2], ui.get(Antiaim[var.p_state].YawRight))
            end
            --ui.set(refs.fakeyaw, ui.get(Antiaim[var.p_state].Fakelimitr))
        else
            if ui.get(Antiaim[var.p_state].Yaw) ~= "5-Way" then
                ui.set(refs.yaw[2], ui.get(Antiaim[var.p_state].YawLeft))
            end
            --ui.set(refs.fakeyaw, ui.get(Antiaim[var.p_state].Fakelimitl))
            end
        end
    else
        ui.set(refs.enable, false)
    end
    up_abuse(cmd)
end
local function manual_aa_draw()
    if ui.get(menu.Manualaa) then
        if ui.get(menu.Manualaaleft) then
            renderer.indicator(210,210,210,255,"Manual: Left")
        elseif ui.get(menu.Manualaaright) then
            renderer.indicator(210,210,210,255,"Manual: Right")
        end
    end
end

-- Configs

local function export_config()
	local settings = {}
	for key, value in pairs(var.player_states) do
		settings[tostring(value)] = {}
		for k, v in pairs(Antiaim[key]) do
			settings[value][k] = ui.get(v)
		end
	end
	client.exec("play ui/beepclear;")
    clipboard.set("Actimel_"..base64.encode(json.stringify(settings), 'base64'))
end
export_btn = ui.new_button("AA", "Anti-aimbot angles", "export settings", export_config)
local function import_config()

	local settings = json.parse(base64.decode(string.sub(clipboard.get(),8,-1), 'base64'))

	for key, value in pairs(var.player_states) do
		for k, v in pairs(Antiaim[key]) do
			local current = settings[value][k]
			if (current ~= nil) then
				ui.set(v, current)
                client.exec("play ui/beepclear;")
			end
		end
	end
end
import_btn = ui.new_button("AA", "Anti-aimbot angles", "import settings", import_config)

local function default_config()

    defaultkfg = 'Actimel_eyJTdGFuZGluZyI6eyJmX3dheTQiOjAsImZfd2F5MSI6MCwiSml0dGVyT2Zmc2V0Ijo1NCwiSml0dGVyIjoiQ2VudGVyIiwiZl93YXk1IjowLCJZYXdMZWZ0IjotMTAsImZfd2F5MiI6MCwiRmFrZWxpbWl0bCI6NjAsImZfd2F5MyI6MCwiQm9keVlhd1ZhbHVlIjotMzksIllhd0Jhc2UiOiJBdCB0YXJnZXRzIiwiWWF3IjoiMTgwIiwiQm9keVlhdyI6IkppdHRlciIsIlBpdGNoIjoiRGVmYXVsdCIsImVtcHR5bGFiZWwzIjoiICIsIkZha2VsaW1pdHIiOjYwLCJZYXdSaWdodCI6MTB9LCJDcm91Y2hpbmciOnsiZl93YXk0IjowLCJmX3dheTEiOjAsIkppdHRlck9mZnNldCI6NTQsIkppdHRlciI6IkNlbnRlciIsImZfd2F5NSI6MCwiWWF3TGVmdCI6LTEyLCJmX3dheTIiOjAsIkZha2VsaW1pdGwiOjYwLCJmX3dheTMiOjAsIkJvZHlZYXdWYWx1ZSI6MCwiWWF3QmFzZSI6IkF0IHRhcmdldHMiLCJZYXciOiIxODAiLCJCb2R5WWF3IjoiSml0dGVyIiwiUGl0Y2giOiJEZWZhdWx0IiwiZW1wdHlsYWJlbDMiOiIgIiwiRmFrZWxpbWl0ciI6NjAsIllhd1JpZ2h0IjoxMH0sIkp1bXBpbmctRHVjayI6eyJmX3dheTQiOjAsImZfd2F5MSI6MCwiSml0dGVyT2Zmc2V0Ijo1MCwiSml0dGVyIjoiQ2VudGVyIiwiZl93YXk1IjowLCJZYXdMZWZ0IjotMTIsImZfd2F5MiI6MCwiRmFrZWxpbWl0bCI6NjAsImZfd2F5MyI6MCwiQm9keVlhd1ZhbHVlIjowLCJZYXdCYXNlIjoiQXQgdGFyZ2V0cyIsIllhdyI6IjE4MCIsIkJvZHlZYXciOiJKaXR0ZXIiLCJQaXRjaCI6IkRlZmF1bHQiLCJlbXB0eWxhYmVsMyI6IiAiLCJGYWtlbGltaXRyIjo2MCwiWWF3UmlnaHQiOjI1fSwiTW92aW5nIjp7ImZfd2F5NCI6LTE2LCJmX3dheTEiOjMwLCJKaXR0ZXJPZmZzZXQiOjUyLCJKaXR0ZXIiOiJDZW50ZXIiLCJmX3dheTUiOi0zMiwiWWF3TGVmdCI6LTEyLCJmX3dheTIiOjE4LCJGYWtlbGltaXRsIjo2MCwiZl93YXkzIjowLCJCb2R5WWF3VmFsdWUiOjAsIllhd0Jhc2UiOiJBdCB0YXJnZXRzIiwiWWF3IjoiMTgwIiwiQm9keVlhdyI6IkppdHRlciIsIlBpdGNoIjoiRGVmYXVsdCIsImVtcHR5bGFiZWwzIjoiICIsIkZha2VsaW1pdHIiOjYwLCJZYXdSaWdodCI6MTZ9LCJTbG93d2FsayI6eyJmX3dheTQiOjAsImZfd2F5MSI6MCwiSml0dGVyT2Zmc2V0Ijo2MSwiSml0dGVyIjoiQ2VudGVyIiwiZl93YXk1IjowLCJZYXdMZWZ0IjotNywiZl93YXkyIjowLCJGYWtlbGltaXRsIjo2MCwiZl93YXkzIjowLCJCb2R5WWF3VmFsdWUiOjAsIllhd0Jhc2UiOiJBdCB0YXJnZXRzIiwiWWF3IjoiMTgwIiwiQm9keVlhdyI6IkppdHRlciIsIlBpdGNoIjoiRGVmYXVsdCIsImVtcHR5bGFiZWwzIjoiICIsIkZha2VsaW1pdHIiOjYwLCJZYXdSaWdodCI6N30sIkp1bXBpbmciOnsiZl93YXk0IjowLCJmX3dheTEiOjAsIkppdHRlck9mZnNldCI6NTUsIkppdHRlciI6IkNlbnRlciIsImZfd2F5NSI6MCwiWWF3TGVmdCI6LTE0LCJmX3dheTIiOjAsIkZha2VsaW1pdGwiOjYwLCJmX3dheTMiOjAsIkJvZHlZYXdWYWx1ZSI6MCwiWWF3QmFzZSI6IkF0IHRhcmdldHMiLCJZYXciOiIxODAiLCJCb2R5WWF3IjoiSml0dGVyIiwiUGl0Y2giOiJEZWZhdWx0IiwiZW1wdHlsYWJlbDMiOiIgIiwiRmFrZWxpbWl0ciI6NjAsIllhd1JpZ2h0IjoxNH19'
	local settings = json.parse(base64.decode(string.sub(defaultkfg,8,-1), 'base64'))

	for key, value in pairs(var.player_states) do
		for k, v in pairs(Antiaim[key]) do
			local current = settings[value][k]
			if (current ~= nil) then
				ui.set(v, current)
                client.exec("play buttons/bell1.wav;")
			end
		end
	end
end
default_btn = ui.new_button("AA", "Anti-aimbot angles", "default settings", default_config)


--# Other
update_dt = 0
force_defensive = function(cmd)
    if ui.get(menu.forcedefensive) == "On" and update_dt + 0.2 < globals.curtime() then
        ui.set(refs.dt2, "Defensive")
        cmd.force_defensive = true
        update_dt = globals.curtime()
    end
end
animfix = function(cmd)
    if not entity.is_alive(entity.get_local_player()) then return end
    if not ui.get(menu.animfix) then return end
    local me = ent.get_local_player()
    local m_fFlags = me:get_prop("m_fFlags");
    local is_onground = bit.band(m_fFlags, 1) ~= 0;
    if ui.get(menu.animfix) == "Modern" then
        ui.set(refs.legmovement, "Never slide")
        entity.set_prop(entity.get_local_player(), "m_flPoseParameter", 1, 7)
        if not is_onground then
            local my_animlayer = me:get_anim_overlay(6);
            my_animlayer.weight = 1;
            entity.set_prop(me, "m_flPoseParameter", 1, 6)
        end
    elseif ui.get(menu.animfix) == "Classic" then
        ui.set(refs.legmovement, "Always slide")
        entity.set_prop(entity.get_local_player(), "m_flPoseParameter", 1, 0)
        entity.set_prop(entity.get_local_player(), "m_flPoseParameter", 1, 6)
    end
end


reason_counter = {}
reason_counter.spread = 0
reason_counter.death = 0
reason_counter.prediction_error = 0
reason_counter.unknown = 0
local chance,bt,predicted_damage,predicted_hitgroup
local hitgroup_names = {"Body", "Head", "Chest", "Stomach", "Left Arm", "Right Arm", "Left Leg", "Right Leg", "Neck", "?", "Gear"}

local pi, max = math.pi, math.max

local dynamic = {}
dynamic.__index = dynamic

function dynamic.new(f, z, r, xi)
   f = max(f, 0.001)
   z = max(z, 0)

   local pif = pi * f
   local twopif = 2 * pif

   local a = z / pif
   local b = 1 / ( twopif * twopif )
   local c = r * z / twopif

   return setmetatable({
      a = a,
      b = b,
      c = c,

      px = xi,
      y = xi,
      dy = 0
   }, dynamic)
end

function dynamic:update(dt, x, dx)
   if dx == nil then
      dx = ( x - self.px ) / dt
      self.px = x
   end

   self.y  = self.y + dt * self.dy
   self.dy = self.dy + dt * ( x + self.c * dx - self.y - self.a * self.dy ) / self.b
   return self
end

function dynamic:get()
   return self.y
end


local hitgroup_names = {'generic', 'head', 'chest', 'stomach', 'left arm', 'right arm', 'left leg', 'right leg', 'neck', '?', 'gear'}
local logs = {}

-------------------> FIRE FUNCTION <------------------- 
function aim_fire(e)
    chance = math.floor(e.hit_chance)
    bt = globals.tickcount() - e.tick
    predicted_damage = e.damage
    predicted_hitgroup = e.hitgroup
end

-------------------> HIT FUNCTION <------------------- 
function aim_hit(e)
   group = hitgroup_names[e.hitgroup + 1] or "?"
    name = entity.get_player_name(e.target)
    damage = e.damage
    hp_left = entity.get_prop(e.target, "m_iHealth")
    js = panorama.open()
    persona_api = js.MyPersonaAPI
    username = persona_api.GetName()  
    targetname = name;
    hitbox = group;
    dmg = damage;
    hc = chance;
    backtrack = bt;
    predicted_group = hitgroup_names[predicted_hitgroup + 1] or "?"

    if table_contains(ui.get(menu.aimbotlogs),"Under crosshair") then
        local string = string.format("Hit %s in the %s for %s damage (%s health remaining)", string.lower(entity.get_player_name(e.target)), string.lower(hitbox),e.damage, entity.get_prop(e.target, 'm_iHealth'))
        table.insert(logs, {
            text = string
        }) 
    end
    if table_contains(ui.get(menu.aimbotlogs),"Console") then
        print(string.format("Registered shot at %s's in the %s for %s damage (backtrack: %s | hitchance: %s)",name,string.lower(hitbox),damage,backtrack,hc))
    end
 
end

-------------------> MISS FUNCTION <------------------- 
function aim_miss(e)
    group = hitgroup_names[e.hitgroup + 1] or "?"
    name = entity.get_player_name(e.target)
    hp_left = entity.get_prop(e.target, "m_iHealth")
    js = panorama.open()
    persona_api = js.MyPersonaAPI
    username = persona_api.GetName()  
    targetname = name;
    hitbox = group;
    hc = chance;
    backtrack = bt;
    reason = e.reason

    predicted_group = hitgroup_names[predicted_hitgroup + 1] or "?"

    if reason == "?" then 
        reason = "resolver" 
        reason_counter.unknown = reason_counter.unknown + 1
    elseif reason == "spread" then
        reason_counter.spread = reason_counter.spread + 1
    elseif reason == "death" then
        reason_counter.death = reason_counter.death + 1
    elseif reason == "prediction error" then
        reason_counter.prediction_error = reason_counter.prediction_error + 1
    end

    if table_contains(ui.get(menu.aimbotlogs),"Under crosshair") then
        local string = string.format("Missed %s's %s due to %s (hitchance: %s)", string.lower(entity.get_player_name(e.target)),string.lower(predicted_group),reason,hc)
        table.insert(logs, {
            text = string
        })
    end

    if table_contains(ui.get(menu.aimbotlogs),"Console") then
        print(string.format("Missed %s's %s due to %s (hitchance: %s)", string.lower(entity.get_player_name(e.target)),string.lower(predicted_group),reason,hc))
    end

end


logging = function()
    local screen = {client.screen_size()}
    for i = 1, #logs do
        if not logs[i] then return end
        if not logs[i].init then
            logs[i].y = dynamic.new(2, 1, 1, -30)
            logs[i].time = globals.tickcount() + 180
            logs[i].init = true
        end

        local string_size = renderer.measure_text("c", logs[i].text)
        local hitcolor2 = {ui.get(menu.aimbotlogscolor)};
        local miscolor2 = {ui.get(menu.aimbotlogscolor2)};
        local renderstring = " "..logs[i].text.." "
        if string.sub(logs[i].text, 1, 1) == "H" then
            notification(screen[1]/2+5, screen[2] / 2 + 400 -logs[i].y:get()+39, hitcolor2[1], hitcolor2[2], hitcolor2[3], 25,25,25,hitcolor2[4], "nil",renderstring, 255,255,255,255)
        elseif string.sub(logs[i].text, 1, 1) == "M" then
            notification(screen[1]/2+5, screen[2] / 2 + 400 -logs[i].y:get()+39, miscolor2[1], miscolor2[2], miscolor2[3], 25,25,25,miscolor2[4], "nil",renderstring, 255,255,255,255)
        end

        get_max = (logs[i].time-globals.tickcount()) * string_size / 252
        --print(get_max)
        if #logs > 5 then
            table.remove(logs, 1)
        end
        if tonumber(logs[i].time) < globals.tickcount() then
            if logs[i].y:get() < -10 then
                table.remove(logs, i)
            else
                logs[i].y:update(globals.frametime(), -50, nil)
            end
        else
            logs[i].y:update(globals.frametime(), 5+(i*30), nil)
        end
    end
end
client.set_event_callback("aim_fire", aim_fire)
client.set_event_callback("aim_hit", aim_hit)
client.set_event_callback("aim_miss", aim_miss)

function doubletap_charged()
    if not ui.get(refs.dt[1]) or not ui.get(refs.dt[2]) or ui.get(refs.fd) then return false end
    if not entity.is_alive(entity.get_local_player()) or entity.get_local_player() == nil then return end
    local weapon = entity.get_prop(entity.get_local_player(), "m_hActiveWeapon")
    if weapon == nil then return false end
    local next_attack = entity.get_prop(entity.get_local_player(), "m_flNextAttack") + 0.25
	local checkcheck = entity.get_prop(weapon, "m_flNextPrimaryAttack")
	if checkcheck == nil then return end
    local next_primary_attack = checkcheck + 0.15
    if next_attack == nil or next_primary_attack == nil then return false end
    return next_attack - globals.curtime() < 0 and next_primary_attack - globals.curtime() < 0
end


old_indicator_spacing = 0
new_old_indicator_spacing = 0
indicator_spacing = 0
indicator_fade_dt = 0
indicator_fade_hs = 0
indicator_fade_fs = 0
indicator_fade_fd = 0
actimel = 0
state = 0
delta2 = 0
actimelbindsDT = 0
local function c_indicators()
        if not entity.is_alive(entity.get_local_player()) then return end
        local X,Y = client.screen_size()
        local color_out = {ui.get(menu.indicatorscolor)} 
        mainlerp = -10
        Acatel = 0
        indicator_spacing = 0
        local scoped = entity.get_prop(entity.get_local_player(), "m_bIsScoped") == 1


        local rx,gx,bx = ui.get(menu.indicatorscolor)

        local function create_color_array(r, g, b)
            local colorsx = {}
            for i = 0, 13 do
                local colorx = {rx, gx , bx, 255 * math.abs(1 * math.cos(2 * math.pi * globals.curtime() / 4 + i * 5 / 30))}
                table.insert(colorsx, colorx)
            end
            return colorsx
        end
        
        local aA = create_color_array(rx, gx, bx)
    

    if ui.get(menu.indicators) == "Modern" then
        if scoped then
            actimel = lerp(actimel,33,globals.frametime() * 15)
            actimelbindsDT = lerp(actimelbindsDT,7,globals.frametime() * 15)
        else 
            actimel = lerp(actimel,0,globals.frametime() * 15)
            actimelbindsDT = lerp(actimelbindsDT,-2,globals.frametime() * 15)
        end
        old_indicator_spacing = lerp(old_indicator_spacing,indicator_spacing, globals.frametime() * 15)
            renderer.text(X / 2 + actimel, Y / 2 + 20 + old_indicator_spacing , 50, 50, 50, 255, "cb", nil, "actimel.dev")
            renderer.text(X / 2 + actimel, Y / 2 + 20 + old_indicator_spacing , 255, 255, 255, 255, "cb", nil, string.format("\a%sa\a%sc\a%st\a%si\a%sm\a%se\a%sl\a%s.\a%sd\a%se\a%sv", RGBAtoHEX(unpack(aA[1])), RGBAtoHEX(unpack(aA[2])), RGBAtoHEX(unpack(aA[3])), RGBAtoHEX(unpack(aA[4])), RGBAtoHEX(unpack(aA[5])), RGBAtoHEX(unpack(aA[6])), RGBAtoHEX(unpack(aA[7])), RGBAtoHEX(unpack(aA[8])), RGBAtoHEX(unpack(aA[9])),RGBAtoHEX(unpack(aA[10])),RGBAtoHEX(unpack(aA[11])),RGBAtoHEX(unpack(aA[12])),RGBAtoHEX(unpack(aA[13]))))
            -- MAIN KITAXE
    
    
            -- BINDS
            if ui.get(refs.dt[1]) and ui.get(refs.dt[2]) then
                indicator_fade_dt = lerp(indicator_fade_dt,mainlerp,globals.frametime() * 15)
        
                renderer.text(X / 2 + actimelbindsDT, Y / 2 + 42 + indicator_spacing + indicator_fade_dt, 255,255,255,210,"-c",0,"DT")
                indicator_spacing = indicator_spacing + 1
                mainlerp = mainlerp + 9
    
            elseif not ui.get(refs.os[1]) or not ui.get(refs.os[2]) then
                indicator_fade_dt = lerp(indicator_fade_dt,mainlerp - 10,globals.frametime() * 15)
    
            end
    
            if ui.get(refs.os[1]) and ui.get(refs.os[2]) then
                indicator_fade_hs = lerp(indicator_fade_hs,mainlerp,globals.frametime() * 15)
    
                renderer.text(X / 2 + actimelbindsDT, Y / 2 + 42 + indicator_spacing + indicator_fade_hs, 255,255,255,210,"-c",0,"OS")

                indicator_spacing = indicator_spacing + 1
                mainlerp = mainlerp + 9
    
            elseif not ui.get(refs.os[1]) or not ui.get(refs.os[2]) then
                indicator_fade_hs = lerp(indicator_fade_hs,mainlerp - 10,globals.frametime() * 15)
    
            end


            if ui.get(menu.freestandinghotkey) then
                indicator_fade_fs = lerp(indicator_fade_fs,mainlerp,globals.frametime() * 15)
    
                renderer.text(X / 2 + actimelbindsDT, Y / 2 + 42 + indicator_spacing + indicator_fade_fs, 255,255,255,210,"-c",0,"FS")

                indicator_spacing = indicator_spacing + 1
                mainlerp = mainlerp + 9
    
            elseif not ui.get(menu.freestandinghotkey) then
                indicator_fade_fs = lerp(indicator_fade_fs,mainlerp - 10,globals.frametime() * 15)

            end
            
    
            if ui.get(refs.fd) then
                indicator_fade_fd = lerp(indicator_fade_fd,mainlerp,globals.frametime() * 15)
    
                renderer.text(X / 2 + actimelbindsDT, Y / 2 + 42 + indicator_spacing + indicator_fade_fd, 255,255,255,210,"-c",0,"FD")
                indicator_spacing = indicator_spacing + 1
                mainlerp = mainlerp + 9
    
            elseif not ui.get(refs.fd) then
                indicator_fade_fd = lerp(indicator_fade_fd,mainlerp - 10,globals.frametime() * 15)
    
        end
    end

    if ui.get(menu.indicators) == "Acatel" then
        local player_inverter = entity.get_prop(entity.get_local_player(), "m_flPoseParameter", 11) * 120 - 60 <= 0 and true or false
        local alphaold = math.min(math.floor(math.sin((globals.curtime()%3) * 5) * 175 + 200), 255)
        renderer.text(X/2 + 16, Y/2 + 30, 255,255,255,255,"-c",0,"ACTIMEL")
        renderer.text(X/2 + 42, Y/2 + 30, color_out[1], color_out[2], color_out[3],alphaold,"-c",0,"BETA")
        renderer.text(X/2 + 19, Y/2 + 38, 217,214,238,255,"-c",0,"FAKE YAW:")
        if player_inverter == true then
            renderer.text(X/2 + 41, Y/2 + 38, 255,255,255,255,"-c",0,"R")
        else
            renderer.text(X/2 + 41, Y/2 + 38, 255,255,255,255,"-c",0,"L")
        end
        if ui.get(refs.dt[1]) and ui.get(refs.dt[2]) then
            if doubletap_charged() and not ui.get(refs.qp[2]) then
                renderer.text(X/2 + 5, Y/2 + 46 + Acatel, 192,226,199,255,"-c",0,"DT")
                Acatel = Acatel + 8
            elseif not doubletap_charged() then
                renderer.text(X/2 + 5, Y/2 + 46 + Acatel, 255,50,0,180,"-c",0,"DT")
                Acatel = Acatel + 8
            elseif doubletap_charged() and ui.get(refs.qp[2]) then
                renderer.text(X/2 + 19, Y/2 + 46 + Acatel, 192,226,199,255,"-c",0,"IDEAL TICK")
                Acatel = Acatel + 8
            end
        end
        if ui.get(refs.baim) then
            renderer.text(X/2 + 10, Y/2 + 46 + Acatel, 255,255,255,255,"-c",0,"BAIM")
        else
            renderer.text(X/2 + 10, Y/2 + 46 + Acatel, 255,255,255,150,"-c",0,"BAIM")
        end
        if ui.get(refs.baim) then
            renderer.text(X/2 + 26, Y/2 + 46 + Acatel, 255,255,255,255,"-c",0,"SP")
        else
            renderer.text(X/2 + 26, Y/2 + 46 + Acatel, 255,255,255,150,"-c",0,"SP")
        end
        if ui.get(menu.freestandinghotkey) then
            renderer.text(X/2 + 37, Y/2 + 46 + Acatel, 255,255,255,255,"-c",0,"FS")
        else
            renderer.text(X/2 + 37, Y/2 + 46 + Acatel, 255,255,255,150,"-c",0,"FS")
        end
    end

end

local function watermark()
    local color_out = {ui.get(menu.watermarkcolor)} 
    local X,Y = client.screen_size()
    if  ui.get(menu.watermark) == "Down center" then
        renderer.text(X / 2,Y / 1.01,color_out[1],color_out[2],color_out[3],color_out[4],"bc",0,"A C T I M E L . D E V")
    end
    if  ui.get(menu.watermark) == "Modern" then
        local alphaold = math.min(math.floor(math.sin((globals.curtime()%3) * 5) * 125 + 200), 255)
        renderer.text(X / 16,Y / 1.96,255,255,255,255,"c",0,"/> actimel.dev multi-script preium [         ] </")
        renderer.text(X / 9.66,Y / 1.96,color_out[1],color_out[2],color_out[3],alphaold,"c",0,"beta")
    end
end

local kill_say_text = {'1v1? 2v2?','fix ur cfg niger','0.001839490  𝔟𝔱𝔠 𝔯𝔦𝔠𝔥𝖍','actimel $ prediction','You are the best at being dead','fix ur stats random','Я использую gamesense',
'I hate pasted luas thats why I use actimel.lua', 'go kys furry dog','不使用 skeet beta，我使用的是 actimel.lua'}

local kill_say_text2 = {"я щас так посрал что просто пиздец, я нахуй такую гороховую банку высрал у меня чуть ушные перепонки не взорвались нахуй","ты раб кадырова","7 радужных чеченцев идут в Москву","ыыыыыыыыыы ыыыыыы","ъ","а ты сувал себе банан в жопу?","бляа пизда седня слышу што-то жужит смотрю а у меня из штанов хуй как пчела улетает","тест влад луа","кто здесь","паймааааал пиупиу!!!! пиупиу ахххахаххаахахахахаааа!!!! пиупиу ихххихиххиии!!!!! ахахахаха!!!!","КАКААААШКИИИ!!!!! КАКАААААШКИИИИИ!!!!!!!!!!","с наступающим Новым Годом!",}

client.set_event_callback("player_death", function(e)

	if client.userid_to_entindex(e.target) == entity.get_local_player() then return end

	if client.userid_to_entindex(e.attacker) == entity.get_local_player() then
        if ui.get(menu.killsay) == "English" then
            local random_number = math.random(1,#kill_say_text)
            client.exec("say " .. kill_say_text[random_number])
        elseif ui.get(menu.killsay) == "Russian" then
            local random_number = math.random(1,#kill_say_text2)
            client.exec("say " .. kill_say_text2[random_number])
        end
	end
   
end)

local function betterprediction()
    if ui.get(menu.b_prediction) == "Off" then
        cvar.sv_maxupdaterate:set_int(64)
    elseif ui.get(menu.b_prediction) == "Instant" then
        cvar.sv_maxupdaterate:set_int(128)
    end
end

function dmgindicator()
    local me = entity.get_local_player()
    if not entity.is_alive(me) then return end
    if ui.get(menu.dmgindicator) == "On" then
        renderer.indicator(210,210,210,255, ui.get(refs.minimum_damage))
        renderer.text(screen_size[1] * 0.507,screen_size[2] * 0.48 ,255,255,255,255,"nil",0,ui.get(refs.minimum_damage))
    end
end

local miss = {}

local function on_aim_miss(e)
    local ent = e.target
    if miss[ent] then
        miss[ent] = miss[ent] + 1
    else
        miss[ent] = 1
    end
end


local function run_cmd(c)
    local baimafter = ui.get(menu.f_baimmis)
    local baimhp = ui.get(menu.f_baimmishp)
    if baimafter == 0 then return end

    local safepointafter = ui.get(menu.sp_baimmis)
    local safepointhp = ui.get(menu.sp_baimmishp)
    if safepintafter == 0 then return end

    local players = entity.get_players(true)
    for i=1, #players do
        local entindex = players[i]
        local enthp = entity.get_prop(entindex, "m_iHealth")

        if table_contains(ui.get(menu.f_baim),"After X misses") and not table_contains(ui.get(menu.f_baim),"HP lower than X") then
            if (miss[entindex] ~= nil and miss[entindex] >= baimafter) then
                ui.set(refs.playerlist_ref, entindex)
                ui.set(refs.override_baim_ref, "Force")
            else
                ui.set(refs.playerlist_ref, entindex)
                ui.set(refs.override_baim_ref, "-")
            end
        end
        if table_contains(ui.get(menu.f_baim),"HP lower than X") and not table_contains(ui.get(menu.f_baim),"After X misses") then
            if (enthp < baimhp) then
                ui.set(refs.playerlist_ref, entindex)
                ui.set(refs.override_baim_ref, "Force")
            else
                ui.set(refs.playerlist_ref, entindex)
                ui.set(refs.override_baim_ref, "-")
            end
        end
        if table_contains(ui.get(menu.f_baim),"After X misses") and table_contains(ui.get(menu.f_baim),"HP lower than X") then
            if (miss[entindex] ~= nil and miss[entindex] >= baimafter) and (enthp > baimhp) then
                ui.set(refs.playerlist_ref, entindex)
                ui.set(refs.override_baim_ref, "Force")
            elseif (enthp < baimhp) then
                ui.set(refs.playerlist_ref, entindex)
                ui.set(refs.override_baim_ref, "Force")
            else
                ui.set(refs.playerlist_ref, entindex)
                ui.set(refs.override_baim_ref, "-")
            end
        end
        if table_contains(ui.get(menu.sp_baim),"After X misses") and not table_contains(ui.get(menu.sp_baim),"HP lower than X") then
            if (miss[entindex] ~= nil and miss[entindex] >= safepointafter) then
                ui.set(refs.playerlist_ref, entindex)
                ui.set(refs.override_safepoint_ref, "On")
            else
                ui.set(refs.playerlist_ref, entindex)
                ui.set(refs.override_safepoint_ref, "-")
            end
        end
        if table_contains(ui.get(menu.sp_baim),"HP lower than X") and not table_contains(ui.get(menu.sp_baim),"After X misses") then
            if (enthp < safepointhp) then
                ui.set(refs.playerlist_ref, entindex)
                ui.set(refs.override_safepoint_ref, "On")
            else
                ui.set(refs.playerlist_ref, entindex)
                ui.set(refs.override_safepoint_ref, "-")
            end
        end
        if table_contains(ui.get(menu.sp_baim),"After X misses") and table_contains(ui.get(menu.sp_baim),"HP lower than X") then
            if (miss[entindex] ~= nil and miss[entindex] >= safepointafter) and (enthp > safepointhp) then
                ui.set(refs.playerlist_ref, entindex)
                ui.set(refs.override_safepoint_ref, "On")
            elseif (enthp < safepointhp) then
                ui.set(refs.playerlist_ref, entindex)
                ui.set(refs.override_safepoint_ref, "On")
            else
                ui.set(refs.playerlist_ref, entindex)
                ui.set(refs.override_safepoint_ref, "-")
            end
        end
    end
    if not entity.is_alive(entity.get_local_player()) then
        ui.set(refs.playerlist_ref, entindex)
        ui.set(refs.override_safepoint_ref, "-")
        ui.set(refs.override_baim_ref, "-")
    end
end



client.set_event_callback("player_death", function(e)
    local players = entity.get_players(true)
    if table_contains(ui.get(menu.f_baim),"After X misses") or table_contains(ui.get(menu.f_baim),"HP lower than X") then
        for i=1, #players do
            local entindex = players[i]
            ui.set(refs.playerlist_ref, entindex)
            ui.set(refs.override_baim_ref, "-")
            table.remove(miss, 1)
        end
    end
    if table_contains(ui.get(menu.sp_baim),"After X misses") or table_contains(ui.get(menu.sp_baim),"HP lower than X") then
        for i=1, #players do
            local entindex = players[i]
            ui.set(refs.playerlist_ref, entindex)
            ui.set(refs.override_safepoint_ref, "-")
            table.remove(miss, 1)
        end
    end
end)

--# Callbacks

local function on_load()
    --# Menu
    ui.set_visible(menu.label, ui.get(menu.enable) == "Enable")
    ui.set_visible(menu.tab, ui.get(menu.enable) == "Enable")
    ui.set_visible(menu.infolabel1, ui.get(menu.enable) == "Enable" and ui.get(menu.tab) == "Information")
    ui.set_visible(menu.infolabel2, ui.get(menu.enable) == "Enable" and ui.get(menu.tab) == "Information")
    --# Other
    ui.set_visible(menu.misc_label, ui.get(menu.enable) == "Enable" and ui.get(menu.tab) == "Misc")
    ui.set_visible(menu.animfix, ui.get(menu.enable) == "Enable" and ui.get(menu.tab) == "Misc")
    ui.set_visible(menu.forcedefensive, ui.get(menu.enable) == "Enable" and ui.get(menu.tab) == "Misc")
    ui.set_visible(menu.Manualaa, ui.get(menu.enable) == "Enable" and ui.get(menu.tab) == "Misc")
    ui.set_visible(menu.Manualaaright, ui.get(menu.enable) == "Enable" and ui.get(menu.tab) == "Misc" and ui.get(menu.Manualaa) == "On")
    ui.set_visible(menu.Manualaaleft, ui.get(menu.enable) == "Enable" and ui.get(menu.tab) == "Misc" and ui.get(menu.Manualaa) == "On")
    ui.set_visible(menu.killsay, ui.get(menu.enable) == "Enable" and ui.get(menu.tab) == "Misc")
    ui.set_visible(menu.freestandinghotkey, ui.get(menu.enable) == "Enable" and ui.get(menu.tab) == "Misc")
    ui.set_visible(menu.watermark, ui.get(menu.enable) == "Enable" and ui.get(menu.tab) == "Visuals")
    ui.set_visible(menu.visuals_label, ui.get(menu.enable) == "Enable" and ui.get(menu.tab) == "Visuals")
    ui.set_visible(menu.watermarkcolor, ui.get(menu.enable) == "Enable" and ui.get(menu.tab) == "Visuals" and (ui.get(menu.watermark) == "Down center" or ui.get(menu.watermark) == "Modern"))
    ui.set_visible(menu.watermarkcolorlabel, ui.get(menu.enable) == "Enable" and ui.get(menu.tab) == "Visuals" and (ui.get(menu.watermark) == "Down center" or ui.get(menu.watermark) == "Modern"))
    ui.set_visible(menu.indicators, ui.get(menu.enable) == "Enable" and ui.get(menu.tab) == "Visuals")
    ui.set_visible(menu.indicatorscolor, ui.get(menu.enable) == "Enable" and ui.get(menu.tab) == "Visuals" and (ui.get(menu.indicators) == "Modern" or ui.get(menu.indicators) == "Acatel"))
    ui.set_visible(menu.indicatorscolorlabel, ui.get(menu.enable) == "Enable" and ui.get(menu.tab) == "Visuals" and (ui.get(menu.indicators) == "Modern" or ui.get(menu.indicators) == "Acatel"))
    ui.set_visible(menu.aimbotlogs, ui.get(menu.enable) == "Enable" and ui.get(menu.tab) == "Visuals")
    ui.set_visible(menu.aimbotlogscolor, ui.get(menu.enable) == "Enable" and ui.get(menu.tab) == "Visuals" and table_contains(ui.get(menu.aimbotlogs),"Under crosshair"))
    ui.set_visible(menu.aimbotlogscolor2, ui.get(menu.enable) == "Enable" and ui.get(menu.tab) == "Visuals" and table_contains(ui.get(menu.aimbotlogs),"Under crosshair"))
    ui.set_visible(menu.aimbotlogscolorlabel, ui.get(menu.enable) == "Enable" and ui.get(menu.tab) == "Visuals" and table_contains(ui.get(menu.aimbotlogs),"Under crosshair"))
    ui.set_visible(menu.aimbotlogscolorlabel2, ui.get(menu.enable) == "Enable" and ui.get(menu.tab) == "Visuals" and table_contains(ui.get(menu.aimbotlogs),"Under crosshair"))
    ui.set_visible(menu.AntiHit, ui.get(menu.enable) == "Enable" and ui.get(menu.tab) == "Misc")
    ui.set_visible(menu.b_prediction, ui.get(menu.enable) == "Enable" and ui.get(menu.tab) == "Ragebot")
    ui.set_visible(menu.ragebot_label, ui.get(menu.enable) == "Enable" and ui.get(menu.tab) == "Ragebot")
    ui.set_visible(menu.f_baim, ui.get(menu.enable) == "Enable" and ui.get(menu.tab) == "Ragebot")
    ui.set_visible(menu.f_baimmis, ui.get(menu.enable) == "Enable" and ui.get(menu.tab) == "Ragebot" and table_contains(ui.get(menu.f_baim),"After X misses"))
    ui.set_visible(menu.f_baimmishp, ui.get(menu.enable) == "Enable" and ui.get(menu.tab) == "Ragebot" and table_contains(ui.get(menu.f_baim),"HP lower than X"))
    ui.set_visible(menu.sp_baim, ui.get(menu.enable) == "Enable" and ui.get(menu.tab) == "Ragebot")
    ui.set_visible(menu.sp_baimmis, ui.get(menu.enable) == "Enable" and ui.get(menu.tab) == "Ragebot" and table_contains(ui.get(menu.sp_baim),"After X misses"))
    ui.set_visible(menu.sp_baimmishp, ui.get(menu.enable) == "Enable" and ui.get(menu.tab) == "Ragebot" and table_contains(ui.get(menu.sp_baim),"HP lower than X"))
    ui.set_visible(menu.dmgindicator, ui.get(menu.enable) == "Enable" and ui.get(menu.tab) == "Visuals")
    ui.set_visible(menu.binds_label, ui.get(menu.enable) == "Enable" and ui.get(menu.tab) == "Misc")
    ui.set_visible(menu.color_label, ui.get(menu.enable) == "Enable" and ui.get(menu.tab) == "Visuals" and (table_contains(ui.get(menu.aimbotlogs),"Under crosshair") or (ui.get(menu.indicators) == "Modern" or ui.get(menu.indicators) == "Acatel")))

    --# Actimel antiaim
    active_i = var.player_states_idx[ui.get(Antiaim[0].Condition)]
    for i = 1,6 do 
        ui.set_visible(Antiaim[i].Pitch, active_i == i and ui.get(menu.enable) == "Enable" and ui.get(menu.tab) == "Anti-Aim")
        ui.set_visible(Antiaim[i].YawBase, active_i == i and ui.get(menu.enable) == "Enable" and ui.get(menu.tab) == "Anti-Aim")
        ui.set_visible(Antiaim[i].Yaw, active_i == i and ui.get(menu.enable) == "Enable" and ui.get(menu.tab) == "Anti-Aim")
        ui.set_visible(Antiaim[i].YawLeft, active_i == i and ui.get(menu.enable) == "Enable" and ui.get(menu.tab) == "Anti-Aim" and ui.get(Antiaim[active_i].Yaw) ~= "5-Way")
        ui.set_visible(Antiaim[i].YawRight, active_i == i and ui.get(menu.enable) == "Enable" and ui.get(menu.tab) == "Anti-Aim" and ui.get(Antiaim[active_i].Yaw) ~= "5-Way")
        ui.set_visible(Antiaim[i].f_way1, active_i == i and ui.get(menu.enable) == "Enable" and ui.get(menu.tab) == "Anti-Aim" and ui.get(Antiaim[active_i].Yaw) == "5-Way")
        ui.set_visible(Antiaim[i].f_way2, active_i == i and ui.get(menu.enable) == "Enable" and ui.get(menu.tab) == "Anti-Aim" and ui.get(Antiaim[active_i].Yaw) == "5-Way")
        ui.set_visible(Antiaim[i].f_way3, active_i == i and ui.get(menu.enable) == "Enable" and ui.get(menu.tab) == "Anti-Aim" and ui.get(Antiaim[active_i].Yaw) == "5-Way")
        ui.set_visible(Antiaim[i].f_way4, active_i == i and ui.get(menu.enable) == "Enable" and ui.get(menu.tab) == "Anti-Aim" and ui.get(Antiaim[active_i].Yaw) == "5-Way")
        ui.set_visible(Antiaim[i].f_way5, active_i == i and ui.get(menu.enable) == "Enable" and ui.get(menu.tab) == "Anti-Aim" and ui.get(Antiaim[active_i].Yaw) == "5-Way")
        ui.set_visible(Antiaim[i].Jitter, active_i == i and ui.get(menu.enable) == "Enable" and ui.get(menu.tab) == "Anti-Aim")
        ui.set_visible(Antiaim[i].JitterOffset, active_i == i and ui.get(menu.enable) == "Enable" and ui.get(menu.tab) == "Anti-Aim" and ui.get(Antiaim[active_i].Jitter) ~= "Off")
        ui.set_visible(Antiaim[i].BodyYaw, active_i == i and ui.get(menu.enable) == "Enable" and ui.get(menu.tab) == "Anti-Aim")
        ui.set_visible(Antiaim[i].BodyYawValue, active_i == i and ui.get(menu.enable) == "Enable" and ui.get(menu.tab) == "Anti-Aim" and (ui.get(Antiaim[i].BodyYaw) == "Jitter" or ui.get(Antiaim[i].BodyYaw) == "Static"))
        ui.set_visible(Antiaim[i].Fakelimitl, active_i == i and ui.get(menu.enable) == "Enable" and ui.get(menu.tab) == "Anti-Aim")
        ui.set_visible(Antiaim[i].Fakelimitr, active_i == i and ui.get(menu.enable) == "Enable" and ui.get(menu.tab) == "Anti-Aim")
        ui.set_visible(Antiaim[i].emptylabel3, active_i == i and ui.get(menu.enable) == "Enable" and ui.get(menu.tab) == "Anti-Aim")
        ui.set_visible(export_btn, ui.get(menu.enable) == "Enable" and ui.get(menu.tab) == "Anti-Aim")
        ui.set_visible(import_btn, ui.get(menu.enable) == "Enable" and ui.get(menu.tab) == "Anti-Aim")
        ui.set_visible(default_btn, ui.get(menu.enable) == "Enable" and ui.get(menu.tab) == "Anti-Aim")
    end
    ui.set_visible(Antiaim[0].Condition, ui.get(menu.enable) == "Enable" and ui.get(menu.tab) == "Anti-Aim")

    --# Skeet antiaim
    ui.set_visible(refs.enable, ui.get(menu.enable) == "Disable")
    ui.set_visible(refs.yaw[1], ui.get(menu.enable) == "Disable")
    ui.set_visible(refs.yaw[2], ui.get(menu.enable) == "Disable")
    ui.set_visible(refs.bodyyaw[1], ui.get(menu.enable) == "Disable")
    ui.set_visible(refs.bodyyaw[2], ui.get(menu.enable) == "Disable")
    ui.set_visible(refs.roll, ui.get(menu.enable) == "Disable")
    ui.set_visible(refs.freestand[1], ui.get(menu.enable) == "Disable")
    ui.set_visible(refs.freestand[2], ui.get(menu.enable) == "Disable")
    ui.set_visible(refs.yawjitter[1], ui.get(menu.enable) == "Disable")
    ui.set_visible(refs.yawjitter[2], ui.get(menu.enable) == "Disable")
    ui.set_visible(refs.pitch, ui.get(menu.enable) == "Disable")
    ui.set_visible(refs.yawbase, ui.get(menu.enable) == "Disable")
    --ui.set_visible(refs.fakeyaw, ui.get(menu.enable) == "Disable")
    ui.set_visible(refs.fsbodyyaw, ui.get(menu.enable) == "Disable")
    ui.set_visible(refs.edgeyaw, ui.get(menu.enable) == "Disable")
end

client.set_event_callback("shutdown", function()
    ui.set_visible(refs.enable, true)
    ui.set_visible(refs.yaw[1], true)
    ui.set_visible(refs.yaw[2], true)
    ui.set_visible(refs.bodyyaw[1], true)
    ui.set_visible(refs.bodyyaw[2], true)
    ui.set_visible(refs.roll, true)
    ui.set_visible(refs.freestand[1], true)
    ui.set_visible(refs.freestand[2], true)
    ui.set_visible(refs.yawjitter[1], true)
    ui.set_visible(refs.yawjitter[2], true)
    ui.set_visible(refs.pitch, true)
    ui.set_visible(refs.yawbase, true)
    --ui.set_visible(refs.fakeyaw, true)
    ui.set_visible(refs.fsbodyyaw, true)
    ui.set_visible(refs.edgeyaw, true)
end)
client.set_event_callback("pre_render", function()
    animfix()
end)
client.set_event_callback("setup_command", function(cmd)
    antiaim_enable(cmd)
    force_defensive(cmd)
    betterprediction()
end)
client.set_event_callback("run_command", run_cmd)
client.set_event_callback("aim_miss", on_aim_miss)
client.set_event_callback("paint", function()
    manual_aa_draw()
    logging()
    c_indicators()
    watermark()
    dmgindicator()
end)
client.set_event_callback("paint_ui", function()
    on_load()
    welcomerfunc()
end)
local function on_round_start(e)
    miss = {}
end