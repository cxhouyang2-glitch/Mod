-- 先注册一个新的MOD模块
local Windows = GameMain:GetMod('Windows')

local PA = Windows:CreateWindow('MainWindow')

local PASettings = nil

local PAPlayerOfDisciple = nil

local PAPlayerOfDiscipleBack = nil

local PAPlayerOfWorker = {}

xlua.private_accessible(CS.XiaWorld.RemoteStorage)
xlua.private_accessible(CS.XiaWorld.CommandEatItem)

-- xlua.private_accessible(CS.XiaWorld.UILogicMode_IndividualCommand)

-- 丹药数据
---@type table<string, table<string, string>>
local tbBuffItem = {
    ['qingxin'] = {'Dan_CalmDown', 'Item_Dan_CalmDown'},
    ['huangya'] = {'Dan_PracticeSpeed', 'Item_Dan_PracticeSpeed'},
    ['yinqi'] = {'Dan_NoHunger', 'Item_Dan_NoHunger'},
    ['jingyuan'] = {'Modifier_Dan_JingYuan', 'Item_Dan_JingYuan'},
    ['shenzhijiuqiaowan'] = {'Modifier_Dan_JingYuan2', 'Item_Dan_JingYuan2'},
    ['xuejiesan'] = {'Modifier_Dan_JingYuan3', 'Item_Dan_JingYuan3'},
    ['lingshi'] = {'Dan_LingStone', 'Item_LingStone'},
    ['lingjing'] = {'Dan_LingCrystal', 'Item_LingCrystal'}
}

function PA:OnInit()
    -- 载入UI包里的窗口
    self.window.contentPane = UIPackage.CreateObject('PracticeAssister',
                                                     'MainWindow')
    self.window.closeButton = self:GetChild('frame'):GetChild('n5')
    self:GetChild('frame'):GetChild('title').text = '修炼辅助'
    self.RoleList = self:GetChild('RoleList')
    self.RoleList:RemoveChildrenToPool()
    self.window:Center()
end

function PA:OnShown()
    -- print('[color=#acacac]Shown[/color]')
    print(PASettings.PAIsOpenPracticeAssister)
    self:LoadPlayers()

end

function PA:OnShowUpdate()
    -- print('[color=#000000]ShowUpdate[/color]')
    self:PAEventListener("Add")
end

function PA:OnUpdate(dt)
    -- print('[color=#000000]Update[/color]')
end

function PA:OnHide()
    -- print('[color=#000000]Hide[/color]')

    self:SetMindValue()

    self:SavePAPlayerOfDisciple()

    self:PAEventListener("Remove")

end

-- 初始化所有内门弟子数据
function PA:InitPlayerData()

    PAPlayerOfDisciple = nil

    PAPlayerOfDiscipleBack = nil

    local settings = {}

    settings.PAIsOpenPracticeAssister = false
    settings.PAIsOnlyPractice = false
    settings.PAIsOnlyPracticeBack = false
    settings.MinMind = 60
    settings.MaxMind = 80
    settings.NPCIsOnlyPractice = false
    settings.PlayerOfDiscipleCount = 0

    local players = {}

    local npcs = Map.Things:GetActiveNpcs(g_emNpcRaceType.Wisdom,
                                          g_emFightCamp.Player)

    local count = 0
    for _, npc in pairs(npcs) do

        if self:IsValidNpc(npc) and self:IsValidDisciple(npc) then
            count = count + 1
            local strID = tostring(npc.ID)
            local player = self:CreatePlayerInfo(npc)
            players[strID] = player
        end
    end

    if count > 0 then
        settings.PlayerOfDiscipleCount = count

        PASettings = settings

        PAPlayerOfDisciple = players

        PAPlayerOfDiscipleBack = PAPlayerOfDisciple

    end
end

-- 创建指定弟子数据
function PA:CreatePlayerInfo(npc)
    local player = {}

    local strID = tostring(npc.ID)

    player.data = strID

    player.PARoleName = npc.Name

    player.PAYQD = false

    player.PAQXD = false

    player.PAJYD = false

    player.PAXJS = false

    player.PASZJQW = false

    player.PAHYD = false

    player.PALS = false

    player.PALJ = false

    player.PANPCIsOnlyPractice = false

    player.PAPracticeMode = 0

    return player
end

