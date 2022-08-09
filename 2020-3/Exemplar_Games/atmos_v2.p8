pico-8 cartridge // http://www.pico-8.com
version 29
__lua__
-- atmos
-- game design, p toups
-- exemplar games

--{ global vars

	-- sprites
		local atmo_sprite
		local satelite_sprite
		local asteroid_sprite
		local gameover_sprite
		local jumping_sprite
		local inverseg_sprite
		local gravs_sprite
		local ijump_sprite

	-- actors
		local atmo
		local satelite
		local satelite2
		local asteroid
		local inverg
		local gdown
		
	-- movement
		local start_y
		local vel
		local gravity
		local inverseg
		local gravs
		
		-- timer
		local currtime
		local timer
		local colour
		
		
		-- levels
		local level
		local gameover
		local win
		local jumping
		
		-- map
		local map_x
		local dead
		local hit 
		local hita
		local hitast
		local heightcheck
		
		local deathsound
		
--} end global vars 

function _init()
 music(0)
	canjump = true
	win = false
	inverseg = false
	vel = 0
	gravity = 0.5
	timer = 0
	gameover = false
	dead = false
	hit = false
	hita = false
	ghit = false
	gdhit = false
	jumping = false
	ijumping = false
	heightcheck = false
	deathsound = false
	map_x = 0
	level = 0
	colour = 7
	currtime = time()
	
	atmo = {} -- init atmo values
	satelite = {}
	satelite2 = {}
	asteroid = {}
	inverg = {}
	gdown = {}

	
	--{ start of anim inits
	
	satelite_sprite = 37
	asteroid_sprite = 96
	jumping_sprite = 42
	gameover_sprite = 48
	atmo_sprite = 16
	inverseg_sprite = 64
	gravs_sprite = 65
	ijump_sprite =66
 
 --} end of anims inits
 satelite.x = 50
 satelite.y = 80
 satelite2.x = 90
 satelite2.y = 20
 asteroid.x = 140
 asteroid.y = 80
	atmo.x = 10 
	atmo.y = 50 
	inverg.x = 1
	inverg.y = 70
	gdown.x = 1
	gdown.y = 50
	start_y = atmo.y -- equate curr y value to start y value
end

function _update()

	if gameover and not dead then
			gameover_sprite += 0.25
			gameover_sprite = goanim(gameover_sprite,48,52) -- loop death anim
	else if (gameover and btnp(2)) then
			reinit()
	end
	end
	
	if win and btnp(2) then
		reinit()
	end
	
 hit = hashit()
 hita = hashitast()
	ghit = hashitg()
	gdhit = hashitgd()
--{ map scrolling

	if (map_x<-127) then 
		map_x=0
	end
	
--} end map scrolling

--{ time

 if (not hit and not game0over and not win) then
		timer = time() - currtime
		map_x-=0.1
	_move()
	end
		
--{ obj transformation	
	
	if (satelite.x < -20) then
		satelite.x = 130 or 190
	end
	
	satelite.x -= 1
	if (satelite2.x < -20) then
		satelite2.x = 150 or 210
	end
	
	satelite2.x -= 1	
	
		if (inverg.x < -20) then
		inverg.x = 300 or 800
	end
	
	inverg.x -= 1	
	
	if (gdown.x < -20) then
		gdown.x = 500 or 900
	end
	
	gdown.x -= 1	
	
		if (asteroid.x < -20) then
		asteroid.x = 130 or 190
	end
	
	asteroid.x -= 1

--} end obj transformation

--{ sprite manipulation
	
 if (btnp(2)) then
 	jumping = true
 	ijumping = true
 	sfx(0)
 if ( inverseg) then
 	gjump()
 	jumping = false
 	else if (not inverseg) then
 	jump()
 	end 
 end
end
 
 if (jumping and not inverseg) then
	 jumping_sprite = 44
		jumping = false
 else if (not jumping and not inverseg) then
 	jumping_sprite = 41
 	
 end
	end
	
		if (ijumping and inverseg) then
	ijump_sprite = 66
	ijumping = false
	else if(not ijumping and inverseg) then
	ijump_sprite = 41
	end
	end

--} end sprite manipulation

	if (hit or heighthit or hita) then
			gameover = true
	end
	
	if (ghit and not inverseg ) then

		inverseg = true
		
		if (inverseg) then
			gravity = gravity *-1
	
	end
end

	 if (gdhit and  inverseg ) then

		inverseg = false
		
		if ( not inverseg) then
			gravity = gravity *-1
	
	end
end
	
	
	if (timer >= 70) then
		win = true
	end
	
--} end time	
end


