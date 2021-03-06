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
 
platforms = {}

platform_link = love.graphics.newImage("data/images/tiles/link.png")
platform_link_origin = love.graphics.newImage("data/images/tiles/link_origin.png")
platform_cradle = love.graphics.newImage("data/images/tiles/cradle.png")

platform_grass = love.graphics.newImage("data/images/tiles/grass.png")




platforms.textures =  textures:load("data/images/textures/")


function platforms:add(x,y,w,h,clip,movex,movey,movespeed,movedist,swing,angle,texture)

	
	table.insert(platforms, {
		--dimensions
		x = x or 0, 
		y = y or 0,
		w = w or 0,
		h = h or 0,

		--properties
		name = "platform",
				
		--movement
		movex = movex or 0,
		movey = movey or 0,
		movespeed = movespeed or 100,
		movedist = movedist or 200,
		clip = clip or 1,
		xorigin = x,
		yorigin = y,
		texture = texture or 1,
		carrying = false,
		
		--swing platforms
		swing = swing or 0,
		angle = angle or 0,
		radius = 200 or 0,
	})
	
	
	print("platform added @  X:"..x.." Y: "..y .. "(w:" .. w .. " h:".. h.. ")")
end



function platforms:drawlink(platform)

	--origin
	love.graphics.setColor(255,255,255,255)
	love.graphics.draw(platform_link_origin, platform.xorigin-platform_link_origin:getWidth()/2, platform.yorigin-platform_link_origin:getHeight()/2, 0,1,1)
	
	local r = 0

	--link
	while r < platform.radius do
		r = r + platform_link:getHeight()
		local x = r * math.cos(platform.angle) + platform.xorigin
		local y = r * math.sin(platform.angle) + platform.yorigin

		love.graphics.draw(platform_link, x-platform_link:getWidth()/2, y-platform_link:getHeight()/2, 0,1,1)

	end
	
end

function platforms:draw()
	local count = 0
	
	local i, platform
	for i, platform in ipairs(platforms) do
		if world:inview(platform) then
		count = count + 1
			
			if platform.name == "platform" then
	 	
			
				if platform.swing == 1 then

					platforms:drawlink(platform, radius)
					
					love.graphics.setColor(
						platform_behind_r,
						platform_behind_g,
						platform_behind_b,
						255
					)
					love.graphics.draw(platform_cradle, platform.x-platform_cradle:getWidth()/2,platform.y-platform_cradle:getHeight()/1.5)
				end
				
				
				if (platform.movex == 1) or (platform.movey == 1) then
					love.graphics.setColor(
						platform_move_r,
						platform_move_g,
						platform_move_b,
						255
					)
				elseif platform.clip == 0 then
					love.graphics.setColor(
						platform_behind_r,
						platform_behind_g,
						platform_behind_b,
						255
					)

				else
					love.graphics.setColor(
						platform_r,
						platform_g,
						platform_b,
						255
					)

				end

	
				local quad = love.graphics.newQuad( 0,0, platform.w, platform.h, self.textures[platform.texture]:getDimensions() )
				self.textures[platform.texture]:setWrap("repeat", "repeat")
				love.graphics.draw(self.textures[platform.texture], quad, platform.x,platform.y)
	
				
				--[[
				--test polygon/mesh texturing (may be needed in future)
				local mesh = love.graphics.newMesh(4, "fan", "dynamic")
				local cols = math.ceil( platform.w/self.textures[platform.texture]:getWidth())
				local rows = math.ceil(platform.h/self.textures[platform.texture]:getHeight())
				print (cols,rows)
				
				local verts
				
				verts = { 
					{0,0, 0,0},  
					{0,0+platform.h, 0,rows}, 
					{0+platform.w,0+platform.h, cols,rows}, 
					{0+platform.w,0, cols,0}
				}

				mesh:setVertices(verts)
				mesh:setTexture(self.textures[platform.texture])
				love.graphics.draw(mesh, platform.x, platform.y)
				--]]
				
				
				

				local offset
				if platform.movex == 1 or (platform.movey == 1) then
					 offset = 4
				else
					 offset = 10
				end
				--shaded edges
				love.graphics.setColor(0,0,0,85)
				--right
				love.graphics.rectangle("fill", platform.x+platform.w-offset, platform.y, offset, platform.h -offset)
				--bottom
				love.graphics.rectangle("fill", platform.x, platform.y+platform.h-offset, platform.w, offset)
				--left
				love.graphics.rectangle("fill", platform.x, platform.y, offset, platform.h - offset)

				
				
		
				--top surface
				love.graphics.setColor(
					platform_top_r,
					platform_top_g,
					platform_top_b,
					255
				)
				
				local offset = 5
				local quad = love.graphics.newQuad( 0,0, platform.w, platform_grass:getHeight(), platform_grass:getDimensions() )
				platform_grass:setWrap("repeat", "repeat")
				love.graphics.draw(platform_grass, quad, platform.x,platform.y-offset)
				

				--[[ --untextured fallback
				--surface
				love.graphics.rectangle("fill", platform.x, platform.y-5, platform.w, 10)	
				
					--arced edges
					love.graphics.arc( "fill", platform.x+platform.w, platform.y, -5, math.pi/2, math.pi*1.5 )
					love.graphics.arc( "fill", platform.x, platform.y, 5, math.pi/2, math.pi*1.5 )
				--]]
				
				
				if editing or debug then platforms:drawDebug(platform, i) end
				
					
			end

		end
	end
	world.platforms = count
end


function platforms:drawDebug(platform, i)
	-- debug mode drawing
	
	-- collision area
	if not (platform.swing == 1) and (platform.clip == 1) then
		love.graphics.setColor(255,0,0,40)
		love.graphics.rectangle("fill", platform.x, platform.y, platform.w, platform.h)
		love.graphics.setColor(255,0,0,255)
		love.graphics.rectangle("line", platform.x, platform.y, platform.w, platform.h)
	end
	
	if platform.clip == 0 then
		love.graphics.setColor(0,255,0,40)
		love.graphics.rectangle("fill", platform.x, platform.y, platform.w, platform.h)
		love.graphics.setColor(255,0,0,255)
		love.graphics.rectangle("line", platform.x, platform.y, platform.w, platform.h)
	end
	
	-- yaxis waypoint
	if platform.movey == 1 then
		love.graphics.setColor(255,0,255,20)
		love.graphics.rectangle("fill", platform.xorigin, platform.yorigin, platform.w, platform.h+platform.movedist)
		love.graphics.setColor(255,0,255,255)
		love.graphics.rectangle("line", platform.xorigin, platform.yorigin, platform.w, platform.h+platform.movedist)
	end
	-- xaxis waypoint
	if platform.movex == 1 then
		love.graphics.setColor(255,0,255,20)
		love.graphics.rectangle("fill", platform.xorigin, platform.yorigin, platform.movedist+platform.w, platform.h)
		love.graphics.setColor(255,0,255,255)
		love.graphics.rectangle("line", platform.xorigin, platform.yorigin, platform.movedist+platform.w, platform.h)
	end 
	
	--debug connector
	if platform.swing == 1 then 
		love.graphics.setColor(255,0,255,100)
		love.graphics.line( platform.xorigin,platform.yorigin,
							platform.x,platform.y
		)	
		love.graphics.setColor(255,0,0,100)
		love.graphics.rectangle("line", platform.xorigin-platform_link_origin:getWidth()/2, platform.yorigin-platform_link_origin:getHeight()/2,platform_link_origin:getWidth(),platform_link_origin:getHeight())
	end
	
	editor:drawid(platform,i)
	editor:drawCoordinates(platform)
	
end