-- 加载所有内门弟子
function PA:LoadPlayers()

    local settings = PASettings

    if not settings then
        PA:InitPlayerData()
        settings = PASettings
    end

    local paIsOpen = self:GetChild("PAIsOpenPracticeAssister")
    paIsOpen.selected = settings.PAIsOpenPracticeAssister or paIsOpen.selected

    local paPAIsOnlyPractice = self:GetChild("PAIsOnlyPractice")
    paPAIsOnlyPractice.selected = settings.PAIsOnlyPractice or
                                      paPAIsOnlyPractice.selected

    local minValue = self:GetChild('PAMinValue'):GetChild('title')
    minValue.text = settings.MinMind

    local maxValue = self:GetChild('PAMaxValue'):GetChild('title')
    maxValue.text = settings.MaxMind

    if paIsOpen.selected then
        paPAIsOnlyPractice.touchable = true
        minValue.touchable = true
        maxValue.touchable = true
    else
        paPAIsOnlyPractice.touchable = false
        minValue.touchable = false
        maxValue.touchable = false
    end

    self.RoleList:RemoveChildrenToPool()

    self:GetPlayerActiveNpcs()

end

-- 获取所有的弟子
function PA:GetPlayerActiveNpcs()

    local npcs = Map.Things:GetActiveNpcs(g_emNpcRaceType.Wisdom,
                                          g_emFightCamp.Player)
    for _, npc in pairs(npcs) do

        if self:IsValidNpc(npc) and self:IsValidDisciple(npc) then

            local item = self.RoleList:AddItemFromPool('ui://o2dlqluhgx61m')

            local paRoleName = item:GetChild('PARoleName')
            paRoleName.touchable = false
            paRoleName.text = npc.Name

            local paQXD = item:GetChild('PAQXD')
            local paHYD = item:GetChild('PAHYD')
            local paYQD = item:GetChild('PAYQD')
            local paJYD = item:GetChild('PAJYD')
            local paSZJQW = item:GetChild('PASZJQW')
            local paXJS = item:GetChild('PAXJS')
            local paLS = item:GetChild('PALS')
            local paLJ = item:GetChild('PALJ')
            local paNPCIsOnlyPractice = item:GetChild('PANPCIsOnlyPractice')
            local paPracticeMode = item:GetChild("PAPracticeMode")

            -- 模式0=默认, 模式1=修行调心, 模式2=练功调心
            paPracticeMode.items = {
                '默认模式', '自动修炼模式', '自动练功模式'
            }
            paPracticeMode.values = {0, 1, 2}

            local strID = tostring(npc.ID)

            item.data = strID
            item.name = strID

            paQXD.data = strID
            paHYD.data = strID
            paYQD.data = strID
            paJYD.data = strID
            paSZJQW.data = strID
            paXJS.data = strID
            paLS.data = strID
            paLJ.data = strID
            paNPCIsOnlyPractice.data = strID
            paPracticeMode.data = strID

            if PAPlayerOfDisciple and PAPlayerOfDisciple[strID] then

                paQXD.selected = PAPlayerOfDisciple[strID].PAQXD
                paYQD.selected = PAPlayerOfDisciple[strID].PAYQD
                paHYD.selected = PAPlayerOfDisciple[strID].PAHYD
                paJYD.selected = PAPlayerOfDisciple[strID].PAJYD
                paSZJQW.selected = PAPlayerOfDisciple[strID].PASZJQW
                paXJS.selected = PAPlayerOfDisciple[strID].PAXJS
                paLS.selected = PAPlayerOfDisciple[strID].PALS
                paLJ.selected = PAPlayerOfDisciple[strID].PALJ
                paNPCIsOnlyPractice.selected =
                    PAPlayerOfDisciple[strID].PANPCIsOnlyPractice
                paPracticeMode.selectedIndex =
                    PAPlayerOfDisciple[strID].PAPracticeMode

                if PAPlayerOfDiscipleBack then
                    if not PAPlayerOfDiscipleBack[strID] then
                        PAPlayerOfDiscipleBack[strID] =
                            self:CreatePlayerInfo(npc)
                    end
                else
                    self:InitPlayerData()
                end

                if PASettings.PAIsOpenPracticeAssister then

                    paQXD.selected = PAPlayerOfDiscipleBack[strID].PAQXD
                    paYQD.selected = PAPlayerOfDiscipleBack[strID].PAYQD
                    paNPCIsOnlyPractice.selected =
                        PAPlayerOfDiscipleBack[strID].PANPCIsOnlyPractice
                    paPracticeMode.selectedIndex =
                        PAPlayerOfDiscipleBack[strID].PAPracticeMode

                    if paNPCIsOnlyPractice.selected then
                        paHYD.touchable = true
                        paJYD.touchable = true
                        paSZJQW.touchable = true
                        paXJS.touchable = true
                        paLS.touchable = true
                        paLJ.touchable = true

                        paHYD.selected = PAPlayerOfDiscipleBack[strID].PAHYD
                        paJYD.selected = PAPlayerOfDiscipleBack[strID].PAJYD
                        paSZJQW.selected = PAPlayerOfDiscipleBack[strID].PASZJQW
                        paXJS.selected = PAPlayerOfDiscipleBack[strID].PAXJS
                        paLS.selected = PAPlayerOfDiscipleBack[strID].PALS
                        paLJ.selected = PAPlayerOfDiscipleBack[strID].PALJ

                    else
                        paHYD.touchable = false
                        paJYD.touchable = false
                        paSZJQW.touchable = false
                        paXJS.touchable = false
                        paLS.touchable = false
                        paLJ.touchable = false

                    end

                else
                    paQXD.touchable = false
                    paHYD.touchable = false
                    paYQD.touchable = false
                    paJYD.touchable = false
                    paSZJQW.touchable = false
                    paXJS.touchable = false
                    paLS.touchable = false
                    paLJ.touchable = false
                    paNPCIsOnlyPractice.touchable = false
                    paPracticeMode.touchable = false

                end
            end

        end
    end
