local aa = {
	enable = ui.reference("AA", "Anti-aimbot angles", "Enabled"),
	pitch = ui.reference("AA", "Anti-aimbot angles", "pitch"),
	leg = ui.reference("AA", "Other", "Leg Movement"),
	yawbase = ui.reference("AA", "Anti-aimbot angles", "Yaw base"),
	yaw = { ui.reference("AA", "Anti-aimbot angles", "Yaw") },
    fsbodyyaw = ui.reference("AA", "anti-aimbot angles", "Freestanding body yaw"),
    edgeyaw = ui.reference("AA", "Anti-aimbot angles", "Edge yaw"),
    fakeduck = ui.reference("RAGE", "Other", "Duck peek assist"),
	dmg = ui.reference("RAGE", "Aimbot", "Minimum damage"),
	roll = ui.reference("AA", "anti-aimbot angles", "Roll"),
	hc = ui.reference("RAGE", "Aimbot", "Minimum hit chance"),
	baim = ui.reference("RAGE", "Aimbot", "Force body aim"),
	preferbaim = ui.reference("RAGE", "Aimbot", "Prefer body aim"),
	prefersp = ui.reference("RAGE", "Aimbot", "Prefer safe point"),
	sp = { ui.reference("RAGE", "Aimbot", "Force safe point") },
	yawjitter = { ui.reference("AA", "Anti-aimbot angles", "Yaw jitter") },
	bodyyaw = { ui.reference("AA", "Anti-aimbot angles", "Body yaw") },
	os = { ui.reference("AA", "Other", "On shot anti-aim") },
	sw = { ui.reference("AA", "Other", "Slow motion") },
	dt = { ui.reference("RAGE", "Aimbot", "Double tap") },
	ps = { ui.reference("MISC", "Miscellaneous", "Ping spike") },
	fakelag = ui.reference("AA", "Fake lag", "Limit"),
}

local fs_fix = ui.reference("AA", "Anti-aimbot angles", "Freestanding")
local easing = require "gamesense/easing"
local base64 = require "gamesense/base64"
local clipboard = require 'gamesense/clipboard'
local images = require "gamesense/images"
local csgo_weapons = require "gamesense/csgo_weapons"
local anti_aim = require 'gamesense/antiaim_funcs'
local vector = require "vector"
local screen_x, screen_y = client.screen_size()
local real_x, real_y = screen_x / 2, screen_y / 2
local manual_state = ui.new_slider("AA", "Anti-aimbot angles", "\n Manual Direction Number", 0, 3, 0)
local tbl = {}
-- hide shits
local debug = false
client.set_event_callback("paint_ui", function(e)
	ui.set(aa.roll,0)
	ui.set_visible(manual_state,debug)
    ui.set_visible(fs_fix,debug)
	ui.set_visible(aa.pitch,debug)
	ui.set_visible(aa.yawbase,debug)
	ui.set_visible(aa.yaw[1],debug)
	ui.set_visible(aa.yaw[2],debug)
	ui.set_visible(aa.fsbodyyaw,debug)
	ui.set_visible(aa.edgeyaw,debug)
	ui.set_visible(aa.yawjitter[1],debug)
	ui.set_visible(aa.yawjitter[2],debug)
	ui.set_visible(aa.bodyyaw[1],debug)
	ui.set_visible(aa.bodyyaw[2],debug)
	ui.set_visible(aa.roll,debug)
end)

local header = ui.new_label("AA", "Anti-aimbot angles", '\aD0B0FFFFStrike Anti-Aim System - [ Exploits ]')
local menu_choice = ui.new_combobox("AA", "Anti-aimbot angles","\a7FE5FFFF\nMenu",{"Keybinds",'Anti-Aim Builder','Exploits','Visuals'})
local menu = {}
menu.hotkey = {
    m_left = ui.new_hotkey("AA", "Anti-aimbot angles", "+ \aFFFF4AFFManual-Left \aFFFFFFFF+"),
	m_right = ui.new_hotkey("AA", "Anti-aimbot angles", "+ \aFFFF4AFFManual-Right \aFFFFFFFF+"),
	m_back = ui.new_hotkey("AA", "Anti-aimbot angles", "+ \aFFFF4AFFManual-Back \aFFFFFFFF+"),
    pitch_breaker = ui.new_hotkey("AA", "Anti-aimbot angles", "+ \aFFFF4AFFPitch Breaker \aFFFFFFFF+"),
	tp = ui.new_hotkey("AA", "Anti-aimbot angles", "+ \aFFFF4AFFTeleport on Vulnerable \aFFFFFFFF+"),
    fs = ui.new_hotkey("AA", "Anti-aimbot angles", "+ \aFFFF4AFFFreestanding \aFFFFFFFF+"),
}
menu.exploits = {
    force_def = ui.new_checkbox("AA", "Anti-aimbot angles", "- \a8BFF7CFFForce Defensive \aFFFFFFFF-"),
    ext_def = ui.new_checkbox("AA", "Anti-aimbot angles", "- \a8BFF7CFFExtrapolate Defensive Cycle \aFFFFFFFF-"),    
}
local pstate = {"STAND","MOVE","MOVE+","AIR","AIR+","AIR-D","AIR-D+","CROUCH","SLOWWALK"}
menu.builder = {
    epeek_enable = ui.new_checkbox("AA", "Anti-aimbot angles", "- \a8BFF7CFFEnable E-peek \aFFFFFFFF-"),
    state = ui.new_combobox("AA", "Anti-aimbot angles","\aD0B0FFFFPlayer State",pstate),
}
for i=1,9 do
    menu.builder[i] = {
        yawlr_sett = ui.new_combobox("AA", "Anti-aimbot angles","\aD0B0FFFF"..pstate[i].." > \aFFFF4AFFYaw Settings",{"Static Yaw","Yaw L&R"}),
        yaw = ui.new_slider("AA", "Anti-aimbot angles","\aD0B0FFFF"..pstate[i].." > \aFFFF4AFFYaw",-180,180,0),
        yawl = ui.new_slider("AA", "Anti-aimbot angles","\aD0B0FFFF"..pstate[i].." > \aFFFF4AFFYaw [L]",-180,180,0),
        yawr = ui.new_slider("AA", "Anti-aimbot angles","\aD0B0FFFF"..pstate[i].." > \aFFFF4AFFYaw [R]",-180,180,0),
        yaw_sway = ui.new_checkbox("AA", "Anti-aimbot angles","\aD0B0FFFF"..pstate[i].." > \aFFFF4AFFYaw Sway"),
        yaws1 = ui.new_slider("AA", "Anti-aimbot angles","\aD0B0FFFF"..pstate[i].." > \aFFFF4AFFYaw Sway [1]",-180,180,0),
        yaws2 = ui.new_slider("AA", "Anti-aimbot angles","\aD0B0FFFF"..pstate[i].." > \aFFFF4AFFYaw Sway [2]",-180,180,0),
        yaws3 = ui.new_slider("AA", "Anti-aimbot angles","\aD0B0FFFF"..pstate[i].." > \aFFFF4AFFYaw Sway [3]",-180,180,0),
        yaws4 = ui.new_slider("AA", "Anti-aimbot angles","\aD0B0FFFF"..pstate[i].." > \aFFFF4AFFYaw Sway [4]",-180,180,0),
        yaw_sett = ui.new_combobox("AA", "Anti-aimbot angles","\aD0B0FFFF"..pstate[i].." > \aFFFF4AFFAdditional Yaw Settings",{"Off","Twist [Customized Swap-Time]","Switch [Tick-Based]","Switch [Choke-Based]"}),
        yaw_switch = ui.new_slider("AA", "Anti-aimbot angles","\aD0B0FFFF"..pstate[i].." > \aFFFF4AFFYaw (Switch)",-180,180,0),
        yaw_twist = ui.new_slider("AA", "Anti-aimbot angles","\aD0B0FFFF"..pstate[i].." > \aFFFF4AFFYaw Twist Time (Tick)",2,100,0),
        jittermode = ui.new_combobox("AA", "Anti-aimbot angles","\aD0B0FFFF"..pstate[i].." > \aFFFF4AFFYaw Jitter Mode",{"Off","Offset","Center","Random"}),
        jitter = ui.new_slider("AA", "Anti-aimbot angles","\aD0B0FFFF"..pstate[i].." > \aFFFF4AFFYaw Jitter Value",-180,180,0),
        jitterl = ui.new_slider("AA", "Anti-aimbot angles","\aD0B0FFFF"..pstate[i].." > \aFFFF4AFFYaw Jitter Value [L]",-180,180,0),
        jitterr = ui.new_slider("AA", "Anti-aimbot angles","\aD0B0FFFF"..pstate[i].." > \aFFFF4AFFYaw Jitter Value [R]",-180,180,0),
        byawmode = ui.new_combobox("AA", "Anti-aimbot angles","\aD0B0FFFF"..pstate[i].." > \aFFFF4AFFBody Yaw Mode",{"Jitter","Static"}),
        byaw = ui.new_slider("AA", "Anti-aimbot angles","\aD0B0FFFF"..pstate[i].." > \aFFFF4AFFBody Yaw Value",-180,180,0),
        --byawl = ui.new_slider("AA", "Anti-aimbot angles","\aD0B0FFFF"..pstate[i].." > \aFFFF4AFFBody Yaw Value [L]",-180,180,0),
        --byawr = ui.new_slider("AA", "Anti-aimbot angles","\aD0B0FFFF"..pstate[i].." > \aFFFF4AFFBody Yaw Value [R]",-180,180,0),
        byaw_sett = ui.new_combobox("AA", "Anti-aimbot angles","\aD0B0FFFF"..pstate[i].." > \aFFFF4AFFAdditional Body Yaw Settings",{"Off","Twist [Customized Swap-Time]","Switch [Tick-Based]","Switch [Choke-Based]"}),
        byaw_switch = ui.new_slider("AA", "Anti-aimbot angles","\aD0B0FFFF"..pstate[i].." > \aFFFF4AFFBody Yaw (Switch)",-180,180,0),
        byaw_twist = ui.new_slider("AA", "Anti-aimbot angles","\aD0B0FFFF"..pstate[i].." > \aFFFF4AFFBody Yaw Twist Time (Tick)",2,100,0),
        fakelimit = ui.new_slider("AA", "Anti-aimbot angles","\aD0B0FFFF"..pstate[i].." > \aFFFF4AFFFake yaw limit",0,60,60),
        fakelimitl = ui.new_slider("AA", "Anti-aimbot angles","\aD0B0FFFF"..pstate[i].." > \aFFFF4AFFFake yaw limit [L]",0,60,60),
        fakelimitr = ui.new_slider("AA", "Anti-aimbot angles","\aD0B0FFFF"..pstate[i].." > \aFFFF4AFFFake yaw limit [R]",0,60,60),
        abf_sett = ui.new_combobox("AA", "Anti-aimbot angles","\aD0B0FFFF"..pstate[i].." > \aFFFF4AFFAnti-Bruteforce Setting",{"Off","Switch Yaw Offset","Switch Body Yaw Offset","Hybrid"}),
        abf_switch = ui.new_slider("AA", "Anti-aimbot angles","\aD0B0FFFF"..pstate[i].." > \aFFFF4AFFAnti-Bruteforce >> Yaw",-180,180,0),
        abf_switchb = ui.new_slider("AA", "Anti-aimbot angles","\aD0B0FFFF"..pstate[i].." > \aFFFF4AFFAnti-Bruteforce >> Body Yaw",-180,180,0),
    }
