--新建一个MOD
local Hui = GameMain:NewMod("解锁心仪之物")

--进入游戏后
function Hui:OnEnter()
	----第一步先获取所有门派势力 得到一个  Dictionary 表
	--	local AllSchool=CS.XiaWorld.SchoolGlobleMgr.m_mapSchoools
	--
	----第二遍历所有门派的首领
	--
	--	for i, v in pairs(AllSchool)  do
	----这里i是势力编号 v是势力数据  Leader 是首领
	--		local Leader=CS.XiaWorld.TradeMgr.Instance.SchoolTrade:Get(i).Leader
	--		if Leader ~= nil then
	--			CS.XiaWorld.JianghuMgr.Instance:KnowNpcAllData(Leader.lseed)
	--		end
	--	end
end

function Hui:OnInit()
	xlua.private_accessible(CS.Wnd_World)
	xlua.private_accessible(CS.Wnd_JianghuTalk)

	local tbEventMod = GameMain:GetMod("_Event")
	tbEventMod:RegisterEvent(g_emEvent.WindowEvent, self.OnWindowEvent, self)
end

function Hui:OnWindowEvent(pThing, pObjs)
	local pWnd = pObjs[0]
	local nArg = pObjs[1]

	if pWnd == CS.Wnd_World.Instance then
		if nArg == 1 then
			self:OnWorldWndShow()
		end
	end

	if pWnd == CS.Wnd_JianghuTalk.Instance then
		self:OnTalkWndShow()
	end
end

function Hui:OnWorldWndShow()
	local listChild = CS.Wnd_World.Instance.bnts
	for k, v in pairs(listChild) do
		v.onClick:Add(function()
			self:KnowLeaderAllData(k)
		end)
	end
end

function Hui:OnTalkWndShow()
	if self._bAddEvent4TalkWnd ~= true then
		self._bAddEvent4TalkWnd = true
		CS.Wnd_JianghuTalk.Instance.UIInfo.m_n89.onClick:Add(Hui.KnowNpcAllDataWhenTalk)
	end
end

function Hui:KnowLeaderAllData(strPlaceName)
	local pPlaceData = PlacesMgr:GetPlaceDef(strPlaceName)
	if pPlaceData == nil then
		return
	end
	local pLeader = CS.XiaWorld.TradeMgr.Instance.SchoolTrade:Get(pPlaceData.School).Leader
	if pLeader == nil then
		return
	end
	CS.XiaWorld.JianghuMgr.Instance:KnowNpcAllData(pLeader.lseed)
end

function Hui.KnowNpcAllDataWhenTalk()
	local nSeed = CS.Wnd_JianghuTalk.Instance.targetseed
	CS.XiaWorld.JianghuMgr.Instance:KnowNpcAllData(nSeed)
	CS.XiaWorld.JianghuMgr.Instance:AddKnowNpcData(nSeed, CS.XiaWorld.g_emJHNpcDataType.None, 100)
end

--就是这么简单粗暴