end

-- 保存所有弟子数据
function PA:SavePAPlayerOfDisciple()

    local settings = PASettings or {}

    PAPlayerOfDisciple = nil

    local paISOpen = self:GetChild("PAIsOpenPracticeAssister")
    settings.PAIsOpenPracticeAssister = paISOpen.selected

    local paPAIsOnlyPractice = self:GetChild("PAIsOnlyPractice")
    settings.PAIsOnlyPractice = paPAIsOnlyPractice.selected

    local minValue = self:GetChild('PAMinValue'):GetChild('title')
    settings.MinMind = minValue.text

    local maxValue = self:GetChild('PAMaxValue'):GetChild('title')
    settings.MaxMind = maxValue.text

    local tempRoles = {}
    local itemList = self.RoleList:GetChildren()

    if itemList.Length > 0 then
        for i = 0, itemList.Length - 1 do
            local item = itemList[i]
            local paRoleName = item:GetChild('PARoleName')
            local paQXD = item:GetChild('PAQXD')
            local paHYD = item:GetChild('PAHYD')
            local paYQD = item:GetChild('PAYQD')
            local paJYD = item:GetChild('PAJYD')
            local paSZJQW = item:GetChild('PASZJQW')
            local paXJS = item:GetChild('PAXJS')
            local paLS = item:GetChild('PALS')
            local paLJ = item:GetChild('PALJ')
            local paNPCIsOnlyPractice = item:GetChild('PANPCIsOnlyPractice')
            local paPracticeMode = item:GetChild("PAPracticeMode")

            local itemStates = {}
            itemStates.PAQXD = paQXD.selected
            itemStates.PAYQD = paYQD.selected

            itemStates.PANPCIsOnlyPractice = paNPCIsOnlyPractice.selected

            itemStates.PAPracticeMode = paPracticeMode.selectedIndex
            itemStates.PAHYD = paHYD.selected
            itemStates.PAJYD = paJYD.selected
            itemStates.PASZJQW = paSZJQW.selected
            itemStates.PAXJS = paXJS.selected
            itemStates.PALS = paLS.selected
            itemStates.PALJ = paLJ.selected

            tempRoles[item.data] = itemStates

        end
    end

    PASettings = settings

    PAPlayerOfDisciple = tempRoles
    if not PAPlayerOfDiscipleBack then
        PAPlayerOfDiscipleBack = PAPlayerOfDisciple
    end
end

