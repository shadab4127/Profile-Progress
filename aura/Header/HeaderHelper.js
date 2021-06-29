({
	updatePercentage : function(component,event,helper) {
		var action = component.get('c.getcalculateactual');
		action.setParams({
			"userId": $A.get("$SObjectType.CurrentUser.Id"),
		});
		action.setCallback(this, function (a) {
			if (a.getState() === 'SUCCESS') {
				var percVal = a.getReturnValue();
                component.set("v.Get_Result",percVal );
                console.log('percVal '+percVal);
			}
		});
		$A.enqueueAction(action);
	}
})