--蛟龙技能水爆脚本
local tbTable = GameMain:GetMod("_SkillScript");
local tbSkill = tbTable:GetSkill("jiaolong_shuibao");

--技能在key点生效
function tbSkill:Apply(skilldef, key, from)
	--print(1)
	
end

--技能在fightbody身上生效
function tbSkill:FightBodyApply(skilldef, fightbody, from)
	--print(2)
end

--技能产生的子弹在pos点爆炸
function tbSkill:MissileBomb(skilldef, pos, from)	
	--print(3)
	local key = GridMgr:Pos2Grid(pos);
	if key <= 0 then
		return;
	end	
end