-- 添加事件监听
function PA:PAEventListener(mode)

    local paIsOpen = self:GetChild("PAIsOpenPracticeAssister")

    local tbPAIsOnlyPractice = self:GetChild("PAIsOnlyPractice")

    if mode == "Add" then
        paIsOpen.onChanged:Add(OnChangedPAIsOpenAutoRactice)
        tbPAIsOnlyPractice.onChanged:Add(OnChangedPAIsOnlyPractice)

    elseif mode == "Remove" then
        paIsOpen.onChanged:Remove(OnChangedPAIsOpenAutoRactice)
        tbPAIsOnlyPractice.onChanged:Remove(OnChangedPAIsOnlyPractice)

    end

    local itemList = self.RoleList:GetChildren()

    for i = 0, itemList.Length - 1 do
        local item = itemList[i]
        local tbPracticeMode = item:GetChild("PAPracticeMode")
        local tbPANPCIsOnlyPractice = item:GetChild('PANPCIsOnlyPractice')
        local paQXD = item:GetChild('PAQXD')
        local paHYD = item:GetChild('PAHYD')
        local paYQD = item:GetChild('PAYQD')
        local paJYD = item:GetChild('PAJYD')
        local paSZJQW = item:GetChild('PASZJQW')
        local paXJS = item:GetChild('PAXJS')
        local paLS = item:GetChild('PALS')
        local paLJ = item:GetChild('PALJ')

        if mode == "Remove" then
            tbPracticeMode.onChanged:Remove(OnChangedPAPracticeMode)
            tbPANPCIsOnlyPractice.onChanged:Remove(OnChangedPANPCIsOnlyPractice)
            paQXD.onChanged:Remove(OnChangedItemSelect)
            paHYD.onChanged:Remove(OnChangedItemSelect)
            paYQD.onChanged:Remove(OnChangedItemSelect)
            paJYD.onChanged:Remove(OnChangedItemSelect)
            paSZJQW.onChanged:Remove(OnChangedItemSelect)
            paXJS.onChanged:Remove(OnChangedItemSelect)
            paLS.onChanged:Remove(OnChangedItemSelect)
            paLJ.onChanged:Remove(OnChangedItemSelect)
        elseif mode == "Add" then
            tbPracticeMode.onChanged:Add(OnChangedPAPracticeMode)
            tbPANPCIsOnlyPractice.onChanged:Add(OnChangedPANPCIsOnlyPractice)
            paQXD.onChanged:Add(OnChangedItemSelect)
            paHYD.onChanged:Add(OnChangedItemSelect)
            paYQD.onChanged:Add(OnChangedItemSelect)
            paJYD.onChanged:Add(OnChangedItemSelect)
            paSZJQW.onChanged:Add(OnChangedItemSelect)
            paXJS.onChanged:Add(OnChangedItemSelect)
            paLS.onChanged:Add(OnChangedItemSelect)
            paLJ.onChanged:Add(OnChangedItemSelect)
        end
    end
end

-- 检测NPC可用性
function PA:IsValidNpc(npc)
    local Enum = CS.XiaWorld
    if not npc.IsValid or npc.IsGod or npc.IsDeath or npc.IsPuppet or
        npc.IsZombie or npc.IsVistor then
        return false
    elseif npc.GongKind == Enum.g_emGongKind.Body or npc.GongKind ==
        Enum.g_emGongKind.God then
        return false
        --[[elseif npc.PropertyMgr.Practice.GongStateLevel == Enum.g_emGongStageLevel.None then
		return]]
    end
    return true
end

-- 检测外门弟子
function PA:IsValidWorker(npc)
    if not self:IsValidNpc(npc) then return false end
    if npc.Rank ~= g_emNpcRank.Worker then return false end
    return true
end

-- 检测内门弟子
function PA:IsValidDisciple(npc)
    if not self:IsValidNpc(npc) then return false end
    if npc.Rank ~= g_emNpcRank.Disciple then return false end
    return true
end

-- 设置MOD选项
function PA:SetPASettings(tbPASettings, tbRoles, tbRolesBack)
    PASettings = tbPASettings
    PAPlayerOfDisciple = tbRoles
    PAPlayerOfDiscipleBack = tbRolesBack
end

-- 获取MOD选项
function PA:GetPASettings()
    return PASettings, PAPlayerOfDisciple, PAPlayerOfDiscipleBack
end

-- 获取外门角色数据
function PA:GetPAPlayerRolesOfWorker() return PAPlayerOfWorker end

