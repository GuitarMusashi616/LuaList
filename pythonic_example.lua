local class = require "lib/class"
local util = require "lib/util"

local List = require "lib/list"
local all, range, izip, println, print = util.all, util.range, util.izip, util.println, util.print


local Point = class()

function Point:__init(x,y,z)
  self.x = x
  self.y = y
  self.z = z
end

function Point:__sub(o)
  if self == o then
    return -1
  end
  return math.abs(self.x - o.x) + math.abs(self.y - o.y) + math.abs(self.z - o.z)
end

function Point:__tostring()
  return "("..tostring(self.x)..", "..tostring(self.y)..", "..tostring(self.z)..")"
end

Point:get_xyz() 
  return self.x, self.y, self.z 
end


local Edge = class()

function Edge:__init(p1, p2)
  self.p1 = p1
  self.p2 = p2
  self.len = p1-p2
end

function Edge:__lt(o)
  return self.len < o.len
end

function Edge:__le(o)
  return self.len <= o.len
end

function Edge:__eq(o)
  return self.len == o.len
end

function Edge:__tostring()
  local str = ""
  for i in range(self.len/4) do
    str = str .. "-"
  end
  return str
end

function main()
  local points = List(range(4)):map(function() return Point(math.random(-8,8), math.random(-8,8), math.random(-8,8)) end)
  print(points) --> [(-8, 1, -5), (5, 1, 0), (-3, 7, 5), (4, -6, 6)]
  
  local N = #points
  local distances = List:zeroes(4, 4)
  println("before {}", distances) --> before [[0, 0, 0, 0], [0, 0, 0, 0], [0, 0, 0, 0], [0, 0, 0, 0]]
  for i, p1 in points(true) do
    for j, p2 in points(true) do
      distances[i][j] = p1-p2
    end
  end
  
  println("after {}", distances) --> after [[-1, 18, 21, 30], [18, -1, 19, 14], [21, 19, -1, 21], [30, 14, 21, -1]]
end

main()