function _draw()
 cls(0) -- clear screen
 	 spr(asteroid_sprite, asteroid.x, asteroid.y, 2, 2)
 print(timer, 90,2,colour)
 map(0,0,map_x,0,128,32)
 map(0,0,map_x+128,0,128,32)
  if(not inverseg) then
 spr(jumping_sprite, atmo.x + 9, atmo.y + 12)
 else if (inverseg) then
 spr(ijump_sprite, atmo.x + 9, atmo.y + 1 )
	end 
end
 if (gameover) then
 	rectfill(34,50,94,74,7)
 	print("game over", 47, 53,5)
 	print("⬆️ to restart", 40, 65, 5)
 	spr(gameover_sprite, atmo.x + 7, atmo.y + 7)
	else if (win) then
		rectfill(34,50,94,74,7)
 	print("you win, gratz", 37, 53,5)
 	print("⬆️ to restart", 40, 65, 5)
	else if (not gameover) then
	 spr(atmo_sprite, atmo.x, atmo.y,3,2)

	end
	end
	end
	
	for i=0, 40 do
	spr(satelite_sprite, satelite.x, i+80)
	end
	
	for i=0, 40 do
	spr(satelite_sprite, satelite2.x, i+2)
	end
	
	spr(inverseg_sprite, inverg.x, inverg.y)
	
		spr(gravs_sprite, gdown.x, gdown.y)
	
	spr(1, 50, 43)
--spr(satelite_sprite, satelite.x, satelite.y,1,4)
end

-->8
function jump()
	if (not gameover) then
 	vel = -4.5
 end
end

function gjump()
	if (not gameover) then
 	vel = 2
 end
end

function _move()
	atmo.y += vel
	vel += gravity
end

function reinit()
	_init()
end


function goanim(sprite, animstart, animend)

	if (not deathsound and gameover) then
		sfx(1)
		deathsound = true
	end
	if (sprite > animend and gameover) then
			dead = true
	end
	return sprite
end

function hashitast()

	if (atmo.y >125 or atmo.y < 0) return true

	hita =	box_hit(atmo.x+8,atmo.y, 10, 5, asteroid.x,asteroid.y,8, 8)
	
	if (not hita) then
		hita = box_hit(atmo.x+8, atmo.y+9, 10, 5, asteroid.x, asteroid.y, 16, 16)
	end
	
	if (hita) then
		return true
	end
	return false
end

function hashit()

	if (atmo.y >125 or atmo.y < 0) return true

	hit =	box_hit(atmo.x+8,atmo.y, 15,5,satelite.x,satelite.y,2, 15)
	
	if (not hit) then
		hit = box_hit(atmo.x+8, atmo.y+9, 15, 4, satelite2.x, satelite2.y, 2, 68)
	end
	
	if (hit) then
		return true
	end
	return false
end

function hashitg()

	if (atmo.y >125 or atmo.y < 0) return true

		ghit = box_hit(atmo.x+8, atmo.y+8, 15, 4, inverg.x, inverg.y, 8, 8) 
  
if (ghit) then
  if (not inverseg) then
  sfx(11)
  end
		return true
	end
	return false
end

function hashitgd()

	if (atmo.y >125 or atmo.y < 0) return true

	gdhit =	box_hit(atmo.x+8,atmo.y+8, 15,5,gdown.x,gdown.y,8, 8)

if (gdhit) then

  if (inverseg) then
  sfx(12)
  end
		return true
	end
	return false
end




function box_hit(
	x1, y1,
	w1, h1,
	x2, y2,
	w2, h2)
	
	local hit = false
 local ghit = false
 local dhit = false
	local xs = w1*0.5 + w2*0.5
	local ys = h1*0.5	+	h2*0.5
	local xd = abs((x1+(w1/2)) - (x2+(w2/2)))
	local yd = abs((y1+(w1/2)) - (y2+(w2/2)))
	
	if (xd<xs) and (yd<ys) then
		
		ghit= true
	end
	
	return ghit
