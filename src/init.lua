-- This was made in two days, for the syn v2 competition
-- consider this code to be technical debt in its entirety.

local GuiService = game:GetService("GuiService")
local UserInputService = game:GetService("UserInputService")
local HttpService = game:GetService("HttpService")
local guiName = HttpService:GenerateGUID(false)
local gui = game:GetObjects("rbxassetid://12356534221")[1]
gui.Name = guiName
syn.protect_gui(gui)
gui.Parent = game:GetService("CoreGui")

local mouseDown = false
local resizing = false
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then
        return
    end

    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        mouseDown = true

        local frame = gui.Frame
        local mouseLocation = UserInputService:GetMouseLocation()
        local absPos, absSize = frame.AbsolutePosition, frame.AbsoluteSize

        local guiInset = GuiService:GetGuiInset()
        

        local relativeX = absPos.X+absSize.X
        local relativeY = absPos.Y+absSize.Y+guiInset.Y
        local range = 10

        if
            mouseLocation.X <= relativeX
            and mouseLocation.X >= relativeX - range
            and mouseLocation.Y <= relativeY
            and mouseLocation.Y >= relativeY - range
        then 

            local offset = mouseLocation-Vector2.new(relativeX, relativeY)
            while mouseDown do

                resizing = true
                local mouseLocation = UserInputService:GetMouseLocation()
                local absPos = frame.AbsolutePosition
                local size = Vector2.new(mouseLocation.X-absPos.X, mouseLocation.Y-absPos.Y-guiInset.Y)-offset
                gui.Frame.Size = UDim2.fromOffset(size.X, size.Y)
                task.wait()
            end

        end
    end
end)

UserInputService.InputEnded:Connect(function(input, gameProcessed)
    if gameProcessed then
        return
    end
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        resizing = false
        mouseDown = false
    end
end)

local dragging
local dragInput
local dragStart
local startPos

local function update(input)
	local delta = input.Position - dragStart
	gui.Frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
end

gui.Frame.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
		dragging = true
		dragStart = input.Position
		startPos = gui.Frame.Position
		
		input.Changed:Connect(function()
			if input.UserInputState == Enum.UserInputState.End then
				dragging = false
			end
		end)
	end
end)

gui.Frame.InputChanged:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
		dragInput = input
	end
end)

UserInputService.InputChanged:Connect(function(input)
	if input == dragInput and dragging and not resizing then
		update(input)
	end
end)