end
local cur
local sel_state
local function hide_builder_functional()
    for i=1,9 do
        if ui.get(menu.builder[i].yaw_sett) == "Off" then
            ui.set_visible(menu.builder[i].yaw_switch,false)
        end
        if ui.get(menu.builder[i].yaw_sett) ~= "Twist [Customized Swap-Time]" then
            ui.set_visible(menu.builder[i].yaw_twist,false)
        end
        if ui.get(menu.builder[i].byaw_sett) == "Off" then
            ui.set_visible(menu.builder[i].byaw_switch,false)
        end
        if ui.get(menu.builder[i].byaw_sett) ~= "Twist [Customized Swap-Time]" then
            ui.set_visible(menu.builder[i].byaw_twist,false)
        end  
        if ui.get(menu.builder[i].abf_sett) == "Off" or ui.get(menu.builder[i].abf_sett) == "Switch Body Yaw Offset" then
            ui.set_visible(menu.builder[i].abf_switch,false)
        end
        if ui.get(menu.builder[i].abf_sett) ~= "Hybrid" and ui.get(menu.builder[i].abf_sett) ~= "Switch Body Yaw Offset" then
            ui.set_visible(menu.builder[i].abf_switchb,false)
        end
        if ui.get(menu.builder[i].yawlr_sett) ~= "Yaw L&R" then
            ui.set_visible(menu.builder[i].fakelimitl,false)
            ui.set_visible(menu.builder[i].fakelimitr,false)
            ui.set_visible(menu.builder[i].yawl,false)
            ui.set_visible(menu.builder[i].yawr,false)
            ui.set_visible(menu.builder[i].jitterl,false)
            ui.set_visible(menu.builder[i].jitterr,false)      
            --ui.set_visible(menu.builder[i].byawl,false)
            --ui.set_visible(menu.builder[i].byawr,false)
        else
            ui.set_visible(menu.builder[i].yaw,false)  
            ui.set_visible(menu.builder[i].fakelimit,false)
            ui.set_visible(menu.builder[i].jitter,false)
            --ui.set_visible(menu.builder[i].byaw,false)       
        end 
        if not ui.get(menu.builder[i].yaw_sway) then
            ui.set_visible(menu.builder[i].yaws1,false)
            ui.set_visible(menu.builder[i].yaws2,false)
            ui.set_visible(menu.builder[i].yaws3,false)
            ui.set_visible(menu.builder[i].yaws4,false)
        end
    end
end
local function hide_builder()
    sel_state = ui.get(menu.builder.state)
    for z=1,9 do
       for i,v in pairs(menu.builder[z]) do
            ui.set_visible(v,sel_state == pstate[z] and cur == "Anti-Aim Builder")
       end
    end
    hide_builder_functional()
end
local function menuhandler()
    cur = ui.get(menu_choice)
    ui.set(header,'\aD0B0FFFFStrike Anti-Aim System - [ '..cur..' ]')
    for i,v in pairs(menu.exploits) do
        ui.set_visible(v,cur == "Exploits")
    end
    for i,v in pairs(menu.hotkey) do
        ui.set_visible(v,cur == "Keybinds")
    end
    ui.set_visible(menu.builder.epeek_enable,cur == "Anti-Aim Builder")
    ui.set_visible(menu.builder.state,cur == "Anti-Aim Builder")
    hide_builder()
end
menuhandler()
ui.set_callback(menu_choice,menuhandler)
ui.set_callback(menu.builder.state,hide_builder)
for i=1,9 do
    ui.set_callback(menu.builder[i].yawlr_sett,hide_builder)
    ui.set_callback(menu.builder[i].yaw_sett,hide_builder)
    ui.set_callback(menu.builder[i].byaw_sett,hide_builder)
    ui.set_callback(menu.builder[i].abf_sett,hide_builder)
    ui.set_callback(menu.builder[i].yaw_sway,hide_builder)
end

client.set_event_callback("setup_command", function(cmd)
    if ui.get(menu.exploits.force_def) then
        cmd.force_defensive = 1
    end
end)
client.set_event_callback("paint_ui", function()
    local local_player = entity.get_local_player()
	if not entity.is_alive(local_player) then
		return
	end
end)

-- tp on vul

client.set_event_callback("setup_command", function()
	if not ui.get(menu.hotkey.tp) then
		ui.set(aa.dt[1],true)
		return
	end
	local local_player = entity.get_local_player()
	if not entity.is_alive(local_player) then
		return
	end
	local enemies = entity.get_players(true)
	local vis = false
	for i=1, #enemies do
		local entindex = enemies[i]
		local body_x,body_y,body_z = entity.hitbox_position(entindex, 1)
		if client.visible(body_x, body_y, body_z + 20) then
			vis = true
		end
	end	
	if vis then
		ui.set(aa.dt[1],false)
	else
		ui.set(aa.dt[1],true)
	end
end)

local fsdirection = "M"

local function fs_system()
    local cpitch, cyaw = client.camera_angles()
	local local_player = entity.get_local_player()
    local re_x, re_y, re_z = client.eye_position()
	local enemies = entity.get_players(true)
	for i=1, #enemies do
        local entindex = enemies[i]
        local body_x,body_y,body_z = entity.hitbox_position(entindex, 3)
        local r = 70
        local xoffs = {}
        local yoffs = {}
        local worldpos = {}
        local dmgpredicts = {}
        local bestdirection = 0
        local bestdmg = 0
        local useless = false
		local enmvis = client.visible(body_x, body_y, body_z)

        for i=1,12 do
            local offset = i * 20 - 120
            xoffs[i] = math.cos(math.rad(cyaw - offset)) * r
            yoffs[i] = math.sin(math.rad(cyaw - offset)) * r
            useless, dmgpredicts[i] = client.trace_bullet(entindex, re_x + xoffs[i], re_y + yoffs[i], re_z, body_x, body_y, body_z, true)
            local visibleornot = client.visible(re_x + xoffs[i] + 2, re_y + yoffs[i] + 2 , re_z)
            if visibleornot then
                if dmgpredicts[i] > bestdmg then
                    bestdmg = dmgpredicts[i]
                    bestdirection = cyaw - offset
                end
            end
        end
        local body_x,body_y,body_z = entity.hitbox_position(entindex, 1)
		if not client.visible(body_x, body_y, body_z + 20) then
			if bestdirection == 0 then
				fsdirection = "M"
			elseif cyaw > bestdirection then
				fsdirection = "L"
			else 
				fsdirection = "R"
			end
		else
            fsdirection = "M"
        end
    end
    
end
client.set_event_callback("paint_ui", fs_system)

-- pasted & fixed anti-bf

local abftimer = globals.tickcount()
local timer = globals.tickcount()
local last_abftick = 0
local reversed = false
local ref = {
    fsbodyyaw = ui.reference('AA', 'anti-aimbot angles', 'Freestanding body yaw'),
	bodyyaw = {ui.reference('AA', 'Anti-aimbot angles', 'Body yaw')},
	fs = {ui.reference('AA', 'Anti-aimbot angles', 'Freestanding')},
	os = {ui.reference('AA', 'Other', 'On shot anti-aim')},
	dt = {ui.reference('RAGE', 'Aimbot', 'Double tap')}
}
local sc 			= {client.screen_size()}
local cw 			= sc[1]/2
local ch 			= sc[2]/2
local function gradient_text(r1, g1, b1, a1, r2, g2, b2, a2, text)
    local output = ''
    local len = #text-1
    local rinc = (r2 - r1) / len
    local ginc = (g2 - g1) / len
    local binc = (b2 - b1) / len
    local ainc = (a2 - a1) / len
    for i=1, len+1 do
        output = output .. ('\a%02x%02x%02x%02x%s'):format(r1, g1, b1, a1, text:sub(i, i))
        r1 = r1 + rinc
        g1 = g1 + ginc
        b1 = b1 + binc
        a1 = a1 + ainc
    end

    return output
