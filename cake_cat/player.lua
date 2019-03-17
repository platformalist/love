-- player functions

function player_init()
	p = {
		x = 122,
		y = 144,
		xd = 0,
		yd = 0,
		w = 10,
		h = 9,
		s = 1,
		m = .9,
		acc = .5,
		maxv = 2,
		xOffset = 5,
		yOffset = -2
	}
end

function player_update(dt)
	-- set starting point
	local tx,ty = p.x,p.y

	-- move player w arrow keys
	if btn("left","a") then
		p.xd = p.xd - p.acc * (dt * dtAnimAdjust)
		p.sf = 1
	elseif btn("right","d") then
		p.xd = p.xd + p.acc * (dt * dtAnimAdjust)
		p.sf = -1
	end
	if btn("up","w") then
		p.yd = p.yd - p.acc * (dt * dtAnimAdjust)
	elseif btn("down","s") then
		p.yd = p.yd + p.acc * (dt * dtAnimAdjust)
	end
	
	-- max speed values
	p.xd,p.yd = norm_vector(p.xd,p.yd,p.maxv)
	p.x = p.x + p.xd * (dt * dtAdjust)
	p.y = p.y + p.yd * (dt * dtAdjust)
	
	-- apply momentum
	p.xd = p.xd * p.m
	p.yd = p.yd * p.m
	
	-- bounds
	if p.x+p.w > 256 or
	   p.x < 0 then
		p.xd = 0
		p.x = tx
	end
	if p.y+p.h > 254 or
	   p.y < 1 then
		p.yd = 0
		p.y = ty
	end
	
	player_animation(dt)
	
end

function player_animation(dt)
	if math.abs(p.xd) < .1 and
		math.abs(p.yd) < .1 then
		-- idle animation
		if p.s < 8.75 then
			p.s = p.s + .25 * (dt * dtAnimAdjust)
		else
			p.s = 1
		end
	else
		-- running animation
		if p.s > 12.5 or
			p.s < 9 then
			p.s = 9
		else
			p.s = p.s + .25 * (dt * dtAnimAdjust)
		end
	end
end

function player_draw()
	col(1)
	love.graphics.draw(spriteBank.player,quadBank.player[math.floor(p.s)],p.x+p.xOffset,p.y+p.yOffset,0,p.sf,1,6)	
end
