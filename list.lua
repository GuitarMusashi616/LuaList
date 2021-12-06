-- python list class for lua
local class = require("class")
local util = require("util")
local t = require("tprint")
local List = class()

local assertEqual, assertRaises, args, all, izip
= util.assertEqual, util.assertRaises, util.args, util.all, util.izip

function List:__init(...)
  --args(self, List)
  self.list = table.pack(...)
  self.list.n = nil
end

function List:ind_0_to_ind_1_key(key, bounds)
  --args(key, "notnil")
  bounds = bounds or 0
  --assert(type(key)=="number", "list key "..tostring(key).. " must be a number")
  --assert((-#self.list)-bounds <= key and key < #self.list+bounds, "list key "..tostring(key).." out of range")
  
  if key < 0 then
    return key+1+#self.list -- -1 return 4, -4 returns 1
  end
  
  return key+1
end

function List.__index(table, key)
  --args(key, "notnil")
  if tonumber(key) then
    key = table:ind_0_to_ind_1_key(key)
    return table.list[key]
  end
  return List[key]
end

function List.__newindex(table, key, value)
  if tonumber(key) then
    key = table:ind_0_to_ind_1_key(key)
    table.list[key] = value
    return
  end
  rawset(table, tostring(key), value)
end

function List:__len()
  --args(self, List)
  return #self.list
end

function List:__tostring()
  --args(self, List)
  local string = "["
  for i,v in ipairs(self.list) do
    string = string..t.str(v)
    if i < #self.list then
      string = string..", "
    end
  end
  string = string.."]"
  return string
end

function List:__call() -- returns iterator
  --args(self, List)
  -- return everything in list except the final
  return all(self.list)
end

function List:__add(o)
  --args(self, List, o, List)
  local new_list = getmetatable(self)()
  for num in self() do
    new_list:append(num)
  end
  for num in o() do
    new_list:append(num)
  end
  return new_list
end

function List:__mul(o)
  --args(self, List, o, "number")
  local new_list = getmetatable(self)()
  for i=1,o do
    for k,v in pairs(self.list) do
      new_list:append(v)
    end
  end
  return new_list
end

function List:__eq(o)
  --args(self, List, o, List)
  if #self.list ~= #o.list then
    return false
  end
  for a,b in izip(self.list, o.list) do
    if a ~= b then
      return false
    end
  end
  return true
end

function List:__lt(o)
  return #self.list < #o.list
end

function List:__le(o)
  return #self.list <= #o.list
end

function List:append(item,...)
  --args(self, List, item, "notnil")
  assert(not ..., "append() takes exactly 1 argument")
  self.list[#self.list+1] = item
end

function List:pop(index)
  index = index or #self.list-1
  index = self:ind_0_to_ind_1_key(index)
  return table.remove(self.list, index)
end

function List:insert(index, item)
  args(self, List, index, "number", item, "notnil")
  assert(self and index and item, "insert() takes exactly 2 arguments")
  index = self:ind_0_to_ind_1_key(index, 1)
  table.insert(self.list, index, item)
end

function List:filter(callable, enumerate)
  local res = List()
  for i,v in ipairs(self.list) do
    if (enumerate and callable(i-1,v)) or (not enumerate and callable(v)) then
      res:append(v)
    end
  end
  return res
end

function List:find(callable)
  for i,v in ipairs(self.list) do
    if callable(v) then
      return v
    end
  end
end

function List:map(callable)
  local res = List()
  for i,v in ipairs(self.list) do
    res:append(callable(v))
  end
  return res
end

function List:reduce(callable, start_val)
  local acc_val = start_val or self.list[1]
  local start_i = start_val and 1 or 2
  for i=start_i,#self.list do
    acc_val = callable(acc_val, self.list[i])
  end
  return acc_val
end

function List:every(callable)
  for i,v in ipairs(self.list) do
    if not callable(v) then
      return false
    end
  end
  return true
end

function List:some(callable)
  for i,v in ipairs(self.list) do
    if callable(v) then
      return true
    end
  end
  return false
end

function List:slice(start, stop)
  start = start or 0
  stop = stop or 1/0
  return self:filter(function(i,x) return start<=i and i<stop end, true)
end

function List:sort(callable)
  table.sort(self.list, callable)
end

local function test()
  local list = List(3,6,9,12,15)
  local list2 = List(5,10,15,20)
  
  -- length, tostring, concatenate test
  assertEqual(5, #list)
  assertEqual("[3, 6, 9, 12, 15]", tostring(list))
  assertEqual("[3, 6, 9, 12, 15, 5, 10, 15, 20]", tostring(list+list2))
  
  --index test
  assertEqual(3, list[0])
  assertEqual(6, list[1])
  assertEqual(9, list[2])
  assertEqual(12, list[3])
  assertEqual(15, list[4])
  
  -- tables within string test
  local list3 = List("stuff",18,14,"thing", List(3,2,1), {1,2,3})
  assertEqual("[stuff, 18, 14, thing, [3, 2, 1], {1, 2, 3}]", tostring(list3))
  
  -- eq test --
  assertEqual(List(5,10,15,20), list2)
  assertEqual(List(3,6,9,12,15), list)
  
  -- slice test --
  assertEqual(List(3,6,9,12,15), list:slice())
  assertEqual(List(3,6,9), list:slice(nil, 3))
  assertEqual(List(9,12,15), list:slice(2))
  
  -- test pop, append, insert
  local list4 = List(9,8,7,6,5)
  list4:append(4)
  assertEqual(4, list4[-1])
  local num = list4:pop()
  assertEqual(4, num)
  assertEqual(List(9,8,7,6,5), list4)
  local num2 = list4:pop(0)
  assertEqual(9, num2)
  assertEqual(List(8,7,6,5), list4)
  list4:insert(0, 9)
  assertEqual(List(9,8,7,6,5), list4)
  list4:insert(5, 9)
  assertEqual(List(9,8,7,6,5,9), list4)
  list4:pop()
  
  -- test out of range and wrong index
  assertRaises("list key 20 out of range", list4.__index, list4, 20)
  assertRaises("list key 5 out of range", list4.__index, list4, 5)
  assertRaises("list key -8 out of range", list4.__index, list4, -8)
  assertRaises("list key -6 out of range", list4.__index, list4, -6)
  assertRaises("insert(5) takes exactly 2 arguments", list4.insert, 5) -- take exactly 2 arguments
  assertRaises("append(5,1) takes exactly 1 argument", list4.append, 5, 1) 
  
  -- test correct index
  assertEqual(9,list4[-5])
  assertEqual(7,list4[-3])
  
  -- test sorting
  list4:sort()
  assertEqual(List(5,6,7,8,9), list4)
  
  -- test new__index
  list4[2] = 5
  assertEqual(List(5,6,5,8,9), list4)
  
  local list = List({name="bird",count=5},{name="air",count=2},{name="diamond",count=5},{name="iron",count=10})
  local thing = list:find(function(obj) return obj.name=="near" end)
  assertEqual(nil, thing)
  
  local list2 = List(5,8,6,7,8,9,3,10,2,1,5)

  assertEqual(64,list2:reduce(function(a,b) return a+b end))
  assertEqual(10,list2:reduce(function(a,b) if b>a then return b else return a end end))
  assertEqual(List("bird: 5","air: 2","diamond: 5","iron: 10"),(list:map(function(item) return item.name..": "..tostring(item.count) end)))
  assertEqual(true,list2:every(function(a) return type(a)=="number" end))
  assertEqual(true,list:some(function(a) return a.name=="bird" end))
end

--test() -- get just numbers between start stop
return List