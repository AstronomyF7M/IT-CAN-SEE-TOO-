const canvas = document.getElementById("gameCanvas");
const ctx = canvas.getContext("2d");
const batteryDisplay = document.getElementById("battery");
const gameoverDisplay = document.getElementById("gameover");


// Game constants
const playerSpeed = 3;
const monsterSpeed = 1.5;
const lightRadius = 80;
let flashlightOn = true;
let flashlightBattery = 100;
const batteryDrainRate = 0.5;
const batteryRechargeRate = 0.2;
let gameover = false;


// Player
const player = {
 x: canvas.width / 2,
 y: canvas.height / 2,
 width: 20,
 height: 20,
};


// Monster
const monster = {
 x: 50,
 y: 50,
 width: 30,
 height: 30,
};


// Input handling
const keys = {};
document.addEventListener("keydown", (e) => {
 keys[e.key] = true;
});
document.addEventListener("keyup", (e) => {
 keys[e.key] = false;
});


function update() {
 if (!gameover) {
 // Player movement
 if (keys["w"]) player.y -= playerSpeed;
 if (keys["s"]) player.y += playerSpeed;
 if (keys["a"]) player.x -= playerSpeed;
 if (keys["d"]) player.x += playerSpeed;


 // Keep player within bounds
 player.x = Math.max(0, Math.min(player.x, canvas.width));
 player.y = Math.max(0, Math.min(player.y, canvas.height));


 // Flashlight battery
 if (flashlightOn) {
 flashlightBattery -= batteryDrainRate;
 if (flashlightBattery <= 0) {
 flashlightBattery = 0;
 flashlightOn = false;
 }
 } else {
 flashlightBattery += batteryRechargeRate;
 if (flashlightBattery >= 100) {
 flashlightBattery = 100;
 }
 }
 batteryDisplay.textContent = `Battery: ${Math.round(flashlightBattery)}%`;


 // Monster AI (chase player)
 const dx = player.x - monster.x;
 const dy = player.y - monster.y;
 const distance = Math.sqrt(dx * dx + dy * dy);


 if (distance > 0) {
 monster.x += (dx / distance) * monsterSpeed;
 monster.y += (dy / distance) * monsterSpeed;
 }


 // Game over check
 if (distance < lightRadius / 2) {
 gameover = true;
 gameoverDisplay.style.display = "block";
 }
 }
}


function draw() {
 // Clear canvas
 ctx.clearRect(0, 0, canvas.width, canvas.height);


 // Draw dark background
 ctx.fillStyle = "black";
 ctx.fillRect(0, 0, canvas.width, canvas.height);


 // Draw light
 if (flashlightOn && flashlightBattery > 0) {
 // Create a radial gradient for the flashlight effect
 const gradient = ctx.createRadialGradient(
 player.x,
 player.y,
 0,
 player.x,
 player.y,
 lightRadius
 );
 gradient.addColorStop(0, "rgba(255, 0, 0, 0.5)"); // Inner color (red with some transparency)
 gradient.addColorStop(1, "rgba(0, 0, 0, 0)");  // Outer color (transparent black)


 ctx.fillStyle = gradient;
 ctx.fillRect(0, 0, canvas.width, canvas.height); // Fill the entire canvas with the gradient
 }


 // Draw player
 ctx.fillStyle = "red";
 ctx.fillRect(player.x - player.width / 2, player.y - player.height / 2, player.width, player.height);


 // Draw monster
 ctx.fillStyle = "white";
 ctx.fillRect(monster.x - monster.width / 2, monster.y - monster.height / 2, monster.width, monster.height);
}


// Game loop
function gameLoop() {
 update();
 draw();
 requestAnimationFrame(gameLoop);
}


// Start the game
gameLoop();


