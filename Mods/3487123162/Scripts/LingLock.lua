local tbLingLock = GameMain:GetMod("LingLock");--先注册一个新的MOD模块
local agent = nil;
function tbLingLock:OnBeforeInit()
    print("LingLock BeforeInit");
    -- if mod == nil or mod.Local == true then
    --     self.checkHack = true
    --     world:ShowMsgBox("锁灵法座 不支持在本地或整合版使用，请到创意工坊订阅。","友情提示")
    --     return
    -- end
    if agent == nil then
        local mod = CS.ModsMgr.Instance:FindMod("LingLock","",true);
        local assembly = CS.System.Reflection.Assembly.LoadFrom(mod.Path.."\\Library\\LingLock.dll");
        local type = assembly:GetType("LingLock.Agent");
        agent = CS.System.Activator.CreateInstance(type);
        print("LingLock load_assembly");
    end
end

function tbLingLock:OnEnter()
    if agent ~= nil then
        agent:Enter();
    end
end

function tbLingLock:UnLock(building)
    if agent ~= nil then
        agent:SwitchLockState(building,false);
    end
end

function tbLingLock:Lock(building)
    if agent ~= nil then
        agent:SwitchLockState(building,true);
    end
end

function tbLingLock:OnStep()
    if agent ~= nil then
        agent:Step()
    end
end

function tbLingLock:OnSave()--系统会将返回的table存档 table应该是纯粹的KV
    if agent ~= nil then
        return agent:Save();
    end
end

function tbLingLock:OnLoad(tbLoad)--读档时会将存档的table回调到这里
    if agent ~= nil then
        agent:Load(tbLoad)
    end
end