-- If running in autoexecute, dont accidently run it twice
if game:IsLoaded() then
    for i,v in next, getactors() do
        syn.run_on_actor(v, [[

        local GuiService = game:GetService("GuiService")
        local UserInputService = game:GetService("UserInputService")
        local HttpService = game:GetService("HttpService")

        -- GetFullName function by Pyseph
            local SpecialCharacters = {
                ['\a'] = '\\a', 
                ['\b'] = '\\b', 
                ['\f'] = '\\f', 
                ['\n'] = '\\n', 
                ['\r'] = '\\r', 
                ['\t'] = '\\t', 
                ['\v'] = '\\v', 
                ['\0'] = '\\0'
            }
            local Keywords = { 
                ['and'] = true, 
                ['break'] = true, 
                ['do'] = true, 
                ['else'] = true, 
                ['elseif'] = true, 
                ['end'] = true, 
                ['false'] = true, 
                ['for'] = true, 
                ['function'] = true, 
                ['if'] = true, 
                ['in'] = true, 
                ['local'] = true, 
                ['nil'] = true, 
                ['not'] = true, 
                ['or'] = true, 
                ['repeat'] = true, 
                ['return'] = true, 
                ['then'] = true, 
                ['true'] = true, 
                ['until'] = true, 
                ['while'] = true, 
                ['continue'] = true
            }
            
            local function GetFullName(Object)
                local Hierarchy = {}
            
                local ChainLength = 1
                local Parent = Object
                
                while Parent do
                    Parent = Parent.Parent
                    ChainLength = ChainLength + 1
                end
            
                Parent = Object
                local Num = 0
                while Parent do
                    Num = Num + 1
            
                    local ObjName = string.gsub(Parent.Name, '[%c%z]', SpecialCharacters)
                    ObjName = Parent == game and 'game' or ObjName
            
                    if Keywords[ObjName] or not string.match(ObjName, '^[_%a][_%w]*$') then
                        ObjName = '["' .. ObjName .. '"]'
                    elseif Num ~= ChainLength - 1 then
                        ObjName = '.' .. ObjName
                    end
            
                    Hierarchy[ChainLength - Num] = ObjName
                    Parent = Parent.Parent
                end
            
                return table.concat(Hierarchy)
            end
            
            local function GetMinMaxFromRegion3Properties(region)
                local cf = region.CFrame;
                local sz = region.Size;
            
                local min = cf * CFrame.new(-sz.X / 2, -sz.Y / 2, -sz.Z / 2)
                local max = cf * CFrame.new(sz.X / 2, sz.Y / 2, sz.Z / 2)
                return min, max
            end
            
        -- GetFullName function by Pyseph
        local SpecialCharacters = {
            ['\a'] = '\\a', 
            ['\b'] = '\\b', 
            ['\f'] = '\\f', 
            ['\n'] = '\\n', 
            ['\r'] = '\\r', 
            ['\t'] = '\\t', 
            ['\v'] = '\\v', 
            ['\0'] = '\\0'
        }
        local Keywords = { 
            ['and'] = true, 
            ['break'] = true, 
            ['do'] = true, 
            ['else'] = true, 
            ['elseif'] = true, 
            ['end'] = true, 
            ['false'] = true, 
            ['for'] = true, 
            ['function'] = true, 
            ['if'] = true, 
            ['in'] = true, 
            ['local'] = true, 
            ['nil'] = true, 
            ['not'] = true, 
            ['or'] = true, 
            ['repeat'] = true, 
            ['return'] = true, 
            ['then'] = true, 
            ['true'] = true, 
            ['until'] = true, 
            ['while'] = true, 
            ['continue'] = true
        }
        
        local function GetFullName(Object)
            local Hierarchy = {}
        
            local ChainLength = 1
            local Parent = Object
            
            while Parent do
                Parent = Parent.Parent
                ChainLength = ChainLength + 1
            end
        
            Parent = Object
            local Num = 0
            while Parent do
                Num = Num + 1
        
                local ObjName = string.gsub(Parent.Name, '[%c%z]', SpecialCharacters)
                ObjName = Parent == game and 'game' or ObjName
        
                if Keywords[ObjName] or not string.match(ObjName, '^[_%a][_%w]*$') then
                    ObjName = '["' .. ObjName .. '"]'
                elseif Num ~= ChainLength - 1 then
                    ObjName = '.' .. ObjName
                end
        
                Hierarchy[ChainLength - Num] = ObjName
                Parent = Parent.Parent
            end
        
            return table.concat(Hierarchy)
        end
        
        local function GetMinMaxFromRegion3Properties(region)
            local cf = region.CFrame;
            local sz = region.Size;
        
            local min = cf * CFrame.new(-sz.X / 2, -sz.Y / 2, -sz.Z / 2)
            local max = cf * CFrame.new(sz.X / 2, sz.Y / 2, sz.Z / 2)
            return min, max
        end
        
        local fromRGB = Color3.fromRGB
        
        local DataTypes = {
            ["BrickColor"] = {
                Transform = function(value)
                    local transformed = "BrickColor.new(\""..tostring(value).."\")"
                    return transformed
                end,
                Color = fromRGB(0, 255, 127)
            };
            ["boolean"] = {
                Transform = function(value)
                    return tostring(value)
                end,
                Color = fromRGB(255, 128, 0)
            };
            ["CFrame"] = {
                Transform = function(value)
                    local transformed = "CFrame.new("..tostring(value)..")"
                    return transformed
                end,
                Color = fromRGB(170, 255, 255)
            };
            ["Color3"] = {
                Transform = function(value)
                    local r, g, b = value.R, value.G, value.B
                    local transformed = "Color3.fromRGB("..table.concat({r,g,b}, ",")..")"
                    return transformed
                end,
                Color = fromRGB(0, 255, 127)
            };
            ["Enum"] = {
                Transform = function(value)
                    local transformed = "Enum."..tostring(value)
                    return transformed
                end,
                Color = fromRGB(0, 170, 255)
            };
            ["EnumItem"] = {
                Transform = function(value)
                    local transformed = tostring(value)
                    return transformed
                end,
                Color = fromRGB(0, 170, 255);
            };
            ["Instance"] = {
                Transform = function(value)
                    local transformed = GetFullName(value)
                    return transformed
                end,
                Color = fromRGB(255, 255, 255)
            };
            ["number"] = {
                Transform = function(value)
                    return tostring(value)
                end,
                Color = fromRGB(255, 255, 127)
            };
            ["Ray"] = {
                Transform = function(value)
                    local transformed = "Ray.new(".."Vector3.new("..tostring(value.Origin).."), Vector3.new("..tostring(value.Direction).."))"
                    return transformed
                end,
                Color = fromRGB(255, 255, 127);
            };
            ["RaycastParams"] = {
                Transform = function(value)
                    local transformed = "RaycastParams.new"..tostring(value):match("%b{}")
                    return transformed
                end,
                Color = fromRGB(255, 255, 127)
            };
            ["Rect"] = {
                Transform = function(value)
                    local transformed = "Rect.new("..tostring(value)..")";
                    return transformed
                end,
                Color = fromRGB(255, 255, 127)
            };
            ["Region3"] = {
                Transform = function(value)
                    local min, max = GetMinMaxFromRegion3Properties(value)
                    local transformed = "Region3.new(".."Vector3.new("..tostring(min.Position).."), Vector3.new("..tostring(max.Position).."))"
                    return transformed
                end,
                Color = fromRGB(170, 255, 255)
            };
            ["Regionint16"] = {
                Transform = function(value)
                    local min, max = GetMinMaxFromRegion3Properties(value)
                    local transformed = "Region3.new(".."Vector3.new("..tostring(min.Position).."), Vector3.new("..tostring(max.Position).."))"
                    return transformed
                end,
                Color = fromRGB(170, 255, 255)
            };
            ["string"] = {
                Transform = function(value)
                    local transformed = "\""..value.."\""
                    return transformed
                end,
                Color = fromRGB(255, 170, 127)
            };
            ["table"] = {
                Transform = function(value)
                    return tostring(value)
                end,
                Color = fromRGB(190, 190, 190)
            };
            ["Vector2"] = {
                Transform = function(value)
                    local transformed = "Vector2.new("..tostring(value)..")"
                    return transformed
                end,
                Color = fromRGB(170, 255, 255)
            };
            ["Vector2int16"] = {
                Transform = function(value)
                    local transformed = "Vector2int16.new("..tostring(value)..")"
                    return transformed
                end,
                Color = fromRGB(170, 255, 255)
            };
            ["Vector3"] = {
                Transform = function(value)
                local transformed = "Vector3.new("..tostring(value)..")"
                return transformed
            end,
                Color = fromRGB(170, 255, 255)
            };
            ["Vector3int16"] = {
                Transform = function(value)
                    local transformed = "Vector3int16.new("..tostring(value)..")"
                    return transformed
                end,
                Color = fromRGB(170, 255, 255)
            };
        
        }
        
        local function transformDataTypeToString(value)
            local dataType = typeof(value)
            local whitelistedDataType = DataTypes[dataType]
            if whitelistedDataType then
                return whitelistedDataType.Transform(value)
            end
        
            return "DataType "..dataType..": "..tostring(value)
        end
        
        local function getColorForType(type)
            return DataTypes[type] and DataTypes[type].Color or fromRGB(180, 180, 180)
        end
        
        -- Created by Pyseph#1015
        
        local SpecialCharacters = {['\a'] = '\\a', ['\b'] = '\\b', ['\f'] = '\\f', ['\n'] = '\\n', ['\r'] = '\\r', ['\t'] = '\\t', ['\v'] = '\\v', ['\0'] = '\\0'}
        local Keywords = { ['and'] = true, ['break'] = true, ['do'] = true, ['else'] = true, ['elseif'] = true, ['end'] = true, ['false'] = true, ['for'] = true, ['function'] = true, ['if'] = true, ['in'] = true, ['local'] = true, ['nil'] = true, ['not'] = true, ['or'] = true, ['repeat'] = true, ['return'] = true, ['then'] = true, ['true'] = true, ['until'] = true, ['while'] = true, ['continue'] = true}
        local Functions = {[DockWidgetPluginGuiInfo.new] = "DockWidgetPluginGuiInfo.new"; [warn] = "warn"; [CFrame.fromMatrix] = "CFrame.fromMatrix"; [CFrame.fromAxisAngle] = "CFrame.fromAxisAngle"; [CFrame.fromOrientation] = "CFrame.fromOrientation"; [CFrame.fromEulerAnglesXYZ] = "CFrame.fromEulerAnglesXYZ"; [CFrame.Angles] = "CFrame.Angles"; [CFrame.fromEulerAnglesYXZ] = "CFrame.fromEulerAnglesYXZ"; [CFrame.new] = "CFrame.new"; [gcinfo] = "gcinfo"; [os.clock] = "os.clock"; [os.difftime] = "os.difftime"; [os.time] = "os.time"; [os.date] = "os.date"; [tick] = "tick"; [bit32.band] = "bit32.band"; [bit32.extract] = "bit32.extract"; [bit32.bor] = "bit32.bor"; [bit32.bnot] = "bit32.bnot"; [bit32.arshift] = "bit32.arshift"; [bit32.rshift] = "bit32.rshift"; [bit32.rrotate] = "bit32.rrotate"; [bit32.replace] = "bit32.replace"; [bit32.lshift] = "bit32.lshift"; [bit32.lrotate] = "bit32.lrotate"; [bit32.btest] = "bit32.btest"; [bit32.bxor] = "bit32.bxor"; [pairs] = "pairs"; [NumberSequence.new] = "NumberSequence.new"; [assert] = "assert"; [tonumber] = "tonumber"; [Color3.fromHSV] = "Color3.fromHSV"; [Color3.toHSV] = "Color3.toHSV"; [Color3.fromRGB] = "Color3.fromRGB"; [Color3.new] = "Color3.new"; [Delay] = "Delay"; [Stats] = "Stats"; [UserSettings] = "UserSettings"; [coroutine.resume] = "coroutine.resume"; [coroutine.yield] = "coroutine.yield"; [coroutine.running] = "coroutine.running"; [coroutine.status] = "coroutine.status"; [coroutine.wrap] = "coroutine.wrap"; [coroutine.create] = "coroutine.create"; [coroutine.isyieldable] = "coroutine.isyieldable"; [NumberRange.new] = "NumberRange.new"; [PhysicalProperties.new] = "PhysicalProperties.new"; [PluginManager] = "PluginManager"; [Ray.new] = "Ray.new"; [NumberSequenceKeypoint.new] = "NumberSequenceKeypoint.new"; [Version] = "Version"; [Vector2.new] = "Vector2.new"; [Instance.new] = "Instance.new"; [delay] = "delay"; [spawn] = "spawn"; [unpack] = "unpack"; [string.split] = "string.split"; [string.match] = "string.match"; [string.gmatch] = "string.gmatch"; [string.upper] = "string.upper"; [string.gsub] = "string.gsub"; [string.format] = "string.format"; [string.lower] = "string.lower"; [string.sub] = "string.sub"; [string.pack] = "string.pack"; [string.rep] = "string.rep"; [string.char] = "string.char"; [string.packsize] = "string.packsize"; [string.reverse] = "string.reverse"; [string.byte] = "string.byte"; [string.unpack] = "string.unpack"; [string.len] = "string.len"; [string.find] = "string.find"; [CellId.new] = "CellId.new"; [ypcall] = "ypcall"; [version] = "version"; [print] = "print"; [stats] = "stats"; [printidentity] = "printidentity"; [settings] = "settings"; [UDim2.fromOffset] = "UDim2.fromOffset"; [UDim2.fromScale] = "UDim2.fromScale"; [UDim2.new] = "UDim2.new"; [table.pack] = "table.pack"; [table.move] = "table.move"; [table.insert] = "table.insert"; [table.getn] = "table.getn"; [table.foreachi] = "table.foreachi"; [table.maxn] = "table.maxn"; [table.foreach] = "table.foreach"; [table.concat] = "table.concat"; [table.unpack] = "table.unpack"; [table.find] = "table.find"; [table.create] = "table.create"; [table.sort] = "table.sort"; [table.remove] = "table.remove"; [TweenInfo.new] = "TweenInfo.new"; [loadstring] = "loadstring"; [require] = "require"; [Vector3.FromNormalId] = "Vector3.FromNormalId"; [Vector3.FromAxis] = "Vector3.FromAxis"; [Vector3.fromAxis] = "Vector3.fromAxis"; [Vector3.fromNormalId] = "Vector3.fromNormalId"; [Vector3.new] = "Vector3.new"; [Vector3int16.new] = "Vector3int16.new"; [setmetatable] = "setmetatable"; [next] = "next"; [Wait] = "Wait"; [wait] = "wait"; [ipairs] = "ipairs"; [elapsedTime] = "elapsedTime"; [time] = "time"; [rawequal] = "rawequal"; [Vector2int16.new] = "Vector2int16.new"; [collectgarbage] = "collectgarbage"; [newproxy] = "newproxy"; [Spawn] = "Spawn"; [PluginDrag.new] = "PluginDrag.new"; [Region3.new] = "Region3.new"; [utf8.offset] = "utf8.offset"; [utf8.codepoint] = "utf8.codepoint"; [utf8.nfdnormalize] = "utf8.nfdnormalize"; [utf8.char] = "utf8.char"; [utf8.codes] = "utf8.codes"; [utf8.len] = "utf8.len"; [utf8.graphemes] = "utf8.graphemes"; [utf8.nfcnormalize] = "utf8.nfcnormalize"; [xpcall] = "xpcall"; [tostring] = "tostring"; [rawset] = "rawset"; [PathWaypoint.new] = "PathWaypoint.new"; [DateTime.fromUnixTimestamp] = "DateTime.fromUnixTimestamp"; [DateTime.now] = "DateTime.now"; [DateTime.fromIsoDate] = "DateTime.fromIsoDate"; [DateTime.fromUnixTimestampMillis] = "DateTime.fromUnixTimestampMillis"; [DateTime.fromLocalTime] = "DateTime.fromLocalTime"; [DateTime.fromUniversalTime] = "DateTime.fromUniversalTime"; [Random.new] = "Random.new"; [typeof] = "typeof"; [RaycastParams.new] = "RaycastParams.new"; [math.log] = "math.log"; [math.ldexp] = "math.ldexp"; [math.rad] = "math.rad"; [math.cosh] = "math.cosh"; [math.random] = "math.random"; [math.frexp] = "math.frexp"; [math.tanh] = "math.tanh"; [math.floor] = "math.floor"; [math.max] = "math.max"; [math.sqrt] = "math.sqrt"; [math.modf] = "math.modf"; [math.pow] = "math.pow"; [math.atan] = "math.atan"; [math.tan] = "math.tan"; [math.cos] = "math.cos"; [math.sign] = "math.sign"; [math.clamp] = "math.clamp"; [math.log10] = "math.log10"; [math.noise] = "math.noise"; [math.acos] = "math.acos"; [math.abs] = "math.abs"; [math.sinh] = "math.sinh"; [math.asin] = "math.asin"; [math.min] = "math.min"; [math.deg] = "math.deg"; [math.fmod] = "math.fmod"; [math.randomseed] = "math.randomseed"; [math.atan2] = "math.atan2"; [math.ceil] = "math.ceil"; [math.sin] = "math.sin"; [math.exp] = "math.exp"; [getfenv] = "getfenv"; [pcall] = "pcall"; [ColorSequenceKeypoint.new] = "ColorSequenceKeypoint.new"; [ColorSequence.new] = "ColorSequence.new"; [type] = "type"; [Region3int16.new] = "Region3int16.new"; [ElapsedTime] = "ElapsedTime"; [select] = "select"; [getmetatable] = "getmetatable"; [rawget] = "rawget"; [Faces.new] = "Faces.new"; [Rect.new] = "Rect.new"; [BrickColor.Blue] = "BrickColor.Blue"; [BrickColor.White] = "BrickColor.White"; [BrickColor.Yellow] = "BrickColor.Yellow"; [BrickColor.Red] = "BrickColor.Red"; [BrickColor.Gray] = "BrickColor.Gray"; [BrickColor.palette] = "BrickColor.palette"; [BrickColor.New] = "BrickColor.New"; [BrickColor.Black] = "BrickColor.Black"; [BrickColor.Green] = "BrickColor.Green"; [BrickColor.Random] = "BrickColor.Random"; [BrickColor.DarkGray] = "BrickColor.DarkGray"; [BrickColor.random] = "BrickColor.random"; [BrickColor.new] = "BrickColor.new"; [setfenv] = "setfenv"; [UDim.new] = "UDim.new"; [Axes.new] = "Axes.new"; [error] = "error"; [debug.traceback] = "debug.traceback"; [debug.profileend] = "debug.profileend"; [debug.profilebegin] = "debug.profilebegin"}
        
        function GetHierarchy(Object)
            local Hierarchy = {}
        
            local ChainLength = 1
            local Parent = Object
            
            while Parent do
                Parent = Parent.Parent
                ChainLength = ChainLength + 1
            end
        
            Parent = Object
            local Num = 0
            while Parent do
                Num = Num + 1
        
                local ObjName = string.gsub(Parent.Name, '[%c%z]', SpecialCharacters)
                ObjName = Parent == game and 'game' or ObjName
        
                if Keywords[ObjName] or not string.match(ObjName, '^[_%a][_%w]*$') then
                    ObjName = '["' .. ObjName .. '"]'
                elseif Num ~= ChainLength - 1 then
                    ObjName = '.' .. ObjName
                end
        
                Hierarchy[ChainLength - Num] = ObjName
                Parent = Parent.Parent
            end
        
            return table.concat(Hierarchy)
        end
        local function SerializeType(Value, Class)
            if Class == 'string' then
                -- Not using %q as it messes up the special characters fix
                return string.format('"%s"', string.gsub(Value, '[%c%z]', SpecialCharacters))
            elseif Class == 'Instance' then
                return GetHierarchy(Value)
            elseif type(Value) ~= Class then -- CFrame, Vector3, UDim2, ...
                return transformDataTypeToString(Value)
            elseif Class == 'function' then
                return Functions[Value] or '\'[Unknown ' .. (pcall(setfenv, Value, getfenv(Value)) and 'Lua' or 'C')  .. ' ' .. tostring(Value) .. ']\''
            elseif Class == 'userdata' then
                return 'newproxy(' .. tostring(not not getmetatable(Value)) .. ')'
            elseif Class == 'thread' then
                return '\'' .. tostring(Value) ..  ', status: ' .. coroutine.status(Value) .. '\''
            else -- thread, number, boolean, nil, ...
                return tostring(Value)
            end
        end
        local function TableToString(Table, IgnoredTables, DepthData, Path)
            IgnoredTables = IgnoredTables or {}
            local CyclicData = IgnoredTables[Table]
            if CyclicData then
                return ((CyclicData[1] == DepthData[1] - 1 and '\'[Cyclic Parent ' or '\'[Cyclic ') .. tostring(Table) .. ', path: ' .. CyclicData[2] .. ']\'')
            end
        
            Path = Path or 'ROOT'
            DepthData = DepthData or {0, Path}
            local Depth = DepthData[1] + 1
            DepthData[1] = Depth
            DepthData[2] = Path
        
            IgnoredTables[Table] = DepthData
            local Tab = string.rep('    ', Depth)
            local TrailingTab = string.rep('    ', Depth - 1)
            local Result = '{'
        
            local LineTab = '\n' .. Tab
            local HasOrder = true
            local Index = 1
        
            local IsEmpty = true
            for Key, Value in next, Table do
                IsEmpty = false
                if Index ~= Key then
                    HasOrder = false
                else
                    Index = Index + 1
                end
        
                local KeyClass, ValueClass = typeof(Key), typeof(Value)
                local HasBrackets = false
                if KeyClass == 'string' then
                    Key = string.gsub(Key, '[%c%z]', SpecialCharacters)
                    if Keywords[Key] or not string.match(Key, '^[_%a][_%w]*$') then
                        HasBrackets = true
                        Key = string.format('["%s"]', Key)
                    end
                else
                    HasBrackets = true
                    Key = '[' .. (KeyClass == 'table' and string.gsub(TableToString(Key, IgnoredTables, {Depth + 1, Path}), '^%s*(.-)%s*$', '%1') or SerializeType(Key, KeyClass)) .. ']'
                end
        
                Value = ValueClass == 'table' and TableToString(Value, IgnoredTables, {Depth + 1, Path}, Path .. (HasBrackets and '' or '.') .. Key) or SerializeType(Value, ValueClass)
                Result = Result .. LineTab .. (HasOrder and Value or Key .. ' = ' .. Value) .. ','
            end
        
            return IsEmpty and Result .. '};' or string.sub(Result,  1, -2) .. '\n' .. TrailingTab .. '};'
        end
        
        local Remotes = {}
        local Logs = {}

        local CoreGui = game:GetService("CoreGui")
        local id = ...
        local gui = CoreGui:FindFirstChild(id)
        local uiFrame = gui.Frame
        local storage = gui.Storage
        local remotesList = uiFrame.Body.Remotes
        local remotesDisplay = uiFrame.Body.Display
        
        remotesList.ChildRemoved:Connect(function()
            Remotes = {}
        end)
        
        local remoteSpyEnabled = true
        uiFrame.Header.Exit.MouseButton1Click:Connect(function()
            remoteSpyEnabled = false
            gui:Destroy()
        end)
        
        local clone = game.Clone
        local getDebugId = game.GetDebugId
        local isA = game.IsA
        
        
        local buttonColors = {
            ["RemoteEvent"] = Color3.fromRGB(255, 255, 127);
            ["RemoteFunction"] = Color3.fromRGB(255, 170, 255) ;
        }
        
        local function InitializeRemote(...)
            local args = table.pack(...)
            local remote = table.remove(args, 1)
            local identity = syn.get_thread_identity()
            syn.set_thread_identity(8)
            local remoteId = getDebugId(remote)
            if Remotes[remoteId] == nil then
                local _script = getcallingscript()
                Remotes[remoteId] = {
                    IgnoreRemote = false;
                    BlockRemote = false;
                    
                }
            end
            syn.set_thread_identity(identity)
        
        
            if Remotes[remoteId].BlockRemote then
                return true
            end
        
            if not Remotes[remoteId].IgnoreRemote then
                table.insert(Logs, {Remote = remote, Script = getcallingscript(), Arguments = args})
            end
        end
        
        local function clearList(list)
            for _, child in next, list:GetChildren() do
                if not child:IsA("UIListLayout") and child.Name ~= "GettingStarted" then
                    child:Destroy()
                end
            end
        end
        
        local function logRemote(remote, _script, ...)
            
            local remoteId = getDebugId(remote)
            local remoteInfo = Remotes[remoteId]
        
            local remoteType = isA(remote, "RemoteEvent") and "RemoteEvent"
            or isA(remote, "RemoteFunction") and "RemoteFunction"
        
            if remoteType == nil then
                return
            end
        
            if remoteInfo and remoteInfo.RemoteInteraction == nil then
        
                local color = remoteType == "RemoteEvent" and buttonColors.RemoteEvent
                or buttonColors.RemoteFunction
                
                local remoteViewer = clone(storage.Viewer)
                remoteViewer.Parent = remotesDisplay
        
                remoteViewer.Clear.MouseButton1Click:Connect(function()
                    clearList(remoteViewer.Frame.ScrollingFrame)
                end)
        
        
                remoteViewer.IgnoreRemote.MouseButton1Click:Connect(function()
                    remoteInfo.IgnoreRemote = not remoteInfo.IgnoreRemote
                    if remoteInfo.IgnoreRemote then
                        remoteViewer.IgnoreRemote.Frame.BackgroundColor3 = Color3.fromRGB(170,255,127)
                    else
                        remoteViewer.IgnoreRemote.Frame.BackgroundColor3 = Color3.fromRGB(255, 85, 73)
                    end
                end)
        
                remoteViewer.BlockRemote.MouseButton1Click:Connect(function()
                    remoteInfo.BlockRemote = not remoteInfo.BlockRemote
                    if remoteInfo.BlockRemote then
                        remoteViewer.BlockRemote.Frame.BackgroundColor3 = Color3.fromRGB(170,255,127)
                    else
                        remoteViewer.BlockRemote.Frame.BackgroundColor3 = Color3.fromRGB(255, 85, 73)
                    end
                end)
        
                local remoteInteraction = clone(storage.RemoteInteract)
                remoteInteraction.RemoteType.BackgroundColor3 = color
                remoteInteraction.TextLabel.Text = tostring(remote)
                remoteInteraction.Parent = remotesList
        
                remoteInteraction.MouseButton1Click:Connect(function()
                    
                    remotesDisplay.GettingStarted.Visible = false
        
                    for _, child in next, remotesDisplay:GetChildren() do
                        if child ~= remoteViewer then
                            child.Visible = false
                        end
                    end
        
                    for _, child in next, remotesList:GetChildren() do
                        if child:IsA("TextButton") and child ~= remoteInteraction then
                            child.BackgroundColor3 = Color3.fromRGB(31, 31, 31)
                        end
                    end
                    remoteViewer.Visible = true
                    remoteInteraction.Notification.Visible = false
                    remoteInteraction.BackgroundColor3 = Color3.fromRGB(51, 51, 51)
        
                end)
                
        
                remoteInteraction.MouseButton2Click:Connect(function()
        
                    local dropdown = clone(storage.Dropdown)
                    local dropdownInteraction = clone(storage.DropdownInteract)
                    dropdownInteraction.Text = "Clear All"
                    local mouseLocation = UserInputService:GetMouseLocation()
                    local x = mouseLocation.X - uiFrame.AbsolutePosition.X
                    local y = mouseLocation.Y - uiFrame.AbsolutePosition.Y - GuiService:GetGuiInset().Y
                    dropdown.Position = UDim2.new(0, x, 0, y)
                    dropdownInteraction.Parent = dropdown
                    dropdownInteraction.MouseButton1Click:Connect(function()
                        clearList(remotesList)
                        clearList(remotesDisplay)
                        remotesDisplay.GettingStarted.Visible = true
                        dropdown:Destroy()
                    end)
        
        
                    dropdownInteraction.MouseLeave:Connect(function()
                        dropdown:Destroy()
                    end)
        
                    dropdown.Parent = uiFrame
                end)
        
                remoteInfo.RemoteInteraction = remoteInteraction
                remoteInfo.RemoteViewer = remoteViewer;
        
            end
        
            if remoteInfo then
                -- check if remote is ignored or blocked
                -- if blocked, may wanna move remoteId as an argument and check it within the metamethod
                local argInteraction = clone(storage.ArgumentInteract)
                argInteraction.Header.TextLabel.Text = _script and tostring(_script) or "nil"
                local parent = argInteraction.Frame
                local numOfArgs = select("#", ...)
                for i = 1, numOfArgs do
                    local value = select(i, ...)
                    local _type = typeof(value)
                    if _type == "table" then
        
                        local tblMain = clone(storage.TableMain)
                        local text, color = transformDataTypeToString(value), getColorForType(_type)
                        
                        tblMain.Header.TextLabel.Text = text
                        tblMain.Header.TextLabel.TextColor3 = color
                        tblMain.Header.Frame.TextLabel.Text = #parent:GetChildren()
        
                        local tableStr, colors = TableToString(value)
                        local strings = string.split(tableStr, "\n")
                        
                        for i = 1, #strings do
                            local arg = clone(storage.TableBody)
                            if strings[i]:match("};,") then
                                strings[i] = strings[i]:gsub(",","")
                            end
                            arg.TextLabel.Text = strings[i]
                            arg.TextLabel.TextColor3 = Color3.fromRGB(255,255,255)
                            arg.Parent = tblMain
                        end
        
                        tblMain.Parent = parent
        
                    else
                        local arg = clone(storage.Argument)
                        local text, color = transformDataTypeToString(value), getColorForType(_type)
                        -- update this to the datatype to string handler
                        arg.TextLabel.Text = text
                        arg.TextLabel.TextColor3 = color
                        arg.Frame.TextLabel.Text = #parent:GetChildren()
                        arg.Parent = parent
                    end
                end
                argInteraction.Parent = remoteInfo.RemoteViewer.Frame.ScrollingFrame
                remoteInfo.RemoteInteraction.Notification.Visible = true
        
                argInteraction.MouseButton2Click:Connect(function()
                    
                    local dropdown = clone(storage.Dropdown)
                    local mouseLocation = UserInputService:GetMouseLocation()
                    local x = mouseLocation.X - uiFrame.AbsolutePosition.X
                    local y = mouseLocation.Y - uiFrame.AbsolutePosition.Y - GuiService:GetGuiInset().Y
                    dropdown.Position = UDim2.new(0, x, 0, y)
        
        
        
                    local dropdownInteraction = clone(storage.DropdownInteract)
                    dropdownInteraction.Text = "Generate Pseudo Script"
                    dropdownInteraction.Parent = dropdown
                    dropdownInteraction.MouseButton1Click:Connect(function()
                        local str = "local arguments = {\n"
                        for _, child in next, argInteraction.Frame:GetChildren() do
                            if child.Name == "TableMain" then
                                for _, subchild in next, child:GetChildren() do
                                    if subchild.Name == "TableBody" then
                                        str = str..subchild.TextLabel.Text.."\n"
                                    end
                                end
                            elseif child.Name == "Argument" then
                                str = str.."\t"..child.TextLabel.Text..";\n"
                            end
                        end
                        str = str.."};\n"
                        local func = remoteType == "RemoteEvent" and "FireServer" or "InvokeServer"
                        str = str..GetFullName(remote)..":"..func.."(unpack(arguments))"
                        setclipboard(str)
                        dropdown:Destroy()
                    end)
        
                    local dropdownInteraction = clone(storage.DropdownInteract)
                    dropdownInteraction.Text = "Decompile Script"
                    dropdownInteraction.Parent = dropdown
                    dropdownInteraction.MouseButton1Click:Connect(function()
                        if _script then
                            dropdownInteraction.Text = "Decompiling..."
                            setclipboard(decompile(_script))
                        end
                        dropdown:Destroy()
                    end)
        
                    local dropdownInteraction = clone(storage.DropdownInteract)
                    dropdownInteraction.Text = "Copy Script Path"
                    dropdownInteraction.Parent = dropdown
                    dropdownInteraction.MouseButton1Click:Connect(function()
                        if _script then
                            setclipboard(GetFullName(_script))
                        end
                        dropdown:Destroy()
                    end)
        
                    dropdown.MouseLeave:Connect(function()
                        dropdown:Destroy()
                    end)
        
                    dropdown.Parent = uiFrame
        
                end)
            end
        
        end
        
        local namecallMethods = {
            ["FireServer"] = true;
            ["fireServer"] = true;
            ["InvokeServer"] = true;
            ["invokeServer"] = true;
        }
        
        local originalNamecall
        originalNamecall = hookmetamethod(game, "__namecall", function(...)
        
            if not remoteSpyEnabled then
                return originalNamecall(...)
            end
        
            local method = getnamecallmethod()
        
            if namecallMethods[method] then
                local blockRemote = InitializeRemote(...)
                if blockRemote then
                    return
                end
            end
        
            return originalNamecall(...)
        end)
        
        local refRemoteEvent = Instance.new("RemoteEvent")
        local refRemoteFunction = Instance.new("RemoteFunction")
        
        local originalFireServer
        fireserverHook = hookfunction(refRemoteEvent.FireServer, function(...)
            if isactor() and not checkparallel() or not remoteSpyEnabled then
                return originalFireServer(...)
            end
        
            local object = ...
            if not typeof(object) == "Instance" then
                return originalFireServer(...)
            end
        
            local blockRemote = InitializeRemote(...)
            if blockRemote then
                return
            end
        
            return originalFireServer(...)
        end)
        
        local originalInvokeServer = hookfunction(refRemoteFunction.InvokeServer, function(...)
            if isactor() and not checkparallel() or not remoteSpyEnabled then
                return originalInvokeServer(...)
            end
        
            local object = ...
            if not typeof(object) == "Instance" then
                return originalInvokeServer(...)
            end
        
            local blockRemote = InitializeRemote(...)
            if blockRemote then
                return
            end
        
            return originalInvokeServer(...)
        end)
        
        while true do
            if #Logs > 0 then
                local log = Logs[1]
                local args = log.Arguments
                logRemote(log.Remote, log.Script, table.unpack(args, 1, args.n-1))
                table.remove(Logs, 1)
            end
            task.wait()
        end
        ]], guiName)
    end