end
__gfx__
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000600000000000000000000000000000000000000000000000000000000444444000000000000000000000000000000000000000000000
007007000000000000000000000000006000000000000000000080000000c0000000000000004444444400000000000000000000000000666666000000000000
00077000000000000000000000000000000000000000000000006000000060000000000006644444444446600000000000000000000006665666600000000000
00077000000000000000000000060000000000000000000000056500000565000000000060444444444444060000000000000000000066666665660000000000
00700700000000000000000000000000000000000000000000056500000565000000000604444444444444406000000000000000000666666666666000000000
00000000060000000000000000000000000000000000000000056500000565000000000604444444444444406000000000000000006656666666666600000000
00000000000000000000000000000000000000000000000000056500000565000000000604444444444444406000000000000000006666666666656600000000
00000000000000000000000000000000000000000000000000056500000555000000000064444444444444460000000000000000006666665666666600000000
00000000000000000000000000000000000000000000000000056500000565000000000006666444444666600000000000000000006566666666666600000000
00000000000000000000000000000000000000000000000000056500000565000000000000444666666444000000000000000000006666666666666600000000
00000000000000000000000000000000000000000000000000056500000565000000000000044444444440000000000000000000000666666665666000000000
00000000000000000000000000000000000000000000000000056500000565000000000000004444444400000000000000000000000065666666660000000000
00000000000000000000000000000000000000000000000000056500000565000000000000000444444000000000000000000000000006666656600000000000
00000000000000000000000000000000000000000000000000056500000565000000000000000000000000000000000000000000000000666666000000000000
00000000000550000000000000000000000000000000000000056500000565000000000000000000000000000000000000000000000000000000000000000000
00000000005665000000000000000000000000005550000000055500000555000000000000000000000990000999999009999990099999900009900000000000
00000000555555555500000000000000000000005650000000056500000565000000000000000000000000000088880000999900008888000000000000000000
0000000566565666665c000000000000000000005650000000056500000565000000000000000000000000000000000000088000000000000000000000000000
00000000566565555555500000000000000000005650000000056500000565000000000000000000000000000000000000000000000000000000000000000000
00000000055555000000000000000000000000005650000000056500000565000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000005650000000056500000565000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000005650000000056500000565000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000005550000000056500000565000000000000000000000000000000000000000000000000000000000000000000
000000000000000000000000a000000a000000000000000000055500000555000000000000055500005555000000000055555555000000000000000000000000
00000000000000000900009000000000000000000000000000056500000565000000000005555055055555500055550055000055000055005500000000000000
00000000008008000000000000000000000000000000000000056500000565000000000055555550055500550550555050000005000566556650000000000000
00088000000990000000000000000000000000000000000000056500000565000000000005005500555550550055555550000005055555555555500000000000
0008800000099000000000000000000000000000000000000005650000056500000000000550550050555555005505555000000556656566665cc50000000000
00000000008008000000000000000000000000000000000000056500000565000000000000555550555555500550055550000005056656655555500000000000
00000000000000000900009000000000000000000000000000056500000565000000000000055050055555500555555055000055005555550000000000000000
000000000000000000000000a000000a000000000000000000055500000555000000000000005500000055000000550055555555000000000000000000000000
00003000000080000000000000000000888888888888888888888888000000000000000000000000000000000000000000000000000000000000000000000000
00033300000080000000000000000000800000000000000000000008000000000000000000000000000000000000000000000000000000000000000000000000
00333330000080000000000000000000808888888888888888888808000000000000000000000000000000000000000000000000000000000000000000000000
03333333000080000000000000000000808000000000000000000808000000000000000000000000000000000000000000000000000000000000000000000000
00003000088888880000000000000000808000000000000000000808000000000000000000000000000000000000000000000000000000000000000000000000
00003000008888800008800000000000808000000000000000000808000000000000000000000000000000000000000000000000000000000000000000000000
00003000000888000099990000000000808000000000000000000808000000000000000000000000000000000000000000000000000000000000000000000000
00003000000080000999999000000000808000000000000000000808000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000080800000000aa00000000808000000000000000000000000000000000000000000000000000000000000000000000000
000000000000000000000000000000008080000000aaaa0000000808000000000000000000000000000000000000000000000000000000000000000000000000
000000000000000000000000000000008080000000a00a0000000808000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000808000000aa00aa000000808000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000080800000aaa00aaa00000808000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000080800000aaaaaaaa00000808000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000080800000aaa00aaa00000808000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000808000000aaaaaa000000808000000000000000000000000000000000000000000000000000000000000000000000000
00055550005500000000000000000000808000000000000000000808000000000000000000000000000000000000000000000000000000000000000000000000
05555550000555000000000000000000808000000000000000000808000000000000000000000000000000000000000000000000000000000000000000000000
05505555000055000000000000000000808000000000000000000808000000000000000000000000000000000000000000000000000000000000000000000000
55000555500055500000000000000000808000000000000000000808000000000000000000000000000000000000000000000000000000000000000000000000
55000555555555500000000000000000808000000000000000000808000000000000000000000000000000000000000000000000000000000000000000000000
55500555555555550000000000000000808888888888888888888808000000000000000000000000000000000000000000000000000000000000000000000000
55505555555555550000000000000000800000000000000000000008000000000000000000000000000000000000000000000000000000000000000000000000
55555555555500550000000000000000888888888888888888888888000000000000000000000000000000000000000000000000000000000000000000000000
55555550055000050000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
50555500055000050000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00055000005500550000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00005000005555550000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00005550055555500000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00055550055555000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00555555555500000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00055555550000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__label__
88888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888
88888eeeeee888777777888888888888888888888888888888888888888888888888888888888888888ff8ff8888228822888222822888888822888888228888
8888ee888ee88778877788888888888888888888888888888888888888888888888888888888888888ff888ff888222222888222822888882282888888222888
888eee8e8ee87777877788888e88888888888888888888888888888888888888888888888888888888ff888ff888282282888222888888228882888888288888
888eee8e8ee8777787778888eee8888888888888888888888888888888888888888888888888888888ff888ff888222222888888222888228882888822288888
888eee8e8ee87777877788888e88888888888888888888888888888888888888888888888888888888ff888ff888822228888228222888882282888222288888
888eee888ee877788877888888888888888888888888888888888888888888888888888888888888888ff8ff8888828828888228222888888822888222888888
888eeeeeeee877777777888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
1eee1e1e1ee111ee1eee1eee11ee1ee1111116661166161611111616166616661171111111111111111111111111111111111111111111111111111111111111
1e111e1e1e1e1e1111e111e11e1e1e1e111116161616161611111616116111611711111111111111111111111111111111111111111111111111111111111111
1ee11e1e1e1e1e1111e111e11e1e1e1e111116611616116111111666116111611711111111111111111111111111111111111111111111111111111111111111
1e111e1e1e1e1e1111e111e11e1e1e1e111116161616161611111616116111611711111111111111111111111111111111111111111111111111111111111111
1e1111ee1e1e11ee11e11eee1ee11e1e111116661661161616661616166611611171111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111616166111111111161616611111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111616116111111111161611611111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111161116111111111166611611111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111616116111711111111611611171111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111616166617111111166616661711111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111616166111111111161616611111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111616116111111111161611611111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111616116111111111166611611111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111666116111711111161611611171111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111666166617111111161616661711111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111616166611111111161616661111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111616111611111111161611161111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111161166611111111166616661111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111616161111711111111616111171111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111616166617111111166616661711111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111616166611111111161616661171111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111616111611111111161611161117111111111111111117111111111111111111111111111111111111111111111111111111111111111111111111111111
11111616166611111111166616661117111111111111111117711111111111111111111111111111111111111111111111111111111111111111111111111111
11111666161111711111161616111117111111111111111117771111111111111111111111111111111111111111111111111111111111111111111111111111
11111666166617111111161616661171111111111111111117777111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111117711111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111171111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111e1111ee11ee1eee1e1111111616166616661111111111111ccc1ccc1c1111cc1ccc11111111111111111111111111111111111111111111111111111111
11111e111e1e1e111e1e1e1111111616116111611111177711111c111c1c1c111c111c1111111111111111111111111111111111111111111111111111111111
11111e111e1e1e111eee1e1111111666116111611111111111111cc11ccc1c111ccc1cc111111111111111111111111111111111111111111111111111111111
11111e111e1e1e111e1e1e1111111616116111611111177711111c111c1c1c11111c1c1111111111111111111111111111111111111111111111111111111111
11111eee1ee111ee1e1e1eee11111616166611611111111111111c111c1c1ccc1cc11ccc11111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111e1111ee11ee1eee1e11111111661616166616661111111111111ccc1ccc1c1111cc1ccc1111111111111111111111111111111111111111111111111111
11111e111e1e1e111e1e1e11111116111616116111611111177711111c111c1c1c111c111c111111111111111111111111111111111111111111111111111111
11111e111e1e1e111eee1e11111116111666116111611111111111111cc11ccc1c111ccc1cc11111111111111111111111111111111111111111111111111111
11111e111e1e1e111e1e1e11111116161616116111611111177711111c111c1c1c11111c1c111111111111111111111111111111111111111111111111111111
11111eee1ee111ee1e1e1eee111116661616166611611111111111111c111c1c1ccc1cc11ccc1111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111e1111ee11ee1eee1e11111116611616166616661111111111111ccc1ccc1c1111cc1ccc1111111111111111111111111111111111111111111111111111
11111e111e1e1e111e1e1e11111116161616116111611111177711111c111c1c1c111c111c111111111111111111111111111111111111111111111111111111
11111e111e1e1e111eee1e11111116161666116111611111111111111cc11ccc1c111ccc1cc11111111111111111111111111111111111111111111111111111
11111e111e1e1e111e1e1e11111116161616116111611111177711111c111c1c1c11111c1c111111111111111111111111111111111111111111111111111111
11111eee1ee111ee1e1e1eee111116661616166611611111111111111c111c1c1ccc1cc11ccc1111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111e1111ee11ee1eee1e111111161611661111111111111616166117171ccc11111ccc1111111111111616166617171ccc11111ccc11111111111111111111
11111e111e1e1e111e1e1e111111161616111111177711111616116111711c1c11111c111111117111111616111611711c1c11111c1111111111111111111111
11111e111e1e1e111eee1e111111116116661111111111111616116117771c1c11111ccc1111177711111616166617771c1c11111ccc11111111111111111111
11111e111e1e1e111e1e1e111111161611161111177711111666116111711c1c1111111c1111117111111666161111711c1c1111111c11111111111111111111
11111eee1ee111ee1e1e1eee1111161616611111111111111666166617171ccc11c11ccc1111111111111666166617171ccc11c11ccc11111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111e1111ee11ee1eee1e111111161611661111111111111616166117171ccc11111ccc1111111111111616166617171ccc11111ccc11111111111111111111
11111e111e1e1e111e1e1e111111161616111111177711111616116111711c1c11111c111111117111111616111611711c1c11111c1111111111111111111111
11111e111e1e1e111eee1e111111166616661111111111111666116117771c1c11111ccc1111177711111666166617771c1c11111ccc11111111111111111111
11111e111e1e1e111e1e1e111111111611161111177711111616116111711c1c1111111c1111117111111616161111711c1c1111111c11111111111111111111
11111eee1ee111ee1e1e1eee1111166616611111111111111616166617171ccc11c11ccc1111111111111616166617171ccc11c11ccc11111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111e1111ee11ee1eee1e111111161616611111111111111bbb1bbb11bb1171117116161661111111711616166111171ccc1171117111111111111111711616
11111e111e1e1e111e1e1e111111161616161111177711111b1b1b1b1b11171117111616116111711711161611611171111c1117111711111111111117111616
11111e111e1e1e111eee1e111111116116161111111111111bbb1bb11bbb1711171111611161177717111616116111711ccc1117111711111777111117111161
11111e111e1e1e111e1e1e111111161616161111177711111b1b1b1b111b1711171116161161117117111666116111711c111117111711111111111117111616
11111eee1ee111ee1e1e1eee1111161616661111111111111b1b1bbb1bb11171117116161666111111711666166617111ccc1171117111111111111111711616
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111e1111ee11ee1eee1e111111161616611111111111111bbb1bbb11bb1171117116161661111111711616166111171ccc1171117111111111111111711616
11111e111e1e1e111e1e1e111111161616161111177711111b1b1b1b1b11171117111616116111711711161611611171111c1117111711111111111117111616
11111e111e1e1e111eee1e111111166616161111111111111bbb1bb11bbb1711171116661161177717111616116111711ccc1117111711111777111117111666
11111e111e1e1e111e1e1e111111111616161111177711111b1b1b1b111b1711171111161161117117111666116111711c111117111711111111111117111116
11111eee1ee111ee1e1e1eee1111166616661111111111111b1b1bbb1bb11171117116661666111111711666166617111ccc1171117111111111111111711666
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111eee1eee1111117116161661111716161166117111111eee1ee11ee11111117116161661111716161166117111111eee1e1e1eee1ee11111111111111111
111111e11e111111171116161616117116161611111711111e1e1e1e1e1e11111711161616161171161616111117111111e11e1e1e111e1e1111111111111111
111111e11ee11111171111611616171111611666111711111eee1e1e1e1e11111711166616161711166616661117111111e11eee1ee11e1e1111111111111111
111111e11e111111171116161616117116161116111711111e1e1e1e1e1e11111711111616161171111611161117111111e11e1e1e111e1e1111111111111111
11111eee1e111111117116161666111716161661117111111e1e1e1e1eee11111171166616661117166616611171111111e11e1e1eee1e1e1111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
111111111166161616661666111111111ccc1ccc1c1c1ccc11111111111111111111111111111111111111111111111111111111111111111111111111111111
1111111116111616116111611777111111c11c1c1c1c1c1111111111111111111111111111111111111111111111111111111111111111111111111111111111
1111111116111666116111611111111111c11cc11c1c1cc111111111111111111111111111111111111111111111111111111111111111111111111111111111
1111111116161616116111611777111111c11c1c1c1c1c1111111111111111111111111111111111111111111111111111111111111111111111111111111111
1111111116661616166611611111111111c11c1c11cc1ccc11111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111eee1ee11ee11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111e111e1e1e1e1111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111ee11e1e1e1e1111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111e111e1e1e1e1111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111eee1e1e1eee1111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
88888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888
82888222822882228888822282828882822882228228888888888888888888888888888888888888888882288222822282228882822282288222822288866688
82888828828282888888888282828828882888828828888888888888888888888888888888888888888888288282828288828828828288288282888288888888
82888828828282288888888282228828882882228828888888888888888888888888888888888888888888288282822282228828822288288222822288822288
82888828828282888888888288828828882882888828888888888888888888888888888888888888888888288282888282888828828288288882828888888888
82228222828282228888888288828288822282228222888888888888888888888888888888888888888882228222888282228288822282228882822288822288
88888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888

