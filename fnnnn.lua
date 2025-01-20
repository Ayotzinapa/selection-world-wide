local A = Instance.new
local B = {
	["Frame_1"] = A("Frame"),
	["ScrollingFrame_1"] = A("ScrollingFrame"),
	["Frame_2"] = A("Frame"),
	["UIPadding_1"] = A("UIPadding"),
	["ScrollingFrame_2"] = A("ScrollingFrame"),
	["UIGradient_1"] = A("UIGradient"),
	["TextBox_1"] = A("TextBox"),
	["UICorner_1"] = A("UICorner"),
	["UIPadding_2"] = A("UIPadding"),
	["UICorner_2"] = A("UICorner"),
	["UIListLayout_1"] = A("UIListLayout"),
	["Frame_3"] = A("Frame"),
	["UIPadding_3"] = A("UIPadding"),
	["Frame_4"] = A("Frame"),
	["UIPadding_4"] = A("UIPadding"),
	["TextButton_1"] = A("TextButton"),
	["LocalScript_1"] = A("LocalScript"),
	["UICorner_3"] = A("UICorner"),
	["ImageLabel_1"] = A("ImageLabel"),
	["TextButton_2"] = A("TextButton"),
	["LocalScript_2"] = A("LocalScript"),
	["UICorner_4"] = A("UICorner"),
	["ImageLabel_2"] = A("ImageLabel"),
	["UIListLayout_2"] = A("UIListLayout"),
	["TextButton_3"] = A("TextButton"),
	["LocalScript_3"] = A("LocalScript"),
	["UICorner_5"] = A("UICorner"),
	["ImageLabel_3"] = A("ImageLabel"),
	["UIListLayout_3"] = A("UIListLayout"),
	["Frame_5"] = A("Frame"),
	["TextLabel_1"] = A("TextLabel"),
	["UIPadding_5"] = A("UIPadding"),
	["ImageLabel_4"] = A("ImageLabel"),
	["UIListLayout_4"] = A("UIListLayout"),
	["UIPadding_6"] = A("UIPadding"),
	["UIListLayout_5"] = A("UIListLayout"),
	["LocalScript_4"] = A("LocalScript"),
	["ScreenGui_1"] = A("ScreenGui"),
}



local crypt = {}

