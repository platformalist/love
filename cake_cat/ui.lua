-- ui functions

function ui_init()
	title = {
	x = 62,
	y = 33,
	t = -3.1,
	introDrop = -120,
	introSlide = -260,
	introSplode = false,
	audio = false,
	pauseTimer = 30,
	pauseRelease = true
	}
end

function title_drop_behavior()
	if title.introDrop < 0 then
		title.introDrop = title.introDrop + 4.8
	end
	if title.introSlide < 0 then
		title.introSlide = title.introSlide + 10
	else
		-- kick off the game
		if btn("left","a") or
			btn("right","d") or
			btn("up","w") or
			btn("down","s") then
			if state == 3 then
				game_start()
			end
			love.audio.stop(audio[5])
			audio[3]:play()
			state = 2
		end
	end
end

function ui_update()
	if state == 1 or
		state == 3 then
		-- slide in the title card and instructions
		if state == 3 then
			if resetTimer > 0 then
				resetTimer = resetTimer - 1
			else
				title_drop_behavior()
			end
		elseif state == 1 then
			title_drop_behavior()
		end
	else
		-- move drop and slide away
		if title.introDrop > -120 then
			title.introDrop = title.introDrop - 9.6
		else
			if title.audio == true then
				title.audio = false
			end
		end
		if title.introSlide > -260 then
			title.introSlide = title.introSlide - 20
		end
	end
	
	-- move title card up and down on a sin wave
	if title.t < 3 then
		title.t = title.t + .05
	else
		title.t = -3.1
	end
	title.y = title.y + math.sin(title.t)/4
	if btn("o","0") then
		table.insert(ball,ball_make())
	end
	
	-- kick off the music when the title drops
	if title.introDrop > -1 and
		title.audio == false then
				audio[5]:play()
		title.audio = true
	end
	
	-- allow player to pause during gameplay
	if state == 2 and
		btn("return") and
		title.pauseRelease == true then
		state = 4
		title.pauseRelease = false
		audio[6]:play()
	end
	
	-- pause actions
	if state == 4 then
		if title.pauseRelease == true and
			btn("return") then
			state = 2
			title.pauseRelease = false
			audio[6]:play()
		end
		-- run pause timer when paused
		if title.pauseTimer > 0 then
			title.pauseTimer = title.pauseTimer - 1
		else
			title.pauseTimer = 30
		end
	end
	-- allow player to unpause
	if btn("return") == false then
		title.pauseRelease = true
	end
end

function bg_draw()
	col(1)
	love.graphics.draw(spriteBank.bg,6,0,0,1,1,6)	
end

function ui_draw()

	-- draw title screen at start	
	col(1)
	love.graphics.draw(spriteBank.titlecard,title.x,title.y + title.introDrop,0,1,1,6)	
	love.graphics.draw(spriteBank.instructioncard,6 + title.introSlide,179,0,1,1,6)	
	love.graphics.draw(spriteBank.eggnog,40 + title.introSlide,134,0,1,1,6)	
	love.graphics.draw(spriteBank.eggnog,161- title.introSlide,134,0,1,1,6)	

	col(2)
 	love.graphics.print("Grab cake, but watch out for donuts!\nRun with the arrow keys!",10 + title.introSlide,191)	
	col(1)

	-- draw score when dead
	if state == 3 then
	col(1)
	love.graphics.draw(spriteBank.titlecard,title.x,title.y + title.introDrop,0,1,1,6)	
	love.graphics.draw(spriteBank.instructioncard,6 + title.introSlide,179,0,1,1,6)	
	col(2)
 	love.graphics.print("Game over!  Score: "..score.."  Hiscore: "..hiscore.."\nPress run to start!",10 + title.introSlide,191)	
	end

	-- sidebars
	col(2)
	love.graphics.rectangle("fill",0,-1,-100,257)
	love.graphics.rectangle("fill",256,0,356,257)
	
	-- pause screen
	col(1)
	if state == 4 and
		title.pauseTimer > 10 then
		love.graphics.draw(spriteBank.pause,110,120,0,1,1,6)	
	end
end