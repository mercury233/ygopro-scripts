--混沌帝龍 －終焉の使者－
function c82301904.initial_effect(c)
	c:EnableReviveLimit()
	--special summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(82301904,0))
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e2:SetRange(LOCATION_HAND)
	e2:SetCondition(c82301904.spcon)
	e2:SetOperation(c82301904.spop)
	c:RegisterEffect(e2)
	--to grave
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(82301904,1))
	e3:SetCategory(CATEGORY_TOGRAVE+CATEGORY_DAMAGE)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCost(c82301904.sgcost)
	e3:SetTarget(c82301904.sgtg)
	e3:SetOperation(c82301904.sgop)
	c:RegisterEffect(e3)
end
function c82301904.spcostfilter(c)
	return c:IsAbleToRemoveAsCost() and c:IsAttribute(ATTRIBUTE_LIGHT+ATTRIBUTE_DARK)
end
function c82301904.spcost_selector(c,tp,g,sg,i)
	sg:AddCard(c)
	g:RemoveCard(c)
	local flag=false
	if i<2 then
		flag=g:IsExists(c82301904.spcost_selector,1,nil,tp,g,sg,i+1)
	else
		flag=sg:FilterCount(Card.IsAttribute,nil,ATTRIBUTE_LIGHT)>0
			and sg:FilterCount(Card.IsAttribute,nil,ATTRIBUTE_DARK)>0
	end
	sg:RemoveCard(c)
	g:AddCard(c)
	return flag
end
function c82301904.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	if Duel.GetMZoneCount(tp)<=0 then return false end
	local g=Duel.GetMatchingGroup(c82301904.spcostfilter,tp,LOCATION_GRAVE,0,nil)
	local sg=Group.CreateGroup()
	return g:IsExists(c82301904.spcost_selector,1,nil,tp,g,sg,1)
end
function c82301904.spop(e,tp,eg,ep,ev,re,r,rp,c)
	local g=Duel.GetMatchingGroup(c82301904.spcostfilter,tp,LOCATION_GRAVE,0,nil)
	local sg=Group.CreateGroup()
	for i=1,2 do
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local g1=g:FilterSelect(tp,c82301904.spcost_selector,1,1,nil,tp,g,sg,i)
		sg:Merge(g1)
		g:Sub(g1)
	end
	Duel.Remove(sg,POS_FACEUP,REASON_COST)
end
function c82301904.sgcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLPCost(tp,1000) end
	Duel.PayLPCost(tp,1000)
end
function c82301904.sgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local g=Duel.GetFieldGroup(tp,0xe,0xe)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,g,g:GetCount(),0,0)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,0,0,1-tp,g:GetCount()*300)
end
function c82301904.sgop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetFieldGroup(tp,0xe,0xe)
	Duel.SendtoGrave(g,REASON_EFFECT)
	local og=Duel.GetOperatedGroup()
	local ct=og:FilterCount(Card.IsLocation,nil,LOCATION_GRAVE)
	Duel.BreakEffect()
	Duel.Damage(1-tp,ct*300,REASON_EFFECT)
end
