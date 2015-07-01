--[[

3d printer

Create an input file in which you draw each level of the structure you want
printed with digits corresponding to which slot to place. Use a "." if you
don't want a block to be placed there. Separate each level with a blank line.

For example, if the turtle has cobblestone in slot 1 and sand in slot 2,
this file "prints" a pyramid that only has sand visible:

--
22222
21112
21112
21112
22222

.....
.222.
.222.
.222.
.....

.....
.....
..2..
.....
.....
--

Place the turtle in the top left corner of the first level, add fuel and
building materials, then run this program with path to the input file as the
argument.

--]]

-- takes a file handle, yields each level of the file as a two dimensional array
function levelIter (h)
  local rows = {}
  local line = h.readLine()
  if not line then return nil end
  while line and not (string.len(line) == 0) do
    local row = {}
    for i = 1, string.len(line) do
      table.insert(row, string.sub(line, i, i))
    end
    table.insert(rows, row)
    line = h.readLine()
  end
  return rows
end

-- main program
args = { ... }
file = fs.open(args[1], "r")
if file then
  for level in levelIter, file do
    for i = 1, table.getn(level) do
      for j = 1, table.getn(level[i]) do
        -- read character and place corresponding block from slot
        char = level[i][j]
        if not (char == ".") then
          turtle.select(tonumber(char))
          turtle.place()
        end

        -- move right
        turtle.turnRight()
        turtle.forward()
        turtle.turnLeft()
      end

      -- move back to left
      turtle.back()
      turtle.turnLeft()
      for j = 1, table.getn(level[i]) do
        turtle.forward()
      end
      turtle.turnRight()
    end

    -- reset to top left corner position on next level
    turtle.up()
    for i = 1, table.getn(level) do
      turtle.forward()
    end
  end
  file.close()
else
  print("error: input file not found")
end
