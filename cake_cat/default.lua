
function default_init()
	screen_set()
	simple_functions()
end

function default_update()
	fullscreen()
end

function default_draw()
	-- translation and scaling based on window size (must be in order)
	love.graphics.translate(screen.loffset,0)
	love.graphics.scale(screen.scale,screen.scale)
end

function set_hiscore()
	-- set end-game score and hiscore, since game just ended
	if score > hiscore then
		hiscore = score
	end
	-- define save file, and grab current hiscore from it
	local saveFile = love.filesystem.newFile("cakecat_save.sav")
	-- open file to read, then close it
	saveFile:open('r')
	i = saveFile:read()
	saveFile:close()
	-- set currentHiscore as either the saveFile's content or 0, if there's no content yet.
	if i ~= nil then
		currentHiscore = i
	else
		currentHiscore = 0
	end	
	-- compare file system hiscore vs recent game hiscore, and set new hiscore as the higher number
	i = math.max(hiscore,currentHiscore)
	-- commit new hiscore to memory
	saveFile:open('w')
	saveFile:write(i)
	saveFile:close()
	hiscore = i
end

function screen_set()
	i,j = love.window.getDesktopDimensions(desktop)
	desktop = {
		w = i,
		h = j
	}

	screen = {}
		screen.w = 256
		screen.h = 256
		screen.scale = 2
		screen.loffset = 0
		screen.fullscreen = false

	love.window.setMode(screen.w*2,screen.h*2, {fullscreen = false, resizable = false, borderless = false, display = 1, centered = true})
	love.graphics.setDefaultFilter("nearest")
	love.graphics.setNewFont("fonts/EnterCommand.ttf",16)		
	love.graphics.setLineStyle( 'rough' )
	
end

function fullscreen()
	-- probably not going to allow this on castle games. keep it simple.
	-- set fullscreen
	-- if love.keyboard.isDown("f") then
		-- love.window.setMode(desktop.w,desktop.h, {fullscreen = false, resizable = false, borderless = true, display = 1, centered = true})
		-- screen.fullscreen = true
		-- screen.scale = desktop_check(desktop.w,desktop.h,screen.w,screen.h)
		-- screen.loffset = (desktop.w - (screen.w * screen.scale)) / 2
	-- end
	-- -- exit fullscreen
	-- if love.keyboard.isDown("g") then
		-- love.window.setMode(screen.w*2,screen.h*2, {fullscreen = false, resizable = false, borderless = false, display = 1, centered = true})
		-- screen.fullscreen = false
		-- screen.scale = 2
		-- screen.loffset = 0
	-- end
end

function desktop_check(i,j,k,l)
	-- if desktop is wider than graphics, return scaling based on height
	if i/j > k/l then
		return desktop.h / screen.h
	-- if desktop is taller than graphics, return scaling based on width
	else
		return desktop.w / screen.w
	end
end

function get_quad(source, array, spriteWidth, spriteHeight)
	-- get_quad() allows you to set all quads from a horizontal spritesheet (16x16 grid) without manually setting every
	-- entry in the array. feed this function the source sprite and the target table, and the table will fill with quads.
	local x,y = source:getDimensions()
	local w = math.ceil(x/spriteWidth)
	for i = 1,w do
		array[i] = love.graphics.newQuad((i-1)*spriteWidth, 0, spriteWidth, spriteHeight, x, y)
	end
end

function simple_functions()
	spr = love.graphics.draw
	btn = love.keyboard.isDown
	rect = love.graphics.rectangle
	circ = love.graphics.circle
end

function col(i)
	love.graphics.setColor(color[i][1]/255,color[i][2]/255,color[i][3]/255)
end

function round(i)
	return i % 1 >= 0.5 and math.ceil(i) or math.floor(i)
end

function mget(i,j)
	k = currentMap[i + j*32]
	return k
end

function draw_hitbox(v)
	love.graphics.rectangle("line",v.x,v.y,v.w,v.z)
end

 function norm_vector(i,j,k)
    q = math.sqrt(i*i+j*j)
    if q > k then
        return (k/q)*i,(k/q)*j
    else
        return i,j
    end
end

function hit_detect(i,j)
	if i.x > j.x + j.w or
		i.x + i.w < j.x or
		i.y > j.y + j.h or
		i.y + i.h < j.y then
		return false
	else
		return true
	end
end

function rnd(i,j)
	return math.random(i*100,j*100)/100
end

function get_index(tab,j)
	for index, value in pairs(tab) do
		if value == j then
			return index
		end
	end
end