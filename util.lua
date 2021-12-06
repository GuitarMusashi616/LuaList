local util = {}

function util.all(tbl) 
  local prev_k = nil
  return function()
    local k,v = next(tbl, prev_k)
    prev_k = k
    return v
  end
end

function util.assertEqual(expected, actual)
  assert(expected == actual, "Expected: "..tostring(expected)..", Actual: "..tostring(actual))
end

function util.assertRaises(exception, callable, ...)
  local status, err = pcall(callable, ...)
  assert(not status, "Exception not raised")
  --local last_err = err:sub(#err-#exception,#err-#exception)
  --assert(last_err==exception, "Expected: "..tostring(exception)..", Actual:"..tostring(last_err))
end

util.aliases = {
  notnil=function(a) return a~=nil end,
}

function util.is_of_type(var, typ)
  if type(var) == "table" and var.is_a then
    return var.is_a[typ]
  end
  
  if type(var) == typ then
    return true
  end
  
  if util.aliases[typ] then
    if util.aliases[typ](var) then
      return true
    end
  end
  return false
end

function util.args(...)
  local tArgs = {...}
  assert(#tArgs%2==0, "must pass a type for each arg")
  for i=1,#tArgs,2 do
    local var = tArgs[i]
    local typ = tArgs[i+1]
    
    assert(util.is_of_type(var, typ), tostring(var) .. " not of type " .. tostring(typ))
  end
end

function util.zip(tbl, oth)
  local prev_tbl_k = nil
  local prev_oth_k = nil
  return function()
    local tbl_k, tbl_val = next(tbl,prev_tbl_k)
    local oth_k, oth_val = next(oth,prev_oth_k)
    prev_tbl_k = tbl_k
    prev_oth_k = oth_k
    return tbl_val, oth_val
  end
end

function util.izip(tbl, oth)
  local i=0
  return function()
    i = i + 1
    return tbl[i], oth[i]
  end
end

return util