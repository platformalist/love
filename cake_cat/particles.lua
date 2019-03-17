-- particle functions

function particle_init()
	crumb = {}
end

function particle_update()
	for k,v in ipairs(crumb) do
		crumb_update(v)
	end
end

function particle_draw()
	for k,v in ipairs(crumb) do
		crumb_draw(v)
	end
end


function bump(j,k)
	for i = 1,10 do
		table.insert(crumb,crumb_make(j,k,9,7,rnd(0,1)))
	end
end

function chomp(j,k)
	for i = 1,15 do
		table.insert(crumb,crumb_make(j,k,5,4,rnd(0,3)))
	end
end


--------------------------------------

function crumb_make(x,y,c1,c2,r)
	local new_crumb = {
	x = x + rnd(0,4) - 2,
	y = y + rnd(0,4) - 2,
	xd = rnd(0,4) - 2,
	yd = rnd(0,4) - 2,
	r = r,
	segments = 5,
	c1 = c1,
	c2 = c2
	}
	return new_crumb
end

function crumb_update(v)
	if v.r > 0 then
		v.r = v.r - .2
		v.x = v.x + v.xd
		v.y = v.y + v.yd
	else
		-- delete crumb. if last one on-screen, clean the table
		if #crumb == 1 then
			crumb = {}
		else
		table.remove(crumb,get_index(crumb,v))
		end
	end
end

function crumb_draw(v)
	col(v.c1)
	love.graphics.circle("fill",v.x,v.y,v.r,v.segments)
	col(v.c2)
	love.graphics.circle("line",v.x,v.y,v.r,v.segments)
	col(1)
end