-- 更改NPC行为模式（内门弟子）
function PA:ChangePracticeMode(npc, PracticeMode)
    if self:IsValidNpc(npc) and self:IsValidDisciple(npc) then
        local npcPracticeMode = npc.PropertyMgr.Practice
        if PracticeMode == 'Practice' then
            npcPracticeMode:ChangeMode(CS.XiaWorld.g_emPracticeBehaviourKind
                                           .Practice) -- 修行模式
        elseif PracticeMode == 'Skill' then
            npcPracticeMode:ChangeMode(CS.XiaWorld.g_emPracticeBehaviourKind
                                           .Skill) -- 练功模式
        elseif PracticeMode == 'Quiet' then
            npcPracticeMode:ChangeMode(CS.XiaWorld.g_emPracticeBehaviourKind
                                           .Quiet) -- 调心模式
        elseif PracticeMode == 'None' then
            npcPracticeMode:ChangeMode(CS.XiaWorld.g_emPracticeBehaviourKind
                                           .None) -- 自动模式
        end
    end
end

-- 自动调心（内门弟子）
function PA:DecidePractice(strID, player)
    if strID then
        local id = tostring(strID)
        local npc = Map.Things:GetNpcByID(id)

        if npc and npc.Camp == g_emFightCamp.Player and npc.ViewRaceType ==
            g_emNpcRaceType.Wisdom and self:IsValidNpc(npc) and
            self:IsValidDisciple(npc) and npc.PropertyMgr.Practice.IsZhuJi then

            player = player or PAPlayerOfDisciple[strID]
            local paPracticeMode = player.PAPracticeMode
            if npc.CanDoAction then
                local MindState = npc.Needs:GetNeedValue('MindState')
                local npcPracticeMode = npc.PropertyMgr.Practice.PracticeMode
                local Job = npc.JobEngine.CurJob -- 取NPC当前工作
                local JobType = nil
                if Job ~= nil and Job.jobdef ~= nil then
                    JobType = Job.jobdef.Name
                end

                if paPracticeMode == 1 then -- 自动修行调心模式

                    if MindState < tonumber(PASettings.MinMind) then -- 心境低于设定
                        if npcPracticeMode ~=
                            CS.XiaWorld.g_emPracticeBehaviourKind.Quiet then -- 如果不在调心模式，则切换到调心模式
                            self:ChangePracticeMode(npc, 'Quiet')

                            if JobType == 'JobPractice' or JobType ==
                                'JobPracticeSkill' then -- 如果还在修行状态，则打断
                                Job:InterruptJob()
                            end
                        end
                    elseif MindState > tonumber(PASettings.MaxMind) then -- 心境高于设定
                        if npcPracticeMode ~=
                            CS.XiaWorld.g_emPracticeBehaviourKind.Practice then -- 如果不在修行模式，则切换到修行模式
                            self:ChangePracticeMode(npc, 'Practice')

                            if JobType == 'JobLookAtSky' then
                                Job:InterruptJob()
                            end

                        end

                    else -- 如果心境值处于区间段，但既不在修行，也不在调心，则切换到调心模式。
                        if npcPracticeMode ~=
                            CS.XiaWorld.g_emPracticeBehaviourKind.Practice and
                            npcPracticeMode ~=
                            CS.XiaWorld.g_emPracticeBehaviourKind.Quiet then

                            self:ChangePracticeMode(npc, 'Quiet')

                            if JobType == 'JobPractice' or JobType ==
                                'JobPracticeSkill' then
                                Job:InterruptJob()
                            end
                        end
                    end

                elseif paPracticeMode == 2 then -- 自动练功调心模式
                    if MindState <= tonumber(PASettings.MinMind) then -- 心境低于设定
                        if npcPracticeMode ~=
                            CS.XiaWorld.g_emPracticeBehaviourKind.Quiet then -- 如果不在调心模式，则切换到调心模式
                            self:ChangePracticeMode(npc, 'Quiet')

                            if JobType == 'JobPractice' or JobType ==
                                'JobPracticeSkill' then
                                Job:InterruptJob()
                            end
                        end

                    elseif MindState >= tonumber(PASettings.MaxMind) then -- 心境高于设定
                        if npcPracticeMode ~=
                            CS.XiaWorld.g_emPracticeBehaviourKind.Skill then -- 如果不在练功模式，则切换到练功模式
                            self:ChangePracticeMode(npc, 'Skill')
                        end
                    else -- 如果心境值处于区间段，但既不在练功，也不在调心，则切换到调心模式。
                        if npcPracticeMode ~=
                            CS.XiaWorld.g_emPracticeBehaviourKind.Skill and
                            npcPracticeMode ~=
                            CS.XiaWorld.g_emPracticeBehaviourKind.Quiet then
                            self:ChangePracticeMode(npc, 'Quiet')

                            if JobType == 'JobPractice' or JobType ==
                                'JobPracticeSkill' then
                                Job:InterruptJob()
                            end
                        end

                    end
                else
                    -- self:ChangePracticeMode(npc, 'None')

                    -- if JobType == 'JobPractice' or JobType == 'JobLookAtSky' or
                    --     JobType == 'JobPracticeSkill' then
                    --     Job:InterruptJob()
                    -- end
                end

                self:DoEatItem(npc, player)
            end
        end
    end
