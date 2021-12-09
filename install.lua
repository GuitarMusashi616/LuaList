-- for simple setup in computercraft computers by using wget run raw.githubusercontent.com/GuitarMusashi616/LuaList/main/install.lua

local function clearDir(dirName)
  shell.run("cd "..tostring(dirName))
  shell.run("rm *.lua")
  shell.run("cd ..")
  shell.run("rm "..tostring(dirName))
end

local function wgetLua(repo, fileNames)
  for i, file in pairs(fileNames) do
    shell.run("wget "..tostring(repo)..tostring(file)..".lua")
  end
end

local function wgetDirWithLua(dirName, repo, fileNames)
  shell.run("mkdir "..tostring(dirName))
  shell.run("cd "..tostring(dirName))
  wgetLua(repo, fileNames)
  shell.run("cd ..")
end

local tArgs = {...}

if tArgs[1] == "update" or tArgs[1] == "uninstall" then
  clearDir("lib")
end

if tArgs[1] == "uninstall" then
  error("Uninstall Successful")
end

wgetDirWithLua("lib", "raw.githubusercontent.com/GuitarMusashi616/LuaList/main/", {"list", "tbl", "util", "class"})
