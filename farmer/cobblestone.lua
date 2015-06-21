--[[

Cobblestone miner

Set up cobblestone generator as follows:

Level 1:

S S S S S
S   C   S
S S T S S
H H   H H
    S

Level 2:

S S S S S
S W C L S
S S S S S



S = Stone (or other non-cobblestone, lava-proof block)
C = Cobblestone
H = Chest
T = Mining Turtle
W = Water
L = Lava

Equip the turtle with a block of coal in any position, then run this program.

The turtle will mine until it is full, then it will dump its load into the left
chest. If the chest is full, it will try the right chest. If both are full, it
will keep spinning until you make some room in one of the chests. The two
chests together can hold 108 stacks of cobblestone.

The algorithm is very fuel efficient--it only requires 2 moves for every 15
stacks of cobblestone generated. The initial piece of coal should last for 640
stacks of cobblestone (5 two-chest loads). A warning will be printed when fuel
is running low. You can add fuel at any time.

--]]

-- return to mining position
function reset ()
  while true do
    local success, data = turtle.inspect()
    if not success then
      ensureFuel()
      turtle.forward()
    else
      if data.name == "minecraft:cobblestone" then
        return
      else
        turtle.turnRight()
      end
    end
  end
end

-- check to see if turtle is full, i.e., cannot pick up more cobblestone
function isFull ()
  local i
  for i = 1,16 do
    if turtle.getItemDetail(i) then
      -- if slot contains some other item type, cobblestone can't be added to
      -- the slot, so consider it full
      if turtle.getItemDetail(i).name == "minecraft:cobblestone" then
        if turtle.getItemSpace(i) > 0 then
          return false
        end
      end
    else
      -- empty slot, can be used
      return false
    end
  end
  return true
end

-- iterator for slots that hold an item of a specific type
function slotIter (blockName)
  i = 1
  return function ()
           local j
           for j = i,16 do
             i = j + 1
             if turtle.getItemDetail(j) then
               if turtle.getItemDetail(j).name == blockName then
                 return j
               end
             end
           end
           return nil
         end
end

-- unloads cobblestone into chests
-- returns true if completely unloaded, false if drop failed (i.e., full chest)
function unload ()
  local i
  for i in slotIter("minecraft:cobblestone") do
    turtle.select(i)
    if not turtle.drop(64) then
      return false
    end
  end
  return true
end

-- ensure there is fuel, if not, print an error and wait for coal to be added
function ensureFuel ()
  while turtle.getFuelLevel() == 0 do
    if not refuel() then
      if not fuelFlags.empty then
        print("Fuel empty, please add coal")
        fuelFlags.empty = true
      else
        sleep(1)
      end
    end
  end
end

-- attempts to refuel
-- returns true if successfully refueled, false if no more fuel
function refuel ()
  local i
  for i in slotIter("minecraft:coal") do
    turtle.select(i)
    if turtle.refuel(1) then
      -- reset flags
      if fuelFlags.empty or fuelFlags.low then
        print("Thanks!")
      end
      fuelFlags = {}
      return true
    end
  end
  return false
end

-- warn if fuel is low
function warnFuel ()
  if turtle.getFuelLevel() < 20 then
    if not fuelFlags.low then
      print("Fuel low, please add coal")
      fuelFlags.low = true
    end
  end
end

-- initialize flags
fuelFlags = {}

-- ensure we're in mining position
reset()

-- main loop
while true do
  -- mine
  if turtle.detect() then
    turtle.dig()
  end

  if isFull() then
    -- go to unload position
    ensureFuel()
    turtle.back()
    turtle.turnLeft()

    -- try to unload items in chest
    while not unload() do
      -- turn around to try other chest
      turtle.turnLeft()
      turtle.turnLeft()
    end

    -- return to mining position
    reset()
  end

  -- refuel if coal was added, doing this greedily frees up a slot which
  -- improves fuel efficiency
  refuel()

  -- warn if fuel is low
  warnFuel()
end
