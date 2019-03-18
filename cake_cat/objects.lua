-- object functions

function object_init()
	ball = {}
	cake = {}
end

function object_update(dt)
	for k,v in ipairs(ball) do
		ball_update(v,dt)
	end
	for k,v in ipairs(cake) do
		cake_update(v,dt)
	end
end

function object_draw()
	for k,v in ipairs(ball) do
		ball_draw(v)
	end
	for k,v in ipairs(cake) do
		cake_draw(v)
	end
end


--------------------

function cake_make()
	local new_cake = {
		x = rnd(15,241),
		y = rnd(15,241),
		w = 8,
		h = 8,
		s = 1,
		sf = 1,
		xOffset = 10,
		yOffset = 0,
		overlap = true,
	}
	chomp(new_cake.x+2,new_cake.y+2)
	return new_cake
end

function cake_update(v,dt)
	-- check if overlapping when first spawned
	if v.overlap == true then
		local q = 0
		for i,j in ipairs(ball) do
			if hit_detect(j,v) == true then
				q = q + 1
			end
		end
		if q == 0 then
			v.overlap = false
		end
	end
	-- hit detect with player
	if hit_detect(p,v) then
		score = score + 1
		chomp(v.x+2,v.y+2)
		table.remove(cake,get_index(cake,v))
		audio[1]:play()

	end
	--animation
	if v.s < 10.5 then
		v.s = v.s + .25 * (dt * dtAnimAdjust)
	else
		v.s = 1
	end
end

function cake_draw(v)
	love.graphics.draw(spriteBank.objects,quadBank.objects[math.floor(v.s)],v.x+v.xOffset,v.y+v.yOffset,0,v.sf,1,10)	
end

--------------------

function ball_make()
	local i = rnd(1,100)/50
	local j = 2-i
	local new_ball = {
		x = rnd(5,245),
		y = rnd(5,245),
		w = 6,
		h = 6,
		xd = i,
		yd = j,
		s = 11,
		sf = 1,
		t = 40,
		xOffset = 3,
		yOffset = -1
	}
	bump(new_ball.x+2,new_ball.y+2)
	return new_ball
end

function ball_update(v,dt)
	-- set original location
	local tx,ty = v.x,v.y

	-- move ball
	v.x = v.x + v.xd * dt * dtAdjust
	v.y = v.y + v.yd * dt * dtAdjust


	-- hit detection
	if v.t > 0 then
		v.t = v.t - 1
	elseif hit_detect(p,v) then
		audio[3]:play()
		set_hiscore()
		state = 3
	end
	
	-- bounce off other donuts
	for i,j in ipairs(ball) do
		if hit_detect(j,v) and
			v.x ~= j.x and
			v.y ~= j.y then
			bump((v.x+j.x)/2+2,(v.y+j.y)/2+2)
			audio[2]:play()

			v.x = tx
			 v.y = ty
			 v.xd = v.xd * -1
			 v.yd = v.yd * -1
			-- while overlapping, keep pushing donut away from other donut
			while hit_detect(j,v) do
				v.x = v.x + v.xd*8
				v.y = v.y + v.yd*8
			end
		 end
	end
	
	-- bounce off cake
	for i,j in ipairs(cake) do
		if j.overlap == false and
			hit_detect(j,v) then
			chomp((v.x+j.x)/2+2,(v.y+j.y)/2+2)
			audio[2]:play()
			v.x,v.y = tx,ty
			v.xd = v.xd * -1
			v.yd = v.yd * -1
			-- while overlapping, keep pushing donut away from cake
			while hit_detect(j,v) do
				v.x = v.x + v.xd*8
				v.y = v.y + v.yd*8
			end
		end
	end
	
	-- bounds
	if v.x+v.w > 254 or
	   v.x < 1 then
		bump(v.x+2,v.y+2)
			audio[4]:play()

		v.x = tx
		v.xd = v.xd * -1
	end
	if v.y+v.h > 254 or
	   v.y < 1 then
		bump(v.x+2,v.y+2)
			audio[4]:play()

	   v.y = ty
	 v.yd = v.yd * -1
	end

	-- set frozen donuts free
	if v.xd == 0 and
		v.yd == 0 then
		v.x = v.x + 3
		v.y = v.y + 3
	end

	--animation
	if v.s < 22.5 then
		v.s = v.s + .25 * (dt * dtAnimAdjust)
	else
		v.s = 11
	end
end

function ball_draw(v)
	-- draw every two frames if recently spawned
	if v.t > 0 then
		if math.floor(v.t/2)%2 == 0 then
		love.graphics.draw(spriteBank.objects,quadBank.objects[math.floor(v.s)],v.x+v.xOffset,v.y+v.yOffset,0,v.sf,1,4)	
		end
	else
		love.graphics.draw(spriteBank.objects,quadBank.objects[math.floor(v.s)],v.x+v.xOffset,v.y+v.yOffset,0,v.sf,1,4)	
	end
end