end


syn.on_actor_created:Connect(function(actor)
    syn.run_on_actor(actor, [[

    local GuiService = game:GetService("GuiService")
    local UserInputService = game:GetService("UserInputService")
    local HttpService = game:GetService("HttpService")

    -- GetFullName function by Pyseph
        local SpecialCharacters = {
            ['\a'] = '\\a', 
            ['\b'] = '\\b', 
            ['\f'] = '\\f', 
            ['\n'] = '\\n', 
            ['\r'] = '\\r', 
            ['\t'] = '\\t', 
            ['\v'] = '\\v', 
            ['\0'] = '\\0'
        }
        local Keywords = { 
            ['and'] = true, 
            ['break'] = true, 
            ['do'] = true, 
            ['else'] = true, 
            ['elseif'] = true, 
            ['end'] = true, 
            ['false'] = true, 
            ['for'] = true, 
            ['function'] = true, 
            ['if'] = true, 
            ['in'] = true, 
            ['local'] = true, 
            ['nil'] = true, 
            ['not'] = true, 
            ['or'] = true, 
            ['repeat'] = true, 
            ['return'] = true, 
            ['then'] = true, 
            ['true'] = true, 
            ['until'] = true, 
            ['while'] = true, 
            ['continue'] = true
        }
        
        local function GetFullName(Object)
            local Hierarchy = {}
        
            local ChainLength = 1
            local Parent = Object
            
            while Parent do
                Parent = Parent.Parent
                ChainLength = ChainLength + 1
            end
        
            Parent = Object
            local Num = 0
            while Parent do
                Num = Num + 1
        
                local ObjName = string.gsub(Parent.Name, '[%c%z]', SpecialCharacters)
                ObjName = Parent == game and 'game' or ObjName
        
                if Keywords[ObjName] or not string.match(ObjName, '^[_%a][_%w]*$') then
                    ObjName = '["' .. ObjName .. '"]'
                elseif Num ~= ChainLength - 1 then
                    ObjName = '.' .. ObjName
                end
        
                Hierarchy[ChainLength - Num] = ObjName
                Parent = Parent.Parent
            end
        
            return table.concat(Hierarchy)
        end
        
        local function GetMinMaxFromRegion3Properties(region)
            local cf = region.CFrame;
            local sz = region.Size;
        
            local min = cf * CFrame.new(-sz.X / 2, -sz.Y / 2, -sz.Z / 2)
            local max = cf * CFrame.new(sz.X / 2, sz.Y / 2, sz.Z / 2)
            return min, max
        end
        
    -- GetFullName function by Pyseph
    local SpecialCharacters = {
        ['\a'] = '\\a', 
        ['\b'] = '\\b', 
        ['\f'] = '\\f', 
        ['\n'] = '\\n', 
        ['\r'] = '\\r', 
        ['\t'] = '\\t', 
        ['\v'] = '\\v', 
        ['\0'] = '\\0'
    }
    local Keywords = { 
        ['and'] = true, 
        ['break'] = true, 
        ['do'] = true, 
        ['else'] = true, 
        ['elseif'] = true, 
        ['end'] = true, 
        ['false'] = true, 
        ['for'] = true, 
        ['function'] = true, 
        ['if'] = true, 
        ['in'] = true, 
        ['local'] = true, 
        ['nil'] = true, 
        ['not'] = true, 
        ['or'] = true, 
        ['repeat'] = true, 
        ['return'] = true, 
        ['then'] = true, 
        ['true'] = true, 
        ['until'] = true, 
        ['while'] = true, 
        ['continue'] = true
    }
    
    local function GetFullName(Object)
        local Hierarchy = {}
    
        local ChainLength = 1
        local Parent = Object
        
        while Parent do
            Parent = Parent.Parent
            ChainLength = ChainLength + 1
        end
    
        Parent = Object
        local Num = 0
        while Parent do
            Num = Num + 1
    
            local ObjName = string.gsub(Parent.Name, '[%c%z]', SpecialCharacters)
            ObjName = Parent == game and 'game' or ObjName
    
            if Keywords[ObjName] or not string.match(ObjName, '^[_%a][_%w]*$') then
                ObjName = '["' .. ObjName .. '"]'
            elseif Num ~= ChainLength - 1 then
                ObjName = '.' .. ObjName
            end
    
            Hierarchy[ChainLength - Num] = ObjName
            Parent = Parent.Parent
        end
    
        return table.concat(Hierarchy)
    end
    
    local function GetMinMaxFromRegion3Properties(region)
        local cf = region.CFrame;
        local sz = region.Size;
    
        local min = cf * CFrame.new(-sz.X / 2, -sz.Y / 2, -sz.Z / 2)
        local max = cf * CFrame.new(sz.X / 2, sz.Y / 2, sz.Z / 2)
        return min, max
    end
    
    local fromRGB = Color3.fromRGB

    local DataTypes = {
        ["BrickColor"] = {
            Transform = function(value)
                local transformed = "BrickColor.new(\""..tostring(value).."\")"
                return transformed
            end,
            Color = fromRGB(0, 255, 127)
        };
        ["boolean"] = {
            Transform = function(value)
                return tostring(value)
            end,
            Color = fromRGB(255, 128, 0)
        };
        ["CFrame"] = {
            Transform = function(value)
                local transformed = "CFrame.new("..tostring(value)..")"
                return transformed
            end,
            Color = fromRGB(170, 255, 255)
        };
        ["Color3"] = {
            Transform = function(value)
                local r, g, b = value.R, value.G, value.B
                local transformed = "Color3.fromRGB("..table.concat({r,g,b}, ",")..")"
                return transformed
            end,
            Color = fromRGB(0, 255, 127)
        };
        ["Enum"] = {
            Transform = function(value)
                local transformed = "Enum."..tostring(value)
                return transformed
            end,
            Color = fromRGB(0, 170, 255)
        };
        ["EnumItem"] = {
            Transform = function(value)
                local transformed = tostring(value)
                return transformed
            end,
            Color = fromRGB(0, 170, 255);
        };
        ["Instance"] = {
            Transform = function(value)
                local transformed = GetFullName(value)
                return transformed
            end,
            Color = fromRGB(255, 255, 255)
        };
        ["number"] = {
            Transform = function(value)
                return tostring(value)
            end,
            Color = fromRGB(255, 255, 127)
        };
        ["Ray"] = {
            Transform = function(value)
                local transformed = "Ray.new(".."Vector3.new("..tostring(value.Origin).."), Vector3.new("..tostring(value.Direction).."))"
                return transformed
            end,
            Color = fromRGB(255, 255, 127);
        };
        ["RaycastParams"] = {
            Transform = function(value)
                local transformed = "RaycastParams.new"..tostring(value):match("%b{}")
                return transformed
            end,
            Color = fromRGB(255, 255, 127)
        };
        ["Rect"] = {
            Transform = function(value)
                local transformed = "Rect.new("..tostring(value)..")";
                return transformed
            end,
            Color = fromRGB(255, 255, 127)
        };
        ["Region3"] = {
            Transform = function(value)
                local min, max = GetMinMaxFromRegion3Properties(value)
                local transformed = "Region3.new(".."Vector3.new("..tostring(min.Position).."), Vector3.new("..tostring(max.Position).."))"
                return transformed
            end,
            Color = fromRGB(170, 255, 255)
        };
        ["Regionint16"] = {
            Transform = function(value)
                local min, max = GetMinMaxFromRegion3Properties(value)
                local transformed = "Region3.new(".."Vector3.new("..tostring(min.Position).."), Vector3.new("..tostring(max.Position).."))"
                return transformed
            end,
            Color = fromRGB(170, 255, 255)
        };
        ["string"] = {
            Transform = function(value)
                local transformed = "\""..value.."\""
                return transformed
            end,
            Color = fromRGB(255, 170, 127)
        };
        ["table"] = {
            Transform = function(value)
                return tostring(value)
            end,
            Color = fromRGB(190, 190, 190)
        };
        ["Vector2"] = {
            Transform = function(value)
                local transformed = "Vector2.new("..tostring(value)..")"
                return transformed
            end,
            Color = fromRGB(170, 255, 255)
        };
        ["Vector2int16"] = {
            Transform = function(value)
                local transformed = "Vector2int16.new("..tostring(value)..")"
                return transformed
            end,
            Color = fromRGB(170, 255, 255)
        };
        ["Vector3"] = {
            Transform = function(value)
            local transformed = "Vector3.new("..tostring(value)..")"
            return transformed
        end,
            Color = fromRGB(170, 255, 255)
        };
        ["Vector3int16"] = {
            Transform = function(value)
                local transformed = "Vector3int16.new("..tostring(value)..")"
                return transformed
            end,
            Color = fromRGB(170, 255, 255)
        };
    
    }
    
    local function transformDataTypeToString(value)
        local dataType = typeof(value)
        local whitelistedDataType = DataTypes[dataType]
        if whitelistedDataType then
            return whitelistedDataType.Transform(value)
        end
    
        return "DataType "..dataType..": "..tostring(value)
    end
    
    local function getColorForType(type)
        return DataTypes[type] and DataTypes[type].Color or fromRGB(180, 180, 180)
    end
    
    -- Created by Pyseph#1015
    
    local SpecialCharacters = {['\a'] = '\\a', ['\b'] = '\\b', ['\f'] = '\\f', ['\n'] = '\\n', ['\r'] = '\\r', ['\t'] = '\\t', ['\v'] = '\\v', ['\0'] = '\\0'}
    local Keywords = { ['and'] = true, ['break'] = true, ['do'] = true, ['else'] = true, ['elseif'] = true, ['end'] = true, ['false'] = true, ['for'] = true, ['function'] = true, ['if'] = true, ['in'] = true, ['local'] = true, ['nil'] = true, ['not'] = true, ['or'] = true, ['repeat'] = true, ['return'] = true, ['then'] = true, ['true'] = true, ['until'] = true, ['while'] = true, ['continue'] = true}
    local Functions = {[DockWidgetPluginGuiInfo.new] = "DockWidgetPluginGuiInfo.new"; [warn] = "warn"; [CFrame.fromMatrix] = "CFrame.fromMatrix"; [CFrame.fromAxisAngle] = "CFrame.fromAxisAngle"; [CFrame.fromOrientation] = "CFrame.fromOrientation"; [CFrame.fromEulerAnglesXYZ] = "CFrame.fromEulerAnglesXYZ"; [CFrame.Angles] = "CFrame.Angles"; [CFrame.fromEulerAnglesYXZ] = "CFrame.fromEulerAnglesYXZ"; [CFrame.new] = "CFrame.new"; [gcinfo] = "gcinfo"; [os.clock] = "os.clock"; [os.difftime] = "os.difftime"; [os.time] = "os.time"; [os.date] = "os.date"; [tick] = "tick"; [bit32.band] = "bit32.band"; [bit32.extract] = "bit32.extract"; [bit32.bor] = "bit32.bor"; [bit32.bnot] = "bit32.bnot"; [bit32.arshift] = "bit32.arshift"; [bit32.rshift] = "bit32.rshift"; [bit32.rrotate] = "bit32.rrotate"; [bit32.replace] = "bit32.replace"; [bit32.lshift] = "bit32.lshift"; [bit32.lrotate] = "bit32.lrotate"; [bit32.btest] = "bit32.btest"; [bit32.bxor] = "bit32.bxor"; [pairs] = "pairs"; [NumberSequence.new] = "NumberSequence.new"; [assert] = "assert"; [tonumber] = "tonumber"; [Color3.fromHSV] = "Color3.fromHSV"; [Color3.toHSV] = "Color3.toHSV"; [Color3.fromRGB] = "Color3.fromRGB"; [Color3.new] = "Color3.new"; [Delay] = "Delay"; [Stats] = "Stats"; [UserSettings] = "UserSettings"; [coroutine.resume] = "coroutine.resume"; [coroutine.yield] = "coroutine.yield"; [coroutine.running] = "coroutine.running"; [coroutine.status] = "coroutine.status"; [coroutine.wrap] = "coroutine.wrap"; [coroutine.create] = "coroutine.create"; [coroutine.isyieldable] = "coroutine.isyieldable"; [NumberRange.new] = "NumberRange.new"; [PhysicalProperties.new] = "PhysicalProperties.new"; [PluginManager] = "PluginManager"; [Ray.new] = "Ray.new"; [NumberSequenceKeypoint.new] = "NumberSequenceKeypoint.new"; [Version] = "Version"; [Vector2.new] = "Vector2.new"; [Instance.new] = "Instance.new"; [delay] = "delay"; [spawn] = "spawn"; [unpack] = "unpack"; [string.split] = "string.split"; [string.match] = "string.match"; [string.gmatch] = "string.gmatch"; [string.upper] = "string.upper"; [string.gsub] = "string.gsub"; [string.format] = "string.format"; [string.lower] = "string.lower"; [string.sub] = "string.sub"; [string.pack] = "string.pack"; [string.rep] = "string.rep"; [string.char] = "string.char"; [string.packsize] = "string.packsize"; [string.reverse] = "string.reverse"; [string.byte] = "string.byte"; [string.unpack] = "string.unpack"; [string.len] = "string.len"; [string.find] = "string.find"; [CellId.new] = "CellId.new"; [ypcall] = "ypcall"; [version] = "version"; [print] = "print"; [stats] = "stats"; [printidentity] = "printidentity"; [settings] = "settings"; [UDim2.fromOffset] = "UDim2.fromOffset"; [UDim2.fromScale] = "UDim2.fromScale"; [UDim2.new] = "UDim2.new"; [table.pack] = "table.pack"; [table.move] = "table.move"; [table.insert] = "table.insert"; [table.getn] = "table.getn"; [table.foreachi] = "table.foreachi"; [table.maxn] = "table.maxn"; [table.foreach] = "table.foreach"; [table.concat] = "table.concat"; [table.unpack] = "table.unpack"; [table.find] = "table.find"; [table.create] = "table.create"; [table.sort] = "table.sort"; [table.remove] = "table.remove"; [TweenInfo.new] = "TweenInfo.new"; [loadstring] = "loadstring"; [require] = "require"; [Vector3.FromNormalId] = "Vector3.FromNormalId"; [Vector3.FromAxis] = "Vector3.FromAxis"; [Vector3.fromAxis] = "Vector3.fromAxis"; [Vector3.fromNormalId] = "Vector3.fromNormalId"; [Vector3.new] = "Vector3.new"; [Vector3int16.new] = "Vector3int16.new"; [setmetatable] = "setmetatable"; [next] = "next"; [Wait] = "Wait"; [wait] = "wait"; [ipairs] = "ipairs"; [elapsedTime] = "elapsedTime"; [time] = "time"; [rawequal] = "rawequal"; [Vector2int16.new] = "Vector2int16.new"; [collectgarbage] = "collectgarbage"; [newproxy] = "newproxy"; [Spawn] = "Spawn"; [PluginDrag.new] = "PluginDrag.new"; [Region3.new] = "Region3.new"; [utf8.offset] = "utf8.offset"; [utf8.codepoint] = "utf8.codepoint"; [utf8.nfdnormalize] = "utf8.nfdnormalize"; [utf8.char] = "utf8.char"; [utf8.codes] = "utf8.codes"; [utf8.len] = "utf8.len"; [utf8.graphemes] = "utf8.graphemes"; [utf8.nfcnormalize] = "utf8.nfcnormalize"; [xpcall] = "xpcall"; [tostring] = "tostring"; [rawset] = "rawset"; [PathWaypoint.new] = "PathWaypoint.new"; [DateTime.fromUnixTimestamp] = "DateTime.fromUnixTimestamp"; [DateTime.now] = "DateTime.now"; [DateTime.fromIsoDate] = "DateTime.fromIsoDate"; [DateTime.fromUnixTimestampMillis] = "DateTime.fromUnixTimestampMillis"; [DateTime.fromLocalTime] = "DateTime.fromLocalTime"; [DateTime.fromUniversalTime] = "DateTime.fromUniversalTime"; [Random.new] = "Random.new"; [typeof] = "typeof"; [RaycastParams.new] = "RaycastParams.new"; [math.log] = "math.log"; [math.ldexp] = "math.ldexp"; [math.rad] = "math.rad"; [math.cosh] = "math.cosh"; [math.random] = "math.random"; [math.frexp] = "math.frexp"; [math.tanh] = "math.tanh"; [math.floor] = "math.floor"; [math.max] = "math.max"; [math.sqrt] = "math.sqrt"; [math.modf] = "math.modf"; [math.pow] = "math.pow"; [math.atan] = "math.atan"; [math.tan] = "math.tan"; [math.cos] = "math.cos"; [math.sign] = "math.sign"; [math.clamp] = "math.clamp"; [math.log10] = "math.log10"; [math.noise] = "math.noise"; [math.acos] = "math.acos"; [math.abs] = "math.abs"; [math.sinh] = "math.sinh"; [math.asin] = "math.asin"; [math.min] = "math.min"; [math.deg] = "math.deg"; [math.fmod] = "math.fmod"; [math.randomseed] = "math.randomseed"; [math.atan2] = "math.atan2"; [math.ceil] = "math.ceil"; [math.sin] = "math.sin"; [math.exp] = "math.exp"; [getfenv] = "getfenv"; [pcall] = "pcall"; [ColorSequenceKeypoint.new] = "ColorSequenceKeypoint.new"; [ColorSequence.new] = "ColorSequence.new"; [type] = "type"; [Region3int16.new] = "Region3int16.new"; [ElapsedTime] = "ElapsedTime"; [select] = "select"; [getmetatable] = "getmetatable"; [rawget] = "rawget"; [Faces.new] = "Faces.new"; [Rect.new] = "Rect.new"; [BrickColor.Blue] = "BrickColor.Blue"; [BrickColor.White] = "BrickColor.White"; [BrickColor.Yellow] = "BrickColor.Yellow"; [BrickColor.Red] = "BrickColor.Red"; [BrickColor.Gray] = "BrickColor.Gray"; [BrickColor.palette] = "BrickColor.palette"; [BrickColor.New] = "BrickColor.New"; [BrickColor.Black] = "BrickColor.Black"; [BrickColor.Green] = "BrickColor.Green"; [BrickColor.Random] = "BrickColor.Random"; [BrickColor.DarkGray] = "BrickColor.DarkGray"; [BrickColor.random] = "BrickColor.random"; [BrickColor.new] = "BrickColor.new"; [setfenv] = "setfenv"; [UDim.new] = "UDim.new"; [Axes.new] = "Axes.new"; [error] = "error"; [debug.traceback] = "debug.traceback"; [debug.profileend] = "debug.profileend"; [debug.profilebegin] = "debug.profilebegin"}
    
    function GetHierarchy(Object)
        local Hierarchy = {}
    
        local ChainLength = 1
        local Parent = Object
        
        while Parent do
            Parent = Parent.Parent
            ChainLength = ChainLength + 1
        end
    
        Parent = Object
        local Num = 0
        while Parent do
            Num = Num + 1
    
            local ObjName = string.gsub(Parent.Name, '[%c%z]', SpecialCharacters)
            ObjName = Parent == game and 'game' or ObjName
    
            if Keywords[ObjName] or not string.match(ObjName, '^[_%a][_%w]*$') then
                ObjName = '["' .. ObjName .. '"]'
            elseif Num ~= ChainLength - 1 then
                ObjName = '.' .. ObjName
            end
    
            Hierarchy[ChainLength - Num] = ObjName
            Parent = Parent.Parent
        end
    
        return table.concat(Hierarchy)
    end
    local function SerializeType(Value, Class)
        if Class == 'string' then
            -- Not using %q as it messes up the special characters fix
            return string.format('"%s"', string.gsub(Value, '[%c%z]', SpecialCharacters))
        elseif Class == 'Instance' then
            return GetHierarchy(Value)
        elseif type(Value) ~= Class then -- CFrame, Vector3, UDim2, ...
            return transformDataTypeToString(Value)
        elseif Class == 'function' then
            return Functions[Value] or '\'[Unknown ' .. (pcall(setfenv, Value, getfenv(Value)) and 'Lua' or 'C')  .. ' ' .. tostring(Value) .. ']\''
        elseif Class == 'userdata' then
            return 'newproxy(' .. tostring(not not getmetatable(Value)) .. ')'
        elseif Class == 'thread' then
            return '\'' .. tostring(Value) ..  ', status: ' .. coroutine.status(Value) .. '\''
        else -- thread, number, boolean, nil, ...
            return tostring(Value)
        end
    end
    local function TableToString(Table, IgnoredTables, DepthData, Path)
        IgnoredTables = IgnoredTables or {}
        local CyclicData = IgnoredTables[Table]
        if CyclicData then
            return ((CyclicData[1] == DepthData[1] - 1 and '\'[Cyclic Parent ' or '\'[Cyclic ') .. tostring(Table) .. ', path: ' .. CyclicData[2] .. ']\'')
        end
    
        Path = Path or 'ROOT'
        DepthData = DepthData or {0, Path}
        local Depth = DepthData[1] + 1
        DepthData[1] = Depth
        DepthData[2] = Path
    
        IgnoredTables[Table] = DepthData
        local Tab = string.rep('    ', Depth)
        local TrailingTab = string.rep('    ', Depth - 1)
        local Result = '{'
    
        local LineTab = '\n' .. Tab
        local HasOrder = true
        local Index = 1
    
        local IsEmpty = true
        for Key, Value in next, Table do
            IsEmpty = false
            if Index ~= Key then
                HasOrder = false
            else
                Index = Index + 1
            end
    
            local KeyClass, ValueClass = typeof(Key), typeof(Value)
            local HasBrackets = false
            if KeyClass == 'string' then
                Key = string.gsub(Key, '[%c%z]', SpecialCharacters)
                if Keywords[Key] or not string.match(Key, '^[_%a][_%w]*$') then
                    HasBrackets = true
                    Key = string.format('["%s"]', Key)
                end
            else
                HasBrackets = true
                Key = '[' .. (KeyClass == 'table' and string.gsub(TableToString(Key, IgnoredTables, {Depth + 1, Path}), '^%s*(.-)%s*$', '%1') or SerializeType(Key, KeyClass)) .. ']'
            end
    
            Value = ValueClass == 'table' and TableToString(Value, IgnoredTables, {Depth + 1, Path}, Path .. (HasBrackets and '' or '.') .. Key) or SerializeType(Value, ValueClass)
            Result = Result .. LineTab .. (HasOrder and Value or Key .. ' = ' .. Value) .. ','
        end
    
        return IsEmpty and Result .. '};' or string.sub(Result,  1, -2) .. '\n' .. TrailingTab .. '};'
    end
    
    local Remotes = {}
    local Logs = {}

    local CoreGui = game:GetService("CoreGui")
    local id = ...
    local gui = CoreGui:FindFirstChild(id)
    local uiFrame = gui.Frame
    local storage = gui.Storage
    local remotesList = uiFrame.Body.Remotes
    local remotesDisplay = uiFrame.Body.Display
    
    remotesList.ChildRemoved:Connect(function()
        Remotes = {}
    end)
    
    local remoteSpyEnabled = true
    uiFrame.Header.Exit.MouseButton1Click:Connect(function()
        remoteSpyEnabled = false
        gui:Destroy()
    end)
    
    local clone = game.Clone
    local getDebugId = game.GetDebugId
    local isA = game.IsA
    
    
    local buttonColors = {
        ["RemoteEvent"] = Color3.fromRGB(255, 255, 127);
        ["RemoteFunction"] = Color3.fromRGB(255, 170, 255) ;
    }
    
    local function InitializeRemote(...)
        local args = table.pack(...)
        local remote = table.remove(args, 1)
        local identity = syn.get_thread_identity()
        syn.set_thread_identity(8)
        local remoteId = getDebugId(remote)
        if Remotes[remoteId] == nil then
            local _script = getcallingscript()
            Remotes[remoteId] = {
                IgnoreRemote = false;
                BlockRemote = false;
                
            }
        end
        syn.set_thread_identity(identity)
    
    
        if Remotes[remoteId].BlockRemote then
            return true
        end
    
        if not Remotes[remoteId].IgnoreRemote then
            table.insert(Logs, {Remote = remote, Script = getcallingscript(), Arguments = args})
        end
    end
    
    local function clearList(list)
        for _, child in next, list:GetChildren() do
            if not child:IsA("UIListLayout") and child.Name ~= "GettingStarted" then
                child:Destroy()
            end
        end
    end
    
    local function logRemote(remote, _script, ...)
        
        local remoteId = getDebugId(remote)
        local remoteInfo = Remotes[remoteId]
    
        local remoteType = isA(remote, "RemoteEvent") and "RemoteEvent"
        or isA(remote, "RemoteFunction") and "RemoteFunction"
    
        if remoteType == nil then
            return
        end
    
        if remoteInfo and remoteInfo.RemoteInteraction == nil then
    
            local color = remoteType == "RemoteEvent" and buttonColors.RemoteEvent
            or buttonColors.RemoteFunction
            
            local remoteViewer = clone(storage.Viewer)
            remoteViewer.Parent = remotesDisplay
    
            remoteViewer.Clear.MouseButton1Click:Connect(function()
                clearList(remoteViewer.Frame.ScrollingFrame)
            end)
    
    
            remoteViewer.IgnoreRemote.MouseButton1Click:Connect(function()
                remoteInfo.IgnoreRemote = not remoteInfo.IgnoreRemote
                if remoteInfo.IgnoreRemote then
                    remoteViewer.IgnoreRemote.Frame.BackgroundColor3 = Color3.fromRGB(170,255,127)
                else
                    remoteViewer.IgnoreRemote.Frame.BackgroundColor3 = Color3.fromRGB(255, 85, 73)
                end
            end)
    
            remoteViewer.BlockRemote.MouseButton1Click:Connect(function()
                remoteInfo.BlockRemote = not remoteInfo.BlockRemote
                if remoteInfo.BlockRemote then
                    remoteViewer.BlockRemote.Frame.BackgroundColor3 = Color3.fromRGB(170,255,127)
                else
                    remoteViewer.BlockRemote.Frame.BackgroundColor3 = Color3.fromRGB(255, 85, 73)
                end
            end)
    
            local remoteInteraction = clone(storage.RemoteInteract)
            remoteInteraction.RemoteType.BackgroundColor3 = color
            remoteInteraction.TextLabel.Text = tostring(remote)
            remoteInteraction.Parent = remotesList
    
            remoteInteraction.MouseButton1Click:Connect(function()
                
                remotesDisplay.GettingStarted.Visible = false
    
                for _, child in next, remotesDisplay:GetChildren() do
                    if child ~= remoteViewer then
                        child.Visible = false
                    end
                end
    
                for _, child in next, remotesList:GetChildren() do
                    if child:IsA("TextButton") and child ~= remoteInteraction then
                        child.BackgroundColor3 = Color3.fromRGB(31, 31, 31)
                    end
                end
                remoteViewer.Visible = true
                remoteInteraction.Notification.Visible = false
                remoteInteraction.BackgroundColor3 = Color3.fromRGB(51, 51, 51)
    
            end)
            
    
            remoteInteraction.MouseButton2Click:Connect(function()
    
                local dropdown = clone(storage.Dropdown)
                local dropdownInteraction = clone(storage.DropdownInteract)
                dropdownInteraction.Text = "Clear All"
                local mouseLocation = UserInputService:GetMouseLocation()
                local x = mouseLocation.X - uiFrame.AbsolutePosition.X
                local y = mouseLocation.Y - uiFrame.AbsolutePosition.Y - GuiService:GetGuiInset().Y
                dropdown.Position = UDim2.new(0, x, 0, y)
                dropdownInteraction.Parent = dropdown
                dropdownInteraction.MouseButton1Click:Connect(function()
                    clearList(remotesList)
                    clearList(remotesDisplay)
                    remotesDisplay.GettingStarted.Visible = true
                    dropdown:Destroy()
                end)
    
    
                dropdownInteraction.MouseLeave:Connect(function()
                    dropdown:Destroy()
                end)
    
                dropdown.Parent = uiFrame
            end)
    
            remoteInfo.RemoteInteraction = remoteInteraction
            remoteInfo.RemoteViewer = remoteViewer;
    
        end
    
        if remoteInfo then
            local argInteraction = clone(storage.ArgumentInteract)
            argInteraction.Header.TextLabel.Text = _script and tostring(_script) or "nil"
            local parent = argInteraction.Frame
            local numOfArgs = select("#", ...)
            for i = 1, numOfArgs do
                local value = select(i, ...)
                local _type = typeof(value)
                if _type == "table" then
    
                    local tblMain = clone(storage.TableMain)
                    local text, color = transformDataTypeToString(value), getColorForType(_type)
                    
                    tblMain.Header.TextLabel.Text = text
                    tblMain.Header.TextLabel.TextColor3 = color
                    tblMain.Header.Frame.TextLabel.Text = #parent:GetChildren()
    
                    local tableStr, colors = TableToString(value)
                    local strings = string.split(tableStr, "\n")
                    
                    for i = 1, #strings do
                        local arg = clone(storage.TableBody)
                        if strings[i]:match("};,") then
                            strings[i] = strings[i]:gsub(",","")
                        end
                        arg.TextLabel.Text = strings[i]
                        arg.TextLabel.TextColor3 = Color3.fromRGB(255,255,255)
                        arg.Parent = tblMain
                    end
    
                    tblMain.Parent = parent
    
                else
                    local arg = clone(storage.Argument)
                    local text, color = transformDataTypeToString(value), getColorForType(_type)
                    arg.TextLabel.Text = text
                    arg.TextLabel.TextColor3 = color
                    arg.Frame.TextLabel.Text = #parent:GetChildren()
                    arg.Parent = parent
                end
            end
            argInteraction.Parent = remoteInfo.RemoteViewer.Frame.ScrollingFrame
            remoteInfo.RemoteInteraction.Notification.Visible = true
    
            argInteraction.MouseButton2Click:Connect(function()
                
                local dropdown = clone(storage.Dropdown)
                local mouseLocation = UserInputService:GetMouseLocation()
                local x = mouseLocation.X - uiFrame.AbsolutePosition.X
                local y = mouseLocation.Y - uiFrame.AbsolutePosition.Y - GuiService:GetGuiInset().Y
                dropdown.Position = UDim2.new(0, x, 0, y)
    
    
    
                local dropdownInteraction = clone(storage.DropdownInteract)
                dropdownInteraction.Text = "Generate Pseudo Script"
                dropdownInteraction.Parent = dropdown
                dropdownInteraction.MouseButton1Click:Connect(function()
                    local str = "local arguments = {\n"
                    for _, child in next, argInteraction.Frame:GetChildren() do
                        if child.Name == "TableMain" then
                            for _, subchild in next, child:GetChildren() do
                                if subchild.Name == "TableBody" then
                                    str = str..subchild.TextLabel.Text.."\n"
                                end
                            end
                        elseif child.Name == "Argument" then
                            str = str.."\t"..child.TextLabel.Text..";\n"
                        end
                    end
                    str = str.."};\n"
                    local func = remoteType == "RemoteEvent" and "FireServer" or "InvokeServer"
                    str = str..GetFullName(remote)..":"..func.."(unpack(arguments))"
                    setclipboard(str)
                    dropdown:Destroy()
                end)
    
                local dropdownInteraction = clone(storage.DropdownInteract)
                dropdownInteraction.Text = "Decompile Script"
                dropdownInteraction.Parent = dropdown
                dropdownInteraction.MouseButton1Click:Connect(function()
                    if _script then
                        dropdownInteraction.Text = "Decompiling..."
                        setclipboard(decompile(_script))
                    end
                    dropdown:Destroy()
                end)
    
                local dropdownInteraction = clone(storage.DropdownInteract)
                dropdownInteraction.Text = "Copy Script Path"
                dropdownInteraction.Parent = dropdown
                dropdownInteraction.MouseButton1Click:Connect(function()
                    if _script then
                        setclipboard(GetFullName(_script))
                    end
                    dropdown:Destroy()
                end)
    
                dropdown.MouseLeave:Connect(function()
                    dropdown:Destroy()
                end)
    
                dropdown.Parent = uiFrame
    
            end)
        end
    
    end
    
    local namecallMethods = {
        ["FireServer"] = true;
        ["fireServer"] = true;
        ["InvokeServer"] = true;
        ["invokeServer"] = true;
    }
    
    local originalNamecall
    originalNamecall = hookmetamethod(game, "__namecall", function(...)
    
        if not remoteSpyEnabled then
            return originalNamecall(...)
        end
    
        local method = getnamecallmethod()
    
        if namecallMethods[method] then
            local blockRemote = InitializeRemote(...)
            if blockRemote then
                return
            end
        end
    
        return originalNamecall(...)
    end)
    
    local refRemoteEvent = Instance.new("RemoteEvent")
    local refRemoteFunction = Instance.new("RemoteFunction")
    
    local originalFireServer
    fireserverHook = hookfunction(refRemoteEvent.FireServer, function(...)
        if isactor() and not checkparallel() or not remoteSpyEnabled then
            return originalFireServer(...)
        end
    
        local object = ...
        if not typeof(object) == "Instance" then
            return originalFireServer(...)
        end
    
        local blockRemote = InitializeRemote(...)
        if blockRemote then
            return
        end
    
        return originalFireServer(...)
    end)
    
    local originalInvokeServer = hookfunction(refRemoteFunction.InvokeServer, function(...)
        if isactor() and not checkparallel() or not remoteSpyEnabled then
            return originalInvokeServer(...)
        end
    
        local object = ...
        if not typeof(object) == "Instance" then
            return originalInvokeServer(...)
        end
    
        local blockRemote = InitializeRemote(...)
        if blockRemote then
            return
        end
    
        return originalInvokeServer(...)
    end)
    
    while true do
        if #Logs > 0 then
            local log = Logs[1]
            local args = log.Arguments
            logRemote(log.Remote, log.Script, table.unpack(args, 1, args.n-1))
            table.remove(Logs, 1)
        end
        task.wait()
    end
    ]], guiName)
end)
local mouseDown = false
local resizing = false
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then
        return
    end

    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        mouseDown = true

        local frame = gui.Frame
        local mouseLocation = UserInputService:GetMouseLocation()
        local absPos, absSize = frame.AbsolutePosition, frame.AbsoluteSize

        local guiInset = GuiService:GetGuiInset()
        

        local relativeX = absPos.X+absSize.X
        local relativeY = absPos.Y+absSize.Y+guiInset.Y
        local range = 10

        if
            mouseLocation.X <= relativeX
            and mouseLocation.X >= relativeX - range
            and mouseLocation.Y <= relativeY
            and mouseLocation.Y >= relativeY - range
        then 

            local offset = mouseLocation-Vector2.new(relativeX, relativeY)
            while mouseDown do

                resizing = true
                local mouseLocation = UserInputService:GetMouseLocation()
                local absPos = frame.AbsolutePosition
                local size = Vector2.new(mouseLocation.X-absPos.X, mouseLocation.Y-absPos.Y-guiInset.Y)-offset
                gui.Frame.Size = UDim2.fromOffset(size.X, size.Y)
                task.wait()
            end

        end
    end