end

-- 处理NPC吃药
function PA:DoEatItem(npc, player)
    if npc.CanDoAction then
        local CanEatItem = true
        local strID = tostring(npc.ID)
        -- local npcItem = self.RoleList:GetChild(strID)
        local item = nil

        if PASettings.PAIsOnlyPractice then
            local npcPracticeMode = npc.PropertyMgr.Practice.PracticeMode
            if npcPracticeMode == CS.XiaWorld.g_emPracticeBehaviourKind.Practice then
                CanEatItem = true
            else
                CanEatItem = false
            end

            if CanEatItem then

                local mindState = npc.Needs:GetNeedValue('MindState')
                if mindState < tonumber(PASettings.MaxMind) then
                    item = player.PAQXD or nil
                    if item then
                        self:AddEatCommand(npc, 'qingxin')
                    end
                end

                item = player.PAHYD or nil
                if item then self:AddEatCommand(npc, 'huangya') end

                item = player.PAYQD or nil
                if item then self:AddEatCommand(npc, 'yinqi') end

                item = player.PAJYD or nil
                if item then self:AddEatCommand(npc, 'jingyuan') end

                item = player.PASZJQW or nil
                if item then
                    self:AddEatCommand(npc, 'shenzhijiuqiaowan')
                end

                item = player.PAXJS or nil
                if item then self:AddEatCommand(npc, 'xuejiesan') end

                item = player.PALS or nil
                if item then self:AddEatCommand(npc, 'lingshi') end

                item = player.PALJ or nil
                if item then self:AddEatCommand(npc, 'lingjing') end
            end
        else
            if CanEatItem then

                local mindState = npc.Needs:GetNeedValue('MindState')
                if mindState < tonumber(PASettings.MaxMind) then
                    item = player.PAQXD or nil
                    if item then
                        self:AddEatCommand(npc, 'qingxin')
                    end
                end

                item = player.PAYQD or nil
                if item then self:AddEatCommand(npc, 'yinqi') end
            end
        end
    end

end

-- 添加NPC吃药行为
function PA:AddEatCommand(npc, Buff)
    local strBuffName, strItemName = table.unpack(tbBuffItem[Buff])

    if strBuffName == nil or strItemName == nil then return end

    if npc.PropertyMgr:FindModifier(strBuffName) ~= nil then return end

    local listCmd = npc:CheckCommand("EatItem", true) or {}
    for _, pCmd in pairs(listCmd) do
        if pCmd.item.def.Name == strItemName then return end
    end

    local pItem = nil

    if strItemName == 'Item_LingStone' then
        local pRemoteStorage = Map.SpaceRing
        local pNearestStorageBuilding = pRemoteStorage:GetNearestWorkThing(
                                            npc.Pos)
        if pRemoteStorage.CanUse then
            local listItem = pRemoteStorage:TakeOut(strItemName, 1, npc.Key,
                                                    pNearestStorageBuilding.Pos)
            if listItem ~= nil then pItem = listItem[0] end
        end
    end

    if pItem == nil then
        pItem = Map.Things:FindItem(npc, 9999, strItemName, 0, false, null, 0,
                                    9999, null, false)
    end

    if pItem == nil then return end

    npc:AddCommandIfNotExist('EatItem', pItem)
end

-- 设置心境区间
function PA:SetMindValue()
    if PASettings then
        local minValue = self:GetChild('PAMinValue'):GetChild('title')
        local minv = tonumber(minValue.text)
        if minv then
            PASettings.MinMind = minv
        else
            PASettings.MinMind = 60
        end
        local maxValue = self:GetChild('PAMaxValue'):GetChild('title')
        local maxv = tonumber(maxValue.text)
        if maxv then
            PASettings.MaxMind = maxv
        else
            PASettings.MaxMind = 80
        end
        if PASettings.MinMind < 10 then PASettings.MinMind = 10 end
        if PASettings.MaxMind > 300 then PASettings.MaxMind = 250 end
        if PASettings.MaxMind <= PASettings.MinMind then
            PASettings.MaxMind = PASettings.MinMind + 1
        end
    end
