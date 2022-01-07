function love.load()
    gamestart()
end

function gamestart()
    love.window.setFullscreen(true)

    target = {}
    target.x = 300
    target.y = 300
    target.radius = 50
    target.speed_x = 0
    target.speed_y = 0
    love.window.setTitle("Clicking Game")

    window = {}
    window.w, window.h = love.graphics.getDimensions()
    score = 0
    timer = 0
    final_time = 0
    win = false
    lose = false
    game_over = false

    scoreFont = love.graphics.newFont(60)
    timerFont = love.graphics.newFont(30)

    math.randomseed(os.time())

    blip_box = {x = window.w-600, y = 0, w = 600, h = 100}
end

function Round(num, dp)
    -- moves it all up and then rounds and moves it back down
    mult = 10^(dp or 0)
    return math.floor(num * mult + 0.5)/mult
end

function love.update(dt)
    if love.audio.getActiveSourceCount() == 0 then
        love.audio.play(love.audio.newSource('game.mp3', 'static'))
    end
    if not game_over then
        timer = timer + dt
        target.x = target.x + target.speed_x
        target.y = target.y + target.speed_y
    end
    if target.x < 0 or target.x > window.w then
        game_over = true
        final_time = timer
        lose = true
    end
    if target.y < 0 or target.y > window.h then
        game_over = true
        final_time = timer
        lose = true
    end
    if score >= 50 then
        game_over = true
        win = true
        final_time = timer
    end
end

function love.draw()
    if not game_over then
        love.graphics.setColor(1, 0.5, 0.2)
        love.graphics.circle('fill', target.x, target.y, target.radius)

        love.graphics.setColor(1, 1, 1)
        love.graphics.setFont(scoreFont)
        love.graphics.print(score, window.w/2, 20)

        love.graphics.setFont(timerFont)
        love.graphics.print(Round(timer, 1), 30, 50)
        love.graphics.print('Clicks per second average: '.. Round(score/timer, 3) , 30, 10)
    else
        if blip then love.graphics.print('Disable Blip', window.w-400, 30)
        elseif not blip then love.graphics.print('Enable Blip', window.w-400, 30) end
        love.graphics.setFont(scoreFont)
        if lose then love.graphics.print('Game Over!', window.w/2 - 130, window.h/2 - 100)
        elseif win then love.graphics.print('You win!', window.w/2 - 130, window.h/2 - 100) end

        love.graphics.setFont(timerFont)
        love.graphics.print('Score: ' .. score, window.w/2-170, window.h/2 - 200)
        love.graphics.print('Time: ' .. Round(final_time, 1), window.w/2+100, window.h/2 - 200)
        love.graphics.print('Clicks per second: '.. Round(score/final_time, 3), window.w/2-130, window.h - 300)
    end    
end

function love.mousepressed(x, y, button, istouch, presses)
    if button == 1 and x > target.x - target.radius and x < target.x + target.radius and  y > target.y - target.radius and y < target.y + target.radius then
        if blip then love.audio.play(love.audio.newSource('hit circle.wav', 'static')) end
        score = score + 1
        target.x = math.random(50, window.w-50)
        target.y = math.random(50, window.h-50)
        target.radius = math.random(10, 50)
        target.speed_x = math.random(-1, 1) * math.random() * (score/10)
        target.speed_y = math.random(-1, 1) * math.random() * (score/10)
    end
    if x > blip_box.x and x < blip_box.x + blip_box.w
    and y > blip_box.y and y < blip_box.y + blip_box.h and game_over then
        if blip then blip = false else blip = true end
    end
end

function love.keypressed(key)
    if key == 'escape' then
        love.event.quit()
    end
    if game_over then
        if key == 'r' then
            game_over = false
            gamestart()
        end
    end
end