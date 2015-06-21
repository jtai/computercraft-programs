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
      -- no block (TODO: implement detection for down)
      return false
    end
  else
    -- obstructed
    return false
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