-- / Random String Generator
-- * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
function crypt.random(len)
	local Lenght = 0
	local Generated = ""

	if not len then
		Lenght = math.random(8, 32)
	else
		Lenght = len
	end

	local upperCase = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
	local lowerCase = "abcdefghijklmnopqrstuvwxyz"
	local numbers = "0123456789"
	local symbols = "!@#$%&()*+-,./\\:;<=>?^[]{}"
	local CharacterSet = upperCase .. lowerCase .. numbers .. symbols

	for i = 1, Lenght do
		local rand = math.random(#CharacterSet)
		Generated = Generated .. string.sub(CharacterSet, rand, rand)
	end

	return Generated
end
-- * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

-- * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

-- / Encrypts the specified object and its descendants name.
-- * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
function cryptobj(Obj)
	Obj.Name = crypt.random()
	for _, Descendant in next, Obj:GetDescendants() do
		Descendant.Name = crypt.random()
	end
end
-- * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local TextService = game:GetService("TextService")

local Player = game:GetService("Players").LocalPlayer

local NotifGui = Instance.new("ScreenGui")
NotifGui.Name = "AkaliNotif"
NotifGui.Parent = RunService:IsStudio() and Player.PlayerGui or game:GetService("CoreGui")

local Container = Instance.new("Frame")
Container.Name = "Container"
Container.Position = UDim2.new(0, 20, 0.5, -20)
Container.Size = UDim2.new(0, 300, 0.5, 0)
Container.BackgroundTransparency = 1
Container.Parent = NotifGui

local function Image(ID, Button)
	local NewImage = Instance.new(string.format("Image%s", Button and "Button" or "Label"))
	NewImage.Image = ID
	NewImage.BackgroundTransparency = 1
	return NewImage
end

local function Round2px()
	local NewImage = Image("http://www.roblox.com/asset/?id=5761488251")
	NewImage.ScaleType = Enum.ScaleType.Slice
	NewImage.SliceCenter = Rect.new(2, 2, 298, 298)
	NewImage.ImageColor3 = Color3.fromRGB(30, 30, 30)
	return NewImage
end

local function Shadow2px()
	local NewImage = Image("http://www.roblox.com/asset/?id=5761498316")
	NewImage.ScaleType = Enum.ScaleType.Slice
	NewImage.SliceCenter = Rect.new(17, 17, 283, 283)
	NewImage.Size = UDim2.fromScale(1, 1) + UDim2.fromOffset(30, 30)
	NewImage.Position = -UDim2.fromOffset(15, 15)
	NewImage.ImageColor3 = Color3.fromRGB(30, 30, 30)
	return NewImage
end

local Padding = 10
local DescriptionPadding = 10
local InstructionObjects = {}
local TweenTime = 1
local TweenStyle = Enum.EasingStyle.Sine
local TweenDirection = Enum.EasingDirection.Out

local LastTick = tick()

local function CalculateBounds(TableOfObjects)
	local TableOfObjects = typeof(TableOfObjects) == "table" and TableOfObjects or {}
	local X, Y = 0, 0
	for _, Object in next, TableOfObjects do
		X += Object.AbsoluteSize.X
		Y += Object.AbsoluteSize.Y
	end
	return { X = X, Y = Y, x = X, y = Y }
end

local CachedObjects = {}

local function Update()
	local DeltaTime = tick() - LastTick
	local PreviousObjects = {}
	for CurObj, Object in next, InstructionObjects do
		local Label, Delta, Done = Object[1], Object[2], Object[3]
		if not Done then
			if Delta < TweenTime then
				Object[2] = math.clamp(Delta + DeltaTime, 0, 1)
				Delta = Object[2]
			else
				Object[3] = true
			end
		end
		local NewValue = TweenService:GetValue(Delta, TweenStyle, TweenDirection)
		local CurrentPos = Label.Position
		local PreviousBounds = CalculateBounds(PreviousObjects)
		local TargetPos = UDim2.new(0, 0, 0, PreviousBounds.Y + (Padding * #PreviousObjects))
		Label.Position = CurrentPos:Lerp(TargetPos, NewValue)
		table.insert(PreviousObjects, Label)
	end
	CachedObjects = PreviousObjects
	LastTick = tick()
end

RunService:BindToRenderStep("UpdateList", 0, Update)

local TitleSettings = {
	Font = Enum.Font.GothamMedium,
	Size = 14,
}

local DescriptionSettings = {
	Font = Enum.Font.Gotham,
	Size = 14,
}

local MaxWidth = (Container.AbsoluteSize.X - Padding - DescriptionPadding)

local function Label(Text, Font, Size, Button)
	local Label = Instance.new(string.format("Text%s", Button and "Button" or "Label"))
	Label.Text = Text
	Label.Font = Font
	Label.TextSize = Size
	Label.BackgroundTransparency = 1
	Label.TextXAlignment = Enum.TextXAlignment.Left
	Label.RichText = true
	Label.TextColor3 = Color3.fromRGB(255, 255, 255)
	return Label
end

local function TitleLabel(Text)
	return Label(Text, TitleSettings.Font, TitleSettings.Size)
end

local function DescriptionLabel(Text)
	return Label(Text, DescriptionSettings.Font, DescriptionSettings.Size)
end

local PropertyTweenOut = {
	Text = "TextTransparency",
	Fram = "BackgroundTransparency",
	Imag = "ImageTransparency",
}

local function FadeProperty(Object)
	local Prop = PropertyTweenOut[string.sub(Object.ClassName, 1, 4)]
	TweenService:Create(Object, TweenInfo.new(0.25, TweenStyle, TweenDirection), {
		[Prop] = 1,
	}):Play()
end

local function SearchTableFor(Table, For)
	for _, v in next, Table do
		if v == For then
			return true
		end
	end
	return false
end

local function FindIndexByDependency(Table, Dependency)
	for Index, Object in next, Table do
		if typeof(Object) == "table" then
			local Found = SearchTableFor(Object, Dependency)
			if Found then
				return Index
			end
		else
			if Object == Dependency then
				return Index
			end
		end
	end
end

local function ResetObjects()
	for _, Object in next, InstructionObjects do
		Object[2] = 0
		Object[3] = false
	end
end

local function FadeOutAfter(Object, Seconds)
	wait(Seconds)
	FadeProperty(Object)
	for _, SubObj in next, Object:GetDescendants() do
		FadeProperty(SubObj)
	end
	wait(0.25)
	table.remove(InstructionObjects, FindIndexByDependency(InstructionObjects, Object))
	ResetObjects()
end

cryptobj(NotifGui)

Notify = function(Properties)
	local Properties = typeof(Properties) == "table" and Properties or {}
	local Title = Properties.Title
	local Description = Properties.Description
	local Duration = Properties.Duration or 5
	if Title or Description then -- Check that user has provided title and/or description
		local Y = Title and 26 or 0
		if Description then
			local TextSize = TextService:GetTextSize(
				Description,
				DescriptionSettings.Size,
				DescriptionSettings.Font,
				Vector2.new(0, 0)
			)
			for i = 1, math.ceil(TextSize.X / MaxWidth) do
				Y += TextSize.Y
			end
			Y += 8
		end

		local NewLabel = Round2px()
		NewLabel.Size = UDim2.new(1, 0, 0, Y)
		NewLabel.Position = UDim2.new(-1, 20, 0, CalculateBounds(CachedObjects).Y + (Padding * #CachedObjects))
		if Title then
			local NewTitle = TitleLabel(Title)
			NewTitle.Size = UDim2.new(1, -10, 0, 26)
			NewTitle.Position = UDim2.fromOffset(10, 0)
			NewTitle.Parent = NewLabel
		end
		if Description then
			local NewDescription = DescriptionLabel(Description)
			NewDescription.TextWrapped = true
			NewDescription.Size = UDim2.fromScale(1, 1) + UDim2.fromOffset(-DescriptionPadding, Title and -26 or 0)
			NewDescription.Position = UDim2.fromOffset(10, Title and 26 or 0)
			NewDescription.TextYAlignment = Enum.TextYAlignment[Title and "Top" or "Center"]
			NewDescription.Parent = NewLabel
		end
		Shadow2px().Parent = NewLabel
		NewLabel.Parent = Container

		table.insert(InstructionObjects, { NewLabel, 0, false })
		coroutine.wrap(FadeOutAfter)(NewLabel, Duration)
	end

	cryptobj(NotifGui)
end

--top parent

local RunService = game:GetService("RunService")

B.ScreenGui_1.Parent = RunService:IsStudio() and game.Players.LocalPlayer.PlayerGui or game:GetService("CoreGui")
B.ScreenGui_1.ResetOnSpawn = false

B.Frame_1.AnchorPoint = Vector2.new(0.5, 0.5)
B.Frame_1.BackgroundColor3 = Color3.new(0.0588235, 0.0588235, 0.0588235)
B.Frame_1.BackgroundTransparency = 1
B.Frame_1.BorderColor3 = Color3.new(0, 0, 0)
B.Frame_1.BorderSizePixel = 0
B.Frame_1.Position = UDim2.new(0.5, 0, 0.5, 0)
B.Frame_1.Size = UDim2.new(0, 550, 0, 300)
B.Frame_1.Name = [[Main]]
B.Frame_1.Parent = B.ScreenGui_1
B.ScrollingFrame_1.AutomaticCanvasSize = Enum.AutomaticSize.XY
B.ScrollingFrame_1.CanvasSize = UDim2.new(0, 0, 0, 0)
B.ScrollingFrame_1.ScrollBarImageColor3 = Color3.new(0, 0, 0)
B.ScrollingFrame_1.ScrollingEnabled = false
B.ScrollingFrame_1.Active = true
B.ScrollingFrame_1.ScrollBarThickness = 0
B.ScrollingFrame_1.AnchorPoint = Vector2.new(0.5, 0.5)
B.ScrollingFrame_1.BackgroundColor3 = Color3.new(0.0588235, 0.0588235, 0.0588235)
B.ScrollingFrame_1.BorderColor3 = Color3.new(0.0588235, 0.0588235, 0.0588235)
B.ScrollingFrame_1.BorderSizePixel = 0
B.ScrollingFrame_1.LayoutOrder = 1
B.ScrollingFrame_1.Position = UDim2.new(0.974545479, 0, 1.21000004, 0)
B.ScrollingFrame_1.Size = UDim2.new(1, 0, 1, 0)
B.ScrollingFrame_1.Parent = B.Frame_1
B.Frame_2.AnchorPoint = Vector2.new(0.5, 0.5)
B.Frame_2.BackgroundColor3 = Color3.new(1, 1, 1)
B.Frame_2.BackgroundTransparency = 1
B.Frame_2.BorderColor3 = Color3.new(0, 0, 0)
B.Frame_2.BorderSizePixel = 0
B.Frame_2.Position = UDim2.new(0.0909090936, 0, 0, 0)
B.Frame_2.Size = UDim2.new(1, 0, 1, 0)
B.Frame_2.Name = [[Holder]]
B.Frame_2.Parent = B.ScrollingFrame_1
B.UIPadding_1.PaddingBottom = UDim.new(0, 10)
B.UIPadding_1.PaddingLeft = UDim.new(0, 10)
B.UIPadding_1.PaddingRight = UDim.new(0, 10)
B.UIPadding_1.PaddingTop = UDim.new(0, 10)
B.UIPadding_1.Parent = B.Frame_2
B.ScrollingFrame_2.AutomaticCanvasSize = Enum.AutomaticSize.XY
B.ScrollingFrame_2.CanvasSize = UDim2.new(25, 0, 50, 0)
B.ScrollingFrame_2.ScrollBarImageColor3 = Color3.new(0.172549, 0.172549, 0.172549)
B.ScrollingFrame_2.ScrollBarThickness = 8
B.ScrollingFrame_2.VerticalScrollBarInset = Enum.ScrollBarInset.Always
B.ScrollingFrame_2.Active = true
B.ScrollingFrame_2.AnchorPoint = Vector2.new(0.5, 0.5)
B.ScrollingFrame_2.BackgroundColor3 = Color3.new(0.0784314, 0.0784314, 0.0784314)
B.ScrollingFrame_2.BorderColor3 = Color3.new(0, 0, 0)
B.ScrollingFrame_2.BorderSizePixel = 0
B.ScrollingFrame_2.Position = UDim2.new(0.5, 0, 0.5, 0)
B.ScrollingFrame_2.Size = UDim2.new(1, 0, 1, 0)
B.ScrollingFrame_2.Name = [[Content]]
B.ScrollingFrame_2.Parent = B.Frame_2
B.UIGradient_1.Parent = B.ScrollingFrame_2
B.TextBox_1.ClearTextOnFocus = false
B.TextBox_1.CursorPosition = -1
B.TextBox_1.FontFace = Font.new("rbxassetid://12187362578", Enum.FontWeight.Regular, Enum.FontStyle.Normal)
B.TextBox_1.MultiLine = true
B.TextBox_1.RichText = true
B.TextBox_1.Text = [[]]
B.TextBox_1.TextColor3 = Color3.new(1, 1, 1)
B.TextBox_1.TextSize = 14
B.TextBox_1.TextXAlignment = Enum.TextXAlignment.Left
B.TextBox_1.TextYAlignment = Enum.TextYAlignment.Top
B.TextBox_1.AnchorPoint = Vector2.new(0.5, 0.00999999978)
B.TextBox_1.BackgroundColor3 = Color3.new(1, 1, 1)
B.TextBox_1.BackgroundTransparency = 1
B.TextBox_1.BorderColor3 = Color3.new(0, 0, 0)
B.TextBox_1.BorderSizePixel = 0
B.TextBox_1.Position = UDim2.new(0.5, 0, 0.5, 0)
B.TextBox_1.Size = UDim2.new(1, 0, 50, 0)
B.TextBox_1.Name = [[Input]]
B.TextBox_1.Parent = B.ScrollingFrame_2
B.UICorner_1.CornerRadius = UDim.new(0, 5)
B.UICorner_1.Parent = B.TextBox_1
B.UIPadding_2.PaddingBottom = UDim.new(0, 10)
B.UIPadding_2.PaddingLeft = UDim.new(0, 10)
B.UIPadding_2.PaddingRight = UDim.new(0, 10)
B.UIPadding_2.PaddingTop = UDim.new(0, 10)
B.UIPadding_2.Parent = B.TextBox_1
B.UICorner_2.CornerRadius = UDim.new(0, 5)
B.UICorner_2.Parent = B.ScrollingFrame_2
B.UIListLayout_1.FillDirection = Enum.FillDirection.Horizontal
B.UIListLayout_1.SortOrder = Enum.SortOrder.LayoutOrder
B.UIListLayout_1.VerticalAlignment = Enum.VerticalAlignment.Center
B.UIListLayout_1.Parent = B.ScrollingFrame_1
B.Frame_3.AnchorPoint = Vector2.new(0.5, 0.5)
B.Frame_3.BackgroundColor3 = Color3.new(0.0862745, 0.0862745, 0.0862745)
B.Frame_3.BorderColor3 = Color3.new(0, 0, 0)
B.Frame_3.BorderSizePixel = 0
B.Frame_3.Position = UDim2.new(0.392727286, 0, 0.0666666701, 0)
B.Frame_3.Size = UDim2.new(1, 0, 0, 40)
B.Frame_3.Name = [[Topbar]]
B.Frame_3.Parent = B.Frame_1
B.UIPadding_3.PaddingLeft = UDim.new(0, 15)
B.UIPadding_3.Parent = B.Frame_3
B.Frame_4.AnchorPoint = Vector2.new(0.5, 0.5)
B.Frame_4.BackgroundColor3 = Color3.new(1, 1, 1)
B.Frame_4.BackgroundTransparency = 1
B.Frame_4.BorderColor3 = Color3.new(0, 0, 0)
B.Frame_4.BorderSizePixel = 0
B.Frame_4.LayoutOrder = 2
B.Frame_4.Position = UDim2.new(0.715887845, 0, 0.5, 0)
B.Frame_4.Size = UDim2.new(1, 0, 0, 40)
B.Frame_4.Name = [[Flex]]
B.Frame_4.Parent = B.Frame_3
B.UIPadding_4.PaddingRight = UDim.new(0, 5)
B.UIPadding_4.Parent = B.Frame_4
B.TextButton_1.FontFace =
	Font.new("rbxasset://fonts/families/SourceSansPro.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal)
B.TextButton_1.Text = [[]]
B.TextButton_1.TextColor3 = Color3.new(0, 0, 0)
B.TextButton_1.TextSize = 14
B.TextButton_1.AutoButtonColor = false
B.TextButton_1.BackgroundColor3 = Color3.new(0.121569, 0.121569, 0.121569)
B.TextButton_1.BackgroundTransparency = 1
B.TextButton_1.BorderColor3 = Color3.new(0, 0, 0)
B.TextButton_1.BorderSizePixel = 0
B.TextButton_1.ClipsDescendants = true
B.TextButton_1.LayoutOrder = 2
B.TextButton_1.Size = UDim2.new(0, 40, 0, 40)
B.TextButton_1.Name = [[Execute]]
B.TextButton_1.Parent = B.Frame_4
B.LocalScript_1.Name = [[Ripple]]
B.LocalScript_1.Parent = B.TextButton_1
B.UICorner_3.CornerRadius = UDim.new(0, 4)
B.UICorner_3.Parent = B.TextButton_1
B.ImageLabel_1.Image = [[http://www.roblox.com/asset/?id=6026663699]]
B.ImageLabel_1.AnchorPoint = Vector2.new(0.5, 0.5)
B.ImageLabel_1.BackgroundColor3 = Color3.new(1, 1, 1)
B.ImageLabel_1.BackgroundTransparency = 1
B.ImageLabel_1.BorderColor3 = Color3.new(0, 0, 0)
B.ImageLabel_1.BorderSizePixel = 0
B.ImageLabel_1.Position = UDim2.new(0.5, 0, 0.5, 0)
B.ImageLabel_1.Size = UDim2.new(0, 25, 0, 25)
B.ImageLabel_1.Name = [[Icon]]
B.ImageLabel_1.Parent = B.TextButton_1
B.TextButton_2.FontFace =
	Font.new("rbxasset://fonts/families/SourceSansPro.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal)
B.TextButton_2.Text = [[]]
B.TextButton_2.TextColor3 = Color3.new(0, 0, 0)
B.TextButton_2.TextSize = 14
B.TextButton_2.AutoButtonColor = false
B.TextButton_2.BackgroundColor3 = Color3.new(0.121569, 0.121569, 0.121569)
B.TextButton_2.BackgroundTransparency = 1
B.TextButton_2.BorderColor3 = Color3.new(0, 0, 0)
B.TextButton_2.BorderSizePixel = 0
B.TextButton_2.ClipsDescendants = true
B.TextButton_2.LayoutOrder = 0
B.TextButton_2.Size = UDim2.new(0, 40, 0, 40)
B.TextButton_2.Name = [[Minimize]]
B.TextButton_2.Parent = B.Frame_4
B.LocalScript_2.Name = [[Ripple]]
B.LocalScript_2.Parent = B.TextButton_2
B.UICorner_4.CornerRadius = UDim.new(0, 4)
B.UICorner_4.Parent = B.TextButton_2
B.ImageLabel_2.Image = [[http://www.roblox.com/asset/?id=6031094679]]
B.ImageLabel_2.AnchorPoint = Vector2.new(0.5, 0.5)
B.ImageLabel_2.BackgroundColor3 = Color3.new(1, 1, 1)
B.ImageLabel_2.BackgroundTransparency = 1
B.ImageLabel_2.BorderColor3 = Color3.new(0, 0, 0)
B.ImageLabel_2.BorderSizePixel = 0
B.ImageLabel_2.Position = UDim2.new(0.5, 0, 0.5, 0)
B.ImageLabel_2.Size = UDim2.new(0, 25, 0, 25)
B.ImageLabel_2.Name = [[Icon]]
B.ImageLabel_2.Parent = B.TextButton_2
B.UIListLayout_2.FillDirection = Enum.FillDirection.Horizontal
B.UIListLayout_2.HorizontalAlignment = Enum.HorizontalAlignment.Right
B.UIListLayout_2.SortOrder = Enum.SortOrder.LayoutOrder
B.UIListLayout_2.VerticalAlignment = Enum.VerticalAlignment.Center
B.UIListLayout_2.Parent = B.Frame_4
B.TextButton_3.FontFace =
	Font.new("rbxasset://fonts/families/SourceSansPro.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal)
B.TextButton_3.Text = [[]]
B.TextButton_3.TextColor3 = Color3.new(0, 0, 0)
B.TextButton_3.TextSize = 14
B.TextButton_3.AutoButtonColor = false
B.TextButton_3.BackgroundColor3 = Color3.new(0.121569, 0.121569, 0.121569)
B.TextButton_3.BackgroundTransparency = 1
B.TextButton_3.BorderColor3 = Color3.new(0, 0, 0)
B.TextButton_3.BorderSizePixel = 0
B.TextButton_3.ClipsDescendants = true
B.TextButton_3.Size = UDim2.new(0, 40, 0, 40)
B.TextButton_3.Name = [[Clear]]
B.TextButton_3.LayoutOrder = 1
B.TextButton_3.Parent = B.Frame_4
B.LocalScript_3.Name = [[Ripple]]
B.LocalScript_3.Parent = B.TextButton_3
B.UICorner_5.CornerRadius = UDim.new(0, 4)
B.UICorner_5.Parent = B.TextButton_3
B.ImageLabel_3.Image = [[http://www.roblox.com/asset/?id=6035181870]]
B.ImageLabel_3.AnchorPoint = Vector2.new(0.5, 0.5)
B.ImageLabel_3.BackgroundColor3 = Color3.new(1, 1, 1)
B.ImageLabel_3.BackgroundTransparency = 1
B.ImageLabel_3.BorderColor3 = Color3.new(0, 0, 0)
B.ImageLabel_3.BorderSizePixel = 0
B.ImageLabel_3.Position = UDim2.new(0.5, 0, 0.5, 0)
B.ImageLabel_3.Size = UDim2.new(0, 25, 0, 25)
B.ImageLabel_3.Name = [[Icon]]
B.ImageLabel_3.Parent = B.TextButton_3
B.UIListLayout_3.FillDirection = Enum.FillDirection.Horizontal
B.UIListLayout_3.SortOrder = Enum.SortOrder.LayoutOrder
B.UIListLayout_3.VerticalAlignment = Enum.VerticalAlignment.Center
B.UIListLayout_3.Parent = B.Frame_3
B.Frame_5.AnchorPoint = Vector2.new(0.5, 0.5)
B.Frame_5.BackgroundColor3 = Color3.new(1, 1, 1)
B.Frame_5.BackgroundTransparency = 1
B.Frame_5.BorderColor3 = Color3.new(0, 0, 0)
B.Frame_5.BorderSizePixel = 0
B.Frame_5.Position = UDim2.new(-0.0280373823, 0, 0.5, 0)
B.Frame_5.Size = UDim2.new(0, 0, 0, 40)
B.Frame_5.Name = [[Titlebar]]
B.Frame_5.Parent = B.Frame_3
B.TextLabel_1.FontFace =
	Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal)
B.TextLabel_1.Text = [[Coldz Hub]]
B.TextLabel_1.TextColor3 = Color3.new(1, 1, 1)
B.TextLabel_1.TextSize = 15
B.TextLabel_1.TextXAlignment = Enum.TextXAlignment.Left
B.TextLabel_1.AnchorPoint = Vector2.new(0.5, 0.5)
B.TextLabel_1.BackgroundColor3 = Color3.new(1, 1, 1)
B.TextLabel_1.BackgroundTransparency = 1
B.TextLabel_1.BorderColor3 = Color3.new(0, 0, 0)
B.TextLabel_1.BorderSizePixel = 0
B.TextLabel_1.LayoutOrder = 1
B.TextLabel_1.Position = UDim2.new(0.765454531, 0, 0.5, 0)
B.TextLabel_1.Size = UDim2.new(0, 200, 0, 30)
B.TextLabel_1.Name = [[Title]]
B.TextLabel_1.Parent = B.Frame_5
B.UIPadding_5.PaddingLeft = UDim.new(0, 5)
B.UIPadding_5.Parent = B.TextLabel_1
B.ImageLabel_4.Image = [[rbxassetid://100347097453848]]
B.ImageLabel_4.AnchorPoint = Vector2.new(0.5, 0.5)
B.ImageLabel_4.BackgroundColor3 = Color3.new(1, 1, 1)
B.ImageLabel_4.BackgroundTransparency = 1
B.ImageLabel_4.BorderColor3 = Color3.new(0, 0, 0)
B.ImageLabel_4.BorderSizePixel = 0
B.ImageLabel_4.Position = UDim2.new(0.0290909093, 0, -1.16666663, 0)
B.ImageLabel_4.Size = UDim2.new(0, 25, 0, 25)
B.ImageLabel_4.Name = [[Icon]]
B.ImageLabel_4.Parent = B.Frame_5
B.UIListLayout_4.FillDirection = Enum.FillDirection.Horizontal
B.UIListLayout_4.SortOrder = Enum.SortOrder.LayoutOrder
B.UIListLayout_4.VerticalAlignment = Enum.VerticalAlignment.Center
B.UIListLayout_4.Parent = B.Frame_5
B.UIPadding_6.PaddingLeft = UDim.new(0, 15)
B.UIPadding_6.Parent = B.Frame_5
B.UIListLayout_5.HorizontalAlignment = Enum.HorizontalAlignment.Center
B.UIListLayout_5.SortOrder = Enum.SortOrder.LayoutOrder
B.UIListLayout_5.Parent = B.Frame_1
B.LocalScript_4.Name = [[worker.js]]
B.LocalScript_4.Parent = B.ScreenGui_1
B.ScreenGui_1.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
B.ScreenGui_1.Name = [[LInjector]]

local LInjector = {}
local crypt = {}

local IsHidden = false
local GUI = B.ScreenGui_1

local UserInputService = game:GetService("UserInputService")

local NotifLib = Notify

local function RippleEffect(script)
	local TweenService = game:GetService("TweenService")

	local button = script.Parent

	button.MouseButton1Click:Connect(function()
		local ripple = Instance.new("Frame")
		local UICorner = Instance.new("UICorner")
		ripple.Size = UDim2.new(0, 0, 0, 0)
		ripple.Position = UDim2.new(0.5, 0, 0.5, 0)
		ripple.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		ripple.BorderSizePixel = 0
		ripple.Parent = button

		UICorner.Parent = ripple
		UICorner.CornerRadius = UDim.new(1, 0)

		local mouse = game.Players.LocalPlayer:GetMouse()
		local maxSize = math.max(button.AbsoluteSize.X, button.AbsoluteSize.Y) * 1.5

		local tweenInfo = TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)

		local tweenSize = TweenService:Create(ripple, tweenInfo, {
			Size = UDim2.new(0, maxSize, 0, maxSize),
		})

		local tweenTransparency = TweenService:Create(ripple, tweenInfo, {
			BackgroundTransparency = 1,
		})

		ripple:TweenSizeAndPosition(
			UDim2.new(0, maxSize, 0, maxSize),
			UDim2.new(0.5, -maxSize / 2, 0.5, -maxSize / 2),
			Enum.EasingDirection.Out,
			Enum.EasingStyle.Quad,
			0.3,
			true
		)

		tweenSize:Play()
		tweenTransparency:Play()

		tweenSize.Completed:Connect(function()
			ripple:Destroy()
		end)
	end)
end

function LInjector.Button(icon, callback, layoutOrder)
	local cloned = B.TextButton_1:Clone()
	local clonedRipple = B.LocalScript_1:Clone()

	local childrens = B.Frame_4:GetChildren()

	cloned.Parent = B.Frame_4
	clonedRipple.Parent = cloned

	cloned.Icon.Image = "http://www.roblox.com/asset/?id=" .. icon
	if layoutOrder then
		cloned.LayoutOrder = layoutOrder
	else
		cloned.LayoutOrder = #childrens - #childrens - 1
	end

	coroutine.wrap(RippleEffect)(clonedRipple)

	cloned.MouseButton1Click:Connect(callback)
end

-- / Random String Generator
-- * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
function crypt.random(len)
	local Lenght = 0
	local Generated = ""

	if not len then
		Lenght = math.random(8, 32)
	else
		Lenght = len
	end

	local upperCase = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
	local lowerCase = "abcdefghijklmnopqrstuvwxyz"
	local numbers = "0123456789"
	local symbols = "!@#$%&()*+-,./\\:;<=>?^[]{}"
	local CharacterSet = upperCase .. lowerCase .. numbers .. symbols

	for i = 1, Lenght do
		local rand = math.random(#CharacterSet)
		Generated = Generated .. string.sub(CharacterSet, rand, rand)
	end

	return Generated
end
-- * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

-- / Encrypts the specified object and its descendants.
-- * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
function LInjector.cryptobj(Obj)
	Obj.Name = crypt.random()
	for _, Descendant in next, Obj:GetDescendants() do
		Descendant.Name = crypt.random()
	end
end
-- * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

B.TextBox_1.Text = [[]] -- INIT TEXT

function LInjector.Toggle()
	if IsHidden == false then
		B.ScrollingFrame_1:TweenSize(
			UDim2.new(1, 0, 0, 0),
			Enum.EasingDirection.InOut,
			Enum.EasingStyle.Sine,
			0.5,
			true
		)
		B.ImageLabel_2.Image = "http://www.roblox.com/asset/?id=6031094687"
		IsHidden = true
	else
		B.ScrollingFrame_1:TweenSize(
			UDim2.new(1, 0, 1, 0),
			Enum.EasingDirection.InOut,
			Enum.EasingStyle.Sine,
			0.5,
			true
		)
		B.ImageLabel_2.Image = "http://www.roblox.com/asset/?id=6031094679"

		IsHidden = false
	end
end

local function main(script)
	local TweenService = game:GetService("TweenService")

	-- / Function to Minimize/Maximize the UI
	-- * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
	function LInjector.NewTogggler(Obj)
		Obj.MouseButton1Click:Connect(LInjector.Toggle)
	end
	-- * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

	-- / Function to Add Spinning Gradinent (Excel loves this for some reason)
	-- * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
	function LInjector.AnimateGradient(Obj)
		TweenService:Create(
			Obj,
			TweenInfo.new(2.5, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true, 0),
			{ Rotation = 405 }
		):Play()
	end
	-- * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

	-- / Add a hover effect to a GuiObject.
	-- * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
	function LInjector.AddHover(Obj)
		local function Tween(Case)
			if Case == 1 then
				TweenService:Create(
					Obj,
					TweenInfo.new(0.3, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, 0, false, 0),
					{ BackgroundTransparency = 0.9 }
				):Play()
			else
				if Case == 2 then
					TweenService:Create(
						Obj,
						TweenInfo.new(0.3, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, 0, false, 0),
						{ BackgroundTransparency = 1 }
					):Play()
				end
			end
		end

		Obj.MouseEnter:Connect(function()
			Tween(1)
		end)
		Obj.MouseLeave:Connect(function()
			Tween(2)
		end)
	end
	-- * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

	-- / Add logic to a button.
	-- * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
	function LInjector.CreateButtonLogic(Obj, Logic)
		Obj.MouseButton1Click:Connect(Logic)
	end
	-- * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

	-- / Initialization
	-- * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
	LInjector.NewTogggler(B.TextButton_2)
	LInjector.AddHover(B.TextButton_1)
	LInjector.AddHover(B.TextButton_2)
	LInjector.AddHover(B.TextButton_3)

	-- * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

	-- / UI Shortcuts
	-- * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
	LInjector.Button(6031075929, function()
		NotifLib({
			Description = "You can still show the UI by pressing the Insert Key on your keyboard",
			Title = "Coldz Hub",
			Duration = 5,
		})

		GUI.Enabled = false
	end, 0)

	UserInputService.InputBegan:Connect(function(input, gameProcessedEvent)
		if input.KeyCode == Enum.KeyCode.Insert then
			if GUI.Enabled == true then
				GUI.Enabled = false
			else
				GUI.Enabled = true
			end
		end
	end)

	-- * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

	-- * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

	-- / Add draggable effect to the main frame
	-- * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
	local UIs = game:GetService("UserInputService")
	local Main = B.Frame_1
	local DragToggle = nil
	local DragStart = nil
	local StartPos = nil

	local function UpdateInput(Input)
		local Delta = Input.Position - DragStart
		local Position =
			UDim2.new(StartPos.X.Scale, StartPos.X.Offset + Delta.X, StartPos.Y.Scale, StartPos.Y.Offset + Delta.Y)
		game:GetService("TweenService"):Create(Main, TweenInfo.new(0.10), { Position = Position }):Play()
	end

	local inputBeganConnection = Main.InputBegan:Connect(function(Input)
		if
			Input.UserInputType == Enum.UserInputType.MouseButton1
			or Input.UserInputType == Enum.UserInputType.Touch
		then
			DragToggle = true
			DragStart = Input.Position
			StartPos = Main.Position
			Input.Changed:Connect(function()
				if Input.UserInputState == Enum.UserInputState.End then
					DragToggle = false
				end
			end)
		end
	end)

	local inputChangedConnection = UIs.InputChanged:Connect(function(Input)
		if
			Input.UserInputType == Enum.UserInputType.MouseMovement
			or Input.UserInputType == Enum.UserInputType.Touch
		then
			if DragToggle then
				UpdateInput(Input)
			end
		end
	end)
	-- * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

	-- / Functions for buttons
	-- * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
	function LInjector.Execute()
		local ScriptText = B.TextBox_1.Text
		if not ScriptText or ScriptText == "" then
			return
		end

		print("Test worked?")
	end

	function LInjector.Clear()
		B.TextBox_1.Text = ""
	end
	-- * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

	-- / Promise functions for buttons
	-- * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

	LInjector.CreateButtonLogic(B.TextButton_1, LInjector.Execute)
	LInjector.CreateButtonLogic(B.TextButton_3, LInjector.Clear)

	-- * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

	-- / Self destroy
	-- * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
	UIs.InputBegan:Connect(function(Input)
		if Input.KeyCode == Enum.KeyCode.End then
			GUI:Remove()
		end
	end)
end

coroutine.wrap(RippleEffect)(B.LocalScript_1)
coroutine.wrap(RippleEffect)(B.LocalScript_3)
coroutine.wrap(RippleEffect)(B.LocalScript_2)
coroutine.wrap(main)(B.LocalScript_4)

LInjector.cryptobj(B.ScreenGui_1)
