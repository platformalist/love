-- game rules

function game_start()
	if state == 1 then
		player_init()
	end
	score = 0
	if hiscore == nil then
		hiscore = 0
	end
	object_init()
	particle_init()
	resetTimer = 15
end


function game_rules()
--	object_init()
	if #cake == 0 then
		table.insert(ball,ball_make())
		table.insert(cake,cake_make())
	end
end