end)

UserInputService.InputEnded:Connect(function(input, gameProcessed)
    if gameProcessed then
        return
    end
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        resizing = false
        mouseDown = false
    end
end)

local dragging
local dragInput
local dragStart
local startPos

local function update(input)
	local delta = input.Position - dragStart
	gui.Frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
end

gui.Frame.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
		dragging = true
		dragStart = input.Position
		startPos = gui.Frame.Position
		
		input.Changed:Connect(function()
			if input.UserInputState == Enum.UserInputState.End then
				dragging = false
			end
		end)
	end
end)

gui.Frame.InputChanged:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
		dragInput = input
	end
end)

UserInputService.InputChanged:Connect(function(input)
	if input == dragInput and dragging and not resizing then
		update(input)
	end
end)

-- GetFullName function by Pyseph
    local SpecialCharacters = {
        ['\a'] = '\\a', 
        ['\b'] = '\\b', 
        ['\f'] = '\\f', 
        ['\n'] = '\\n', 
        ['\r'] = '\\r', 
        ['\t'] = '\\t', 
        ['\v'] = '\\v', 
        ['\0'] = '\\0'
    }
    local Keywords = { 
        ['and'] = true, 
        ['break'] = true, 
        ['do'] = true, 
        ['else'] = true, 
        ['elseif'] = true, 
        ['end'] = true, 
        ['false'] = true, 
        ['for'] = true, 
        ['function'] = true, 
        ['if'] = true, 
        ['in'] = true, 
        ['local'] = true, 
        ['nil'] = true, 
        ['not'] = true, 
        ['or'] = true, 
        ['repeat'] = true, 
        ['return'] = true, 
        ['then'] = true, 
        ['true'] = true, 
        ['until'] = true, 
        ['while'] = true, 
        ['continue'] = true
    }
    
    local function GetFullName(Object)
        local Hierarchy = {}
    
        local ChainLength = 1
        local Parent = Object
        
        while Parent do
            Parent = Parent.Parent
            ChainLength = ChainLength + 1
        end
    
        Parent = Object
        local Num = 0
        while Parent do
            Num = Num + 1
    
            local ObjName = string.gsub(Parent.Name, '[%c%z]', SpecialCharacters)
            ObjName = Parent == game and 'game' or ObjName
    
            if Keywords[ObjName] or not string.match(ObjName, '^[_%a][_%w]*$') then
                ObjName = '["' .. ObjName .. '"]'
            elseif Num ~= ChainLength - 1 then
                ObjName = '.' .. ObjName
            end
    
            Hierarchy[ChainLength - Num] = ObjName
            Parent = Parent.Parent
        end
    
        return table.concat(Hierarchy)
    end
    
    local function GetMinMaxFromRegion3Properties(region)
        local cf = region.CFrame;
        local sz = region.Size;
    
        local min = cf * CFrame.new(-sz.X / 2, -sz.Y / 2, -sz.Z / 2)
        local max = cf * CFrame.new(sz.X / 2, sz.Y / 2, sz.Z / 2)
        return min, max
    end
    
