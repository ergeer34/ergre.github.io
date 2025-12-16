-- Pet Farm Script with WindUI v2.0
-- Combined Pet Farm + WindUI Integration

if not hookmetamethod then
    return notify('Incompatible Exploit', 'Your exploit does not support `hookmetamethod`')
end

local TeleportService = game:GetService("TeleportService")
local oldIndex
local oldNamecall

oldIndex = hookmetamethod(game, "__index", function(self, key)
    if self == TeleportService and (key:lower() == "teleport" or key == "TeleportToPlaceInstance") then
        return function()
            error("Teleportation blocked by anti-teleport script.", 2)
        end
    end
    return oldIndex(self, key)
end)

oldNamecall = hookmetamethod(game, "__namecall", function(self, ...)
    local method = getnamecallmethod()
    if self == TeleportService and (method:lower() == "teleport" or method == "TeleportToPlaceInstance") then
        return
    end
    return oldNamecall(self, ...)
end)

print('Anti-Rejoin', 'Teleportation prevention is now active.')

local router
for i, v in next, getgc(true) do
    if type(v) == 'table' and rawget(v, 'get_remote_from_cache') then
        router = v
    end
end

local function rename(remotename, hashedremote)
    hashedremote.Name = remotename
end
table.foreach(debug.getupvalue(router.get_remote_from_cache, 1), rename)

local args = {
    "show_spawn_location_dialog",
    false
}
game:GetService("ReplicatedStorage"):WaitForChild("API"):WaitForChild("SettingsAPI/SetSetting"):FireServer(unpack(args))

local ClientData = require(game:GetService("ReplicatedStorage").ClientModules.Core.ClientData)
local PetData = ClientData.get_data()[game.Players.LocalPlayer.Name].inventory.pets

getgenv().PetFarmGuiStarter = false
getgenv().BabyFarmGuiStarter = false
getgenv().AntiAFKEnabled = false
getgenv().SimpleAutoEnabled = false
getgenv().AdvancedAutoEnabled = false
getgenv().IdleProgressionEnabled = false
getgenv().AutoFusionEnabled = false

local petOptions = {}
local petToEquip

local Players = game:GetService("Players")
local Player = Players.LocalPlayer
local CoreGui = game:GetService("CoreGui")
local PlayerGui = Player:FindFirstChildOfClass("PlayerGui") or CoreGui
local LiveOpsMapSwap = require(game:GetService("ReplicatedStorage").SharedModules.Game.LiveOpsMapSwap)

local playButton = game:GetService("Players").LocalPlayer.PlayerGui.NewsApp.EnclosingFrame.MainFrame.Buttons.PlayButton
local babyButton = game:GetService("Players").LocalPlayer.PlayerGui.DialogApp.Dialog.RoleChooserDialog.Baby
local rbxProductButton = game:GetService("Players").LocalPlayer.PlayerGui.DialogApp.Dialog.RobuxProductDialog.Buttons.ButtonTemplate
local claimButton = game:GetService("Players").LocalPlayer.PlayerGui.DailyLoginApp.Frame.Body.Buttons.ClaimButton

task.wait(1)
local xc = 0
local NewAcc = false
local HasTradeLic = false
local Cash = ClientData.get_data()[game.Players.LocalPlayer.Name].money

local function FireSig(button)
    pcall(function()
        for _, connection in pairs(getconnections(button.MouseButton1Down)) do
            connection:Fire()
        end
        task.wait(1)
        for _, connection in pairs(getconnections(button.MouseButton1Up)) do
            connection:Fire()
        end
        task.wait(1)
        for _, connection in pairs(getconnections(button.MouseButton1Click)) do
            connection:Fire()
        end
    end)
end

local NewsApp = game:GetService("Players").LocalPlayer.PlayerGui.NewsApp.Enabled
local sound = require(game.ReplicatedStorage:WaitForChild("Fsys")).load("SoundPlayer")
local UIManager = require(game.ReplicatedStorage:WaitForChild("Fsys")).load("UIManager")

sound.FX:play("BambooButton")
UIManager.set_app_visibility("NewsApp", false)

while NewsApp do
    NewsApp = game:GetService("Players").LocalPlayer.PlayerGui.NewsApp.Enabled
    sound = require(game.ReplicatedStorage:WaitForChild("Fsys")).load("SoundPlayer")
    UIManager = require(game.ReplicatedStorage:WaitForChild("Fsys")).load("UIManager")
    sound.FX:play("BambooButton")
    UIManager.set_app_visibility("NewsApp", false)
    task.wait(3)
end

task.wait(5)
game:GetService("ReplicatedStorage"):WaitForChild("API"):WaitForChild("DailyLoginAPI/ClaimDailyReward"):InvokeServer()
sound.FX:play("BambooButton")
UIManager.set_app_visibility("DailyLoginApp", false)

local NewAcc = false
local HasTradeLic = false
if ClientData.get_data()[game.Players.LocalPlayer.Name].inventory.toys then 
    for i, v in pairs(ClientData.get_data()[game.Players.LocalPlayer.Name].inventory.toys) do
        if v.id == "trade_license" then
            print("has trade lic")
            HasTradeLic = true
        end
    end
end

