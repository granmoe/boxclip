input = {}

function input:check(dt)
	
	if love.keyboard.isDown("d") or love.keyboard.isDown("right") 
		and player.alive == 1 then
		player.lastdir = player.dir
		player.dir = "right"	
	
	elseif love.keyboard.isDown("a") or love.keyboard.isDown("left")
		and player.alive == 1 then
		player.lastdir = player.dir
		player.dir = "left"
			
	else
		player.dir = "idle"

	end
end

function love.keypressed(key)
		util:dprint("[KEY        ] '".. key .. "'")
	
		--quit
		if key == "escape" then
				love.event.quit()
		end

		--debug console
		if key == "`" then
			love.audio.play( sound.beep )
			if debug == 1 then
				debug = 0
			elseif debug == 0 then
				debug =1
			end
			
		end

		--toggle fullscreen
		if key == "f1" then
			love.window.setFullscreen( 1 )
		end

		if player.alive == 1 then
			--jump
			if key == " " and mode == 1 then
				if player.jumping == 0 then
					sound:play(sound.jump)
					player.jumping = 1
					player.yvel = player.jumpheight
					
				end
			end

			--suicide
			if key == "b" then
				physics:kill(player)
			end
		end
end
