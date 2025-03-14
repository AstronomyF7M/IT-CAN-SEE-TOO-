-- [PREVIEW_SIZE:800x600]
 -- Love2D Lua Code for "IT KNOWS YOU'RE HERE" - Black and Blood Red Color Scheme
 

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
  monsterImage = love.graphics.newImage("New Piskel (7).gif") -- Changed filename here
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
  love.graphics.setColor(0, 0, 0) -- Black hallway color
  love.graphics.rectangle("fill", 0, 0, screenWidth, screenHeight)
 

  -- Draw player's light
  love.graphics.setColor(255, 0, 0, 80) -- Blood red light
  love.graphics.circle("fill", player.x, player.y, playerLightRadius)
 

  -- Draw player
  love.graphics.setColor(200, 0, 0) -- Darker Red for player
  love.graphics.rectangle("fill", player.x - player.width / 2, player.y - player.height / 2, player.width, player.height)
 

  -- Draw monster with scaling
  love.graphics.setColor(255, 255, 255) -- Use original image color
  local monsterWidth = monster.width * monsterScale
  local monsterHeight = monster.height * monsterScale
  love.graphics.draw(monsterImage, monster.x - monsterWidth / 2, monster.y - monsterHeight / 2, 0, monsterScale, monsterScale, monster.width / 2, monster.height / 2) -- Centered drawing
 

  love.graphics.pop() -- Restore previous transformation
 

  -- Game over message
  if gameover then
  love.graphics.setColor(255, 0, 0) -- Blood Red
  love.graphics.printf(message, 0, screenHeight / 2 - 20, screenWidth, "center")
  end
 end
 -- [PREVIEW_SIZE:800x600]
 -- Love2D Lua Code for "IT KNOWS YOU'RE HERE" - Black and Blood Red Color Scheme + Spice
 

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
 local flashlightOn = true -- Initial state of the flashlight
 local flashlightBattery = 100 -- Flashlight battery percentage
 local batteryDrainRate = 5 -- % drained per second
 local batteryRechargeRate = 2 -- % recharged per second when off
 

 -- Monster setup
 monster.x = 100
 monster.y = 100
 monster.width = 32
 monster.height = 32
 local monsterSpeed = 60
 local monsterImage
 local monsterScale = 1 -- Starting scale
 

 -- Sound setup
 local ambientSound
 local chaseSound
 

 -- Load assets
 function love.load()
  love.window.setTitle("IT KNOWS YOU'RE HERE")
  monsterImage = love.graphics.newImage("New Piskel (7).gif") -- Changed filename here
 

  -- Load sounds (ensure you have these .wav files in your directory)
  ambientSound = love.audio.newSource("ambient.wav", "stream")
  chaseSound = love.audio.newSource("chase.wav", "stream")
  love.audio.setVolume(0.5) -- Adjust volume if needed
  love.audio.play(ambientSound)
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
 

  -- Flashlight toggle
  if love.keyboard.isDown("f") then
  flashlightOn = true
  else
  flashlightOn = false
  end
 

  -- Battery logic
  if flashlightOn then
  flashlightBattery = flashlightBattery - batteryDrainRate * dt
  if flashlightBattery < 0 then
  flashlightBattery = 0
  flashlightOn = false -- Automatically turn off if battery is dead
  end
  else
  flashlightBattery = flashlightBattery + batteryRechargeRate * dt
  if flashlightBattery > 100 then
  flashlightBattery = 100
  end
  end
 

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
  love.audio.stop(ambientSound) -- Stop ambient sound
  love.audio.play(chaseSound) -- Play chase sound on game over
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
  love.graphics.setColor(0, 0, 0) -- Black hallway color
  love.graphics.rectangle("fill", 0, 0, screenWidth, screenHeight)
 

  -- Draw player's light
  if flashlightOn and flashlightBattery > 0 then
  love.graphics.setColor(255, 0, 0, 80) -- Blood red light
  love.graphics.circle("fill", player.x, player.y, playerLightRadius)
  end
 

  -- Draw player
  love.graphics.setColor(200, 0, 0) -- Darker Red for player
  love.graphics.rectangle("fill", player.x - player.width / 2, player.y - player.height / 2, player.width, player.height)
 

  -- Draw monster with scaling
  love.graphics.setColor(255, 255, 255) -- Use original image color
  local monsterWidth = monster.width * monsterScale
  local monsterHeight = monster.height * monsterScale
  love.graphics.draw(monsterImage, monster.x - monsterWidth / 2, monster.y - monsterHeight / 2, 0, monsterScale, monsterScale, monster.width / 2, monster.height / 2) -- Centered drawing
 

  love.graphics.pop() -- Restore previous transformation
 

  -- Draw UI elements
  love.graphics.setColor(255, 255, 255)
  love.graphics.print("Press F to toggle flashlight", 10, 10)
  love.graphics.print("Battery: " .. string.format("%.1f", flashlightBattery) .. "%", 10, 30)
 

  -- Game over message
  if gameover then
  love.graphics.setColor(255, 0, 0) -- Blood Red
  love.graphics.printf(message, 0, screenHeight / 2 - 20, screenWidth, "center")
  end
 end
 

 -- Key press event for toggling sounds (optional)
 function love.keypressed(key)
  if key == "space" then -- Example: toggle ambient sound with spacebar
  if love.audio.isPlaying(ambientSound) then
  love.audio.pause(ambientSound)
  else
  love.audio.resume(ambientSound)
  end
  end
 end