if Cash <= 10000 and not HasTradeLic then
    print("New account")
    print("Inside new account")
    local success, err = pcall(function()
        game:GetService("ReplicatedStorage"):WaitForChild("API"):WaitForChild("SettingsAPI/SetSetting"):FireServer("theme_color", "red")
        local args = {
            [1] = "theme_color",
            [2] = "red"
        }
        task.wait(2)
        game:GetService("ReplicatedStorage"):WaitForChild("API"):WaitForChild("SettingsAPI/SetSetting"):FireServer(unpack(args))
        task.wait(2)
        game:GetService("ReplicatedStorage"):WaitForChild("API"):WaitForChild("TeamAPI/ChooseTeam"):InvokeServer("Parents", {
            ["source_for_logging"] = "intro_sequence",
            ["dont_enter_location"] = true
        })
        task.wait(2)
        game:GetService("ReplicatedStorage"):WaitForChild("API"):WaitForChild("LegacyTutorialAPI/StashTutorialStatus"):FireServer("Avatar Tutorial Started")
        task.wait(2)
        game:GetService("ReplicatedStorage"):WaitForChild("API"):WaitForChild("LegacyTutorialAPI/StashTutorialStatus"):FireServer("Avatar Editor Opened")
        task.wait(2)
        game:GetService("ReplicatedStorage"):WaitForChild("API"):WaitForChild("AvatarAPI/SubmitAvatarAnalyticsEvent"):FireServer("opened")
        task.wait(2)
        game:GetService("ReplicatedStorage"):WaitForChild("API"):WaitForChild("AvatarAPI/SetGender"):FireServer("male")
        task.wait(2)
        game:GetService("ReplicatedStorage"):WaitForChild("API"):WaitForChild("LegacyTutorialAPI/StashTutorialStatus"):FireServer("Avatar Editor Closed")
        task.wait(2)
        game:GetService("ReplicatedStorage"):WaitForChild("API"):WaitForChild("LegacyTutorialAPI/StashTutorialStatus"):FireServer("Housing Tutorial Started")
        task.wait(2)
        game:GetService("ReplicatedStorage"):WaitForChild("API"):WaitForChild("LegacyTutorialAPI/StashTutorialStatus"):FireServer("Housing Editor Opened")
        task.wait(2)
        game:GetService("ReplicatedStorage"):WaitForChild("API"):WaitForChild("HousingAPI/SendHousingOnePointOneLog"):FireServer("edit_state_entered", {
            ["house_type"] = "mine"
        })
        task.wait(2)
        local args = { [1] = {} }
        game:GetService("ReplicatedStorage"):WaitForChild("API"):WaitForChild("HousingAPI/PushFurnitureChanges"):FireServer(unpack(args))
        task.wait(2)
        local args = { [1] = "edit_state_exited", [2] = {} }
        game:GetService("ReplicatedStorage"):WaitForChild("API"):WaitForChild("HousingAPI/SendHousingOnePointOneLog"):FireServer(unpack(args))
        task.wait(2)
        game:GetService("ReplicatedStorage"):WaitForChild("API"):WaitForChild("LegacyTutorialAPI/StashTutorialStatus"):FireServer("House Exited")
        task.wait(2)
        game:GetService("ReplicatedStorage"):WaitForChild("API"):WaitForChild("DailyLoginAPI/ClaimDailyReward"):InvokeServer()
        task.wait(2)
        game:GetService("ReplicatedStorage"):WaitForChild("API"):WaitForChild("LegacyTutorialAPI/StashTutorialStatus"):FireServer("Nursery Tutorial Started")
        task.wait(2)
        game:GetService("ReplicatedStorage"):WaitForChild("API"):WaitForChild("LegacyTutorialAPI/StashTutorialStatus"):FireServer("Nursery Entered")
        task.wait(2)
        game:GetService("ReplicatedStorage"):WaitForChild("API"):WaitForChild("LegacyTutorialAPI/EquipTutorialEgg"):FireServer()
        task.wait(2)
        game:GetService("ReplicatedStorage"):WaitForChild("API"):WaitForChild("LegacyTutorialAPI/StashTutorialStatus"):FireServer("Started Egg Received")
        task.wait(2)
        game:GetService("ReplicatedStorage"):WaitForChild("API"):WaitForChild("TutorialAPI/AddTutorialQuest"):FireServer()
        task.wait(2)
        game:GetService("ReplicatedStorage"):WaitForChild("API"):WaitForChild("LegacyTutorialAPI/StashTutorialStatus"):FireServer("Tutorial Ailment Spawned")
        task.wait(2)
        local args = { [1] = workspace:WaitForChild("Pets"):WaitForChild("Starter Egg") }
        task.wait(2)
        game:GetService("ReplicatedStorage"):WaitForChild("API"):WaitForChild("AdoptAPI/FocusPet"):FireServer(unpack(args))
        task.wait(2)
        game:GetService("ReplicatedStorage"):WaitForChild("API"):WaitForChild("LegacyTutorialAPI/MarkTutorialCompleted"):FireServer()
        task.wait(2)
    end)
    if not success then
        warn("Error in first task: " .. tostring(err))
    end
    
    local success, err = pcall(function()
        local ReplicatedStorage = game:GetService("ReplicatedStorage")
        local API = ReplicatedStorage:WaitForChild("API")
        
        API:WaitForChild("TutorialAPI/ReportDiscreteStep"):FireServer("npc_interaction")
        task.wait(2)
        API:WaitForChild("TutorialAPI/ChoosePet"):FireServer("dog")
        task.wait(2)
        API:WaitForChild("TutorialAPI/ReportStepCompleted"):FireServer(2, { chosen_pet = "dog" })
        task.wait(2)
        API:WaitForChild("TutorialAPI/ReportStepCompleted"):FireServer(3, { named_pet = false })
        task.wait(2)
        API:WaitForChild("TutorialAPI/ReportDiscreteStep"):FireServer("focused_pet")
        task.wait(2)
        API:WaitForChild("TutorialAPI/ReportDiscreteStep"):FireServer("focused_pet")
        task.wait(2)
        API:WaitForChild("TutorialAPI/ReportStepCompleted"):FireServer(4)
        task.wait(2)
        API:WaitForChild("TutorialAPI/ReportStepCompleted"):FireServer(5)
        task.wait(2)
        API:WaitForChild("TutorialAPI/SpawnPetTreat"):FireServer()
        task.wait(2)
        API:WaitForChild("TutorialAPI/ReportDiscreteStep"):FireServer("focused_pet_2")
        task.wait(2)
        API:WaitForChild("TutorialAPI/ReportStepCompleted"):FireServer(6)
        task.wait(2)
        API:WaitForChild("TutorialAPI/ReportStepCompleted"):FireServer(7)
        task.wait(2)
        API:WaitForChild("TutorialAPI/AddTutorialQuest"):FireServer()
        task.wait(2)
        API:WaitForChild("TutorialAPI/ReportDiscreteStep"):FireServer("opened_taskboard")
        task.wait(2)
        API:WaitForChild("QuestAPI/MarkQuestsViewed"):FireServer()
        task.wait(2)
        API:WaitForChild("TutorialAPI/ReportDiscreteStep"):FireServer("focused_pet_3")
        task.wait(2)
        API:WaitForChild("TutorialAPI/ReportDiscreteStep"):FireServer("started_playground_nav")
        task.wait(2)
        API:WaitForChild("TutorialAPI/ReportDiscreteStep"):FireServer("reached_playground")
        task.wait(2)
        API:WaitForChild("TutorialAPI/ReportDiscreteStep"):FireServer("opened_taskboard_2")
        task.wait(2)
        API:WaitForChild("QuestAPI/ClaimQuest"):InvokeServer("{6d6b008a-650e-4bea-b65c-20357e85f71c}")
        task.wait(2)
        API:WaitForChild("QuestAPI/MarkQuestsViewed"):FireServer()
        task.wait(2)
        API:WaitForChild("TutorialAPI/ReportStepCompleted"):FireServer(10)
        task.wait(2)
        API:WaitForChild("TutorialAPI/ReportDiscreteStep"):FireServer("focused_pet_4")
        task.wait(2)
        API:WaitForChild("TutorialAPI/ReportDiscreteStep"):FireServer("started_home_nav")
        task.wait(2)
        API:WaitForChild("TutorialAPI/ReportStepCompleted"):FireServer(11)
        task.wait(2)
        API:WaitForChild("TutorialAPI/ReportStepCompleted"):FireServer(12)
        task.wait(2)
        API:WaitForChild("TutorialAPI/ReportDiscreteStep"):FireServer("cured_dirty_ailment")
        task.wait(2)
        API:WaitForChild("DailyLoginAPI/ClaimDailyReward"):InvokeServer()
        task.wait(2)
    end)
    if not success then
        warn("Error in second task: " .. tostring(err))
    end
    while not HasTradeLic do
        print("no trade lic")
        if ClientData.get_data()[game.Players.LocalPlayer.Name].inventory.toys then 
            fsys = require(game.ReplicatedStorage:WaitForChild("Fsys")).load
            local ClientData = require(game:GetService("ReplicatedStorage").ClientModules.Core.ClientData)
            fsys("RouterClient").get("SettingsAPI/SetBooleanFlag"):FireServer("has_talked_to_trade_quest_npc", true)
            task.wait()
            fsys("RouterClient").get("TradeAPI/BeginQuiz"):FireServer()
            task.wait(1)
            for i, v in pairs(fsys('ClientData').get("trade_license_quiz_manager")["quiz"]) do
                    fsys("RouterClient").get("TradeAPI/AnswerQuizQuestion"):FireServer(v["answer"])
                task.wait()
            end
            for i, v in pairs(ClientData.get_data()[game.Players.LocalPlayer.Name].inventory.toys) do
                if v.id == "trade_license" then
                    print("have trade lic")
                    HasTradeLic = true
                end
            end
        end
        task.wait(0.4)
    end
    Player:Kick("Tutorial completed please restart game!")
end

task.wait(5)
game:GetService("ReplicatedStorage"):WaitForChild("API"):WaitForChild("TeamAPI/Spawn"):InvokeServer()
task.wait(1)
game:GetService("ReplicatedStorage"):WaitForChild("API"):WaitForChild("PayAPI/DisablePopups"):FireServer()
task.wait(5)

local function getCurrentMoney()
    local currentMoneyText = Player.PlayerGui.BucksIndicatorApp.CurrencyIndicator.Container.Amount.Text
    local sanitizedMoneyText = currentMoneyText:gsub(",", ""):gsub("%s+", "")
    local currentMoney = tonumber(sanitizedMoneyText)
    if currentMoney == nil then
        return 0
    end
    return currentMoney
end

task.wait(1)
local focusPetApp = Player.PlayerGui.FocusPetApp.Frame
local ailments = focusPetApp.Ailments
local ClientData = require(game:GetService("ReplicatedStorage").ClientModules.Core.ClientData)
getgenv().fsys = require(game:GetService("ReplicatedStorage").ClientModules.Core.ClientData)

local virtualUser = game:GetService("VirtualUser")

Player.Idled:Connect(function()
    virtualUser:CaptureController()
    virtualUser:ClickButton2(Vector2.new())
end)

local function startAntiAFK()
    task.spawn(function()
        while getgenv().AntiAFKEnabled do
            task.wait(1200)
            game:GetService("Players").LocalPlayer.Character:FindFirstChildOfClass("Humanoid"):ChangeState(Enum.HumanoidStateType.Jumping)
            print("Anti-AFK jump")
        end
    end)