end

-- 设置角色修炼方式
function PA:SetNpcPracticeMode(strID, player)

    if PASettings.PAIsOpenPracticeAssister then

        local id = tostring(strID)

        local npc = Map.Things:GetNpcByID(id)

        local tbPAPracticeMode = self.RoleList:GetChild(strID):GetChild(
                                     "PAPracticeMode")

        -- 当手动选择角色修炼模式为默认的时候，调整MOD
        if npc.PropertyMgr.Practice.PracticeMode ==
            CS.XiaWorld.g_emPracticeBehaviourKind.None and player.PAPracticeMode ~=
            0 and tbPAPracticeMode.selectedIndex ~= 0 then
            tbPAPracticeMode.selectedIndex = 0
            player.PAPracticeMode = 0
            PAPlayerOfDiscipleBack[strID].PAPracticeMode = 0
        end
        -- 当手动选择角色修炼模式为修行、调心、练功的时候，根据是否开启修炼辅助自动调整模式

    end

end

-- MOD功能开关切换
function OnChangedPAIsOpenAutoRactice(context)
    PA:ToggledPAIsOpenAutoRactice(context)
end

function PA:ToggledPAIsOpenAutoRactice(context)

    local selected = context.initiator.selected

    local paPAIsOnlyPractice = PA:GetChild("PAIsOnlyPractice")
    local minValue = PA:GetChild('PAMinValue')
    local maxValue = PA:GetChild('PAMaxValue')

    if selected then

        PAPlayerOfDisciple = PAPlayerOfDiscipleBack

    else
        PAPlayerOfDiscipleBack = PAPlayerOfDisciple
        PASettings.PAIsOnlyPractice = paPAIsOnlyPractice.selected
    end

    local itemList = PA.RoleList:GetChildren()
    if itemList.Length > 0 then
        for i = 0, itemList.Length - 1 do
            local item = itemList[i]
            local paRoleName = item:GetChild('PARoleName')
            local paQXD = item:GetChild('PAQXD')
            local paHYD = item:GetChild('PAHYD')
            local paYQD = item:GetChild('PAYQD')
            local paJYD = item:GetChild('PAJYD')
            local paSZJQW = item:GetChild('PASZJQW')
            local paXJS = item:GetChild('PAXJS')
            local paLS = item:GetChild('PALS')
            local paLJ = item:GetChild('PALJ')
            local paNPCIsOnlyPractice = item:GetChild('PANPCIsOnlyPractice')
            local paPracticeMode = item:GetChild("PAPracticeMode")

            if not selected then

                paQXD.selected = false
                paHYD.selected = false
                paYQD.selected = false
                paJYD.selected = false
                paSZJQW.selected = false
                paXJS.selected = false
                paLS.selected = false
                paLJ.selected = false
                paNPCIsOnlyPractice.selected = false
                paPracticeMode.selectedIndex = 0

                paRoleName.touchable = false
                paQXD.touchable = false
                paYQD.touchable = false
                paHYD.touchable = false
                paJYD.touchable = false
                paSZJQW.touchable = false
                paXJS.touchable = false
                paLS.touchable = false
                paLJ.touchable = false
                paNPCIsOnlyPractice.touchable = false
                paPracticeMode.touchable = false

            else
                local roleItems = PAPlayerOfDiscipleBack[item.data]

                paQXD.touchable = true
                paYQD.touchable = true

                paPracticeMode.touchable = true
                paNPCIsOnlyPractice.touchable = true

                paQXD.selected = roleItems.PAQXD
                paYQD.selected = roleItems.PAYQD

                paNPCIsOnlyPractice.selected = roleItems.PANPCIsOnlyPractice

                if roleItems.PANPCIsOnlyPractice then

                    paHYD.touchable = true
                    paJYD.touchable = true
                    paSZJQW.touchable = true
                    paXJS.touchable = true
                    paLS.touchable = true
                    paLJ.touchable = true

                    paHYD.selected = roleItems.PAHYD
                    paLS.selected = roleItems.PALS
                    paLJ.selected = roleItems.PALJ
                    paJYD.selected = roleItems.PAJYD
                    paSZJQW.selected = roleItems.PASZJQW
                    paXJS.selected = roleItems.PAXJS
                end

            end
        end
    end

    if selected then

        paPAIsOnlyPractice.touchable = true
        paPAIsOnlyPractice.selected = PASettings.PAIsOnlyPracticeBack

        minValue.touchable = true
        maxValue.touchable = true

        PA:SetMindValue()

    else

        paPAIsOnlyPractice.selected = false
        paPAIsOnlyPractice.touchable = false

        minValue.touchable = false
        maxValue.touchable = false

    end

    self:SavePAPlayerOfDisciple()

