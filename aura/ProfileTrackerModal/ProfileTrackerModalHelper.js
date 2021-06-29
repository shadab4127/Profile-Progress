({
	showToast: function (component, result, helper) {
        var results = result.match(/[A-Z][a-z]+|[0-9]+/g).join(" ");
		var toastEvent = $A.get("e.force:showToast");
		toastEvent.setParams({
			"title": "Success!",
			"message": "The " + results + " has been updated successfully.",
			type: 'success',
		});
		toastEvent.fire();
	},
	callParentMethod: function (component, event, helper) {
		var p = component.get("v.parent");
		p.parentMethod();
	},

})