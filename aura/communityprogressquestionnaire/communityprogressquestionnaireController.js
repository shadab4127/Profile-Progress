({
	doInit: function (component, event, helper) {
		helper.computeProgress(component, event, helper);
		helper.padding(component, event, helper);
	},
	doHandleFromChild: function (component, event, helper) {
		var percVal = event.getParam("storeMessage");
		var progressVal = parseInt((percVal / 100) * 360);
		component.set("v.cirDeg", progressVal);
        component.set("v.perTexts", parseInt(percVal) + '%');
        setTimeout(function(){
			component.set("v.perText", parseInt(percVal) + '%');
			component.set("v.isVisible", percVal.toString()==='100'? true:false);
        },1200); 
	}
})