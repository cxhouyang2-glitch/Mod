

--新建一个MOD
--local Hui=GameMain:NewMod("解锁心仪之物")

--进入游戏后
--function Hui:OnEnter()


--第一步先获取所有门派势力 得到一个  Dictionary 表
	--local AllSchool=CS.XiaWorld.SchoolGlobleMgr.m_mapSchoools

--第二遍历所有门派的首领

	--for i, v in pairs(AllSchool)  do 

--这里i是势力编号 v是势力数据  Leader 是首领
		--local Leader=CS.XiaWorld.TradeMgr.Instance.SchoolTrade:Get(i).Leader



		--if Leader ~= nil then
			
			--CS.XiaWorld.JianghuMgr.Instance:KnowNpcAllData(Leader.lseed)
			
			
			
		--end



	--end




--end

--就是这么简单粗暴