end

-- “是否只在修行者中使用”开关切换
function OnChangedPAIsOnlyPractice(context) PA:ToggledPAIsOnlyPractice(context) end

function PA:ToggledPAIsOnlyPractice(context)

    PASettings.PAIsOnlyPractice = context.initiator.selected

    PASettings.PAIsOnlyPracticeBack = context.initiator.selected

end

-- 子弟修行方式切换
function OnChangedPAPracticeMode(context) PA:ToggledPAPracticeMode(context) end

function PA:ToggledPAPracticeMode(context)
    local strID = context.initiator.data
    local id = tonumber(strID)
    PAPlayerOfDisciple[strID].PAPracticeMode = context.initiator.selectedIndex
    PAPlayerOfDiscipleBack[strID].PAPracticeMode = context.initiator
                                                       .selectedIndex

    local npc = Map.Things:GetNpcByID(id)

    if context.initiator.selectedIndex == 0 then
        self:ChangePracticeMode(npc, 'None')
    elseif context.initiator.selectedIndex == 1 then
        self:ChangePracticeMode(npc, 'Practice')
    elseif context.initiator.selectedIndex == 2 then
        self:ChangePracticeMode(npc, 'Skill')
    end

end

-- 在修炼中使用一些修炼药物开关切换
function OnChangedPANPCIsOnlyPractice(context)
    PA:TogglePANPCIsOnlyPractice(context)
end

function PA:TogglePANPCIsOnlyPractice(context)

    local strID = context.initiator.data

    local roleItems = context.initiator.parent

    local selected = context.initiator.selected

    PAPlayerOfDisciple[strID].PANPCIsOnlyPractice = context.initiator.selected
    PAPlayerOfDiscipleBack[strID].PANPCIsOnlyPractice = context.initiator
                                                            .selected

    local paHYD = roleItems:GetChild('PAHYD')
    local paLS = roleItems:GetChild('PALS')
    local paLJ = roleItems:GetChild('PALJ')
    local paJYD = roleItems:GetChild('PAJYD')
    local paSZJQW = roleItems:GetChild('PASZJQW')
    local paXJS = roleItems:GetChild('PAXJS')

    if not selected then

        paHYD.selected = false
        paLS.selected = false
        paLJ.selected = false
        paJYD.selected = false
        paSZJQW.selected = false
        paXJS.selected = false

        paHYD.touchable = false
        paLS.touchable = false
        paLJ.touchable = false
        paJYD.touchable = false
        paSZJQW.touchable = false
        paXJS.touchable = false

    else
        paHYD.touchable = true
        paLS.touchable = true
        paLJ.touchable = true
        paJYD.touchable = true
        paSZJQW.touchable = true
        paXJS.touchable = true

        paHYD.selected = PAPlayerOfDiscipleBack[strID].PAHYD
        paLS.selected = PAPlayerOfDiscipleBack[strID].PALS
        paLJ.selected = PAPlayerOfDiscipleBack[strID].PALJ
        paJYD.selected = PAPlayerOfDiscipleBack[strID].PAJYD
        paSZJQW.selected = PAPlayerOfDiscipleBack[strID].PASZJQW
        paXJS.selected = PAPlayerOfDiscipleBack[strID].PAXJS

    end
end

-- 药品选择
function OnChangedItemSelect(context) PA:ToggledItemSelect(context) end

function PA:ToggledItemSelect(context)
    local strID = context.initiator.data
    local name = context.initiator.name
    local temp = PAPlayerOfDisciple[strID]
    temp[name] = context.initiator.selected
    PAPlayerOfDiscipleBack[strID][name] = context.initiator.selected
end

-- 开始运行
function PA:StartPracticeAssister()
    if PASettings and PASettings.PlayerOfDiscipleCount > 0 and
        PAPlayerOfDisciple then
        if PASettings.PAIsOpenPracticeAssister then
            for strID, player in pairs(PAPlayerOfDisciple) do
                if player.PAPracticeMode ~= 0 then
                    self:SetNpcPracticeMode(strID, player)
                    self:DecidePractice(strID, player)
                end
            end
        end
    else
        self:InitPlayerData()
    end
end
