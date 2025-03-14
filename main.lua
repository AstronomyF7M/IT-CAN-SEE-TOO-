 -- [PREVIEW_SIZE:800x600]
 -- Love2D Lua Code for "IT KNOWS YOU'RE HERE"
 

 -- Game setup
 local screenWidth = 800
 local screenHeight = 600
 local player = {}
 local monster = {}
 local gameover = false
 local message = ""
 local hallwayWidth = 64
 local hallwayLength = 800 -- Adjust as needed
 local cameraX = 0
 local cameraY = 0
 

 -- Player setup
 local playerSpeed = 120
 player.x = screenWidth / 2
 player.y = screenHeight / 2
 player.width = 24
 player.height = 24
 local playerLightRadius = 80
 

 -- Monster setup
 monster.x = 100
 monster.y = 100
 monster.width = 32
 monster.height = 32
 local monsterSpeed = 60
 local monsterImage
 local monsterScale = 1 -- Starting scale
 

 -- Load assets
 function love.load()
  love.window.setTitle("IT KNOWS YOU'RE HERE")
  monsterImage = love.graphics.newImage("monster.png")
  -- Example: "monster.png" should be a creepy image.
 end
 

 function love.update(dt)
  if not gameover then
  -- Player movement (clamped to hallway)
  local moveX = 0
  local moveY = 0
  if love.keyboard.isDown("w") then
  moveY = -1
  end
  if love.keyboard.isDown("s") then
  moveY = 1
  end
  if love.keyboard.isDown("a") then
  moveX = -1
  end
  if love.keyboard.isDown("d") then
  moveX = 1
  end
 

  -- Normalize movement vector
  if moveX ~= 0 or moveY ~= 0 then
  local length = math.sqrt(moveX * moveX + moveY * moveY)
  moveX = moveX / length
  moveY = moveY / length
  end
 

  player.x = player.x + moveX * playerSpeed * dt
  player.y = player.y + moveY * playerSpeed * dt
 

  -- Keep player within the hallway bounds (adjust as needed)
  player.x = math.max(hallwayWidth / 2, math.min(player.x, screenWidth - hallwayWidth / 2))
  player.y = math.max(hallwayWidth / 2, math.min(player.y, screenHeight - hallwayWidth / 2))
 

  -- Monster AI (stalking, change speed and scale based on distance)
  local distanceX = player.x - monster.x
  local distanceY = player.y - monster.y
  local distance = math.sqrt(distanceX * distanceX + distanceY * distanceY)
 

  local monsterMoveSpeed = monsterSpeed * (1 - math.min(distance / 400, 1)) -- Slower when closer
  monsterScale = 1 + math.min(distance / 400, 1) * 0.5 -- Bigger when closer
 

  if player.x > monster.x then
  monster.x = monster.x + monsterMoveSpeed * dt
  else
  monster.x = monster.x - monsterMoveSpeed * dt
  end
  if player.y > monster.y then
  monster.y = monster.y + monsterMoveSpeed * dt
  else
  monster.y = monster.y - monsterMoveSpeed * dt
  end
 

  -- Collision detection (proximity-based game over)
  if distance < playerLightRadius / 2 then
  gameover = true
  message = "IT KNOWS YOU'RE HERE..."
  end
 

  -- Camera follows player
  cameraX = player.x - screenWidth / 2
  cameraY = player.y - screenHeight / 2
  end
 end
 

 function love.draw()
  love.graphics.push() -- Save current transformation
  love.graphics.translate(-cameraX, -cameraY) -- Apply camera translation
 

  -- Draw hallway
  love.graphics.setColor(50, 50, 50) -- Dark hallway color
  love.graphics.rectangle("fill", 0, 0, screenWidth, screenHeight)
 

  -- Draw player's light
  love.graphics.setColor(255, 255, 150, 80) -- Soft yellow light
  love.graphics.circle("fill", player.x, player.y, playerLightRadius)
 

  -- Draw player
  love.graphics.setColor(100, 150, 255)
  love.graphics.rectangle("fill", player.x - player.width / 2, player.y - player.height / 2, player.width, player.height)
 

  -- Draw monster with scaling
  love.graphics.setColor(255, 255, 255) -- Reset color
  local monsterWidth = monster.width * monsterScale
  local monsterHeight = monster.height * monsterScale
  love.graphics.draw(monsterImage, monster.x - monsterWidth / 2, monster.y - monsterHeight / 2, 0, monsterScale, monsterScale, monster.width / 2, monster.height / 2) -- Centered drawing
 

  love.graphics.pop() -- Restore previous transformation
 

  -- Game over message
  if gameover then
  love.graphics.setColor(255, 0, 0)
  love.graphics.printf(message, 0, screenHeight / 2 - 20, screenWidth, "center")
  end
 end
