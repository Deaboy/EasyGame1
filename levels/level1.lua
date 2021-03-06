levelScript["level1"] = function()
  --Room dimensions
  width = 48
  height = 36
  --Player spawn location
  playerSpawn_x = 8 * 16
  playerSpawn_y = 5 * 16
  
  
  --Initilize room
  local room = Room(width, height)
  
  --add a player spawn
  room:addPlayerSpawnPoint(playerSpawn_x, playerSpawn_y)
  
  
  --Box in the room
  ---------------------------------------------------------------------
  --build a floor
  room:buildBlock( 0, height * 16 - 32, width * 16 , 32 )
  --build a ceiling
  room:buildBlock( 0, 0, width * 16, 32 )
  --build left wall
  room:buildBlock( 0, 0, 32, height * 16 )
  --build right wall
  room:buildBlock( 16 * (width - 2), 0, 32, height * 16 )
  
  
  --Add stepping blocks
  ---------------------------------------------------------------------
  room:buildBlock( 16 * 16, 5 * 16, 5 * 16, 32)
  room:addObject(PassthroughBlock(20*16, 10*16, 5*16, 16))
  room:addObject(PassthroughBlock(10*16, 10*16, 5*16, 16))
  room:addObject(PassthroughBlock(20*16, 16*16, 5*16, 16))
  room:addObject(PassthroughBlock(10*16, 22*16, 5*16, 16))
  room:addObject(PassthroughBlock(20*16, 28*16, 5*16, 16))
  
  
  --Add moving platforms
  ---------------------------------------------------------------------
  room:addObject(MovingPlatform(24*16, 30*16, 8*16, 24, 24*16, 10*16, 240))
  
  
  --Add Enemy Spawns
  ---------------------------------------------------------------------
  room:addSpawn(Spawn( 5 * 16, 5 * 16, Kitty, Penguin))
  
  
  
  --Add Enemy Counts
  ---------------------------------------------------------------------
  room:addEnemies(Kitty, 5)
  room:addEnemies(Penguin, 5)
  
  
  
  return room
end