end

local function GetFurniture(furnitureName)
    local furnitureFolder = workspace.HouseInteriors.furniture
    if furnitureFolder then
        for _, child in pairs(furnitureFolder:GetChildren()) do
            if child:IsA("Folder") then
                for _, grandchild in pairs(child:GetChildren()) do
                    if grandchild:IsA("Model") then
                        if grandchild.Name == furnitureName then
                            local furnitureUniqueValue = grandchild:GetAttribute("furniture_unique")
                            return furnitureUniqueValue
                        end
                    end
                end
            end
        end
    end
end

getgenv().fsysCore = require(game:GetService("ReplicatedStorage").ClientModules.Core.InteriorsM.InteriorsM)

local levelOfPet = 0
local petToEquip
local function getHighestLevelPet()
    for i, v in pairs(fsys.get("inventory").pets) do
        if levelOfPet < v.properties.age and v.kind ~= "practice_dog" then
            levelOfPet = v.properties.age
            petToEquip = v.unique
            if levelOfPet >= 6 then
                return petToEquip
            end
        end
    end
    return petToEquip
end

local PetAilmentsArray = {}
local BabyAilmentsArray = {}
local PetAilmentsData = ClientData.get_data()[game.Players.LocalPlayer.Name].ailments_manager.ailments
local BabyAilmentsData = ClientData.get_data()[game.Players.LocalPlayer.Name].ailments_manager.baby_ailments

local function getAilments(tbl)
    task.wait(.3)
    local equipManager = fsys.get("equip_manager")
    local equipManagerPets = equipManager and equipManager.pets
    PetAilmentsArray = {}
    for key, value in pairs(tbl) do
        if key == equipManagerPets[1].unique then
            for subKey, subValue in pairs(value) do
                table.insert(PetAilmentsArray, subValue.kind)
            end
        end
    end
end

local function getBabyAilments(tbl)
    BabyAilmentsArray = {}
    for key, value in pairs(tbl) do
        table.insert(BabyAilmentsArray, key)
    end
end

local function checkHouse()
    print("=============Checking House================")
    local ClientData = require(game:GetService("ReplicatedStorage").ClientModules.Core.ClientData)
    local Data = ClientData.get_data()[game.Players.LocalPlayer.Name].house_manager
    local activeHouse = { name = nil, active = false }
    local activeIsPudding = false
    local farmingHouse = { name = nil, house_id = nil }

    for _, house in pairs(Data) do
        if house.active then
            activeHouse.name = house.name
            activeHouse.active = true
            activeIsPudding = (house.name:lower() == "my christmas pudding house")
        end
        if not farmingHouse.house_id and house.name:lower() ~= "my christmas pudding house" then
            farmingHouse.name = house.name
            farmingHouse.house_id = house.house_id or house.id
        end
    end

    if activeHouse.active and activeIsPudding and farmingHouse.house_id then
        print("Changing house to", farmingHouse.name)
        game:GetService("ReplicatedStorage"):WaitForChild("API"):WaitForChild("HousingAPI/SpawnHouse"):FireServer(farmingHouse.house_id)
        task.wait(10)
        print("Respawning")
        game:GetService("ReplicatedStorage"):WaitForChild("API"):WaitForChild("TeamAPI/Spawn"):InvokeServer()
    else
        if not activeHouse.active then
            print("No active house; nothing to change.")
        elseif not activeIsPudding then
            print("Active house is not the pudding house; no change needed.")
        elseif not farmingHouse.house_id then
            print("No alternative non-pudding house found to switch to.")
        end
    end
end

local function equipPet()
    checkHouse()    
    local success, fsys = pcall(function()
        return require(game:GetService("ReplicatedStorage").ClientModules.Core.ClientData)
    end)
    
    if not success or not fsys then
        warn("Failed to require fsys")
        return
    end
    
    local equipManager = fsys.get("equip_manager")
    local equipManagerPets = equipManager and equipManager.pets or {}
    local inventory = fsys.get("inventory")
    local inventoryPets = inventory and inventory.pets or {}
    
    local currentPet = equipManagerPets[1]
    local shouldEquipNewPet = not currentPet or not petToEquip or (currentPet.unique ~= petToEquip)
    
    if shouldEquipNewPet then
        for _, pet in pairs(inventoryPets) do
            if pet.kind ~= "practice_dog" then
                if pet.properties.age == 6 then
                    petToEquip = pet.unique
                    break
                end
                petToEquip = pet.unique
            end
        end
        if petToEquip then
            game:GetService("ReplicatedStorage"):WaitForChild("API"):WaitForChild("AdoptAPI/AdoptPet"):InvokeServer(petToEquip)
        end
    end
    
    PetAilmentsData = ClientData.get_data()[game.Players.LocalPlayer.Name].ailments_manager.ailments
    getAilments(PetAilmentsData)
    BabyAilmentsData = ClientData.get_data()[game.Players.LocalPlayer.Name].ailments_manager.baby_ailments
    getBabyAilments(BabyAilmentsData)
end

local startingMoney = getCurrentMoney()

local function removeItemByValue(tbl, val)
    for i = #tbl, 1, -1 do
        if tbl[i] == val then
            table.remove(tbl, i)
        end
    end
end

local function teleportPlayerNeeds(x, y, z)
    local char = Player.Character or Player.CharacterAdded:Wait()
    local rootPart = char:WaitForChild("HumanoidRootPart")
    rootPart.CFrame = CFrame.new(x, y, z)
end

local function createPlatform()
    local existingPlatform = workspace:FindFirstChild("FarmPlatform")
    if existingPlatform then
        existingPlatform:Destroy()
    end
    
    local platform = Instance.new("Part")
    platform.Name = "FarmPlatform"
    platform.Size = Vector3.new(50, 1, 50)
    platform.Position = Vector3.new(0, 349, 0)
    platform.Anchored = true
    platform.CanCollide = true
    platform.Transparency = 0.5
    platform.BrickColor = BrickColor.new("Bright green")
    platform.Parent = workspace
end

local function buyItems()
    local args = {
        [1] = "strollers",
        [2] = "stroller-default",
        [3] = { ["buy_count"] = 1 }
    }
    game:GetService("ReplicatedStorage"):WaitForChild("API"):WaitForChild("ShopAPI/BuyItem"):InvokeServer(unpack(args))
    
    local args2 = {
        [1] = "toys",
        [2] = "squeaky_bone_default",
        [3] = { ["buy_count"] = 1 }
    }
    game:GetService("ReplicatedStorage"):WaitForChild("API"):WaitForChild("ShopAPI/BuyItem"):InvokeServer(unpack(args2))
end

Player.PlayerGui.TransitionsApp.Whiteout:GetPropertyChangedSignal("BackgroundTransparency"):Connect(function()
    if Player.PlayerGui.TransitionsApp.Whiteout.BackgroundTransparency == 0 then
        Player.PlayerGui.TransitionsApp.Whiteout.BackgroundTransparency = 1
    end
end)

local function buyItem(itemName)
    local args = {
        [1] = "food",
        [2] = itemName,
        [3] = { ["buy_count"] = 1 }
    }
    game:GetService("ReplicatedStorage"):WaitForChild("API"):WaitForChild("ShopAPI/BuyItem"):InvokeServer(unpack(args))
end

local function getFoodID(itemName)
    local ailmentsData = ClientData.get_data()[game.Players.LocalPlayer.Name].inventory.food
    for key, value in pairs(ailmentsData) do
        if value.id == itemName then
            return key
        end
    end
    return nil
end

local function useItem(itemID, useCount)
    for i = 1, useCount do
        local args = {
            [1] = itemID,
            [2] = "END"
        }
        game:GetService("ReplicatedStorage"):WaitForChild("API"):WaitForChild("ToolAPI/ServerUseTool"):FireServer(unpack(args))
        task.wait(2)
    end
end

local function hasTargetAilment(targetKind)
    print(targetKind)
    local ailments = ClientData.get_data()[game.Players.LocalPlayer.Name].ailments_manager.ailments
    for _, ailment in pairs(ailments) do
        if ailment.kind == targetKind then
            print(ailment.kind)
            return true
        end
    end
    return false
