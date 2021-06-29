({
	showToast: function (component, result, helper) {
        var results = result.match(/[A-Z][a-z]+|[0-9]+/g).join(" ");
		var toastEvent = $A.get("e.force:showToast");
		toastEvent.setParams({
			"title": "Success!",
			"message": "The user info has been updated successfully.",
			type: 'success',
		});
		toastEvent.fire();
	},
    docomputeProgress: function (component, event, helper) {
        var action = component.get('c.getcalculateactual');
		action.setParams({
			"userId": $A.get("$SObjectType.CurrentUser.Id"),
		});
		action.setCallback(this, function (a) {
			if (a.getState() === 'SUCCESS') {
				var percVal = a.getReturnValue();
				component.set("v.oldbadge",parseInt(percVal));
			}
		});
		$A.enqueueAction(action);
    },
	computeProgress: function (component, event, helper) {
        var action = component.get('c.getcalculateactual');
		action.setParams({
			"userId": $A.get("$SObjectType.CurrentUser.Id"),
		});
		action.setCallback(this, function (a) {
			if (a.getState() === 'SUCCESS') {
				var percVal = a.getReturnValue();
				component.set("v.newbadges", parseInt(percVal));
				var olds= component.get("v.oldbadge");
				var news = component.get("v.newbadges");
				if(olds !== news){
					this.creates(component, event, helper);
				} else {
					this.getBackToHome(component, event, helper);
				}
			}
		});
		$A.enqueueAction(action);
    },
	creates : function(component,event,helper){
        var Weightage= component.get("v.oldbadge");
        var action = component.get('c.createBadges');
        action.setParams({
            'Weightage' : Weightage
        });
        action.setCallback(this, function(response){
            var state = response.getState();
            if (state === "SUCCESS") {
				this.getBackToHome(component, event, helper);
                console.log('Result : '+state);
            }
        })
        $A.enqueueAction(action);           
    },
	getBackToHome : function(component, event, helper) {
        var urlString = window.location.href;
        var baseURL = urlString.substring(0, urlString.lastIndexOf("s/")+2);
        var urlEvent = $A.get("e.force:navigateToURL");
        urlEvent.setParams({ "url": baseURL+'profile/home' });   // Pass your community URL
        urlEvent.fire(); 
    },
})