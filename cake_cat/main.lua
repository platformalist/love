
 --  ________   ________   __    __   ________
 -- |  _____|  |  ____ |  | |   / /  |  _____|
 -- | |        | |___| |  | |__/ /   | |______
 -- | |        |  ____ |  |  _  /    |  _____|
 -- | |______  | |   | |  | |  \ \   | |______
 -- |_______|  |_|   |_|  |_|   \_\  |_______|
 --  ________   ________   ________
 -- |  _____|  |  ____ |  |___  __|
 -- | |        | |___| |     | |
 -- | |        |  ____ |     | |
 -- | |______  | |   | |     | |
 -- |_______|  |_|   |_|     |_|


-- Cake Cat
-- Eggnog Games
-- 2019

-- Game by Andrew Reist
-- eggnog.itch.io
-- platformalist.newgrounds.com
-- gamejolt.com/@platformalist

-- Cake Cat uses the RKBV Palette:
-- lospec.com/palette-list/rkbv
-- It's a good palette. Use it!

-- Thanks to Paige for baking the cake that inspired this game.


function love.load()

	require("default")
	require("player")
	require("ui")
	require("rules")
	require("objects")
	require("particles")

	-- delta adjust - once speeds are multiplied by delta time, they need to be
	-- increased by a set amount to get objects moving at the proper speed again.
	-- wouldn't be necessary if delta time was included in the code from the start.
	dtAdjust = 53
	dtAnimAdjust = 40
	
	-- global vars
	state = 1
	resetTimer = 15

	default_init()
	
	color = {
		{255,255,255},
		{21,25,26},
		{138,76,88},
		{217,98,117},
		{230,184,193},
		{69,107,115},
		{75,151,166},
		{165,189,194},
		{255,245,247}
		}	
	
	-- banks
		
	spriteBank = {
		player = love.graphics.newImage("sprites/player.png"),
		objects = love.graphics.newImage("sprites/objects.png"),
		titlecard = love.graphics.newImage("sprites/titlecard.png"),
		instructioncard = love.graphics.newImage("sprites/instructioncard.png"),
		gameover = love.graphics.newImage("sprites/gameover.png"),
		bg = love.graphics.newImage("sprites/bg.png"),
		eggnog = love.graphics.newImage("sprites/eggnog.png"),
		pause = love.graphics.newImage("sprites/pause.png")
		}
	
	quadBank = {
		player = {},
		objects = {}
		}

	get_quad(spriteBank.player,quadBank.player,16,12)
	get_quad(spriteBank.objects,quadBank.objects,8,8)
	
	audio = {
		[1] = love.audio.newSource("audio/1.ogg", "static"),
		[2] = love.audio.newSource("audio/2.ogg", "static"),
		[3] = love.audio.newSource("audio/3.ogg", "static"),
		[4] = love.audio.newSource("audio/4.ogg", "static"),
		[5] = love.audio.newSource("audio/5.ogg", "static"),
		[6] = love.audio.newSource("audio/6.ogg", "static")
	}

	-- kick off the game
	game_start()
	ui_init()
	
end

function love.update(dt)
	default_update()
	ui_update(dt)
	if state == 1 then
		player_animation(dt)
	elseif state == 2 then
		object_update(dt)
		player_update(dt)
		game_rules()
	end
	particle_update()
	test_update()
end

function love.draw()
	-- set screen in middle of castle panel
	local ww, wh = love.graphics.getDimensions()
	love.graphics.translate(0.5 * (ww - 512), 0.5 * (wh - 512))
	col(1)
	default_draw()
	bg_draw()
	object_draw()
	particle_draw()
	player_draw()
	ui_draw()
	test_draw()
end

function test_update()
end

function test_draw()

end
