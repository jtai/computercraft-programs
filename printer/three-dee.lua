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

args = { ... }
file = fs.open(args[1], "r")
if file
then
  lines = 0
  line = file.readLine()
  while line do
    if not (string.len(line) == 0) then
      for i = 1, string.len(line) do
        -- read character and place corresponding block from slot
        char = string.sub(line, i, i)
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
      turtle.turnLeft()
      for i = 1, string.len(line) do
        turtle.forward()
      end
      turtle.turnRight()
      turtle.back()

      lines = lines + 1
    else
      -- blank line means next level
      turtle.up()
      for i = 1, lines do
        turtle.forward()
      end

      lines = 0
    end
    line = file.readLine()
  end

  file.close()
else
  print("error: input file not found")
end
