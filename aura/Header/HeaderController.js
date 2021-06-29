({
    doInit : function(component, event, helper) {
        helper.updatePercentage(component, event, helper);
    },
    upadtePercentage : function(component, event, helper) {
        var ShowResultValue = event.getParam("Pass_Result");
        component.set("v.Get_Result",ShowResultValue );
    },
})