end

local taskName = "none"
local function EatDrink(isEquippedPet)
    if isEquippedPet then
        equipPet()
    end
    task.wait(1)
    if table.find(PetAilmentsArray, "hungry") then
        taskName = "Hungry"
        getgenv().fsys = require(game:GetService("ReplicatedStorage").ClientModules.Core.ClientData)
        if getgenv().FoodID then
            game:GetService("ReplicatedStorage").API["HousingAPI/ActivateFurniture"]:InvokeServer(game:GetService("Players").LocalPlayer,getgenv().FoodID,"UseBlock",{['cframe'] = CFrame.new(game:GetService("Players").LocalPlayer.Character.Head.Position + Vector3.new(0, .5, 0))},fsys.get("pet_char_wrappers")[1]["char"])
            local t = 0
            repeat task.wait(1)
                t = t + 1
            until not hasTargetAilment("hungry") or t > 60
            local args = {
                [1] = getgenv().fsys.get("pet_char_wrappers")[1].pet_unique
            }
            game:GetService("ReplicatedStorage"):WaitForChild("API"):WaitForChild("AdoptAPI/EjectBaby"):FireServer(unpack(args))
        else
            if startingMoney > 80 then
                game:GetService("ReplicatedStorage").API:FindFirstChild("HousingAPI/BuyFurnitures"):InvokeServer({[1] = {["properties"] = {["cframe"] = CFrame.new(30.5, 0, -20) * CFrame.Angles(-0, -1.57, 0)},["kind"] = "pet_food_bowl"}})
                task.wait(1)
                getgenv().FoodID = GetFurniture("PetFoodBowl")
                startingMoney = getCurrentMoney()
            end
        end
        removeItemByValue(PetAilmentsArray, "hungry")
        PetAilmentsData = ClientData.get_data()[game.Players.LocalPlayer.Name].ailments_manager.ailments
        getAilments(PetAilmentsData)
        taskName = "none"
        equipPet()
    end
    if table.find(PetAilmentsArray, "thirsty") then
        taskName = "Thirsty"
        getgenv().fsys = require(game:GetService("ReplicatedStorage").ClientModules.Core.ClientData)
        if getgenv().WaterID then
            game:GetService("ReplicatedStorage").API["HousingAPI/ActivateFurniture"]:InvokeServer(game:GetService("Players").LocalPlayer,getgenv().WaterID,"UseBlock",{['cframe'] = CFrame.new(game:GetService("Players").LocalPlayer.Character.Head.Position + Vector3.new(0, .5, 0))},fsys.get("pet_char_wrappers")[1]["char"])
            local t = 0
            repeat task.wait(1)
                t = t + 1
            until not hasTargetAilment("thirsty") or t > 60
            local args = {
                [1] = getgenv().fsys.get("pet_char_wrappers")[1].pet_unique
            }
            game:GetService("ReplicatedStorage"):WaitForChild("API"):WaitForChild("AdoptAPI/EjectBaby"):FireServer(unpack(args))
        else
            if startingMoney > 80 then
                game:GetService("ReplicatedStorage").API:FindFirstChild("HousingAPI/BuyFurnitures"):InvokeServer({[1] = {["properties"] = {["cframe"] = CFrame.new(30.5, 0, -20) * CFrame.Angles(-0, -1.57, 0)},["kind"] = "pet_water_bowl"}})
                task.wait(1)
                getgenv().WaterID = GetFurniture("PetWaterBowl")
                startingMoney = getCurrentMoney()
            end
        end
        removeItemByValue(PetAilmentsArray, "thirsty")
        PetAilmentsData = ClientData.get_data()[game.Players.LocalPlayer.Name].ailments_manager.ailments
        getAilments(PetAilmentsData)
        taskName = "none"
        equipPet()
    end
end

local function EatDrinkSafeCall(isEquippedPet)
    local success = false
    while not success do
        success, err = pcall(function()
            EatDrink(isEquippedPet)
        end)
        if not success then
            warn("Error occurred: ", err)
            task.wait(1)
        end
    end
end

local function BabyJump()
    local char = Player.Character
    if char then
        local humanoid = char:FindFirstChildOfClass("Humanoid")
        if humanoid then
            humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
        end
    end
end

local function claimDailyReward()
    pcall(function()
        game:GetService("ReplicatedStorage"):WaitForChild("API"):WaitForChild("DailyLoginAPI/ClaimDailyReward"):InvokeServer()
    end)
end

local function claimAdventCalendar()
    pcall(function()
        local day = tonumber(os.date("%d"))
        local admday = day - 1
        local args = { admday }
        game:GetService("ReplicatedStorage"):WaitForChild("API"):WaitForChild("WinterEventAPI/AdventCalendarTryTakeReward"):InvokeServer(unpack(args))
    end)
end

_G.FarmTypeRunning = "none"