// Toggle flashlight with 'f' key
document.addEventListener("keydown", (e) => {
 if (e.key === 'f') {
 flashlightOn = !flashlightOn;
 }
});
 const canvas = document.getElementById("gameCanvas");
 const ctx = canvas.getContext("2d");
 const batteryDisplay = document.getElementById("battery");
 const gameoverDisplay = document.getElementById("gameover");
 

 // Game constants
 const playerSpeed = 3;
 const monsterSpeed = 1.5;
 const lightRadius = 80;
 let flashlightOn = true;
 let flashlightBattery = 100;
 const batteryDrainRate = 0.5;
 const batteryRechargeRate = 0.2;
 let gameover = false;
 

 // Player
 const player = {
  x: canvas.width / 2,
  y: canvas.height / 2,
  width: 20,
  height: 20,
 };
 

 // Monster
 const monster = {
  x: 50,
  y: 50,
  width: 30,
  height: 30,
 };
 

 // Input handling
 const keys = {};
 document.addEventListener("keydown", (e) => {
  keys[e.key] = true;
 });
 document.addEventListener("keyup", (e) => {
  keys[e.key] = false;
 });
 

 //Audio
 const ambientSound = new Audio("ambient.wav"); // or ambient.mp3
 const chaseSound = new Audio("chase.wav"); // or chase.mp3
 const flashlightSound = new Audio("flashlight.wav"); // or flashlight.mp3
 ambientSound.loop = true;
 

 function update() {
  if (!gameover) {
  // Player movement
  if (keys["w"]) player.y -= playerSpeed;
  if (keys["s"]) player.y += playerSpeed;
  if (keys["a"]) player.x -= playerSpeed;
  if (keys["d"]) player.x += playerSpeed;
 

  // Keep player within bounds
  player.x = Math.max(0, Math.min(player.x, canvas.width));
  player.y = Math.max(0, Math.min(player.y, canvas.height));
 

  // Flashlight battery
  if (flashlightOn) {
  flashlightBattery -= batteryDrainRate;
  if (flashlightBattery <= 0) {
  flashlightBattery = 0;
  flashlightOn = false;
  }
  } else {
  flashlightBattery += batteryRechargeRate;
  if (flashlightBattery >= 100) {
  flashlightBattery = 100;
  }
  }
  batteryDisplay.textContent = `Battery: ${Math.round(flashlightBattery)}%`;
 

  // Monster AI (chase player)
  const dx = player.x - monster.x;
  const dy = player.y - monster.y;
  const distance = Math.sqrt(dx * dx + dy * dy);
 

  if (distance > 0) {
  monster.x += (dx / distance) * monsterSpeed;
  monster.y += (dy / distance) * monsterSpeed;
  }
 

  // Game over check
  if (distance < lightRadius / 2) {
  gameover = true;
  gameoverDisplay.style.display = "block";
  chaseSound.play();
  ambientSound.pause();
  }
  }
 }
 

 function draw() {
  // Clear canvas
  ctx.clearRect(0, 0, canvas.width, canvas.height);
 

  // Draw dark background
  ctx.fillStyle = "black";
  ctx.fillRect(0, 0, canvas.width, canvas.height);
 

  // Draw light
  if (flashlightOn && flashlightBattery > 0) {
  // Create a radial gradient for the flashlight effect
  const gradient = ctx.createRadialGradient(
  player.x,
  player.y,
  0,
  player.x,
  player.y,
  lightRadius
  );
  gradient.addColorStop(0, "rgba(255, 0, 0, 0.5)"); // Inner color (red with some transparency)
  gradient.addColorStop(1, "rgba(0, 0, 0, 0)");  // Outer color (transparent black)
 

  ctx.fillStyle = gradient;
  ctx.fillRect(0, 0, canvas.width, canvas.height); // Fill the entire canvas with the gradient
  }
 

  // Draw player
  ctx.fillStyle = "red";
  ctx.fillRect(player.x - player.width / 2, player.y - player.height / 2, player.width, player.height);
 

  // Draw monster
  ctx.fillStyle = "white";
  ctx.fillRect(monster.x - monster.width / 2, monster.y - monster.height / 2, monster.width, monster.height);
 }
 

 // Game loop
 function gameLoop() {
  update();
  draw();
  requestAnimationFrame(gameLoop);
 }
 

 // Start the game
 gameLoop();
 ambientSound.play();
 

 // Toggle flashlight with 'f' key
 document.addEventListener("keydown", (e) => {
  if (e.key === 'f') {
  flashlightOn = !flashlightOn;
  flashlightSound.play();
  }
 });