-- GetFullName function by Pyseph
local SpecialCharacters = {
    ['\a'] = '\\a', 
    ['\b'] = '\\b', 
    ['\f'] = '\\f', 
    ['\n'] = '\\n', 
    ['\r'] = '\\r', 
    ['\t'] = '\\t', 
    ['\v'] = '\\v', 
    ['\0'] = '\\0'
}
local Keywords = { 
    ['and'] = true, 
    ['break'] = true, 
    ['do'] = true, 
    ['else'] = true, 
    ['elseif'] = true, 
    ['end'] = true, 
    ['false'] = true, 
    ['for'] = true, 
    ['function'] = true, 
    ['if'] = true, 
    ['in'] = true, 
    ['local'] = true, 
    ['nil'] = true, 
    ['not'] = true, 
    ['or'] = true, 
    ['repeat'] = true, 
    ['return'] = true, 
    ['then'] = true, 
    ['true'] = true, 
    ['until'] = true, 
    ['while'] = true, 
    ['continue'] = true
}

local function GetFullName(Object)
    local Hierarchy = {}

    local ChainLength = 1
    local Parent = Object
    
    while Parent do
        Parent = Parent.Parent
        ChainLength = ChainLength + 1
    end

    Parent = Object
    local Num = 0
    while Parent do
        Num = Num + 1

        local ObjName = string.gsub(Parent.Name, '[%c%z]', SpecialCharacters)
        ObjName = Parent == game and 'game' or ObjName

        if Keywords[ObjName] or not string.match(ObjName, '^[_%a][_%w]*$') then
            ObjName = '["' .. ObjName .. '"]'
        elseif Num ~= ChainLength - 1 then
            ObjName = '.' .. ObjName
        end

        Hierarchy[ChainLength - Num] = ObjName
        Parent = Parent.Parent
    end

    return table.concat(Hierarchy)
