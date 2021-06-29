({
	computeProgress: function (component, event, helper) {
		var action = component.get('c.getcalculateactual');
		action.setParams({
			"userId": $A.get("$SObjectType.CurrentUser.Id"),
		});
		action.setCallback(this, function (a) {
			if (a.getState() === 'SUCCESS') {
				var percVal = a.getReturnValue();
				var progressVal = parseInt((percVal / 100) * 360);
				var evt = $A.get("e.c:Result");
                evt.setParams({
                    "Pass_Result": percVal
                });
                evt.fire();
				component.set("v.cirDeg", progressVal);
				component.set("v.perText", parseInt(percVal) + '%');
                component.set("v.isVisible", percVal.toString()==='100'? true:false);
			}
		});
		$A.enqueueAction(action);
	},
	padding: function (component, event, helper) {
		var getvalue = component.get('v.boxPadding');
		if (getvalue === false) {
			var cmpDiv = component.find('hwDiv');
			$A.util.removeClass(cmpDiv, 'slds-m-around_x-small');
		}
	}

})