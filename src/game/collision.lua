--[[
 * Copyright (C) 2015 Ricky K. Thomson
 * 
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
 * GNU General Public License for more details.
 * u should have received a copy of the GNU General Public License
 * along with this program. If not, see <http://www.gnu.org/licenses/>.
 --]]
 
collision = {}

function collision:checkWorld(dt)
	if not editing and player.alive then
		self:bounds()
		self:enemies(dt) -- move this to physics module
	end
end

function collision:check(x1,y1,w1,h1, x2,y2,w2,h2)
	world.collision = world.collision +1
	return x1 < x2+w2 and
		 x2 < x1+w1 and
		 y1 < y2+h2 and
		 y2 < y1+h1
end

function collision:right(a,b)
	world.collision = world.collision +1
	return a.newX < b.x+b.w and 
					a.x > b.x+b.w 
end

function collision:left(a,b)
	world.collision = world.collision +1
	return a.newX+a.w > b.x and 
					a.x+a.w < b.x 
end

function collision:top(a,b)
	world.collision = world.collision +1

	return a.newY+a.h > b.y  and 
					a.y+a.h-(a.h/4) < b.y
					--a.y+a.h-2 < b.y
					-- why -2?
end

function collision:bottom(a,b)
	world.collision = world.collision +1
	return a.newY < b.y+b.h and 
					a.y+a.h > b.y+b.h
end

function collision:above(a,b)
	--use this for a bigger intersect, eg; attacking a small enemy from above
	world.collision = world.collision +1
	return a.newY+a.h > b.y  and 
					a.y-a.h < b.y
end

function collision:bounds() 
	-- we might not need these, if map size can be unlimited?
	--if player.x < 0 then
	--	player.x = 0
	--	player.xvel = 0
	--end
end






--TODO MOVE THIS to physics.lua
function collision:enemies(dt)
	if mode == "editing" then return end
	local i, enemy
	for i, enemy in ipairs(enemies) do
		if world:inview(enemy) and enemy.alive then
			if enemy.name == "walker" then
				if collision:check(player.newX,player.newY,player.w,player.h,
					enemy.x+5,enemy.y+5,enemy.w-10,enemy.h-10) then
					-- if we land on top, kill enemy
					if collision:above(player,enemy) then	
						if player.jumping then
						--player.y = enemy.y - player.h -1 *dt
							popups:add(enemy.x-enemy.w,enemy.y+enemy.h/2,"+"..enemy.score)
							player.yvel = player.mass
							player:attack(enemy)
							return true
							
						else
							-- otherwise we die			
							player:die(enemy.name)
							
						end
						
							
					end
				end
			end
			
			if enemy.name == "floater" then
				if collision:check(player.newX,player.newY,player.w,player.h,
					enemy.x+5,enemy.y+5,enemy.w-10,enemy.h-10) then
					-- if we land on top, kill enemy
					if player.jumping then	
											
						if player.y > enemy.y then
							player.yvel = -player.mass
						elseif player.y < enemy.y then
							player.yvel = player.mass
						end
						
						--[[
						if player.x > enemy.x then
							player.xvel = player.mass/2
						elseif player.x < enemy.x then
							player.xvel = -player.mass/2
						end
						--]]
						popups:add(enemy.x-enemy.w/2,enemy.y+enemy.h/2,"+"..enemy.score)
						enemy.alive = false
						player:attack(enemy)
						
							
					else			
						-- otherwise we die			
						player:die(enemy.name)
					end
				end
			end
			
			if enemy.name == "spike" or enemy.name == "spike_large" then
				if collision:check(player.newX,player.newY,player.w,player.h,
					enemy.x+5,enemy.y+5,enemy.w-10,enemy.h-10) then
					player:die(enemy.name)
				end
			end
			
			if enemy.name == "icicle" then
				if collision:check(player.newX,player.newY,player.w,player.h,
					enemy.x-50,enemy.y,enemy.w+50,enemy.h+200) and enemy.y == enemy.yorigin then
					enemy.falling = true
				
				end
			
				if collision:check(player.newX,player.newY,player.w,player.h,
					enemy.x+5,enemy.y+5,enemy.w-10,enemy.h-10) and enemy.falling then
						player:die(enemy.name)
				end
			end
			
			if enemy.name == "spikeball" then
				if collision:check(player.newX,player.newY,player.w,player.h,
					enemy.x-enemy.gfx:getWidth()/2+5,enemy.y-enemy.gfx:getHeight()/2+5,enemy.w-10,enemy.h-10)  then
					player:die(enemy.name)
				end
			end
		end
	end
end









