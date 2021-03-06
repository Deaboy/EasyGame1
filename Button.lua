require "common/class"
require "Entity"
require "Secretary"

Button = buildClass(Entity)

-- 
-- Button constructor
--
function Button:_init( text, x, y, w, h, room, action )
  Entity._init(self)
  
  self.text = text or ""
  self.x = x or 0
  self.y = y or 0
  self.width = w or 32
  self.height = h or 32
  self.room = room
  self.padding = 4
  self.border = 4
  
  self.hover = false
  self.down = false
  self.selected = false
  
  self.actions = {}
  self.actions.click = action
  self.actions.hover = nil
  self.actions.unhover = nil
end

function Button:registerWithSecretary(secretary)
  Entity.registerWithSecretary(self, secretary)
  
  -- Register for event callbacks
  secretary:registerEventListener(self, self.onKeyboardDown, EventType.KEYBOARD_DOWN)
  secretary:registerEventListener(self, self.onKeyboardUp, EventType.KEYBOARD_UP)
  secretary:registerEventListener(self, self.onMouseMove, EventType.MOUSE_MOVE)
  secretary:registerEventListener(self, self.onMouseDown, EventType.MOUSE_DOWN)
  secretary:registerEventListener(self, self.onMouseUp, EventType.MOUSE_UP)
  secretary:registerEventListener(self, self.draw, EventType.DRAW)
  
  return self
end



--
-- Button:setOnClickAction
--
function Button:setOnClickAction(action)
  
  -- Verify parameters
  assert(type(action) == "function" or action == nil, "Expected parameter of type 'function' or nil, '" .. type(action) .. "' received")
  self.actions.click = action
end

--
-- Button:setOnHoverAction
--
function Button:setOnHoverAction(action)
  
  -- Verify parameters
  assert(type(action) == "function" or action == nil, "Expected parameter of type 'function' or nil, '" .. type(action) .. "' received")
  self.actions.hover = action
end

--
-- Button:setOnUnhoverAction
--
function Button:setOnUnhoverAction(action)
  
  -- Verify parameters
  assert(type(action) == "function" or action == nil, "Expected parameter of type 'function' or nil, '" .. type(action) .. "' received")
  self.actions.unhover = action
end



--
-- Button:onKeyboardDown
--
function Button:onKeyboardDown( key, scancode, isRepeat )
  if self.selected and key == "return" then
    self.down = true  
  end
end

--
-- Button:onKeyboardUp
function Button:onKeyboardUp( key, scancode )
  if self.selected and key == "return" then
    if self.down then
      self.down = false
      self:onClick()
    end
  end
end



--
-- Button:onMouseMove
--
function Button:onMouseMove( x, y )
  
  x, y = camera:drawingPoint(x, y)
  
  -- Trigger mouse hover events
  if x >= self.x and x < self.x + self.width and y >= self.y and y < self.y + self.height then
    if self.hover == false then
      self.hover = true
      self:onMouseOver()
    end
  else
    if self.hover == true then
      self.hover = false
      self:onMouseOff()
    end
  end
  
end

--
-- Button:onMouseOver
--
function Button:onMouseOver( )
  if self.actions.hover ~= nil then
    self.actions.hover()
  end
end

--
-- Button:onMouseOff
--
function Button:onMouseOff( )
  if self.actions.unhover ~= nil then
    self.actions.unhover()
  end
end

--
-- Button:onMousePressed
--
function Button:onMouseDown( x, y, button )
  local debug = false
  if debug then print("Button:onMouseDown - "..button.." released") end
  
  x, y = camera:drawingPoint(x, y)
  
  if button ~= 1 and button ~= "l" then return end
  
  if x >= self.x and x < self.x + self.width and y >= self.y and y < self.y + self.height then
    if debug then print("Button:onMouseDown - mouse down on button") end
    self.down = true
  end
end

--
-- Button:onMouseUp
--
function Button:onMouseUp( x, y, button )
  local debug = false
  if debug then print("Button:onMouseUp - "..button.." released") end
  
  x, y = camera:drawingPoint(x, y)
  
  if button ~= 1 and button ~= "l" then return end
  
  -- Update flags
  local down = self.down
  self.down = false
  
  if down and x >= self.x and x < self.x + self.width and y >= self.y and y < self.y + self.height then
    if debug then print("Button:onMouseUp - mouse up on button, triggered onclick") end
    self:onClick()
  end
end

--
-- Button:onClick
--
function Button:onClick( )
  local debug = false
  if debug then print("Button:onClick") end
  
  if self.actions.click ~= nil then
    if debug then print("Button:onClick - triggered click action") end
    self.actions.click()
  end
end

--
-- Button:draw
--
function Button:draw()
  
  -- Back up color
  local r, g, b, a = love.graphics.getColor()
  
  -- White outline
  love.graphics.setColor( 255, 255, 255 )
  if self.down and self.hover then
    love.graphics.rectangle( "fill", self.x - 2, self.y - 2, self.width + 4, self.height + 4 )
  else
    love.graphics.rectangle( "fill", self.x, self.y, self.width, self.height )
  end
  
  -- Black background
  if self.hover == false and self.selected == false then
    love.graphics.setColor( 0, 0, 0 )
    love.graphics.rectangle( "fill", self.x + self.border, self.y + self.border, self.width - self.border * 2, self.height - self.border * 2 )
  end
  
  -- Text
  if self.hover == false and self.selected == false then
    love.graphics.setColor( 255, 255, 255 )
  else
    love.graphics.setColor( 0, 0, 0 )
  end
  love.graphics.printf( self.text, self.x + self.border + self.padding, self.y + self.border + self.padding, self.width - (self.border + self.padding) * 2, "center" )
  
  -- Restore color
  love.graphics.setColor( r, g, b, a )
  
end
