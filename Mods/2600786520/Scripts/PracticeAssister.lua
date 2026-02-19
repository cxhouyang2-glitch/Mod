local PracticeAssister = GameMain:NewMod("PracticeAssister") -- 先注册一个新的MOD模块

local SaveData = {}

function PracticeAssister:OnInit()

    -- self:InitEvents()

    SaveData = SaveData or {}

    local practiceAssisterWindow = self:GetPracticeAssisterWindow()
    practiceAssisterWindow:SetPASettings(SaveData.PASettings, SaveData.Roles,
                                         SaveData.RolesBack)
end

function PracticeAssister:InitEvents()

    local Event = GameMain:GetMod("_Event")

    local tbPracticeAssister = GameMain:GetMod("PracticeAssister")

    local NpcRank = CS.XiaWorld.g_emNpcRank.Disciple
    local ThingType = CS.XiaWorld.g_emThingType.Npc

    -- Event:RegisterEvent(g_emEvent.NpcPropertyChange, function(evt, item, objs)
    --     if item.Rank == NpcRank and item.ThingType == ThingType then
    --         tbPracticeAssister:NpcPropertyChange(evt, item, objs)
    --     end
    -- end, "PracticeAssister")

    -- Event:RegisterEvent(g_emEvent.NpcPracticeChange, function(evt, item, objs)
    --     if item.Rank == NpcRank and item.ThingType == ThingType then
    --         tbPracticeAssister:NpcPracticeChange(evt, item, objs)
    --     end
    -- end, "PracticeAssister")

end

function PracticeAssister:OnEnter()
    -- self:InitEvents()
    self.mod_enable = true

    if Map.World.GameMode == CS.XiaWorld.g_emGameMode.Fight then
        self.mod_enable = false
    end

end

function PracticeAssister:OnSetHotKey()
    -- ID为快捷键注册时的编码，编码需要是唯一的，不可为空
    -- Name为快捷键的名称，会显示到快捷键面板上，需要将本文件转换为UTF-8才可使用中文
    -- Type为快捷键所属类别，快捷键会根据类别自动分类，不可为空
    -- InitialKey1为快捷键的第一组按键，使用"+"进行连接组合键位，键位请阅读快捷键列表找到所需要的键盘编码，可以为空
    -- InitialKey2为快捷键的第二组按键，使用"+"进行连接组合键位，键位请阅读快捷键列表找到所需要的键盘编码，可以为空
    -- 快捷键有区分大小写，请按快捷键列表的键盘编码输入

    local tbHotKeys = {
        {
            ID = 'PracticeAssister',
            Name = '修炼辅助',
            Type = 'Mod',
            InitialKey1 = 'LeftShift + Q',
            InitialKey2 = 'RightShift + Q'
        }
    }

    return tbHotKeys
end

function PracticeAssister:OnHotKey(ID, State)
    -- ID为快捷键注册时的编码，系统识别快捷键的唯一标识
    -- state为快捷键当前操作状态，按下"down"，持续"stay"，离开"up"

    -- 在ID和state都对应的情况下，会执行此部分逻辑
    if ID == 'PracticeAssister' and State == 'down' then
        local MainWindow = self:GetPracticeAssisterWindow()
        if self.mod_enable then
            if MainWindow.window.isShowing then
                MainWindow:Hide()
            else
                MainWindow:Show()
            end
        end

    end
end

function PracticeAssister:OnStep(dt) -- 请谨慎处理step的逻辑，可能会影响游戏效率

    if self.mod_enable then
        local practiceAssisterWindow = self:GetPracticeAssisterWindow()

        practiceAssisterWindow:StartPracticeAssister()
    end

end

function PracticeAssister:OnLeave() end

function PracticeAssister:OnSave() -- 系统会将返回的table存档 table应该是纯粹的KV
    SaveData = {}
    local practiceAssisterWindow = self:GetPracticeAssisterWindow()
    SaveData.PASettings, SaveData.Roles, SaveData.RolesBack =
        practiceAssisterWindow:GetPASettings()
    return SaveData
end

function PracticeAssister:OnLoad(tbLoad) -- 读档时会将存档的table回调到这里
    SaveData = tbLoad or {}
    local practiceAssisterWindow = self:GetPracticeAssisterWindow()
    practiceAssisterWindow:SetPASettings(SaveData.PASettings, SaveData.Roles,
                                         SaveData.RolesBack)
end

function PracticeAssister:NeedSyncData() -- 切换地图的时候是否会同步数据，请谨慎使用
    return true
end

function PracticeAssister:OnSyncLoad(tbData) -- 切换地图的时候载入的数据
end

function PracticeAssister:OnSyncSave() -- 切换地图时传输的数据
end

function PracticeAssister:OnAfterLoad() -- 读档且所有系统准备完毕后，切换地图后也会调用
end

function PracticeAssister:GetPracticeAssisterWindow()
    local window = GameMain:GetMod('Windows'):GetWindow('MainWindow')
    repeat window = GameMain:GetMod('Windows'):GetWindow('MainWindow') until window
    return window
end
