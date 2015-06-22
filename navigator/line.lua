--[[

Line following turtle

Create a line for the turtle to follow using stained clay blocks. Set turtle on
one end of the line, facing the direction you want it to go. Be sure to refuel
before running the program!

--]]

function forward (blockName)
  if turtle.forward() then
    local success, data = turtle.inspectDown()
    if success then
      if data.name == blockName then
        -- found the path
        return true
      else
        -- backtrack
        turtle.back()
        return false
      end
    else
      -- no block below
      if not down(blockName) then
        -- backtrack
        turtle.back()
        return false
      end
      return true
    end
  else
    -- obstructed
    return false
  end
end

function left (blockName)
  turtle.turnLeft()
  if not forward(blockName) then
    -- backtrack
    turtle.turnRight()
    return false
  end
  return true
end

function right (blockName)
  turtle.turnRight()
  if not forward(blockName) then
    -- backtrack
    turtle.turnLeft()
    return false
  end
  return true
end

function up (blockName)
  local success, data = turtle.inspect()
  if success then
    if data.name == blockName then
      -- found the path
      turtle.up()
      return true
    else
      return false
    end
  else
    -- no block in front
    return false
  end
end

function down (blockName)
  if turtle.down() then
    turtle.turnLeft()
    turtle.turnLeft()
    local success, data = turtle.inspect()
    if success then
      if data.name == blockName then
        -- found the path
        turtle.turnRight()
        turtle.turnRight()
        return true
      else
        -- backtrack
        turtle.turnRight()
        turtle.turnRight()
        turtle.up()
        return false
      end
    else
      -- no block, backtrack
      turtle.turnRight()
      turtle.turnRight()
      turtle.up()
      return false
    end
  else
    -- obstructed
    return false
  end
end

directions = {up, down, forward, right, left}

while true do
  found = false

  for i, direction in pairs(directions) do
    if direction("minecraft:stained_hardened_clay") then
      found = true
      break
    end
  end

  -- no valid moves, must be at end of maze
  if not found then
    break
  end
end
