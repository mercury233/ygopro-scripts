--ゲール・ドグラ
function c16229315.initial_effect(c)
	--to grave
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOGRAVE)
	e1:SetDescription(aux.Stringid(16229315,0))
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCost(c16229315.cost)
	e1:SetTarget(c16229315.target)
	e1:SetOperation(c16229315.operation)
	c:RegisterEffect(e1)
	if YGO233_TAG and not c16229315.global_check then
		c16229315.global_check=true
		Debug.Message("活动中「狂风毒蛾」效果在双打模式改为「支付6000基本分才能发动」，节日快乐！")
	end
end
function c16229315.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local cost=YGO233_TAG and 6000 or 3000
	if chk==0 then return Duel.CheckLPCost(tp,cost) end
	Duel.PayLPCost(tp,cost)
end
function c16229315.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToGrave,tp,LOCATION_EXTRA,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_EXTRA)
end
function c16229315.operation(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,Card.IsAbleToGrave,tp,LOCATION_EXTRA,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoGrave(g,REASON_EFFECT)
	end
end
