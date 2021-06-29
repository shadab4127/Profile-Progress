({
	buttonAClicked : function(component, event, helper) {
		var evt = $A.get("e.c:TestingEvent");
        evt.setParams({
            "message": "Component A "
        });
        evt.fire();
	}
})