__map__
0101050505050505050505050105050100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0505050505030505050505050505050500000400000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0508090a0b050505050505050505010500000000000002000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0505191a05010105050505010523230500000000000000000002000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0205050505050505050505050105030500000300000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0105010505050505050501050505050500000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0105020505050505050505050505050100000000000000000400000100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0505050505050505050105050505050500000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
01050503053f3f3f0505050505053f0500000000000200000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000030000040000010000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000020000000200000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000040000000000000000000300000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000040000000000020000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000d0e000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000003000000000300001d1e000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0500000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0500000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__sfx__
000100001161014640186201e6202361027620296202a6202a6202a6202a62029620286202662024620226201b62018620116200f6200d6200b6100a61008610086100762007620086100a6200d6201162014620
000200000705034050340500605033050330500505033650306502e6502b650286502565023650206501e6501c6501b6501a6501865017650176501765014650136501365012650136501365013650136500c650
011000200c013000000c615000000c013000000c615000000c013000000c615000000c013000000c615000000c013000000c615000000c013000000c615000000c013000000c615000000c013000000c61500000
011000200c7100e7101071000000107100000010710107101071011710137100000013710000001371013710137101771018710000001871000000187101871013710187101c710000001c710000001c7101c710
011000200c0130000000000001000c0130010000100001000c0130010000100001000c0130010000100001000c0130010000100001000c0130010000100001000c0130010000100001000c013001000c61500100
011000080071505705077150470500715007050771500000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
012000000051007510005100751000510075100051007510045100b510045100b510045100b510045100b51002510095100251009510025100951002510095100051007510005100751000510075100051007510
011000000c5120c5120c5120c5120c5120c5120c5120c5120c5120c5120c5120c5120c5120c5120c5120c5120e5120e5120e5120e5120e5120e5120e5120e5120e5120e5120e5120e5120e5120e5120e5120e512
01200000105111051110511105110c5110c5110c5110c511135111351113511135110e5110e5110e5110e5110c5120c5120c5120c5120e5120e5120e5120e5121051210512105121051213512135121351213512
01200000185121851218512185120e5120e5120e5120e51210512105121051210512135121351213512135121051210512105121051218512185121851218512135121351213512135120e5120e5120e5120e512
011000001851200000000000000000000000000000000000000000e51200000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0008000024570005002c5700c50035570165001850000500105001c5000750009500105000050022500265002650000500005000b5001b50014500115000d5000850006500005001750011500075000350000500
0008000035560005002d5600050022560015000050000500005000050000500005000050000500005000050000500005000050000500005000050000500005000050000500005000050000500005000050000500
__music__
00 04464748
00 04064748
00 04060708
00 04060709
00 04060708
00 04060709
00 04060708
00 04060709
00 04060708
00 04060709
00 04060708
00 04060709
00 04060708
00 04060709
00 04060708
00 04060709
00 04060708
00 04060709

