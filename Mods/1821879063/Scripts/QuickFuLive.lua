local Quick = GameMain:GetMod("QuickFuLive");
local time = 0;
local flag = 0;

function Quick:OnStep(dt)
if flag == 0 then
time = time + dt;
if time >= 10 then
flag = 1;
local GlobleDataMgr = CS.XiaWorld.GlobleDataMgr.Instance;
local count = 0;
for k, v in pairs(PracticeMgr.m_mapSpellDefs) do
local s , cv = GlobleDataMgr.FuSaves:TryGetValue(k)
if s and cv > 1 then
GlobleDataMgr.FuSaves:Remove(k)
end
GlobleDataMgr:SaveFuValue(k,1);
count = count + 1;
end
end
end
end

