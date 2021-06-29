({
	doInit: function (component, event, helper) {
		helper.computeProgress(component, event, helper);
		helper.padding(component, event, helper);
	},
	doHandleFromChild: function (component, event, helper) {
		var percVal = event.getParam("storeMessage");
        console.log('storeMessage',percVal);
		var progressVal = parseInt((percVal / 100) * 360);
		component.set("v.cirDeg", progressVal);
		component.set("v.perText", parseInt(percVal) + '%');
	},
    questionsDetails : function(component, event, helper) {
        var urlString = window.location.href;
        var baseURL = urlString.substring(0, urlString.lastIndexOf("s/")+2);
        var urlEvent = $A.get("e.force:navigateToURL");
        urlEvent.setParams({ "url": baseURL+"progress-bar-questions" });   // Pass your community URL
        urlEvent.fire(); 
    }
})