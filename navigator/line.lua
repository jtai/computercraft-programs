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
      -- no block below, try down
      turtle.down()
      turtle.turnLeft()
      turtle.turnLeft()
      local success, data = turtle.inspect()
      if success then
        if data.name == blockName then
          -- found the path
          turtle.turnLeft()
          turtle.turnLeft()
          return true
        else
          --backtrack
          turtle.turnLeft()
          turtle.turnLeft()
          turtle.up()
          return false
        end
      else
        -- should never hit this
      end
    end
  else
    -- obstructed
    local success, data = turtle.inspect()
    if success then
      if data.name == blockName then
        -- found the path
        turtle.up()
        return true
      else
        -- obstruction is not a maze marker block
        return false
      end
    else
      print("Fuel empty, please add fuel")
      return false
    end
  end
end

function left (blockName)
  turtle.turnLeft()
  if not forward(blockName) then
    turtle.turnRight()
    return false
  end
  return true
end

function right (blockName)
  turtle.turnRight()
  if not forward(blockName) then
    turtle.turnLeft()
    return false
  end
  return true
end

blockName = "minecraft:stained_hardened_clay"

while true do
  if not forward(blockName) then
    if not right(blockName) then
      if not left(blockName) then
        -- no valid moves, must be at end of maze
        break
      end
    end
  end
end
