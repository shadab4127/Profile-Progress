({
	doInit : function(component, event, helper) {
		var evt = $A.get("e.c:TestingEvent");
        evt.setParams({
            "message": "Component Loadad "
        });
        evt.fire();
	},
    buttonBClicked : function(component, event, helper) {
		var evt = $A.get("e.c:TestingEvent");
        evt.setParams({
            "message": "Component B "
        });
        evt.fire();
	}
})