local function startPetFarm()
    game:GetService("ReplicatedStorage"):WaitForChild("API"):WaitForChild("TeamAPI/ChooseTeam"):InvokeServer("Babies",{["dont_send_back_home"] = true, ["source_for_logging"] = "avatar_editor"})
    game:GetService("ReplicatedStorage"):WaitForChild("API"):WaitForChild("TeamAPI/Spawn"):InvokeServer()
    task.wait(5)
    buyItems()
    local LiveOpsMapSwap = require(game:GetService("ReplicatedStorage").SharedModules.Game.LiveOpsMapSwap)
    game:GetService("ReplicatedStorage").API:FindFirstChild("LocationAPI/SetLocation"):FireServer("MainMap",
    game:GetService("Players").LocalPlayer, "Snow")
    teleportPlayerNeeds(0,350,0)
    createPlatform()
    equipPet()
    task.wait(1)

    task.spawn(function()
        while getgenv().PetFarmGuiStarter do
            for _, obj in ipairs(workspace:GetDescendants()) do
                if obj.Name == "BucksBillboard" or obj.Name == "XPBillboard" then
                    obj:Destroy()
                end
            end
            task.wait(0.5)
        end
    end)

    local character = Player.Character or Player.CharacterAdded:Wait()
    local rootPart = character:WaitForChild("HumanoidRootPart")
    
    local bodyVelocity = rootPart:FindFirstChildOfClass("BodyVelocity")
    if bodyVelocity then
        bodyVelocity:Destroy()
    end
    
    local humanoid = character:FindFirstChildOfClass("Humanoid")
    if humanoid then
        humanoid.PlatformStand = false
    end   

    while getgenv().PetFarmGuiStarter do
        _G.FarmTypeRunning = "Pet/Baby"
        task.wait(5)
        equipPet()
        
        if table.find(PetAilmentsArray, "hungry") or table.find(PetAilmentsArray, "thirsty") then
            EatDrinkSafeCall(true)
        end
        
        if table.find(BabyAilmentsArray, "hungry") then
            startingMoney = getCurrentMoney()
            if startingMoney > 5 then
                buyItem("apple")
                local appleID = getFoodID("apple")
                useItem(appleID, 3)
                task.wait(1)
            end
            removeItemByValue(BabyAilmentsArray, "hungry")
            BabyAilmentsData = ClientData.get_data()[game.Players.LocalPlayer.Name].ailments_manager.baby_ailments
            getBabyAilments(BabyAilmentsData)
            equipPet()
        end
        
        if table.find(BabyAilmentsArray, "thirsty") then
            startingMoney = getCurrentMoney()
            if startingMoney > 5 then
                buyItem("tea")
                local teaID = getFoodID("tea")
                useItem(teaID, 6)
                task.wait(1)
            end
            removeItemByValue(BabyAilmentsArray, "thirsty")
            BabyAilmentsData = ClientData.get_data()[game.Players.LocalPlayer.Name].ailments_manager.baby_ailments
            getBabyAilments(BabyAilmentsData)
            equipPet()
        end
        
        if table.find(BabyAilmentsArray, "sick") then
            game:GetService("ReplicatedStorage").API:FindFirstChild("LocationAPI/SetLocation"):FireServer("Hospital")
            task.wait(0.3)
            teleportPlayerNeeds(0, 350, 0)
            task.wait(0.3)
            pcall(function()
                getgenv().HospitalBedID = GetFurniture("HospitalRefresh2023Bed")
                game:GetService("ReplicatedStorage"):WaitForChild("API"):WaitForChild("HousingAPI/ActivateInteriorFurniture"):InvokeServer(getgenv().HospitalBedID, "Seat1", {['cframe']=CFrame.new(game:GetService("Players").LocalPlayer.Character.Head.Position + Vector3.new(0,.5,0))}, fsys.get("char_wrapper")["char"])
            end)
            task.wait(15)
            BabyJump()
            removeItemByValue(BabyAilmentsArray, "sick")
            BabyAilmentsData = ClientData.get_data()[game.Players.LocalPlayer.Name].ailments_manager.baby_ailments
            getBabyAilments(BabyAilmentsData)
            if not getgenv().PetFarmGuiStarter then break end
            local LiveOpsMapSwap = require(game:GetService("ReplicatedStorage").SharedModules.Game.LiveOpsMapSwap)
            game:GetService("ReplicatedStorage").API:FindFirstChild("LocationAPI/SetLocation"):FireServer("MainMap",
            game:GetService("Players").LocalPlayer, LiveOpsMapSwap.get_current_map_type())
            task.wait(0.3)
            teleportPlayerNeeds(0, 350, 0)
            task.wait(0.3)
            createPlatform()
            equipPet()
        end
        
        if table.find(BabyAilmentsArray, "sleepy") then
            if getgenv().BedID then
                task.spawn(function()
                    game:GetService("ReplicatedStorage").API["HousingAPI/ActivateFurniture"]:InvokeServer(game:GetService("Players").LocalPlayer,getgenv().BedID,"UseBlock",{['cframe'] = CFrame.new(game:GetService("Players").LocalPlayer.Character.HumanoidRootPart.Position)},fsys.get("char_wrapper")["char"])
                end)
                local t = 0
                repeat 
                    task.wait(1)
                    t = t + 1
                    local playerData = ClientData.get_data()
                    local playerName = game.Players.LocalPlayer.Name
                    local babyAilments = playerData and playerData[playerName] 
                        and playerData[playerName].ailments_manager 
                        and playerData[playerName].ailments_manager.baby_ailments
                    local sleepyAilment = babyAilments and babyAilments["sleepy"]
                until not sleepyAilment or t > 60
                BabyJump()
                removeItemByValue(BabyAilmentsArray, "sleepy")
            else
                startingMoney = getCurrentMoney()
                if startingMoney > 5 then
                    game:GetService("ReplicatedStorage").API:FindFirstChild("HousingAPI/BuyFurnitures"):InvokeServer({[1] = {["properties"] = {["cframe"] = CFrame.new(33.5, 0, -30) * CFrame.Angles(-0, -1.57, 0)},["kind"] = "basiccrib"}})
                    task.wait(1)
                    getgenv().BedID = GetFurniture("BasicCrib")
                    startingMoney = getCurrentMoney()
                end
            end
            equipPet()
        end
        
        if table.find(PetAilmentsArray, "sleepy") then
            taskName = "Sleepy"
            if getgenv().PetBedID then
                game:GetService("ReplicatedStorage").API["HousingAPI/ActivateFurniture"]:InvokeServer(game:GetService("Players").LocalPlayer,getgenv().PetBedID,"Seat1",{['cframe']=CFrame.new(game:GetService("Players").LocalPlayer.Character.Head.Position + Vector3.new(0,.5,0))},fsys.get("pet_char_wrappers")[1]["char"])
                local t = 0
                repeat task.wait(1)
                    t = t + 1
                until not hasTargetAilment("sleepy") or t > 60
                local args = {
                    [1] = getgenv().fsys.get("pet_char_wrappers")[1].pet_unique
                }
                game:GetService("ReplicatedStorage"):WaitForChild("API"):WaitForChild("AdoptAPI/EjectBaby"):FireServer(unpack(args))
            else
                startingMoney = getCurrentMoney()
                if startingMoney > 9 then
                    game:GetService("ReplicatedStorage").API:FindFirstChild("HousingAPI/BuyFurnitures"):InvokeServer({[1] = {["properties"] = {["cframe"] = CFrame.new(30.5, 0, -20) * CFrame.Angles(-0, -1.57, 0)},["kind"] = "pet_bed"}})
                    task.wait(1)
                    getgenv().PetBedID = GetFurniture("PetBed")
                    startingMoney = getCurrentMoney()
                end
            end
            removeItemByValue(PetAilmentsArray, "sleepy")
            PetAilmentsData = ClientData.get_data()[game.Players.LocalPlayer.Name].ailments_manager.ailments
            getAilments(PetAilmentsData)
            taskName = "none"
            equipPet()
        end

        if table.find(PetAilmentsArray, "dirty") then
            taskName = "Dirty"
            if getgenv().ShowerID then
                game:GetService("ReplicatedStorage").API["HousingAPI/ActivateFurniture"]:InvokeServer(game:GetService("Players").LocalPlayer,getgenv().ShowerID,"Seat1",{['cframe']=CFrame.new(game:GetService("Players").LocalPlayer.Character.Head.Position + Vector3.new(0,.5,0))},fsys.get("pet_char_wrappers")[1]["char"])
                local t = 0
                repeat task.wait(1)
                    t = t + 1
                until not hasTargetAilment("dirty") or t > 60
                local args = {
                    [1] = getgenv().fsys.get("pet_char_wrappers")[1].pet_unique
                }
                game:GetService("ReplicatedStorage"):WaitForChild("API"):WaitForChild("AdoptAPI/EjectBaby"):FireServer(unpack(args))
            else
                startingMoney = getCurrentMoney()
                if startingMoney > 80 then
                    game:GetService("ReplicatedStorage").API:FindFirstChild("HousingAPI/BuyFurnitures"):InvokeServer({[1] = {["properties"] = {["cframe"] = CFrame.new(30.5, 0, -20) * CFrame.Angles(-0, -1.57, 0)},["kind"] = "shower"}})
                    task.wait(1)
                    getgenv().ShowerID = GetFurniture("Shower")
                    startingMoney = getCurrentMoney()
                end
            end
            removeItemByValue(PetAilmentsArray, "dirty")
            PetAilmentsData = ClientData.get_data()[game.Players.LocalPlayer.Name].ailments_manager.ailments
            getAilments(PetAilmentsData)
            taskName = "none"
            equipPet()
        end

        if table.find(PetAilmentsArray, "toilet") then
            taskName = "Toilet"
            task.wait(3)
            if getgenv().ToiletID then
                game:GetService("ReplicatedStorage"):WaitForChild("API"):WaitForChild("HousingAPI/ActivateFurniture"):InvokeServer(game:GetService("Players").LocalPlayer,getgenv().ToiletID,"Seat1",{['cframe']=CFrame.new(game:GetService("Players").LocalPlayer.Character.Head.Position + Vector3.new(0,.5,0))},fsys.get("pet_char_wrappers")[1]["char"])
                local t = 0
                repeat 
                    task.wait(1)
                    t = t + 1
                until not hasTargetAilment("toilet") or t > 60
                local args = {
                    [1] = getgenv().fsys.get("pet_char_wrappers")[1].pet_unique
                }
                game:GetService("ReplicatedStorage"):WaitForChild("API"):WaitForChild("AdoptAPI/EjectBaby"):FireServer(unpack(args))
                removeItemByValue(PetAilmentsArray, "toilet")
            else
                startingMoney = getCurrentMoney()
                if startingMoney > 9 then
                    game:GetService("ReplicatedStorage").API:FindFirstChild("HousingAPI/BuyFurnitures"):InvokeServer({[1] = {["properties"] = {["cframe"] = CFrame.new(30.5, 0, -20) * CFrame.Angles(-0, -1.57, 0)},["kind"] = "toilet"}})
                    task.wait(1)
                    getgenv().ToiletID = GetFurniture("Toilet")
                    startingMoney = getCurrentMoney()
                end
            end
            taskName = "none"
            equipPet()
        end

        if table.find(PetAilmentsArray, "mystery") then
            taskName = "Mystery"
            getgenv().fsys = require(game:GetService("ReplicatedStorage").ClientModules.Core.ClientData)
            task.wait(3)
            local actions = {
                "hungry", "thirsty", "sleepy", "toilet", "bored", "dirty",
                "play", "school", "salon", "pizza_party", "sick",
                "camping", "beach_party", "walk", "ride", "moon"
            }
            for _, action in ipairs(actions) do
                local ClientData = require(game:GetService("ReplicatedStorage").ClientModules.Core.ClientData)
                local args = {
                    ClientData.get_data()[game.Players.LocalPlayer.Name].equip_manager.pets[1].unique,
                    "mystery",
                    1,
                    action
                }
                game:GetService("ReplicatedStorage"):WaitForChild("API"):WaitForChild("AilmentsAPI/ChooseMysteryAilment"):FireServer(unpack(args))
                task.wait(2)
            end
            local t = 0
            repeat task.wait(1)
                t = 1 + t
            until not hasTargetAilment("mystery") or t > 60
            local args = {
                [1] = getgenv().fsys.get("pet_char_wrappers")[1].pet_unique
            }
            game:GetService("ReplicatedStorage"):WaitForChild("API"):WaitForChild("AdoptAPI/EjectBaby"):FireServer(unpack(args))
            removeItemByValue(PetAilmentsArray, "mystery")
            taskName = "none"
            equipPet()
        end

        if table.find(PetAilmentsArray, "play") then
            taskName = "Play"
            getgenv().fsys = require(game:GetService("ReplicatedStorage").ClientModules.Core.ClientData)
            task.wait(3)
            for i = 1, 3 do
                if not getgenv().PetFarmGuiStarter then break end
                for i, v in pairs(fsys.get("inventory").toys) do
                    if v.id == "squeaky_bone_default" then
                        ToyToThrow = v.unique
                    end
                end
                game:GetService("ReplicatedStorage"):WaitForChild("API"):WaitForChild("PetObjectAPI/CreatePetObject"):InvokeServer("__Enum_PetObjectCreatorType_1", {["reaction_name"] = "ThrowToyReaction", ["unique_id"] = ToyToThrow})
                wait(4)
            end
            local t = 0
            repeat task.wait(1)
                t = 1 + t
            until not hasTargetAilment("play") or t > 60
            local args = {
                [1] = getgenv().fsys.get("pet_char_wrappers")[1].pet_unique
            }
            game:GetService("ReplicatedStorage"):WaitForChild("API"):WaitForChild("AdoptAPI/EjectBaby"):FireServer(unpack(args))
            removeItemByValue(PetAilmentsArray, "play")
            taskName = "none"
            equipPet()
        end

        if table.find(PetAilmentsArray, "sick") then
            taskName = "Sick"
            getgenv().fsys = require(game:GetService("ReplicatedStorage").ClientModules.Core.ClientData)
            game:GetService("ReplicatedStorage").API:FindFirstChild("LocationAPI/SetLocation"):FireServer("Hospital")
            task.wait(0.3)
            teleportPlayerNeeds(0, 350, 0)
            task.wait(0.3)
            createPlatform()
            task.wait(0.3)
            getgenv().HospitalBedID = GetFurniture("HospitalRefresh2023Bed")
            task.wait(2)
            game:GetService("ReplicatedStorage"):WaitForChild("API"):WaitForChild("HousingAPI/ActivateInteriorFurniture"):InvokeServer(getgenv().HospitalBedID, "Seat1", {['cframe']=CFrame.new(game:GetService("Players").LocalPlayer.Character.Head.Position + Vector3.new(0,.5,0))}, fsys.get("pet_char_wrappers")[1]["char"])
            task.wait(15)
            local args = {
                [1] = getgenv().fsys.get("pet_char_wrappers")[1].pet_unique
            }
            game:GetService("ReplicatedStorage"):WaitForChild("API"):WaitForChild("AdoptAPI/EjectBaby"):FireServer(unpack(args))
            removeItemByValue(PetAilmentsArray, "sick")
            if not getgenv().PetFarmGuiStarter then break end
            task.wait(1)
            local LiveOpsMapSwap = require(game:GetService("ReplicatedStorage").SharedModules.Game.LiveOpsMapSwap)
            game:GetService("ReplicatedStorage").API:FindFirstChild("LocationAPI/SetLocation"):FireServer("MainMap",
            game:GetService("Players").LocalPlayer, LiveOpsMapSwap.get_current_map_type())
            task.wait(0.3)
            teleportPlayerNeeds(0, 350, 0)
            task.wait(0.3)
            createPlatform()
            task.wait(0.3)
            taskName = "none"
            equipPet()
        end

        if table.find(PetAilmentsArray, "walk") then
            if not getgenv().PetFarmGuiStarter then break end
            taskName = "Walk"
            task.wait(3)
            local Character = Player.Character or Player.CharacterAdded:Wait()
            local HumanoidRootPart = Character:WaitForChild("HumanoidRootPart")
            local Humanoid = Character:WaitForChild("Humanoid")
            local walkDistance = 1000
            local walkDuration = 30
            local initialPosition = HumanoidRootPart.Position
            local forwardPosition = initialPosition + (HumanoidRootPart.CFrame.LookVector * walkDistance)
            local walkSpeed = walkDistance / walkDuration
            Humanoid.WalkSpeed = walkSpeed

            for i = 1, 2 do
                if not getgenv().PetFarmGuiStarter then break end
                Humanoid:MoveTo(forwardPosition)
                Humanoid.MoveToFinished:Wait()
                task.wait(1)
                if not getgenv().PetFarmGuiStarter then break end
                Humanoid:MoveTo(initialPosition)
                Humanoid.MoveToFinished:Wait()
                task.wait(1)
            end
            local t = 0
            repeat
                if not getgenv().PetFarmGuiStarter then break end
                t = 1 + t
                task.wait(1)
            until not hasTargetAilment("walk") or t > 60
            Humanoid.WalkSpeed = 16
            removeItemByValue(PetAilmentsArray, "walk")
            taskName = "none"
            equipPet()
        end

        if table.find(PetAilmentsArray, "ride") then
            if not getgenv().PetFarmGuiStarter then break end
            taskName = "Ride"
            getgenv().fsys = require(game:GetService("ReplicatedStorage").ClientModules.Core.ClientData)
            task.wait(3)
            local strollerUnique
            for i,v in pairs(fsys.get("inventory").strollers) do
                if v.id == 'stroller-default' then
                    strollerUnique = v.unique
                end   
            end
            
            local args = {
                [1] = strollerUnique,
                [2] = {
                    ["use_sound_delay"] = true,
                    ["equip_as_last"] = false
                }
            }
            game:GetService("ReplicatedStorage"):WaitForChild("API"):WaitForChild("ToolAPI/Equip"):InvokeServer(unpack(args))

            local args = {
                game:GetService("Players"):WaitForChild(workspace:WaitForChild("PlayerCharacters"):GetChildren()[1].Name),
                workspace:WaitForChild("Pets"):GetChildren()[1],
                game:GetService("Players").LocalPlayer.Character:WaitForChild("StrollerTool"):WaitForChild("ModelHandle"):WaitForChild("TouchToSits"):WaitForChild("TouchToSit")
            }
            game:GetService("ReplicatedStorage"):WaitForChild("API"):WaitForChild("AdoptAPI/UseStroller"):InvokeServer(unpack(args))

            local Character = Player.Character or Player.CharacterAdded:Wait()
            local HumanoidRootPart = Character:WaitForChild("HumanoidRootPart")
            local Humanoid = Character:WaitForChild("Humanoid")
            local walkDistance = 1000
            local walkDuration = 30
            local initialPosition = HumanoidRootPart.Position
            local forwardPosition = initialPosition + (HumanoidRootPart.CFrame.LookVector * walkDistance)
            local walkSpeed = walkDistance / walkDuration
            Humanoid.WalkSpeed = walkSpeed

            for i = 1, 2 do
                if not getgenv().PetFarmGuiStarter then break end
                Humanoid:MoveTo(forwardPosition)
                Humanoid.MoveToFinished:Wait()
                task.wait(1)
                if not getgenv().PetFarmGuiStarter then break end
                Humanoid:MoveTo(initialPosition)
                Humanoid.MoveToFinished:Wait()
                task.wait(1)
            end
            local t = 0
            repeat
                t = 1 + t
                if not getgenv().PetFarmGuiStarter then break end
                task.wait(1)
            until not hasTargetAilment("ride") or t > 60

            local argsUnequip = {
                [1] = strollerUnique,
                [2] = {
                    ["use_sound_delay"] = true,
                }
            }
            game:GetService("ReplicatedStorage"):WaitForChild("API"):WaitForChild("ToolAPI/Unequip"):InvokeServer(unpack(argsUnequip))
            
            Humanoid.WalkSpeed = 16
            removeItemByValue(PetAilmentsArray, "ride")
            taskName = "none"
            equipPet()
        end
    end
    _G.FarmTypeRunning = "none"
