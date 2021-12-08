# LuaList
Python-like List for Lua, make your Lua code Pythonic

#### List Features
* ```lst = List(1,2,3,4)```       \-- simple class initialization
* ```print(lst) --> [1,2,3,4]```  \-- prints itself with default print
* ```lst[0] --> 1```                -- zero indexed list
* ```lst[-2] --> 3```               -- supports negative int
* ```lst:slice(nil,nil,-1) --> [4,3,2,1]```  -- supports slicing from python
* ```lst:contains(3) --> true```
* ```lst*2+lst  --> [1,2,3,4,1,2,3,4,1,2,3,4]``` -- support + and *
* ```List(range(10)) --> [0,1,2,3,4,5,6,7,8,9]```  -- List constructor can take iterator (range from util.range)
* ```lst[-1]=5, lst:pop(0), lst:append(2)```       -- assignment, pop, append, and insert supported
* ```lst:map(function(n) return List(n) end) --> [[1],[2],[3],[4]]``` -- supports find, filter, map,reduce
* see below and test/test_list for more examples


#### Util Features
* ```print({3,2,1,key=5}, List("stuff")])  --> {3, 2, 1, key=5} [stuff]```  -- util.print will print default tables as well as custom classes
* ```println("{}+{}={}", 5, 3, 8) --> 5+3=8```   -- util.println supports simple print formatting
* ```for i in range(4) do print(i) end --> 0,1,2,3```  -- util.range works like range from python
* ```for v in all{5,6,7,key=val} do print(v) end  --> 5,6,7,val``` -- util.all returns just val from table
* ```assertEqual(5,5), assertRaises("error", assert, false)``` -- util comes with test functions
* ```args(num, "number", str, "string", b, "bool?", List(), List)```  -- will error if num not number, str not string, b not bool or nil, or List not type List
* ```for a,b in zip({"A","B","C"}, {1,2,3}) print(a,b) end``` --> A1 A2 A3  -- util.izip version returns 1,A,1,1; 2,A,2,2 etc


#### OOP Features
* declare new class by using ```local Point = class()```
* optionally declare instance methods by defining ```Point:__init(x,y,z)``` (see below)
* instantiate class by using ```local pt = Point(5,1,6)```
* define/call methods with : operator ```pt:get_xyz() --> 5,1,6```
~~~
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
  local distances = List:zeroes(4, 4)  --> before [[0, 0, 0, 0], [0, 0, 0, 0], [0, 0, 0, 0], [0, 0, 0, 0]]
  println("before {}", distances)
  for i, p1 in points(true) do
    for j, p2 in points(true) do
      distances[i][j] = p1-p2
    end
  end
  
  println("after {}", distances)  --> after [[-1, 18, 21, 30], [18, -1, 19, 14], [21, 19, -1, 21], [30, 14, 21, -1]]
end

main()
~~~