end

local function GetMinMaxFromRegion3Properties(region)
    local cf = region.CFrame;
    local sz = region.Size;

    local min = cf * CFrame.new(-sz.X / 2, -sz.Y / 2, -sz.Z / 2)
    local max = cf * CFrame.new(sz.X / 2, sz.Y / 2, sz.Z / 2)
    return min, max
end

local fromRGB = Color3.fromRGB

local DataTypes = {
    ["BrickColor"] = {
        Transform = function(value)
            local transformed = "BrickColor.new(\""..tostring(value).."\")"
            return transformed
        end,
        Color = fromRGB(0, 255, 127)
    };
    ["boolean"] = {
        Transform = function(value)
            return tostring(value)
        end,
        Color = fromRGB(255, 128, 0)
    };
    ["CFrame"] = {
        Transform = function(value)
            local transformed = "CFrame.new("..tostring(value)..")"
            return transformed
        end,
        Color = fromRGB(170, 255, 255)
    };
    ["Color3"] = {
        Transform = function(value)
            local r, g, b = value.R, value.G, value.B
            local transformed = "Color3.fromRGB("..table.concat({r,g,b}, ",")..")"
            return transformed
        end,
        Color = fromRGB(0, 255, 127)
    };
    ["Enum"] = {
        Transform = function(value)
            local transformed = "Enum."..tostring(value)
            return transformed
        end,
        Color = fromRGB(0, 170, 255)
    };
    ["EnumItem"] = {
        Transform = function(value)
            local transformed = tostring(value)
            return transformed
        end,
        Color = fromRGB(0, 170, 255);
    };
    ["Instance"] = {
        Transform = function(value)
            local transformed = GetFullName(value)
            return transformed
        end,
        Color = fromRGB(255, 255, 255)
    };
    ["number"] = {
        Transform = function(value)
            return tostring(value)
        end,
        Color = fromRGB(255, 255, 127)
    };
    ["Ray"] = {
        Transform = function(value)
            local transformed = "Ray.new(".."Vector3.new("..tostring(value.Origin).."), Vector3.new("..tostring(value.Direction).."))"
            return transformed
        end,
        Color = fromRGB(255, 255, 127);
    };
    ["RaycastParams"] = {
        Transform = function(value)
            local transformed = "RaycastParams.new"..tostring(value):match("%b{}")
            return transformed
        end,
        Color = fromRGB(255, 255, 127)
    };
    ["Rect"] = {
        Transform = function(value)
            local transformed = "Rect.new("..tostring(value)..")";
            return transformed
        end,
        Color = fromRGB(255, 255, 127)
    };
    ["Region3"] = {
        Transform = function(value)
            local min, max = GetMinMaxFromRegion3Properties(value)
            local transformed = "Region3.new(".."Vector3.new("..tostring(min.Position).."), Vector3.new("..tostring(max.Position).."))"
            return transformed
        end,
        Color = fromRGB(170, 255, 255)
    };
    ["Regionint16"] = {
        Transform = function(value)
            local min, max = GetMinMaxFromRegion3Properties(value)
            local transformed = "Region3.new(".."Vector3.new("..tostring(min.Position).."), Vector3.new("..tostring(max.Position).."))"
            return transformed
        end,
        Color = fromRGB(170, 255, 255)
    };
    ["string"] = {
        Transform = function(value)
            local transformed = "\""..value.."\""
            return transformed
        end,
        Color = fromRGB(255, 170, 127)
    };
    ["table"] = {
        Transform = function(value)
            return tostring(value)
        end,
        Color = fromRGB(190, 190, 190)
    };
    ["Vector2"] = {
        Transform = function(value)
            local transformed = "Vector2.new("..tostring(value)..")"
            return transformed
        end,
        Color = fromRGB(170, 255, 255)
    };
    ["Vector2int16"] = {
        Transform = function(value)
            local transformed = "Vector2int16.new("..tostring(value)..")"
            return transformed
        end,
        Color = fromRGB(170, 255, 255)
    };
    ["Vector3"] = {
        Transform = function(value)
        local transformed = "Vector3.new("..tostring(value)..")"
        return transformed
    end,
        Color = fromRGB(170, 255, 255)
    };
    ["Vector3int16"] = {
        Transform = function(value)
            local transformed = "Vector3int16.new("..tostring(value)..")"
            return transformed
        end,
        Color = fromRGB(170, 255, 255)
    };

}