end
local iu = {
	x = database.read("ui_x") or 250,
	y = database.read("ui_y") or 250,
	w = 140,
	h = 1,
	dragging = false
}
local function intersect(x, y, w, h, debug) 
	local cx, cy = ui.mouse_position()
	return cx >= x and cx <= x + w and cy >= y and cy <= y + h
end
local function clamp(x, min, max)
	return x < min and min or x > max and max or x
end
local function contains(table, key)
    for index, value in pairs(table) do
        if value == key then return true end -- , index
    end
    return false -- , nil
end
local function KaysFunction(A,B,C)
    local d = (A-B) / A:dist(B)
    local v = C - B
    local t = v:dot(d) 
    local P = B + d:scaled(t)
    
    return P:dist(C)
end
local function reset_brute()
	pct = 1
	start = 720
	reversed = false
end
local function on_bullet_impact(e)
	local local_player = entity.get_local_player()
	local shooter = client.userid_to_entindex(e.userid)

	if not true then return end

	if not entity.is_enemy(shooter) or not entity.is_alive(local_player) then
		return
	end

	local shot_start_pos 	= vector(entity.get_prop(shooter, "m_vecOrigin"))
	shot_start_pos.z 		= shot_start_pos.z + entity.get_prop(shooter, "m_vecViewOffset[2]")
	local eye_pos			= vector(client.eye_position())
	local shot_end_pos 		= vector(e.x, e.y, e.z)
	local closest			= KaysFunction(shot_start_pos, shot_end_pos, eye_pos)

	if globals.tickcount() - abftimer < 0 then
		abftimer = globals.tickcount()
	end

	if globals.tickcount() - abftimer > 3 and closest < 70 then
		pct = 1
		start = 720
		abftimer = globals.tickcount()
		reversed = not reversed
		last_abftick = globals.tickcount()
	end
end
local function handle_callbacks()
	local call_back = client.set_event_callback
	call_back('bullet_impact', on_bullet_impact)
	call_back('shutdown', function()
		reset_brute()
	end)
	call_back('round_end', reset_brute)
	call_back('round_start', reset_brute)
	call_back('client_disconnect', reset_brute)
	call_back('level_init', reset_brute)
	call_back('player_connect_full', function(e) if client.userid_to_entindex(e.userid) == entity.get_local_player() then reset_brute() end end)
end
handle_callbacks()

--epeek

client.set_event_callback("setup_command",function(e)
    if not ui.get(menu.builder.epeek_enable) then
        return
    end
    local weaponn = entity.get_player_weapon()
        if weaponn ~= nil and entity.get_classname(weaponn) == "CC4" then
            if e.in_attack == 1 then
                e.in_attack = 0 
                e.in_use = 1
            end
        else
            if e.chokedcommands == 0 then
                e.in_use = 0
            end
        end
end)

--manual bind system

local bind_system = {left = false, right = false, back = false,}
function bind_system:update()
	ui.set(menu.hotkey.m_left, "On hotkey")
	ui.set(menu.hotkey.m_right, "On hotkey")
	ui.set(menu.hotkey.m_back, "On hotkey")
	local m_state = ui.get(manual_state)
	local left_state, right_state, backward_state = 
		ui.get(menu.hotkey.m_left), 
		ui.get(menu.hotkey.m_right),
		ui.get(menu.hotkey.m_back)
	if left_state == self.left and 
		right_state == self.right and
		backward_state == self.back then
		return
	end
	self.left, self.right, self.back = 
		left_state, 
		right_state, 
		backward_state
	if (left_state and m_state == 1) or (right_state and m_state == 2) or (backward_state and m_state == 3) then
		ui.set(manual_state, 0)
		return
	end
	if left_state and m_state ~= 1 then
		ui.set(manual_state, 1)
	end
	if right_state and m_state ~= 2 then
		ui.set(manual_state, 2)
	end
	if backward_state and m_state ~= 3 then
		ui.set(manual_state, 3)	
	end
end

-- functions
local tbl = {}
tbl.checker = 0
tbl.defensive = 0
local tickreversed = false
local chokereversed = false
local twisted = false
local tick_var = 0
local tick_var2 = 0
local tick_var3 = 0
local sway_stage = 1
local function tickrev(a,b)
	return tickreversed and a or b
end
local function chokerev(a,b)
	return chokereversed and a or b
end
local function twist(a,b,time)
    if globals.tickcount() % time == 0 then
        twisted = true
    else
        twisted = false
    end
    return twisted and b or a
end
local function sway(a,b,c,d,e)
	return sway_stage == 1 and a or sway_stage == 2 and b or sway_stage == 3 and c or sway_stage == 4 and d or sway_stage == 5 and e
end
client.set_event_callback("paint_ui", function()
	local local_player = entity.get_local_player()
	if not entity.is_alive(local_player) then
		return
	end
    local tickbase = entity.get_prop(entity.get_local_player(), "m_nTickBase")
    tbl.defensive = math.abs(tickbase - tbl.checker)
    tbl.checker = math.max(tickbase, tbl.checker or 0)
end)
-- main callback
local snum = 1
local setting = {}
client.set_event_callback("setup_command", function(arg)
    if globals.tickcount() - last_abftick > 600 and reversed then
		reset_brute()
	end
	local local_player = entity.get_local_player()
	if not entity.is_alive(local_player) then
		return
	end
	if globals.tickcount() - tick_var2 > 1 then
		tickreversed = not tickreversed
		tick_var2 = globals.tickcount()
	elseif globals.tickcount() - tick_var2 < -1 then
		tick_var2 = globals.tickcount()
	end
    if globals.tickcount() - tick_var > 0 and arg.chokedcommands == 1 then
		chokereversed = not chokereversed
		tick_var = globals.tickcount()
	elseif globals.tickcount() - tick_var < -1 then
		tick_var = globals.tickcount()
	end
    if globals.tickcount() - tick_var3 > 1 and globals.chokedcommands() == 1 then
		if sway_stage < 5 then 
            sway_stage = sway_stage + 1
        elseif sway_stage >= 5 then
            sway_stage = 1
        end
		tick_var3 = globals.tickcount()
	elseif globals.tickcount() - tick_var3 < -1 then
		tick_var3 = globals.tickcount()
	end
    local vx, vy = entity.get_prop(local_player, "m_vecVelocity")
	local speed = math.floor(math.min(10000, math.sqrt(vx*vx + vy*vy) + 0.5))
	local onground = (bit.band(entity.get_prop(local_player, "m_fFlags"), 1) == 1)
	local infiniteduck = (bit.band(entity.get_prop(local_player, "m_fFlags"), 2) == 2)
	local ekey = client.key_state(0x45)
    local onexploit = ui.get(aa.dt[2]) or ui.get(aa.os[2])
    bind_system:update()
    --state detection
    if client.key_state(0x20) or not onground then
        if infiniteduck then
            if onexploit then
                snum = 7
            else
                snum = 6
            end
        else
            if onexploit then
                snum = 5
            else
                snum = 4
            end
        end
    elseif onground and infiniteduck or onground and ui.get(aa.fakeduck) then
        snum = 8
    elseif ui.get(aa.sw[1]) and ui.get(aa.sw[2]) then
        snum = 9
    elseif onground and speed > 5 then
        if onexploit then
            snum = 3
        else
            snum = 2
        end
    else
        snum = 1
    end
    local msyaw = 0
	local mwork = ui.get(manual_state) ~= 0 and ui.get(manual_state) ~= 3
	if mwork then
		msyaw = ui.get(manual_state) == 1 and -85 or ui.get(manual_state) == 2 and 87
	end
    setting.yaw = ui.get(menu.builder[snum].yaw)
    setting.jitter = ui.get(menu.builder[snum].jitter)
    setting.byaw = ui.get(menu.builder[snum].byaw)
    setting.fakelimit = ui.get(menu.builder[snum].fakelimit)
    if ui.get(menu.builder[snum].yaw_sett) ~= "Off" then
        if ui.get(menu.builder[snum].yaw_sett) == "Twist [Customized Swap-Time]" then
            setting.yaw = twist(setting.yaw,ui.get(menu.builder[snum].yaw_switch),ui.get(menu.builder[snum].yaw_twist))
        elseif ui.get(menu.builder[snum].yaw_sett) == "Switch [Tick-Based]" then
            setting.yaw = tickrev(setting.yaw,ui.get(menu.builder[snum].yaw_switch))
        elseif ui.get(menu.builder[snum].yaw_sett) == "Switch [Choke-Based]" then
            setting.yaw = chokerev(setting.yaw,ui.get(menu.builder[snum].yaw_switch))
        end
    end
    if ui.get(menu.builder[snum].byaw_sett) ~= "Off" then
        if ui.get(menu.builder[snum].byaw_sett) == "Twist [Customized Swap-Time]" then
            setting.byaw = twist(setting.byaw,ui.get(menu.builder[snum].byaw_switch),ui.get(menu.builder[snum].byaw_twist))
        elseif ui.get(menu.builder[snum].yaw_sett) == "Switch [Tick-Based]" then
            setting.byaw = tickrev(setting.byaw,ui.get(menu.builder[snum].byaw_switch))
        elseif ui.get(menu.builder[snum].yaw_sett) == "Switch [Choke-Based]" then
            setting.byaw = chokerev(setting.byaw,ui.get(menu.builder[snum].byaw_switch))
        end
    end
    if ui.get(menu.builder[snum].abf_sett) ~= "Off" then
        if reversed and ui.get(menu.builder[snum].abf_sett) ~= "Switch Body Yaw Offset" then
            setting.yaw = ui.get(menu.builder[snum].abf_switch)
        end
        if reversed and ui.get(menu.builder[snum].abf_sett) ~= "Switch Yaw Offset" then
            setting.byaw = ui.get(menu.builder[snum].abf_switchb)
        end
    end
    if ui.get(menu.builder[snum].yawlr_sett) == "Yaw L&R" then
        setting.yaw = chokerev(ui.get(menu.builder[snum].yawl),ui.get(menu.builder[snum].yawr))
        if ui.get(menu.builder[snum].jittermode) == "Center" then
            setting.yaw = setting.yaw + chokerev(-1 * (ui.get(menu.builder[snum].jitterl) / 2),ui.get(menu.builder[snum].jitterr) / 2)
            setting.jitter = 0
        else
            setting.jitter = chokerev(ui.get(menu.builder[snum].jitterl),ui.get(menu.builder[snum].jitterr))
        end
        setting.fakelimit = chokerev(ui.get(menu.builder[snum].fakelimitl),ui.get(menu.builder[snum].fakelimitr))
    end
    if ui.get(menu.builder[snum].yaw_sway) then
        if ui.get(menu.builder[snum].yawlr_sett) == "Yaw L&R" then
            setting.yaw = sway(ui.get(menu.builder[snum].yaws1),ui.get(menu.builder[snum].yaws2),setting.yaw,ui.get(menu.builder[snum].yaws3),ui.get(menu.builder[snum].yaws4)) + chokerev(-1 * (ui.get(menu.builder[snum].jitterl) / 2),ui.get(menu.builder[snum].jitterr) / 2)
        else
            setting.yaw = sway(ui.get(menu.builder[snum].yaws1),ui.get(menu.builder[snum].yaws2),setting.yaw,ui.get(menu.builder[snum].yaws3),ui.get(menu.builder[snum].yaws4))
        end
    end 
    if setting.fakelimit == 60 then
        setting.fakelimit = 59
    end
	local msyaw = 0
	local mwork = ui.get(manual_state) ~= 0
	if mwork then
		setting.yaw = ui.get(manual_state) == 1 and -85 or ui.get(manual_state) == 2 and 87 or setting.yaw
	end
    if (tbl.defensive > 2 and tbl.defensive < 14) and ui.get(menu.hotkey.pitch_breaker) then
        ui.set(aa.pitch,"Up")
    else
        ui.set(aa.pitch,"Minimal")
    end
	if mwork then
    	ui.set(aa.yawbase,"Local view")
	else
		ui.set(aa.yawbase,"At targets")
	end
    ui.set(aa.yaw[1],"180")
    ui.set(aa.yaw[2],setting.yaw)
    ui.set(aa.yawjitter[1],ui.get(menu.builder[snum].jittermode))
    ui.set(aa.yawjitter[2],setting.jitter)
    ui.set(aa.bodyyaw[1],ui.get(menu.builder[snum].byawmode))
    ui.set(aa.bodyyaw[2],setting.byaw)
    if ui.get(menu.hotkey.fs) then
        ui.set(fs_fix, true)
        ui.set(fs_fix[1],"Always On")
    else
        ui.set(fs_fix, false)
    end
end)

