({
    getQuestions : function(component, event, helper) {
        helper.doInit(component,event,helper);
        helper.computeProgressz(component,event,helper);
    },
    updateQuestions : function(component, event, helper) {
        helper.computeProgressz(component,event,helper);
        helper.creates(component,event,helper);
        if(component.get("v.label") === "Save"){
            helper.doInit(component,event,helper);
        }
    },
    Save : function(component,event,helper){
        var label =  event.getSource().get("v.label");
        var obj =  event.getSource().get("v.value");
        var fields =  event.getSource().get("v.title");
        component.set("v.objects",obj);
        component.set("v.fields",fields);
        if(obj!=='User' && fields!=='smallphotourl'){
            component.set("v.truthy",true);
            component.set("v.fieldvalue1",''); 
        } else if(obj=='User' && fields!=='smallphotourl'){
            component.set("v.truthy",true);
            component.set("v.fieldvalue1",'');  
        } else if(obj=='User' && fields=='smallphotourl'){
            component.set("v.uploads",true);
        } else{
            component.set("v.truthy",true);
        }
        component.set("v.label",label);       
    },
    Updates : function(component,event,helper){
        var label =  event.getSource().get("v.label");
        component.set("v.label",label);
        var obj =  event.getSource().get("v.value");
        var fields =  event.getSource().get("v.title");
        component.set("v.objects",obj);
        component.set("v.fields",fields);
        var action = component.get('c.returnrecords');
        action.setParams({
            "obj" : obj,
            "flds" : fields
        });
        if(obj=='User' && fields=='smallphotourl'){
            component.set("v.truthy",false);
            component.set("v.uploads",true);
        } else{
            component.set("v.truthy",true);
        }
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                component.set("v.fieldvalue1", response.getReturnValue());
            } else {
                console.log("Failed with state: " + state);
            }
        });
        $A.enqueueAction(action);
        //helper.doInit(component,event,helper);
    },
    next: function (component, event, helper) {
        helper.next(component, event);
        component.set("v.truthy",false);
    },
    previous: function (component, event, helper) {
        helper.previous(component, event);
        component.set("v.truthy",false);
    }
})