end

task.spawn(function()
    while true do
        local day = tonumber(os.date("%d"))
        local admday = day - 1
        local args = { admday }
        game:GetService("ReplicatedStorage"):WaitForChild("API"):WaitForChild("WinterEventAPI/AdventCalendarTryTakeReward"):InvokeServer(unpack(args))
        task.wait(3600)
    end    
end)

task.spawn(function()
    local RS = game:GetService("ReplicatedStorage")
    local API = RS:WaitForChild("API", 10)
    local ClientData = require(RS.ClientModules.Core.ClientData)
    local playerName = game.Players.LocalPlayer.Name
    
    assert(API, "[Fusion] API folder not found")
    local DoNeonFusion = API:WaitForChild("PetAPI/DoNeonFusion", 10)
    assert(DoNeonFusion, "[Fusion] PetAPI/DoNeonFusion remote not found")
    
    local function inv()
        return ClientData.get_data()[playerName].inventory.pets
    end
    
    local function getActiveUids()
        local set = {}
        local act = ClientData.get_data()[playerName].idle_progression_manager
        local ap = act and act.active_pets
        if ap then
            for _, slot in pairs(ap) do
                local ii = slot and slot.item_info
                if ii then
                    local u = ii.unique or ii.id or ii.uid
                    if u then set[u] = true end
                    for _, v in pairs(ii) do
                        if type(v) == "table" then
                            local uu = v.unique or v.id or v.uid
                            if uu then set[uu] = true end
                        end
                    end
                end
            end
        end
        return set
    end
    
    local function extract(p, key)
        local uid = p.unique or p.id or p.uid or key
        local kind = p.kind or (p.item_info and (p.item_info.kind or p.item_info.Kind))
        local props = p.properties or (p.item_info and p.item_info.properties) or {}
        local age = tonumber(props.age or props.Age)
        local neon = (props.neon == true) or (props.neon == "true")
        local locked = props.locked or props.Locked or props.favorite or props.Favorite
        return uid, kind, age, neon, locked
    end
    
    local function buildBuckets(activeSet)
        local neonBuckets, megaBuckets = {}, {}
        for k, p in pairs(inv() or {}) do
            local uid, kind, age, neon, locked = extract(p, k)
            if uid and kind and age == 6 and not activeSet[uid] and not locked then
                local bucket = neon and megaBuckets or neonBuckets
                local arr = bucket[kind]
                if arr then
                    arr[#arr + 1] = uid
                else
                    bucket[kind] = { uid }
                end
            end
        end
        return neonBuckets, megaBuckets
    end
    
    local function fuse4(a, b, c, d)
        local ok = pcall(function() DoNeonFusion:InvokeServer({a, b, c, d}) end)
        if ok then return true end
        ok = pcall(function() DoNeonFusion:InvokeServer(a, b, c, d) end)
        return ok
    end
    
    local function fuseBuckets(buckets, label)
        local groups = 0
        for kind, arr in pairs(buckets) do
            local n = #arr - (#arr % 4)
            for i = 1, n, 4 do
                local a, b, c, d = arr[i], arr[i+1], arr[i+2], arr[i+3]
                local ok = fuse4(a, b, c, d)
                if ok then
                    groups = groups + 1
                else
                    warn(("[Fusion] %s failed for kind=%s on ids=%s,%s,%s,%s")
                        :format(label, tostring(kind), tostring(a), tostring(b), tostring(c), tostring(d)))
                    break
                end
                task.wait(1.0)
            end
        end
        return groups
    end

    while true do
        if getgenv().AutoFusionEnabled then
            do
                local commit = API:FindFirstChild("IdleProgressionAPI/CommitAllProgression")
                if commit then
                    pcall(function()
                        if commit:IsA("RemoteEvent") then
                            commit:FireServer()
                        elseif commit:IsA("RemoteFunction") then
                            commit:InvokeServer()
                        end
                    end)
                end
            end
        
            local data = ClientData.get_data() and ClientData.get_data()[playerName]
            if not data then
                task.wait(5)
                continue
            end
        
            local active = (data.idle_progression_manager and data.idle_progression_manager.active_pets) or {}
            local invPets = (data.inventory and data.inventory.pets) or {}
        
            local activeList = {}
            for slotId, slot in pairs(active) do
                local info = slot and slot.item_info
                if type(info) == "table" then
                    if info.kind then
                        table.insert(activeList, {
                            slotId = slotId,
                            kind   = info.kind,
                            age    = info.properties and info.properties.age,
                        })
                    else
                        for _, item in pairs(info) do
                            if type(item) == "table" and item.kind then
                                table.insert(activeList, {
                                    slotId = slotId,
                                    kind   = item.kind,
                                    age    = item.properties and item.properties.age,
                                })
                            end
                        end
                    end
                end
            end
        
            local count = #activeList
            local allSame = count > 0
            local firstKind = (activeList[1] and activeList[1].kind) or nil
            local hasEgg = false
        
            for i = 1, count do
                local p = activeList[i]
                if p.age == 6 then hasEgg = true end
                if firstKind and p.kind ~= firstKind then allSame = false end
            end
        
            if count == 4 and allSame and not hasEgg then
                task.wait(450)
                local activeUids = getActiveUids()
                local neonBuckets, megaBuckets = buildBuckets(activeUids)
                local neonFused = fuseBuckets(neonBuckets, "Neon")
                local megaFused = fuseBuckets(megaBuckets, "Mega")
                print(("[Fusion] Neon groups: %d | Mega groups: %d"):format(neonFused, megaFused))
                print("Pen OK. Waiting 450s...")
                continue
            end
        
            local RemovePet = API:FindFirstChild("IdleProgressionAPI/RemovePet")
            if RemovePet and RemovePet:IsA("RemoteEvent") then
                for _, p in ipairs(activeList) do
                    pcall(function() RemovePet:FireServer(p.slotId) end)
                end
            end
        
            local byKind = {}
            for petId, pet in pairs(invPets) do
                if pet and pet.kind then
                    local age = pet.properties and pet.properties.age
                    if age ~= 6 then
                        local list = byKind[pet.kind]
                        if not list then
                            list = {}
                            byKind[pet.kind] = list
                        end
                        list[#list + 1] = petId
                    end
                end
            end
        
            local chosenIds
            for _, ids in pairs(byKind) do
                if #ids >= 4 then
                    chosenIds = { ids[1], ids[2], ids[3], ids[4] }
                    break
                end
            end
        
            if not chosenIds then
                warn("No kind with 4 available (non-egg) in inventory.")
                task.wait(450)
                continue
            end
        
            local AddPet = API:FindFirstChild("IdleProgressionAPI/AddPet")
            if AddPet and AddPet:IsA("RemoteEvent") then
                for _, petId in ipairs(chosenIds) do
                    pcall(function() AddPet:FireServer(petId) end)
                end
                print("Refilled pen with 4 of the same kind.")
            else
                warn("AddPet remote not found or wrong class.")
            end
        
            local activeUids = getActiveUids()
            local neonBuckets, megaBuckets = buildBuckets(activeUids)
            local neonFused = fuseBuckets(neonBuckets, "Neon")
            local megaFused = fuseBuckets(megaBuckets, "Mega")
            print(("[Fusion] Neon groups: %d | Mega groups: %d"):format(neonFused, megaFused))
        end
        task.wait(450)
    end
end)

local WindUI = loadstring(game:HttpGet("https://tree-hub.vercel.app/api/UI/WindUI"))()

local Window = WindUI:CreateWindow({
    Folder = "AdoptMe Scripts",
    Title = "Pet Farm - WindUI Edition",
    Icon = "heart",
    Author = "Pet Farm Scripts",
    Theme = "Dark",
    Size = UDim2.fromOffset(700, 550),
    HasOutline = true,
})

Window:EditOpenButton({
    Title = "Open Pet Farm GUI",
    Icon = "pointer",
    CornerRadius = UDim.new(0, 6),
    StrokeThickness = 2,
    Color = ColorSequence.new(Color3.fromRGB(255, 100, 150), Color3.fromRGB(100, 200, 255)),
    Draggable = true,
    OnlyMobile = false,
})

local Sections = {
    Home = Window:Section({
        Title = "Home",
        Icon = "home",
        Opened = true,
    }),
    Features = Window:Section({
        Title = "Features",
        Icon = "package",
        Opened = true,
    }),
    Events = Window:Section({
        Title = "Events",
        Icon = "gift",
        Opened = true,
    }),
    Advanced = Window:Section({
        Title = "Advanced",
        Icon = "settings",
        Opened = true,
    }),
}

local Tabs = {
    Home = Sections.Home:Tab({
        Title = "Home",
        Icon = "home",
        Desc = "Info & Quick Actions",
        ShowTabTitle = true
    }),
    Teleport = Sections.Features:Tab({
        Title = "Teleport",
        Icon = "rocket",
        Desc = "Teleport Features",
        ShowTabTitle = true
    }),
    PetFarm = Sections.Features:Tab({
        Title = "Pet Farm",
        Icon = "heart",
        Desc = "Full Pet Farming",
        ShowTabTitle = true
    }),
    BabyFarm = Sections.Features:Tab({
        Title = "Baby Farm",
        Icon = "baby",
        Desc = "Baby Ailment Care",
        ShowTabTitle = true
    }),
    SimpleAuto = Sections.Features:Tab({
        Title = "Simple Auto",
        Icon = "zap",
        Desc = "Simple Auto Farm",
        ShowTabTitle = true
    }),
    AdvancedAuto = Sections.Features:Tab({
        Title = "Advanced Auto",
        Icon = "cpu",
        Desc = "Advanced Auto Farm",
        ShowTabTitle = true
    }),
    Winter = Sections.Events:Tab({
        Title = "Winter 2025",
        Icon = "snowflake",
        Desc = "Winter Event Features",
        ShowTabTitle = true
    }),
    Fusion = Sections.Advanced:Tab({
        Title = "Fusion",
        Icon = "layers",
        Desc = "Neon/Mega Fusion",
        ShowTabTitle = true
    }),
    Progression = Sections.Advanced:Tab({
        Title = "Progression",
        Icon = "trending-up",
        Desc = "Idle & Tutorial",
        ShowTabTitle = true
    }),
    Misc = Sections.Advanced:Tab({
        Title = "Misc",
        Icon = "tool",
        Desc = "Other Features",
        ShowTabTitle = true
    }),
}

Tabs.Home:Paragraph({
    Title = "Pet Farm - WindUI Edition",
    Desc = "Complete Adopt Me farming script with:\n- Pet/Baby Auto Farm\n- Winter 2025 Events\n- Neon/Mega Fusion\n- Tutorial Auto-Complete\n- Anti-AFK & Anti-Rejoin"
})

Tabs.Home:Button({
    Title = "Claim Daily Reward",
    Desc = "Claim your daily login reward",
    Callback = claimDailyReward
})

Tabs.Home:Button({
    Title = "Dismiss Popups",
    Desc = "Close news and popup dialogs",
    Callback = function()
        pcall(function()
            if UIManager then
                UIManager.set_app_visibility("NewsApp", false)
                UIManager.set_app_visibility("DailyLoginApp", false)
            end
        end)
    end
})

Tabs.Home:Toggle({
    Title = "Anti-AFK",
    Desc = "Prevents being kicked for inactivity",
    Value = false,
    Callback = function(value)
        getgenv().AntiAFKEnabled = value
        if value then
            startAntiAFK()
        end
    end
})

Tabs.PetFarm:Paragraph({
    Title = "Pet Farm System",
    Desc = "Automatically takes care of all pet ailments including hungry, thirsty, sleepy, dirty, sick, play, walk, ride, and mystery tasks."
})

Tabs.PetFarm:Toggle({
    Title = "Start Pet Farm",
    Desc = "Enable automatic pet farming",
    Value = false,
    Callback = function(value)
        getgenv().PetFarmGuiStarter = value
        if value then
            task.spawn(function()
                startPetFarm()
            end)
        end
    end
})

Tabs.PetFarm:Button({
    Title = "Equip Best Pet",
    Desc = "Equip your highest level pet",
    Callback = function()
        equipPet()
    end
})

Tabs.PetFarm:Button({
    Title = "Create Farm Platform",
    Desc = "Creates a platform in the sky for farming",
    Callback = function()
        createPlatform()
        teleportPlayerNeeds(0, 350, 0)
    end
})

Tabs.BabyFarm:Paragraph({
    Title = "Baby Care System",
    Desc = "Handles baby ailments automatically including feeding, giving drinks, sleep, and healing."
})

Tabs.BabyFarm:Toggle({
    Title = "Start Baby Farm",
    Desc = "Enable automatic baby care",
    Value = false,
    Callback = function(value)
        getgenv().BabyFarmGuiStarter = value
    end
})

Tabs.Winter:Paragraph({
    Title = "Winter 2025 Event",
    Desc = "Special features for the Winter 2025 event in Adopt Me."
})

Tabs.Winter:Button({
    Title = "Claim Advent Calendar",
    Desc = "Claim today's advent calendar reward",
    Callback = claimAdventCalendar
})

Tabs.Fusion:Paragraph({
    Title = "Neon & Mega Fusion",
    Desc = "Automatically fuses pets into Neon and Mega versions when you have 4 of the same kind at full growth."
})

Tabs.Fusion:Toggle({
    Title = "Auto Fusion",
    Desc = "Automatically fuse pets into Neon/Mega",
    Value = false,
    Callback = function(value)
        getgenv().AutoFusionEnabled = value
    end
})

Tabs.Progression:Paragraph({
    Title = "Idle Progression",
    Desc = "Manages the idle pet progression system and automatically fills pens with matching pets."
})

Tabs.Progression:Toggle({
    Title = "Auto Idle Progression",
    Desc = "Automatically manage idle pet pens",
    Value = false,
    Callback = function(value)
        getgenv().IdleProgressionEnabled = value
    end
})

Tabs.Teleport:Paragraph({
    Title = "Teleport Features",
    Desc = "Teleport to various locations in the game."
})

Tabs.Teleport:Button({
    Title = "Teleport to Hospital",
    Desc = "Go to the hospital",
    Callback = function()
        game:GetService("ReplicatedStorage").API:FindFirstChild("LocationAPI/SetLocation"):FireServer("Hospital")
    end
})

Tabs.Teleport:Button({
    Title = "Teleport to Main Map",
    Desc = "Return to the main map",
    Callback = function()
        local LiveOpsMapSwap = require(game:GetService("ReplicatedStorage").SharedModules.Game.LiveOpsMapSwap)
        game:GetService("ReplicatedStorage").API:FindFirstChild("LocationAPI/SetLocation"):FireServer("MainMap",
        game:GetService("Players").LocalPlayer, LiveOpsMapSwap.get_current_map_type())
    end
})

Tabs.Teleport:Button({
    Title = "Teleport to Sky",
    Desc = "Teleport high up with platform",
    Callback = function()
        createPlatform()
        teleportPlayerNeeds(0, 350, 0)
    end
})

Tabs.Misc:Paragraph({
    Title = "Miscellaneous Features",
    Desc = "Additional utility features for the script."
})

Tabs.Misc:Button({
    Title = "Buy Farm Items",
    Desc = "Buy stroller and toy for farming",
    Callback = function()
        buyItems()
    end
})

Tabs.Misc:Button({
    Title = "Spawn Character",
    Desc = "Respawn your character",
    Callback = function()
        game:GetService("ReplicatedStorage"):WaitForChild("API"):WaitForChild("TeamAPI/Spawn"):InvokeServer()
    end
})

Tabs.Misc:Toggle({
    Title = "Remove Billboards",
    Desc = "Remove XP and Bucks billboards",
    Value = false,
    Callback = function(value)
        if value then
            task.spawn(function()
                while value do
                    for _, obj in ipairs(workspace:GetDescendants()) do
                        if obj.Name == "BucksBillboard" or obj.Name == "XPBillboard" then
                            obj:Destroy()
                        end
                    end
                    task.wait(0.5)
                end
            end)
        end
    end
})

print("Pet Farm WindUI Script Loaded Successfully!")