local ui_get = ui.get
local ui_set = ui.set
local function str_to_sub(input, sep)
	local t = {}
	for str in string.gmatch(input, "([^"..sep.."]+)") do
		t[#t + 1] = string.gsub(str, "\n", "")
	end
	return t
end
local function to_boolean(str)
	if str == "true" or str == "false" then
		return (str == "true")
	else
		return str
	end
end
local function export_cfg()
	local str = ""

	for i=1, 9 do

		str = str
		.. tostring(ui.get(menu.builder[i].yawlr_sett)) .. "|"
		.. tostring(ui.get(menu.builder[i].yaw)) .. "|"
		.. tostring(ui.get(menu.builder[i].yawl)) .. "|"
		.. tostring(ui.get(menu.builder[i].yawr)) .. "|"
		.. tostring(ui.get(menu.builder[i].yaw_sway)) .. "|"
		.. tostring(ui.get(menu.builder[i].yaws1)) .. "|"
		.. tostring(ui.get(menu.builder[i].yaws2)) .. "|"
		.. tostring(ui.get(menu.builder[i].yaws3)) .. "|"
        .. tostring(ui.get(menu.builder[i].yaws4)) .. "|"
        .. tostring(ui.get(menu.builder[i].yaw_sett)) .. "|"
        .. tostring(ui.get(menu.builder[i].yaw_switch)) .. "|"
        .. tostring(ui.get(menu.builder[i].yaw_twist)) .. "|"
        .. tostring(ui.get(menu.builder[i].jittermode)) .. "|"
        .. tostring(ui.get(menu.builder[i].jitter)) .. "|"
        .. tostring(ui.get(menu.builder[i].jitterl)) .. "|"
        .. tostring(ui.get(menu.builder[i].jitterr)) .. "|"
        .. tostring(ui.get(menu.builder[i].byawmode)) .. "|"
        .. tostring(ui.get(menu.builder[i].byaw)) .. "|"
    --    .. tostring(ui.get(menu.builder[i].byawl)) .. "|"
    --    .. tostring(ui.get(menu.builder[i].byawr)) .. "|"
        .. tostring(ui.get(menu.builder[i].byaw_sett)) .. "|"
        .. tostring(ui.get(menu.builder[i].byaw_switch)) .. "|"
        .. tostring(ui.get(menu.builder[i].byaw_twist)) .. "|"
        .. tostring(ui.get(menu.builder[i].fakelimit)) .. "|"
        .. tostring(ui.get(menu.builder[i].fakelimitl)) .. "|"
        .. tostring(ui.get(menu.builder[i].fakelimitr)) .. "|"
        .. tostring(ui.get(menu.builder[i].abf_sett)) .. "|"
        .. tostring(ui.get(menu.builder[i].abf_switch)) .. "|"
        .. tostring(ui.get(menu.builder[i].abf_switchb)) .. "|"
	end
	clipboard.set(base64.encode(str))
end

local function load_cfg(input)
	local tbl = str_to_sub(input, "|")
	for i=1, 9 do
		ui_set(menu.builder[i].yawlr_sett, tostring(tbl[1 + (27 * (i - 1))]))
		ui_set(menu.builder[i].yaw, tonumber(tbl[2 + (27 * (i - 1))]))
		ui_set(menu.builder[i].yawl, tonumber(tbl[3 + (27 * (i - 1))]))
		ui_set(menu.builder[i].yawr, tonumber(tbl[4 + (27 * (i - 1))]))
		ui_set(menu.builder[i].yaw_sway, to_boolean(tbl[5 + (27 * (i - 1))]))
		ui_set(menu.builder[i].yaws1, tonumber(tbl[6 + (27 * (i - 1))]))
		ui_set(menu.builder[i].yaws2, tonumber(tbl[7 + (27 * (i - 1))]))
		ui_set(menu.builder[i].yaws3, tonumber(tbl[8 + (27 * (i - 1))]))
        ui_set(menu.builder[i].yaws4, tonumber(tbl[9 + (27 * (i - 1))]))
        ui_set(menu.builder[i].yaw_sett, tostring(tbl[10 + (27 * (i - 1))]))
        ui_set(menu.builder[i].yaw_switch, tonumber(tbl[11 + (27 * (i - 1))]))
        ui_set(menu.builder[i].yaw_twist, tonumber(tbl[12 + (27 * (i - 1))]))
        ui_set(menu.builder[i].jittermode, tostring(tbl[13 + (27 * (i - 1))]))
        ui_set(menu.builder[i].jitter, tonumber(tbl[14 + (27 * (i - 1))]))   
        ui_set(menu.builder[i].jitterl, tonumber(tbl[15 + (27 * (i - 1))]))
        ui_set(menu.builder[i].jitterr, tonumber(tbl[16 + (27 * (i - 1))]))       
        ui_set(menu.builder[i].byawmode, to_boolean(tbl[17 + (27 * (i - 1))]))    
        ui_set(menu.builder[i].byaw, tonumber(tbl[18 + (27 * (i - 1))]))  
 --       ui_set(menu.builder[i].byawl, tonumber(tbl[19 + (29 * (i - 1))]))   
 --       ui_set(menu.builder[i].byawr, tonumber(tbl[20 + (29 * (i - 1))]))
        ui_set(menu.builder[i].byaw_sett, tostring(tbl[19 + (27 * (i - 1))]))       
        ui_set(menu.builder[i].byaw_switch, tonumber(tbl[20 + (27 * (i - 1))]))    
        ui_set(menu.builder[i].byaw_twist, tonumber(tbl[21 + (27 * (i - 1))]))         
        ui_set(menu.builder[i].fakelimit, tonumber(tbl[22 + (27 * (i - 1))]))         
        ui_set(menu.builder[i].fakelimitl, tonumber(tbl[23 + (27 * (i - 1))]))         
        ui_set(menu.builder[i].fakelimitr, tonumber(tbl[24 + (27 * (i - 1))]))         
        ui_set(menu.builder[i].abf_sett, tostring(tbl[25 + (27 * (i - 1))]))         
        ui_set(menu.builder[i].abf_switch, tonumber(tbl[26 + (27 * (i - 1))]))         
        ui_set(menu.builder[i].abf_switchb, tonumber(tbl[27 + (27 * (i - 1))]))         
	end
end

local function export_stage_cfg()
	local str = ""

	for i=1, 9 do
        if sel_state == pstate[i] then
            str = str
            .. tostring(ui.get(menu.builder[i].yawlr_sett)) .. "|"
            .. tostring(ui.get(menu.builder[i].yaw)) .. "|"
            .. tostring(ui.get(menu.builder[i].yawl)) .. "|"
            .. tostring(ui.get(menu.builder[i].yawr)) .. "|"
            .. tostring(ui.get(menu.builder[i].yaw_sway)) .. "|"
            .. tostring(ui.get(menu.builder[i].yaws1)) .. "|"
            .. tostring(ui.get(menu.builder[i].yaws2)) .. "|"
            .. tostring(ui.get(menu.builder[i].yaws3)) .. "|"
            .. tostring(ui.get(menu.builder[i].yaws4)) .. "|"
            .. tostring(ui.get(menu.builder[i].yaw_sett)) .. "|"
            .. tostring(ui.get(menu.builder[i].yaw_switch)) .. "|"
            .. tostring(ui.get(menu.builder[i].yaw_twist)) .. "|"
            .. tostring(ui.get(menu.builder[i].jittermode)) .. "|"
            .. tostring(ui.get(menu.builder[i].jitter)) .. "|"
            .. tostring(ui.get(menu.builder[i].jitterl)) .. "|"
            .. tostring(ui.get(menu.builder[i].jitterr)) .. "|"
            .. tostring(ui.get(menu.builder[i].byawmode)) .. "|"
            .. tostring(ui.get(menu.builder[i].byaw)) .. "|"
 --           .. tostring(ui.get(menu.builder[i].byawl)) .. "|"
 --           .. tostring(ui.get(menu.builder[i].byawr)) .. "|"
            .. tostring(ui.get(menu.builder[i].byaw_sett)) .. "|"
            .. tostring(ui.get(menu.builder[i].byaw_switch)) .. "|"
            .. tostring(ui.get(menu.builder[i].byaw_twist)) .. "|"
            .. tostring(ui.get(menu.builder[i].fakelimit)) .. "|"
            .. tostring(ui.get(menu.builder[i].fakelimitl)) .. "|"
            .. tostring(ui.get(menu.builder[i].fakelimitr)) .. "|"
            .. tostring(ui.get(menu.builder[i].abf_sett)) .. "|"
            .. tostring(ui.get(menu.builder[i].abf_switch)) .. "|"
            .. tostring(ui.get(menu.builder[i].abf_switchb)) .. "|"
        end
	end
	clipboard.set(base64.encode(str))
end

local function load_stage_cfg(input)
	local tbl = str_to_sub(input, "|")
	for i=1, 9 do
        if sel_state == pstate[i] then
            ui_set(menu.builder[i].yawlr_sett, tostring(tbl[1]))
            ui_set(menu.builder[i].yaw, tonumber(tbl[2]))
            ui_set(menu.builder[i].yawl, tonumber(tbl[3]))
            ui_set(menu.builder[i].yawr, tonumber(tbl[4]))
            ui_set(menu.builder[i].yaw_sway, to_boolean(tbl[5]))
            ui_set(menu.builder[i].yaws1, tonumber(tbl[6]))
            ui_set(menu.builder[i].yaws2, tonumber(tbl[7]))
            ui_set(menu.builder[i].yaws3, tonumber(tbl[8]))
            ui_set(menu.builder[i].yaws4, tonumber(tbl[9]))
            ui_set(menu.builder[i].yaw_sett, tostring(tbl[10]))
            ui_set(menu.builder[i].yaw_switch, tonumber(tbl[11]))
            ui_set(menu.builder[i].yaw_twist, tonumber(tbl[12]))
            ui_set(menu.builder[i].jittermode, tostring(tbl[13]))
            ui_set(menu.builder[i].jitter, tonumber(tbl[14]))   
            ui_set(menu.builder[i].jitterl, tonumber(tbl[15]))
            ui_set(menu.builder[i].jitterr, tonumber(tbl[16]))       
            ui_set(menu.builder[i].byawmode, to_boolean(tbl[17]))    
            ui_set(menu.builder[i].byaw, tonumber(tbl[18]))  
 --           ui_set(menu.builder[i].byawl, tonumber(tbl[19]))   
--            ui_set(menu.builder[i].byawr, tonumber(tbl[20]))
            ui_set(menu.builder[i].byaw_sett, tostring(tbl[19]))       
            ui_set(menu.builder[i].byaw_switch, tonumber(tbl[20]))    
            ui_set(menu.builder[i].byaw_twist, tonumber(tbl[21]))         
            ui_set(menu.builder[i].fakelimit, tonumber(tbl[22]))         
            ui_set(menu.builder[i].fakelimitl, tonumber(tbl[23]))         
            ui_set(menu.builder[i].fakelimitr, tonumber(tbl[24]))         
            ui_set(menu.builder[i].abf_sett, tostring(tbl[25]))         
            ui_set(menu.builder[i].abf_switch, tonumber(tbl[26]))         
            ui_set(menu.builder[i].abf_switchb, tonumber(tbl[27]))         
        end
	end
end

local function import_cfg()
	local cfgtext = base64.decode(clipboard.get())
	load_cfg(cfgtext)
end
local function import_stage_cfg()
	local cfgtext = base64.decode(clipboard.get())
	load_stage_cfg(cfgtext)
end

-- visuals
local vector = require('vector')
local images = require("gamesense/images")
--local inspect = require'inspect'
local build = "nightly"

local ctx = (function()
	local ctx = {}

	ctx.logo = images.load_png(base64.decode("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AAECBOIFBJB4cxUJECBAgAABAgQIpBUQQNKOXuMECBAgQIAAAQIE4gUEkHhzFQkQIECAAAECBAikFRBA0o5e4wQIECBAgAABAgTiBQSQeHMVCRAgQIAAAQIECKQVEEDSjl7jBAgQIECAAAECBOIFBJB4cxUJECBAgAABAgQIpBUQQNKOXuMECBAgQIAAAQIE4gUEkHhzFQkQIECAAAECBAikFRBA0o5e4wQIECBAgAABAgTiBQSQeHMVCRAgQIAAAQIECKQVEEDSjl7jBAgQIECAAAECBOIFBJB4cxUJECBAgAABAgQIpBUQQNKOXuMECBAgQIAAAQIE4gUEkHhzFQkQIECAAAECBAikFRBA0o5e4wQIECBAgAABAgTiBQSQeHMVCRAgQIAAAQIECKQVEEDSjl7jBAgQIECAAAECBOIFBJB4cxUJECBAgAABAgQIpBUQQNKOXuMECBAgQIAAAQIE4gUEkHhzFQkQIECAAAECBAikFRBA0o5e4wQIECBAgAABAgTiBQSQeHMVCRAgQIAAAQIECKQVEEDSjl7jBAgQIECAAAECBOIFBJB4cxUJECBAgAABAgQIpBUQQNKOXuMECBAgQIAAAQIE4gUEkHhzFQkQIECAAAECBAikFRBA0o5e4wQIECBAgAABAgTiBQSQeHMVCRAgQIAAAQIECKQVEEDSjl7jBAgQIECAAAECBOIFBJB4cxUJECBAgAABAgQIpBUQQNKOXuMECBAgQIAAAQIE4gUEkHhzFQkQIECAAAECBAikFRBA0o5e4wQIECBAgAABAgTiBQSQeHMVCRAgQIAAAQIECKQVEEDSjl7jBAgQIECAAAECBOIFBJB4cxUJECBAgAABAgQIpBUQQNKOXuMECBAgQIAAAQIE4gUEkHhzFQkQIECAAAECBAikFRBA0o5e4wQIECBAgAABAgTiBQSQeHMVCRAgQIAAAQIECKQVEEDSjl7jBAgQIECAAAECBOIFBJB4cxUJECBAgAABAgQIpBUQQNKOXuMECBAgQIAAAQIE4gUEkHhzFQkQIECAAAECBAikFRBA0o5e4wQIECBAgAABAgTiBQSQeHMVCRAgQIAAAQIECKQVEEDSjl7jBAgQIECAAAECBOIFBJB4cxUJECBAgAABAgQIpBUQQNKOXuMECBAgQIAAAQIE4gUEkHhzFQkQIECAAAECBAikFRBA0o5e4wQIECBAgAABAgTiBQSQeHMVCRAgQIAAAQIECKQVEEDSjl7jBAgQIECAAAECBOIFBJB4cxUJECBAgAABAgQIpBUQQNKOXuMECBAgQIAAAQIE4gUEkHhzFQkQIECAAAECBAikFRBA0o5e4wQIECBAgAABAgTiBQSQeHMVCRAgQIAAAQIECKQVEEDSjl7jBAgQIECAAAECBOIFBJB4cxUJECBAgAABAgQIpBUQQNKOXuMECBAgQIAAAQIE4gUEkHhzFQkQIECAAAECBAikFRBA0o5e4wQIECBAgAABAgTiBQSQeHMVCRAgQIAAAQIECKQVEEDSjl7jBAgQIECAAAECBOIFBJB4cxUJECBAgAABAgQIpBUQQNKOXuMECBAgQIAAAQIE4gUEkHhzFQkQIECAAAECBAikFRBA0o5e4wQIECBAgAABAgTiBQSQeHMVCRAgQIAAAQIECKQVEEDSjl7jBAgQIECAAAECBOIFBJB4cxUJECBAgAABAgQIpBUQQNKOXuMECBAgQIAAAQIE4gUEkHhzFQkQIECAAAECBAikFRBA0o5e4wQIECBAgAABAgTiBQSQeHMVCRAgQIAAAQIECKQVEEDSjl7jBAgQIECAAAECBOIFBJB4cxUJECBAgAABAgQIpBUQQNKOXuMECBAgQIAAAQIE4gUEkHhzFQkQIECAAAECBAikFRBA0o5e4wQIECBAgAABAgTiBQSQeHMVCRAgQIAAAQIECKQVEEDSjl7jBAgQIECAAAECBOIFBJB4cxUJECBAgAABAgQIpBUQQNKOXuMECBAgQIAAAQIE4gUEkHhzFQkQIECAAAECBAikFRBA0o5e4wQIECBAgAABAgTiBQSQeHMVCRAgQIAAAQIECKQVEEDSjl7jBAgQIECAAAECBOIFBJB4cxUJECBAgAABAgQIpBUQQNKOXuMECBAgQIAAAQIE4gUEkHhzFQkQIECAAAECBAikFRBA0o5e4wQIECBAgAABAgTiBQSQeHMVCRAgQIAAAQIECKQVEEDSjl7jBAgQIECAAAECBOIFBJB4cxUJECBAgAABAgQIpBUQQNKOXuMECBAgQIAAAQIE4gUEkHhzFQkQIECAAAECBAikFRBA0o5e4wQIECBAgAABAgTiBQSQeHMVCRAgQIAAAQIECKQVEEDSjl7jBAgQIECAAAECBOIFBJB4cxUJECBAgAABAgQIpBUQQNKOXuMECBAgQIAAAQIE4gUEkHhzFQkQIECAAAECBAikFRBA0o5e4wQIECBAgAABAgTiBQSQeHMVCRAgQIAAAQIECKQVEEDSjl7jBAgQIECAAAECBOIFBJB4cxUJECBAgAABAgQIpBUQQNKOXuMECBAgQIAAAQIE4gUEkHhzFQkQIECAAAECBAikFRBA0o5e4wQIECBAgAABAgTiBQSQeHMVCRAgQIAAAQIECKQVEEDSjl7jBAgQIECAAAECBOIFBJB4cxUJECBAgAABAgQIpBUQQNKOXuMECBAgQIAAAQIE4gUEkHhzFQkQIECAAAECBAikFRBA0o5e4wQIECBAgAABAgTiBQSQeHMVCRAgQIAAAQIECKQVEEDSjl7jBAgQIECAAAECBOIFBJB4cxUJECBAgAABAgQIpBUQQNKOXuMECBAgQIAAAQIE4gUEkHhzFQkQIECAAAECBAikFRBA0o5e4wQIECBAgAABAgTiBQSQeHMVCRAgQIAAAQIECKQVEEDSjl7jBAgQIECAAAECBOIFBJB4cxUJECBAgAABAgQIpBUQQNKOXuMECBAgQIAAAQIE4gUEkHhzFQkQIECAAAECBAikFRBA0o5e4wQIECBAgAABAgTiBQSQeHMVCRAgQIAAAQIECKQVEEDSjl7jBAgQIECAAAECBOIFBJB4cxUJECBAgAABAgQIpBUQQNKOXuMECBAgQIAAAQIE4gUEkHhzFQkQIECAAAECBAikFRBA0o5e4wQIECBAgAABAgTiBQSQeHMVCRAgQIAAAQIECKQVEEDSjl7jBAgQIECAAAECBOIFBJB4cxUJECBAgAABAgQIpBUQQNKOXuMECBAgQIAAAQIE4gUEkHhzFQkQIECAAAECBAikFRBA0o5e4wQIECBAgAABAgTiBQSQeHMVCRAgQIAAAQIECKQVEEDSjl7jBAgQIECAAAECBOIFBJB4cxUJECBAgAABAgQIpBUQQNKOXuMECBAgQIAAAQIE4gUEkHhzFQkQIECAAAECBAikFRBA0o5e4wQIECBAgAABAgTiBQSQeHMVCRAgQIAAAQIECKQVEEDSjl7jBAgQIECAAAECBOIFBJB4cxUJECBAgAABAgQIpBUQQNKOXuMECBAgQIAAAQIE4gUEkHhzFQkQIECAAAECBAikFRBA0o5e4wQIECBAgAABAgTiBQSQeHMVCRAgQIAAAQIECKQVEEDSjl7jBAgQIECAAAECBOIFBJB4cxUJECBAgAABAgQIpBUQQNKOXuMECBAgQIAAAQIE4gUEkHhzFQkQIECAAAECBAikFRBA0o5e4wQIECBAgAABAgTiBQSQeHMVCRAgQIAAAQIECKQVEEDSjl7jBAgQIECAAAECBOIFBJB4cxUJECBAgAABAgQIpBUQQNKOXuMECBAgQIAAAQIE4gUEkHhzFQkQIECAAAECBAikFRBA0o5e4wQIECBAgAABAgTiBQSQeHMVCRAgQIAAAQIECKQVEEDSjl7jBAgQIECAAAECBOIFBJB4cxUJECBAgAABAgQIpBUQQNKOXuMECBAgQIAAAQIE4gUEkHhzFQkQIECAAAECBAikFfh/rls70VGoigEAAAAASUVORK5CYII="))

	ctx.ref = {
		fd = ui.reference("Rage", "Other", "Duck peek assist"),
		dt = {ui.reference("Rage", "Aimbot", "Double Tap")},
		dt_fl = ui.reference("Rage", "Aimbot", "Double tap fake lag limit"),
		hs = {ui.reference("AA", "Other", "On shot anti-aim")},
		silent = ui.reference("Rage", "Other", "Silent aim"),
		slow_motion = {ui.reference("AA", "Other", "Slow motion")}
	}

	ctx.helpers = {
		defensive = 0,
		checker = 0,
		contains = function(self, tbl, val)
			for k, v in pairs(tbl) do
				if v == val then
					return true
				end
			end
			return false
		end,

		easeInOut = function(self, t)
			return (t > 0.5) and 4*((t-1)^3)+1 or 4*t^3;
		end,

		clamp = function(self, val, lower, upper)
			assert(val and lower and upper, "not very useful error message here")
			if lower > upper then lower, upper = upper, lower end -- swap if boundaries supplied the wrong way
			return math.max(lower, math.min(upper, val))
		end,

		split = function(self, inputstr, sep)
			if sep == nil then
					sep = "%s"
			end
			local t={}
			for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
					table.insert(t, str)
			end
			return t
		end,

		rgba_to_hex = function(self, r, g, b, a)
		  return bit.tohex(
		    (math.floor(r + 0.5) * 16777216) + 
		    (math.floor(g + 0.5) * 65536) + 
		    (math.floor(b + 0.5) * 256) + 
		    (math.floor(a + 0.5))
		  )
		end,

		hex_to_rgba = function(self, hex)
    	local color = tonumber(hex, 16)

    	return 
        math.floor(color / 16777216) % 256, 
        math.floor(color / 65536) % 256, 
        math.floor(color / 256) % 256, 
        color % 256
		end,

		color_text = function(self, string, r, g, b, a)
			local accent = "\a" .. self:rgba_to_hex(r, g, b, a)
			local white = "\a" .. self:rgba_to_hex(255, 255, 255, a)

			local str = ""
			for i, s in ipairs(self:split(string, "$")) do
				str = str .. (i % 2 ==( string:sub(1, 1) == "$" and 0 or 1) and white or accent) .. s
			end

			return str
		end,

		animate_text = function(self, time, string, r, g, b, a)
			local t_out, t_out_iter = { }, 1

			local l = string:len( ) - 1
	
			local r_add = (255 - r)
			local g_add = (255 - g)
			local b_add = (255 - b)
			local a_add = (155 - a)
	
			for i = 1, #string do
				local iter = (i - 1)/(#string - 1) + time
				t_out[t_out_iter] = "\a" .. ctx.helpers:rgba_to_hex( r + r_add * math.abs(math.cos( iter )), g + g_add * math.abs(math.cos( iter )), b + b_add * math.abs(math.cos( iter )), a + a_add * math.abs(math.cos( iter )) )
	
				t_out[t_out_iter + 1] = string:sub( i, i )
	
				t_out_iter = t_out_iter + 2
			end
	
			return t_out
		end,

		get_velocity = function(self, ent)
			return vector(entity.get_prop(ent, "m_vecVelocity")):length()
		end,

		in_air = function(self, _ent)
			local flags = entity.get_prop(_ent, "m_fFlags")
	
			if bit.band(flags, 1) == 0 then
				return true
			end
			
			return false
		end,

		in_duck = function(self, _ent)
			local flags = entity.get_prop(_ent, "m_fFlags")
			
			if bit.band(flags, 4) == 4 then
				return true
			end
			
			return false
		end,

		get_state = function(self, ent)
			local vel = self:get_velocity(ent)
			local air = self:in_air(ent)
			local duck = self:in_duck(ent)

			local state = vel > 3 and "run" or "stand"
			if air then
				state = duck and "duck jump" or "jump"
			elseif ui.get(ctx.ref.slow_motion[1]) and ui.get(ctx.ref.slow_motion[2]) and ent == entity.get_local_player() then
				state = "slow move"
			elseif duck then
				state = "duck"
			end

			return state
		end,

		get_time = function(self, h12)
			local hours, minutes, seconds = client.system_time()

			if h12 then
					local hrs = hours % 12

					if hrs == 0 then
							hrs = 12
					else
							hrs = hrs < 10 and hrs or ('%02d'):format(hrs)
					end

					return ('%s:%02d %s'):format(
							hrs,
							minutes,
							hours >= 12 and 'pm' or 'am'
					)
			end

			return ('%02d:%02d:%02d'):format(
					hours,
					minutes,
					seconds
			)
	end,
	}

	ctx.menu = {
		label = ui.new_label("AA", "Anti-aimbot angles", "\a8BFF7CFFAccent >>"),
		color = ui.new_color_picker("AA", "Anti-aimbot angles", "log color", 208, 176, 255, 255),
		notifications = ui.new_checkbox("AA", "Anti-aimbot angles", "- \a8BFF7CFFNotification \aFFFFFFFF-"),
		options = ui.new_multiselect("AA", "Anti-aimbot angles", "\n", {"rounding", "size", "glow", "time", }),
		rounding = ui.new_slider("AA", "Anti-aimbot angles", "notification rounding", 1, 10, 0.8, true, "%", 0.1),
		size = ui.new_slider("AA", "Anti-aimbot angles", "notification size", 0, 10, 10, true, "x", 0.2),
		glow = ui.new_slider("AA", "Anti-aimbot angles", "notification glow size", 0, 20, 110, true, "x", 0.1),
		time = ui.new_slider("AA", "Anti-aimbot angles", "notification time", 3, 15, 5, true, "s",1),
		indicators = ui.new_checkbox("AA", "Anti-aimbot angles", "- \a8BFF7CFFIndicators \aFFFFFFFF-"),
		style = ui.new_combobox("AA", "Anti-aimbot angles", "\n", {"#1", "#2"}),
		watermark = ui.new_checkbox("AA", "Anti-aimbot angles", "- \a8BFF7CFFWatermark \aFFFFFFFF-"),
		initialize = function(self)
			local callback = function()
				local notifs = ui.get(self.notifications)
				local options = ui.get(self.options)
				local indicators = ui.get(self.indicators)

				ui.set_visible(self.options, notifs)
				ui.set_visible(self.rounding, notifs and ctx.helpers:contains(options, "rounding"))
				ui.set_visible(self.size, notifs and ctx.helpers:contains(options, "size"))
				ui.set_visible(self.glow, notifs and ctx.helpers:contains(options, "glow"))
				ui.set_visible(self.time, notifs and ctx.helpers:contains(options, "time"))
				ui.set_visible(self.style, indicators)
			end

			for _, item in pairs(self) do
				if type(item) ~= "function" then
					ui.set_callback(item, callback)
				end
			end
			callback()
		end
	}
	ctx.m_render = {
		rec = function(self, x, y, w, h, radius, color)
			radius = math.min(x/2, y/2, radius)
			local r, g, b, a = unpack(color)
			renderer.rectangle(x, y + radius, w, h - radius*2, r, g, b, a)
			renderer.rectangle(x + radius, y, w - radius*2, radius, r, g, b, a)
			renderer.rectangle(x + radius, y + h - radius, w - radius*2, radius, r, g, b, a)
			renderer.circle(x + radius, y + radius, r, g, b, a, radius, 180, 0.25)
			renderer.circle(x - radius + w, y + radius, r, g, b, a, radius, 90, 0.25)
			renderer.circle(x - radius + w, y - radius + h, r, g, b, a, radius, 0, 0.25)
			renderer.circle(x + radius, y - radius + h, r, g, b, a, radius, -90, 0.25)
		end,

		rec_outline = function(self, x, y, w, h, radius, thickness, color)
			radius = math.min(w/2, h/2, radius)
			local r, g, b, a = unpack(color)
			if radius == 1 then
				renderer.rectangle(x, y, w, thickness, r, g, b, a)
				renderer.rectangle(x, y + h - thickness, w , thickness, r, g, b, a)
			else
				renderer.rectangle(x + radius, y, w - radius*2, thickness, r, g, b, a)
				renderer.rectangle(x + radius, y + h - thickness, w - radius*2, thickness, r, g, b, a)
				renderer.rectangle(x, y + radius, thickness, h - radius*2, r, g, b, a)
				renderer.rectangle(x + w - thickness, y + radius, thickness, h - radius*2, r, g, b, a)
				renderer.circle_outline(x + radius, y + radius, r, g, b, a, radius, 180, 0.25, thickness)
				renderer.circle_outline(x + radius, y + h - radius, r, g, b, a, radius, 90, 0.25, thickness)
				renderer.circle_outline(x + w - radius, y + radius, r, g, b, a, radius, -90, 0.25, thickness)
				renderer.circle_outline(x + w - radius, y + h - radius, r, g, b, a, radius, 0, 0.25, thickness)
			end
		end,

		glow_module = function(self, x, y, w, h, width, rounding, accent, accent_inner)
			local thickness = 1
			local offset = 1
			local r, g, b, a = unpack(accent)
			if accent_inner then
				self:rec(x , y, w, h + 1, rounding, accent_inner)
				--renderer.blur(x , y, w, h)
				--m_render.rec_outline(x + width*thickness - width*thickness, y + width*thickness - width*thickness, w - width*thickness*2 + width*thickness*2, h - width*thickness*2 + width*thickness*2, color(r, g, b, 255), rounding, thickness)
			end
			for k = 0, width do
				if a * (k/width)^(1) > 5 then
					local accent = {r, g, b, a * (k/width)^(2)}
					self:rec_outline(x + (k - width - offset)*thickness, y + (k - width - offset) * thickness, w - (k - width - offset)*thickness*2, h + 1 - (k - width - offset)*thickness*2, rounding + thickness * (width - k + offset), thickness, accent)
				end
			end
		end
	}

	ctx.notifications = {
		anim_time = 0.75,
		max_notifs = 6,
		data = {},

		new = function(self, string, r, g, b)
			table.insert(self.data, {
				time = globals.curtime(),
				string = string,
				color = {r, g, b, 255},
				fraction = 0
			})
			local time = ctx.helpers:contains(ui.get(ctx.menu.options), "time") and ui.get(ctx.menu.time) or 5
			for i = #self.data, 1, -1 do
				local notif = self.data[i]
				if #self.data - i + 1 > self.max_notifs and notif.time + time - globals.curtime() > 0 then
					notif.time = globals.curtime() - time
				end
			end
		end,

		render = function(self)
			local x, y = client.screen_size()
			local to_remove = {}
			local offset = 0
			for i = 1, #self.data do
				local notif = self.data[i]

				local options = ui.get(ctx.menu.options)
				local data = {rounding = 8, size = 4, glow = 8, time = 5}
				for _, item in ipairs(options) do
					data[item] = ui.get(ctx.menu[item])
				end

				if notif.time + data.time - globals.curtime() > 0 then
					notif.fraction = ctx.helpers:clamp(notif.fraction + globals.frametime() / self.anim_time, 0, 1)
				else
					notif.fraction = ctx.helpers:clamp(notif.fraction - globals.frametime() / self.anim_time, 0, 1)
				end

				if notif.fraction <= 0 and notif.time + data.time - globals.curtime() <= 0 then
					table.insert(to_remove, i)
				end
				local fraction = ctx.helpers:easeInOut(notif.fraction)

				local r, g, b, a = unpack(notif.color)
				local string = ctx.helpers:color_text(notif.string, r, g, b, a * fraction)

				local strw, strh = renderer.measure_text("", string)
				local strw2 = renderer.measure_text("b", " strike  ")

				local paddingx, paddingy = 7, data.size
				data.rounding = math.ceil(data.rounding/10 * (strh + paddingy*2)/2)

				offset = offset + (strh + paddingy*2 + 	math.sqrt(data.glow/10)*10 + 5) * fraction

				ctx.m_render:glow_module(x/2 - (strw + strw2)/2 - paddingx, y - 100 - strh/2 - paddingy - offset, strw + strw2 + paddingx*2, strh + paddingy*2, data.glow, data.rounding, {r, g, b, 45 * fraction}, {25,25,25,255 * fraction})
				renderer.text(x/2 + strw2/2, y - 100 - offset, 255, 255, 255, 255 * fraction, "c", 0, string)
				renderer.text(x/2 - strw/2, y - 100 - offset, 255, 255, 255, 255 * fraction, "cb", 0, ctx.helpers:color_text(" $strike  ", r, g, b, a * fraction))
			end

			for i = #to_remove, 1, -1 do
				table.remove(self.data, to_remove[i])
			end
		end,

		clear = function(self)
			self.data = {}
		end
	}

	ctx.indicators = {
		active_fraction = 0,
		inactive_fraction = 0,
		hide_fraction = 0,
		scoped_fraction = 0,
		fraction = 0,
		render = function(self)
			local me = entity.get_local_player()

			if not me or not entity.is_alive(me) then
				return
			end

			local state = ctx.helpers:get_state(me)
			local x, y = client.screen_size()
			local r, g, b = ui.get(ctx.menu.color)

			local style = ui.get(ctx.menu.style)
			local scoped = entity.get_prop(me, "m_bIsScoped") == 1

			if scoped then
				self.scoped_fraction = ctx.helpers:clamp(self.scoped_fraction + globals.frametime()/0.5, 0, 1)
			else
				self.scoped_fraction = ctx.helpers:clamp(self.scoped_fraction - globals.frametime()/0.5, 0, 1)
			end

			local scoped_fraction = ctx.helpers:easeInOut(self.scoped_fraction)

			if style == "#1" then
				local strike_w, strike_h = renderer.measure_text("-", "STRIKE YAW")

				ctx.m_render:glow_module(x/2 + ((strike_w + 2)/2) * scoped_fraction - strike_w/2 + 4, y/2 + 20, strike_w - 3, 0, 10, 0, {r, g, b, 100 * math.abs(math.cos(globals.curtime()*2))}, {r, g, b, 100 * math.abs(math.cos(globals.curtime()*2))})
				renderer.text(x/2 + ((strike_w + 2)/2) * scoped_fraction, y/2 + 20, 255, 255, 255, 255, "-c", 0, "STRIKE ", "\a" .. ctx.helpers:rgba_to_hex( r, g, b, 255 * math.abs(math.cos(globals.curtime()*2))) .. "YAW")

				local next_attack = entity.get_prop(me, "m_flNextAttack")
				local next_primary_attack = entity.get_prop(entity.get_player_weapon(me), "m_flNextPrimaryAttack")

				local dt_toggled = ui.get(ctx.ref.dt[1]) and ui.get(ctx.ref.dt[2])
				local dt_active = not (math.max(next_primary_attack, next_attack) > globals.curtime()) --or (ctx.helpers.defensive and ctx.helpers.defensive > ui.get(ctx.ref.dt_fl))

				if dt_toggled and dt_active then
					self.active_fraction = ctx.helpers:clamp(self.active_fraction + globals.frametime()/0.15, 0, 1)
				else
					self.active_fraction = ctx.helpers:clamp(self.active_fraction - globals.frametime()/0.15, 0, 1)
				end

				if dt_toggled and not dt_active then
					self.inactive_fraction = ctx.helpers:clamp(self.inactive_fraction + globals.frametime()/0.15, 0, 1)
				else
					self.inactive_fraction = ctx.helpers:clamp(self.inactive_fraction - globals.frametime()/0.15, 0, 1)
				end

				if ui.get(ctx.ref.hs[1]) and ui.get(ctx.ref.hs[2]) and ui.get(ctx.ref.silent) and not dt_toggled then
					self.hide_fraction = ctx.helpers:clamp(self.hide_fraction + globals.frametime()/0.15, 0, 1)
				else
					self.hide_fraction = ctx.helpers:clamp(self.hide_fraction - globals.frametime()/0.15, 0, 1)
				end

				if math.max(self.hide_fraction, self.inactive_fraction, self.active_fraction) > 0 then
					self.fraction = ctx.helpers:clamp(self.fraction + globals.frametime()/0.2, 0, 1)
				else
					self.fraction = ctx.helpers:clamp(self.fraction - globals.frametime()/0.2, 0, 1)
				end

				local dt_size = renderer.measure_text("-", "DT ")
				local ready_size = renderer.measure_text("-", "READY")
				renderer.text(x/2 + ((dt_size + ready_size + 2)/2) * scoped_fraction, y/2 + 30, 255, 255, 255, self.active_fraction * 255, "-c", dt_size + self.active_fraction * ready_size + 1, "DT ", "\a" .. ctx.helpers:rgba_to_hex(155, 255, 155, 255 * self.active_fraction) .. "READY")

				local charging_size = renderer.measure_text("-", "CHARGING")
				local ret = ctx.helpers:animate_text(globals.curtime(), "CHARGING", 255, 100, 100, 255)
				renderer.text(x/2 + ((dt_size + charging_size + 2)/2) * scoped_fraction, y/2 + 30, 255, 255, 255, self.inactive_fraction * 255, "-c", dt_size + self.inactive_fraction * charging_size + 1, "DT ", unpack(ret))

				local hide_size = renderer.measure_text("-", "HIDE ")
				local active_size = renderer.measure_text("-", "ACTIVE")
				renderer.text(x/2 + ((hide_size + active_size + 2)/2) * scoped_fraction, y/2 + 30, 255, 255, 255, self.hide_fraction * 255, "-c", hide_size + self.hide_fraction * active_size + 1, "HIDE ", "\a" .. ctx.helpers:rgba_to_hex(155, 155, 200, 255 * self.hide_fraction) .. "ACTIVE")
			
				local state_size = renderer.measure_text("-", '- ' .. string.upper(state) .. ' -')
				renderer.text(x/2 + ((state_size + 2)/2) * scoped_fraction, y/2 + 30 + 10 * ctx.helpers:easeInOut(self.fraction), 255, 255, 255, 255, "-c", 0, '- ' .. string.upper(state) .. ' -')
			elseif style == "#2" then
				renderer.text(x/2, y/2 + 20, r, g, b, 255 * math.abs(math.cos(globals.curtime()*2)), "-", 0, "...")
			end
		end
	}

	ctx.watermark = {
		render = function()
			local me = entity.get_local_player()
			local r, g, b = ui.get(ctx.menu.color)
			local x, y = client.screen_size()

			local accent = '\a' .. ctx.helpers:rgba_to_hex(r, g, b, 255)
			local reset = '\a' .. ctx.helpers:rgba_to_hex(255, 255, 255, 255)
			local hours, minutes = client.system_time()


			local str = 'strike.lua [' .. accent .. build .. reset .. '] / ' .. entity.get_player_name(me) .. ' ' .. math.floor((client.latency()*1000)) .. ' ms ' .. ctx.helpers:get_time(true)
			local w, h = renderer.measure_text("", str)
			local paddingw, paddingh = 6, 6
			ctx.m_render:glow_module(x/2 - (w + paddingw)/2, y - 40 - (h + paddingh)/2, (w + paddingw), (h + paddingh), 8, 2, {r, g, b, 20 + 55 * math.abs(math.sin(globals.curtime()*5))}, {25, 25, 25, 155})
			renderer.text(x/2, y - 40, 255, 255, 255, 255, "c", 0, str)
		end
	}

	return ctx
end)()

do
	local r, g, b = ui.get(ctx.menu.color)
	ctx.notifications:new("successfully $loaded$ strike.lua!", r, g, b)
	client.delay_call(1, function()
		ctx.notifications:new("welcome back.", r, g, b)
	end)
end

local function time_to_ticks(t)
	return math.floor(0.5 + (t / globals.tickinterval()))
end

local hitgroup_names = {'generic', 'head', 'chest', 'stomach', 'left arm', 'right arm', 'left leg', 'right leg', 'neck', '?', 'gear'}


local ccheck = function(val)
	for k, v in pairs(ui.get(ctx.menu.options)) do
		if v == val then
			return true
		end
	end
	return false
end


for _, cid in ipairs({
	{
		"paint_ui", 0, function()
			if cur ~= "Visuals" then
				ui.set_visible(ctx.menu.label,false)
				ui.set_visible(ctx.menu.color,false)
				ui.set_visible(ctx.menu.notifications,false)
				ui.set_visible(ctx.menu.options,false)
				ui.set_visible(ctx.menu.rounding,false)
				ui.set_visible(ctx.menu.size,false)
				ui.set_visible(ctx.menu.glow,false)
				ui.set_visible(ctx.menu.time,false)
				ui.set_visible(ctx.menu.indicators,false)
				ui.set_visible(ctx.menu.style,false)
				ui.set_visible(ctx.menu.watermark,false)
			else
				ui.set_visible(ctx.menu.label,true)
				ui.set_visible(ctx.menu.color,true)
				ui.set_visible(ctx.menu.notifications,true)
				ui.set_visible(ctx.menu.indicators,true)
				ui.set_visible(ctx.menu.style,ui.get(ctx.menu.indicators))
				ui.set_visible(ctx.menu.watermark,true)
				if ui.get(ctx.menu.notifications) then
					ui.set_visible(ctx.menu.options,true)
					ui.set_visible(ctx.menu.rounding,ui.get(ctx.menu.notifications) and ccheck("rounding"))
					ui.set_visible(ctx.menu.size,ui.get(ctx.menu.notifications) and ccheck("size"))
					ui.set_visible(ctx.menu.glow,ui.get(ctx.menu.notifications) and ccheck("glow"))
					ui.set_visible(ctx.menu.time,ui.get(ctx.menu.notifications) and ccheck("time"))
				else
					ui.set_visible(ctx.menu.options,false)
				end
			end	
		end
		
	},
	{
		"paint", 0, function()
			if ui.get(ctx.menu.notifications) then
				ctx.notifications:render()
			end

			if ui.get(ctx.menu.indicators) then
				ctx.indicators:render()
			end

			if ui.get(ctx.menu.watermark) then
				ctx.watermark:render()
			end		
		end
		
	},
	{
		"aim_fire" .. "remove_this", 0, function(e)	
			local flags = {
        e.teleported and 'T' or '',
        e.interpolated and 'I' or '',
        e.extrapolated and 'E' or '',
        e.boosted and 'B' or '',
        e.high_priority and 'H' or ''
    	}
    	local group = hitgroup_names[e.hitgroup + 1] or '?'
			local r, g, b, a = ui.get(ctx.menu.color)
			ctx.notifications:new(string.format('fired at %s (%s) for %d dmg (chance=%d%%, bt=%2d, flags=%s)', string.lower(entity.get_player_name(e.target)), group, e.damage, math.floor(e.hit_chance + 0.5), time_to_ticks(e.backtrack), table.concat(flags)), r, g, b)
		end
	},
	{
		"aim_hit", 0 , function(e)
			local r, g, b = ui.get(ctx.menu.color)
			local group = hitgroup_names[e.hitgroup + 1] or '?'
			ctx.notifications:new(string.format('hit %s in the %s for %d damage (%d health remaining)', string.lower(entity.get_player_name(e.target)), group, e.damage, entity.get_prop(e.target, 'm_iHealth')), r, g, b)
		end
	},
	{
		"aim_miss", 0 , function(e)
			local group = hitgroup_names[e.hitgroup + 1] or '?'
			ctx.notifications:new(string.format('missed %s (%s) due to %s', string.lower(entity.get_player_name(e.target)), group, e.reason), 255, 120, 120)
		end
	},
	{
		"ui_callback", 0, function()
			ctx.menu:initialize()
		end
	},
	{
		"round_start", 0, function()
			ctx.notifications:clear()
		end
	},
	{
		"client_disconnect", 0, function()
			ctx.notifications:clear()
		end
	},
	{
		"predict_command", 0, function()
			local tickbase = entity.get_prop(entity.get_local_player(), "m_nTickBase")
			ctx.helpers.defensive = math.abs(tickbase - ctx.helpers.checker)
			ctx.helpers.checker = math.max(tickbase, ctx.helpers.checker or 0)
		end
	}
}) do
	if cid[1] == 'ui_callback' then
		cid[3]()
	else
		client.delay_call(cid[2], function()
				client.set_event_callback(cid[1], cid[3])
		end)
	end
end

local exp_stage = ui.new_button("AA", "Anti-aimbot angles", "Export Stage Config", export_stage_cfg)
local imp_stage = ui.new_button("AA", "Anti-aimbot angles", "Import Stage Config", import_stage_cfg)
local exp = ui.new_button("AA", "Anti-aimbot angles", "Export Full Config", export_cfg)
local imp = ui.new_button("AA", "Anti-aimbot angles", "Import Full Config", import_cfg)