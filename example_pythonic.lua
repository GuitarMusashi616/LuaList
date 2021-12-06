local class = require("class")
local List = require("list")

local Point = class()

function Point:__init(x,y,z)
  self.x = x
  self.y = y
  self.z = z
end

function Point:__sub(o)
  return math.abs(self.x - o.x) + math.abs(self.y - o.y) + math.abs(self.z - o.z)
end

function Point:__tostring()
  return "("..tostring(self.x)..", "..tostring(self.y)..", "..tostring(self.z)..")"
end


local Edge = class()

function Edge:__init(p1, p2)
  self.p1 = p1
  self.p2 = p2
  self.len = p1-p2
end

function Edge:__lt(p1,p2)
  return p1 < p2
end

function Edge:__le(p1,p2)
  return p1 <= p2
end

function Edge:__eq(p1,p2)
  return p1==p2
end

local coords = List()
for i=1,10 do
  coords:append(Point(math.random(-8,8),math.random(-8,8),math.random(-8,8)))
end
print(coords)