local function transformDataTypeToString(value)
    local dataType = typeof(value)
    local whitelistedDataType = DataTypes[dataType]
    if whitelistedDataType then
        return whitelistedDataType.Transform(value)
    end

    return "DataType "..dataType..": "..tostring(value)
end

local function getColorForType(type)
    return DataTypes[type] and DataTypes[type].Color or fromRGB(180, 180, 180)
end

-- Created by Pyseph#1015

local SpecialCharacters = {['\a'] = '\\a', ['\b'] = '\\b', ['\f'] = '\\f', ['\n'] = '\\n', ['\r'] = '\\r', ['\t'] = '\\t', ['\v'] = '\\v', ['\0'] = '\\0'}
local Keywords = { ['and'] = true, ['break'] = true, ['do'] = true, ['else'] = true, ['elseif'] = true, ['end'] = true, ['false'] = true, ['for'] = true, ['function'] = true, ['if'] = true, ['in'] = true, ['local'] = true, ['nil'] = true, ['not'] = true, ['or'] = true, ['repeat'] = true, ['return'] = true, ['then'] = true, ['true'] = true, ['until'] = true, ['while'] = true, ['continue'] = true}
local Functions = {[DockWidgetPluginGuiInfo.new] = "DockWidgetPluginGuiInfo.new"; [warn] = "warn"; [CFrame.fromMatrix] = "CFrame.fromMatrix"; [CFrame.fromAxisAngle] = "CFrame.fromAxisAngle"; [CFrame.fromOrientation] = "CFrame.fromOrientation"; [CFrame.fromEulerAnglesXYZ] = "CFrame.fromEulerAnglesXYZ"; [CFrame.Angles] = "CFrame.Angles"; [CFrame.fromEulerAnglesYXZ] = "CFrame.fromEulerAnglesYXZ"; [CFrame.new] = "CFrame.new"; [gcinfo] = "gcinfo"; [os.clock] = "os.clock"; [os.difftime] = "os.difftime"; [os.time] = "os.time"; [os.date] = "os.date"; [tick] = "tick"; [bit32.band] = "bit32.band"; [bit32.extract] = "bit32.extract"; [bit32.bor] = "bit32.bor"; [bit32.bnot] = "bit32.bnot"; [bit32.arshift] = "bit32.arshift"; [bit32.rshift] = "bit32.rshift"; [bit32.rrotate] = "bit32.rrotate"; [bit32.replace] = "bit32.replace"; [bit32.lshift] = "bit32.lshift"; [bit32.lrotate] = "bit32.lrotate"; [bit32.btest] = "bit32.btest"; [bit32.bxor] = "bit32.bxor"; [pairs] = "pairs"; [NumberSequence.new] = "NumberSequence.new"; [assert] = "assert"; [tonumber] = "tonumber"; [Color3.fromHSV] = "Color3.fromHSV"; [Color3.toHSV] = "Color3.toHSV"; [Color3.fromRGB] = "Color3.fromRGB"; [Color3.new] = "Color3.new"; [Delay] = "Delay"; [Stats] = "Stats"; [UserSettings] = "UserSettings"; [coroutine.resume] = "coroutine.resume"; [coroutine.yield] = "coroutine.yield"; [coroutine.running] = "coroutine.running"; [coroutine.status] = "coroutine.status"; [coroutine.wrap] = "coroutine.wrap"; [coroutine.create] = "coroutine.create"; [coroutine.isyieldable] = "coroutine.isyieldable"; [NumberRange.new] = "NumberRange.new"; [PhysicalProperties.new] = "PhysicalProperties.new"; [PluginManager] = "PluginManager"; [Ray.new] = "Ray.new"; [NumberSequenceKeypoint.new] = "NumberSequenceKeypoint.new"; [Version] = "Version"; [Vector2.new] = "Vector2.new"; [Instance.new] = "Instance.new"; [delay] = "delay"; [spawn] = "spawn"; [unpack] = "unpack"; [string.split] = "string.split"; [string.match] = "string.match"; [string.gmatch] = "string.gmatch"; [string.upper] = "string.upper"; [string.gsub] = "string.gsub"; [string.format] = "string.format"; [string.lower] = "string.lower"; [string.sub] = "string.sub"; [string.pack] = "string.pack"; [string.rep] = "string.rep"; [string.char] = "string.char"; [string.packsize] = "string.packsize"; [string.reverse] = "string.reverse"; [string.byte] = "string.byte"; [string.unpack] = "string.unpack"; [string.len] = "string.len"; [string.find] = "string.find"; [CellId.new] = "CellId.new"; [ypcall] = "ypcall"; [version] = "version"; [print] = "print"; [stats] = "stats"; [printidentity] = "printidentity"; [settings] = "settings"; [UDim2.fromOffset] = "UDim2.fromOffset"; [UDim2.fromScale] = "UDim2.fromScale"; [UDim2.new] = "UDim2.new"; [table.pack] = "table.pack"; [table.move] = "table.move"; [table.insert] = "table.insert"; [table.getn] = "table.getn"; [table.foreachi] = "table.foreachi"; [table.maxn] = "table.maxn"; [table.foreach] = "table.foreach"; [table.concat] = "table.concat"; [table.unpack] = "table.unpack"; [table.find] = "table.find"; [table.create] = "table.create"; [table.sort] = "table.sort"; [table.remove] = "table.remove"; [TweenInfo.new] = "TweenInfo.new"; [loadstring] = "loadstring"; [require] = "require"; [Vector3.FromNormalId] = "Vector3.FromNormalId"; [Vector3.FromAxis] = "Vector3.FromAxis"; [Vector3.fromAxis] = "Vector3.fromAxis"; [Vector3.fromNormalId] = "Vector3.fromNormalId"; [Vector3.new] = "Vector3.new"; [Vector3int16.new] = "Vector3int16.new"; [setmetatable] = "setmetatable"; [next] = "next"; [Wait] = "Wait"; [wait] = "wait"; [ipairs] = "ipairs"; [elapsedTime] = "elapsedTime"; [time] = "time"; [rawequal] = "rawequal"; [Vector2int16.new] = "Vector2int16.new"; [collectgarbage] = "collectgarbage"; [newproxy] = "newproxy"; [Spawn] = "Spawn"; [PluginDrag.new] = "PluginDrag.new"; [Region3.new] = "Region3.new"; [utf8.offset] = "utf8.offset"; [utf8.codepoint] = "utf8.codepoint"; [utf8.nfdnormalize] = "utf8.nfdnormalize"; [utf8.char] = "utf8.char"; [utf8.codes] = "utf8.codes"; [utf8.len] = "utf8.len"; [utf8.graphemes] = "utf8.graphemes"; [utf8.nfcnormalize] = "utf8.nfcnormalize"; [xpcall] = "xpcall"; [tostring] = "tostring"; [rawset] = "rawset"; [PathWaypoint.new] = "PathWaypoint.new"; [DateTime.fromUnixTimestamp] = "DateTime.fromUnixTimestamp"; [DateTime.now] = "DateTime.now"; [DateTime.fromIsoDate] = "DateTime.fromIsoDate"; [DateTime.fromUnixTimestampMillis] = "DateTime.fromUnixTimestampMillis"; [DateTime.fromLocalTime] = "DateTime.fromLocalTime"; [DateTime.fromUniversalTime] = "DateTime.fromUniversalTime"; [Random.new] = "Random.new"; [typeof] = "typeof"; [RaycastParams.new] = "RaycastParams.new"; [math.log] = "math.log"; [math.ldexp] = "math.ldexp"; [math.rad] = "math.rad"; [math.cosh] = "math.cosh"; [math.random] = "math.random"; [math.frexp] = "math.frexp"; [math.tanh] = "math.tanh"; [math.floor] = "math.floor"; [math.max] = "math.max"; [math.sqrt] = "math.sqrt"; [math.modf] = "math.modf"; [math.pow] = "math.pow"; [math.atan] = "math.atan"; [math.tan] = "math.tan"; [math.cos] = "math.cos"; [math.sign] = "math.sign"; [math.clamp] = "math.clamp"; [math.log10] = "math.log10"; [math.noise] = "math.noise"; [math.acos] = "math.acos"; [math.abs] = "math.abs"; [math.sinh] = "math.sinh"; [math.asin] = "math.asin"; [math.min] = "math.min"; [math.deg] = "math.deg"; [math.fmod] = "math.fmod"; [math.randomseed] = "math.randomseed"; [math.atan2] = "math.atan2"; [math.ceil] = "math.ceil"; [math.sin] = "math.sin"; [math.exp] = "math.exp"; [getfenv] = "getfenv"; [pcall] = "pcall"; [ColorSequenceKeypoint.new] = "ColorSequenceKeypoint.new"; [ColorSequence.new] = "ColorSequence.new"; [type] = "type"; [Region3int16.new] = "Region3int16.new"; [ElapsedTime] = "ElapsedTime"; [select] = "select"; [getmetatable] = "getmetatable"; [rawget] = "rawget"; [Faces.new] = "Faces.new"; [Rect.new] = "Rect.new"; [BrickColor.Blue] = "BrickColor.Blue"; [BrickColor.White] = "BrickColor.White"; [BrickColor.Yellow] = "BrickColor.Yellow"; [BrickColor.Red] = "BrickColor.Red"; [BrickColor.Gray] = "BrickColor.Gray"; [BrickColor.palette] = "BrickColor.palette"; [BrickColor.New] = "BrickColor.New"; [BrickColor.Black] = "BrickColor.Black"; [BrickColor.Green] = "BrickColor.Green"; [BrickColor.Random] = "BrickColor.Random"; [BrickColor.DarkGray] = "BrickColor.DarkGray"; [BrickColor.random] = "BrickColor.random"; [BrickColor.new] = "BrickColor.new"; [setfenv] = "setfenv"; [UDim.new] = "UDim.new"; [Axes.new] = "Axes.new"; [error] = "error"; [debug.traceback] = "debug.traceback"; [debug.profileend] = "debug.profileend"; [debug.profilebegin] = "debug.profilebegin"}

function GetHierarchy(Object)
	local Hierarchy = {}

	local ChainLength = 1
	local Parent = Object
	
	while Parent do
		Parent = Parent.Parent
		ChainLength = ChainLength + 1
	end

	Parent = Object
	local Num = 0
	while Parent do
		Num = Num + 1

		local ObjName = string.gsub(Parent.Name, '[%c%z]', SpecialCharacters)
		ObjName = Parent == game and 'game' or ObjName

		if Keywords[ObjName] or not string.match(ObjName, '^[_%a][_%w]*$') then
			ObjName = '["' .. ObjName .. '"]'
		elseif Num ~= ChainLength - 1 then
			ObjName = '.' .. ObjName
		end

		Hierarchy[ChainLength - Num] = ObjName
		Parent = Parent.Parent
	end

	return table.concat(Hierarchy)
end
local function SerializeType(Value, Class)
	if Class == 'string' then
		-- Not using %q as it messes up the special characters fix
		return string.format('"%s"', string.gsub(Value, '[%c%z]', SpecialCharacters))
	elseif Class == 'Instance' then
		return GetHierarchy(Value)
	elseif type(Value) ~= Class then -- CFrame, Vector3, UDim2, ...
		return transformDataTypeToString(Value)
	elseif Class == 'function' then
		return Functions[Value] or '\'[Unknown ' .. (pcall(setfenv, Value, getfenv(Value)) and 'Lua' or 'C')  .. ' ' .. tostring(Value) .. ']\''
	elseif Class == 'userdata' then
		return 'newproxy(' .. tostring(not not getmetatable(Value)) .. ')'
	elseif Class == 'thread' then
		return '\'' .. tostring(Value) ..  ', status: ' .. coroutine.status(Value) .. '\''
	else -- thread, number, boolean, nil, ...
		return tostring(Value)
	end
