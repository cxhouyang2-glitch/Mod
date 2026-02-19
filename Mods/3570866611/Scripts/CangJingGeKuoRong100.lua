local CangJingGeKuoRong100 = GameMain:GetMod("CangJingGeKuoRong100");


function CangJingGeKuoRong100:OnEnter()
	--藏经阁建筑上限
	xlua.private_accessible(CS.CangJingGeMgr)
	CS.CangJingGeMgr.Instance.BOOK_SHELF_MEMORY = 10000
	CS.CangJingGeMgr.Instance:ResetBookSelf()
end