end
local function TableToString(Table, IgnoredTables, DepthData, Path)
	IgnoredTables = IgnoredTables or {}
	local CyclicData = IgnoredTables[Table]
	if CyclicData then
		return ((CyclicData[1] == DepthData[1] - 1 and '\'[Cyclic Parent ' or '\'[Cyclic ') .. tostring(Table) .. ', path: ' .. CyclicData[2] .. ']\'')
	end

	Path = Path or 'ROOT'
	DepthData = DepthData or {0, Path}
	local Depth = DepthData[1] + 1
	DepthData[1] = Depth
	DepthData[2] = Path

	IgnoredTables[Table] = DepthData
	local Tab = string.rep('    ', Depth)
	local TrailingTab = string.rep('    ', Depth - 1)
	local Result = '{'

	local LineTab = '\n' .. Tab
	local HasOrder = true
	local Index = 1

	local IsEmpty = true
	for Key, Value in next, Table do
		IsEmpty = false
		if Index ~= Key then
			HasOrder = false
		else
			Index = Index + 1
		end

		local KeyClass, ValueClass = typeof(Key), typeof(Value)
		local HasBrackets = false
		if KeyClass == 'string' then
			Key = string.gsub(Key, '[%c%z]', SpecialCharacters)
			if Keywords[Key] or not string.match(Key, '^[_%a][_%w]*$') then
				HasBrackets = true
				Key = string.format('["%s"]', Key)
			end
		else
			HasBrackets = true
			Key = '[' .. (KeyClass == 'table' and string.gsub(TableToString(Key, IgnoredTables, {Depth + 1, Path}), '^%s*(.-)%s*$', '%1') or SerializeType(Key, KeyClass)) .. ']'
		end

		Value = ValueClass == 'table' and TableToString(Value, IgnoredTables, {Depth + 1, Path}, Path .. (HasBrackets and '' or '.') .. Key) or SerializeType(Value, ValueClass)
		Result = Result .. LineTab .. (HasOrder and Value or Key .. ' = ' .. Value) .. ','
	end

	return IsEmpty and Result .. '};' or string.sub(Result,  1, -2) .. '\n' .. TrailingTab .. '};'
end

local Remotes = {}
local Logs = {}

local CoreGui = game:GetService("CoreGui")
local uiFrame = gui.Frame
local storage = gui.Storage
local remotesList = uiFrame.Body.Remotes
local remotesDisplay = uiFrame.Body.Display

remotesList.ChildRemoved:Connect(function()
    Remotes = {}
end)

local remoteSpyEnabled = true
uiFrame.Header.Exit.MouseButton1Click:Connect(function()
    remoteSpyEnabled = false
    gui:Destroy()
end)

local clone = game.Clone
local getDebugId = game.GetDebugId
local isA = game.IsA


local buttonColors = {
    ["RemoteEvent"] = Color3.fromRGB(255, 255, 127);
    ["RemoteFunction"] = Color3.fromRGB(255, 170, 255) ;
}

local function InitializeRemote(...)
    local args = table.pack(...)
    local remote = table.remove(args, 1)
    local identity = syn.get_thread_identity()
    syn.set_thread_identity(8)
    local remoteId = getDebugId(remote)
    if Remotes[remoteId] == nil then
        local _script = getcallingscript()
        Remotes[remoteId] = {
            IgnoreRemote = false;
            BlockRemote = false;
            
        }
    end
    syn.set_thread_identity(identity)


    if Remotes[remoteId].BlockRemote then
        return true
    end

    if not Remotes[remoteId].IgnoreRemote then
        table.insert(Logs, {Remote = remote, Script = getcallingscript(), Arguments = args})
    end
end

local function clearList(list)
    for _, child in next, list:GetChildren() do
        if not child:IsA("UIListLayout") and child.Name ~= "GettingStarted" then
            child:Destroy()
        end
    end
end

local function logRemote(remote, _script, ...)
    
    local remoteId = getDebugId(remote)
    local remoteInfo = Remotes[remoteId]

    local remoteType = isA(remote, "RemoteEvent") and "RemoteEvent"
    or isA(remote, "RemoteFunction") and "RemoteFunction"

    if remoteType == nil then
        return
    end

    if remoteInfo and remoteInfo.RemoteInteraction == nil then

        local color = remoteType == "RemoteEvent" and buttonColors.RemoteEvent
        or buttonColors.RemoteFunction
        
        local remoteViewer = clone(storage.Viewer)
        remoteViewer.Parent = remotesDisplay

        remoteViewer.Clear.MouseButton1Click:Connect(function()
            clearList(remoteViewer.Frame.ScrollingFrame)
        end)


        remoteViewer.IgnoreRemote.MouseButton1Click:Connect(function()
            remoteInfo.IgnoreRemote = not remoteInfo.IgnoreRemote
            if remoteInfo.IgnoreRemote then
                remoteViewer.IgnoreRemote.Frame.BackgroundColor3 = Color3.fromRGB(170,255,127)
            else
                remoteViewer.IgnoreRemote.Frame.BackgroundColor3 = Color3.fromRGB(255, 85, 73)
            end
        end)

        remoteViewer.BlockRemote.MouseButton1Click:Connect(function()
            remoteInfo.BlockRemote = not remoteInfo.BlockRemote
            if remoteInfo.BlockRemote then
                remoteViewer.BlockRemote.Frame.BackgroundColor3 = Color3.fromRGB(170,255,127)
            else
                remoteViewer.BlockRemote.Frame.BackgroundColor3 = Color3.fromRGB(255, 85, 73)
            end
        end)

        local remoteInteraction = clone(storage.RemoteInteract)
        remoteInteraction.RemoteType.BackgroundColor3 = color
        remoteInteraction.TextLabel.Text = tostring(remote)
        remoteInteraction.Parent = remotesList

        remoteInteraction.MouseButton1Click:Connect(function()
            
            remotesDisplay.GettingStarted.Visible = false

            for _, child in next, remotesDisplay:GetChildren() do
                if child ~= remoteViewer then
                    child.Visible = false
                end
            end

            for _, child in next, remotesList:GetChildren() do
                if child:IsA("TextButton") and child ~= remoteInteraction then
                    child.BackgroundColor3 = Color3.fromRGB(31, 31, 31)
                end
            end
            remoteViewer.Visible = true
            remoteInteraction.Notification.Visible = false
            remoteInteraction.BackgroundColor3 = Color3.fromRGB(51, 51, 51)

        end)
        

        remoteInteraction.MouseButton2Click:Connect(function()

            local dropdown = clone(storage.Dropdown)
            local dropdownInteraction = clone(storage.DropdownInteract)
            dropdownInteraction.Text = "Clear All"
            local mouseLocation = UserInputService:GetMouseLocation()
            local x = mouseLocation.X - uiFrame.AbsolutePosition.X
            local y = mouseLocation.Y - uiFrame.AbsolutePosition.Y - GuiService:GetGuiInset().Y
            dropdown.Position = UDim2.new(0, x, 0, y)
            dropdownInteraction.Parent = dropdown
            dropdownInteraction.MouseButton1Click:Connect(function()
                clearList(remotesList)
                clearList(remotesDisplay)
                remotesDisplay.GettingStarted.Visible = true
                dropdown:Destroy()
            end)


            dropdownInteraction.MouseLeave:Connect(function()
                dropdown:Destroy()
            end)

            dropdown.Parent = uiFrame
        end)

        remoteInfo.RemoteInteraction = remoteInteraction
        remoteInfo.RemoteViewer = remoteViewer;

    end

    if remoteInfo then
        local argInteraction = clone(storage.ArgumentInteract)
        argInteraction.Header.TextLabel.Text = _script and tostring(_script) or "nil"
        local parent = argInteraction.Frame
        local numOfArgs = select("#", ...)
        for i = 1, numOfArgs do
            local value = select(i, ...)
            local _type = typeof(value)
            if _type == "table" then

                local tblMain = clone(storage.TableMain)
                local text, color = transformDataTypeToString(value), getColorForType(_type)
                
                tblMain.Header.TextLabel.Text = text
                tblMain.Header.TextLabel.TextColor3 = color
                tblMain.Header.Frame.TextLabel.Text = #parent:GetChildren()

                local tableStr, colors = TableToString(value)
                local strings = string.split(tableStr, "\n")
                
                for i = 1, #strings do
                    local arg = clone(storage.TableBody)
                    if strings[i]:match("};,") then
                        strings[i] = strings[i]:gsub(",","")
                    end
                    arg.TextLabel.Text = strings[i]
                    arg.TextLabel.TextColor3 = Color3.fromRGB(255,255,255)
                    arg.Parent = tblMain
                end

                tblMain.Parent = parent

            else
                local arg = clone(storage.Argument)
                local text, color = transformDataTypeToString(value), getColorForType(_type)
                -- update this to the datatype to string handler
                arg.TextLabel.Text = text
                arg.TextLabel.TextColor3 = color
                arg.Frame.TextLabel.Text = #parent:GetChildren()
                arg.Parent = parent
            end
        end
        argInteraction.Parent = remoteInfo.RemoteViewer.Frame.ScrollingFrame
        remoteInfo.RemoteInteraction.Notification.Visible = true

        argInteraction.MouseButton2Click:Connect(function()
            
            local dropdown = clone(storage.Dropdown)
            local mouseLocation = UserInputService:GetMouseLocation()
            local x = mouseLocation.X - uiFrame.AbsolutePosition.X
            local y = mouseLocation.Y - uiFrame.AbsolutePosition.Y - GuiService:GetGuiInset().Y
            dropdown.Position = UDim2.new(0, x, 0, y)



            local dropdownInteraction = clone(storage.DropdownInteract)
            dropdownInteraction.Text = "Generate Pseudo Script"
            dropdownInteraction.Parent = dropdown
            dropdownInteraction.MouseButton1Click:Connect(function()
                local str = "local arguments = {\n"
                for _, child in next, argInteraction.Frame:GetChildren() do
                    if child.Name == "TableMain" then
                        for _, subchild in next, child:GetChildren() do
                            if subchild.Name == "TableBody" then
                                str = str..subchild.TextLabel.Text.."\n"
                            end
                        end
                    elseif child.Name == "Argument" then
                        str = str.."\t"..child.TextLabel.Text..";\n"
                    end
                end
                str = str.."};\n"
                local func = remoteType == "RemoteEvent" and "FireServer" or "InvokeServer"
                str = str..GetFullName(remote)..":"..func.."(unpack(arguments))"
                setclipboard(str)
                dropdown:Destroy()
            end)

            local dropdownInteraction = clone(storage.DropdownInteract)
            dropdownInteraction.Text = "Decompile Script"
            dropdownInteraction.Parent = dropdown
            dropdownInteraction.MouseButton1Click:Connect(function()
                if _script then
                    dropdownInteraction.Text = "Decompiling..."
                    setclipboard(decompile(_script))
                end
                dropdown:Destroy()
            end)

            local dropdownInteraction = clone(storage.DropdownInteract)
            dropdownInteraction.Text = "Copy Script Path"
            dropdownInteraction.Parent = dropdown
            dropdownInteraction.MouseButton1Click:Connect(function()
                if _script then
                    setclipboard(GetFullName(_script))
                end
                dropdown:Destroy()
            end)

            dropdown.MouseLeave:Connect(function()
                dropdown:Destroy()
            end)

            dropdown.Parent = uiFrame

        end)
    end

end

local namecallMethods = {
    ["FireServer"] = true;
    ["fireServer"] = true;
    ["InvokeServer"] = true;
    ["invokeServer"] = true;
}

local originalNamecall
originalNamecall = hookmetamethod(game, "__namecall", function(...)

    if not remoteSpyEnabled then
        return originalNamecall(...)
    end

    local method = getnamecallmethod()

    if namecallMethods[method] then
        local blockRemote = InitializeRemote(...)
        if blockRemote then
            return
        end
    end

    return originalNamecall(...)
end)

local refRemoteEvent = Instance.new("RemoteEvent")
local refRemoteFunction = Instance.new("RemoteFunction")

local originalFireServer
fireserverHook = hookfunction(refRemoteEvent.FireServer, function(...)
    if isactor() and not checkparallel() or not remoteSpyEnabled then
        return originalFireServer(...)
    end

    local object = ...
    if not typeof(object) == "Instance" then
        return originalFireServer(...)
    end

    local blockRemote = InitializeRemote(...)
    if blockRemote then
        return
    end

    return originalFireServer(...)
end)

local originalInvokeServer = hookfunction(refRemoteFunction.InvokeServer, function(...)
    if isactor() and not checkparallel() or not remoteSpyEnabled then
        return originalInvokeServer(...)
    end

    local object = ...
    if not typeof(object) == "Instance" then
        return originalInvokeServer(...)
    end

    local blockRemote = InitializeRemote(...)
    if blockRemote then
        return
    end

    return originalInvokeServer(...)
end)

while true do
    if #Logs > 0 then
        local log = Logs[1]
        local args = log.Arguments
        logRemote(log.Remote, log.Script, table.unpack(args, 1, args.n-1))
        table.remove(Logs, 1)
    end
    task.wait()
end