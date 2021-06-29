({
    doInit : function(component) {
        component.set('v.isSending',true);
        var action = component.get("c.getQue");
        action.setParams({
            "userId": $A.get("$SObjectType.CurrentUser.Id"),
        });
        action.setCallback(this, function(response){
            var state = response.getState();
            if (state === "SUCCESS" && component.isValid()) {
                var pageSize = component.get("v.pageSize");
                // hold all the records into an attribute named "wrapper"
                component.set('v.wrapper', response.getReturnValue());
                // get size of all the records and then hold into an attribute "totalRecords"
                component.set("v.totalRecords", component.get("v.wrapper").length);
                // set star as 0
                component.set("v.startPage",0);
                component.set("v.endPage",pageSize-1);
                var QuestionnaireList = [];
                for(var i=0; i< pageSize; i++){
                    if(component.get("v.wrapper").length> i){
                        QuestionnaireList.push(response.getReturnValue()[i]); 
                        var questins = response.getReturnValue()[i].pk;
                        component.set('v.ques',questins);
                    }
                }
                component.set('v.QuestionnaireList', QuestionnaireList);
                component.set('v.isSending',false);
            }else{
                alert('ERROR');
            }
        });
        $A.enqueueAction(action);
    },
    computeProgressz : function(component, event, helper)  {
        var action = component.get('c.getcalculateactual');
        action.setParams({
            userId : $A.get("$SObjectType.CurrentUser.Id")
        });
        action.setCallback(this, function(a) {
            if (a.getState() === 'SUCCESS') {
                var percVal = a.getReturnValue() ; 
                var progressVal = parseInt((percVal/100) * 360) ;
                component.set("v.cirDeg" , progressVal);
                component.set("v.Weightage" , parseInt(percVal));
                setTimeout(function(){ component.set("v.perText" , parseInt(percVal)  +'%' ); },1200); 
                var cmpEvnt=component.getEvent("regInChild");
                cmpEvnt.setParams({
                    "storeMessage" :  percVal    
                });
                cmpEvnt.fire();
                var evt = $A.get("e.c:Result");
                evt.setParams({ "Pass_Result": percVal});
                evt.fire();
            }  
        }); 
        $A.enqueueAction(action); 
    },
    creates : function(component,event,helper){
        var Weightage = component.get("v.Weightage");
        var action = component.get('c.createBadges');
        action.setParams({
            'Weightage' : Weightage
        }); 
        action.setCallback(this, function(response){
            var state = response.getState();
            if (state === "SUCCESS") {
                console.log('Result : '+state);
            }
        })
        $A.enqueueAction(action);           
    },
    /*
     * Method will be called when use clicks on next button and performs the 
     * calculation to show the next set of records
     */
    next : function(component, event){
        var sObjectList = component.get("v.wrapper");
        var end = component.get("v.endPage");
        var start = component.get("v.startPage");
        var pageSize = component.get("v.pageSize");
        var QuestionnaireList = [];
        var counter = 0;
        for(var i=end+1; i<end+pageSize+1; i++){
            if(sObjectList.length > i){
                QuestionnaireList.push(sObjectList[i]);
                var questins = sObjectList[i].pk;
                component.set('v.ques',questins);
            }
            counter ++ ;
        }
        start = start + counter;
        end = end + counter;
        component.set("v.startPage",start);
        component.set("v.endPage",end);
        component.set('v.QuestionnaireList', QuestionnaireList);
    },
    /*
     * Method will be called when use clicks on previous button and performs the 
     * calculation to show the previous set of records
     */
    previous : function(component, event){
        var sObjectList = component.get("v.wrapper");
        var end = component.get("v.endPage");
        var start = component.get("v.startPage");
        var pageSize = component.get("v.pageSize");
        var QuestionnaireList = [];
        var counter = 0;
        for(var i= start-pageSize; i < start ; i++){
            if(i > -1){
                QuestionnaireList.push(sObjectList[i]);
                var questins = sObjectList[i].pk;
                component.set('v.ques',questins);
                counter ++;
            }else{
                start++;
            }
        }
        start = start - counter;
        end = end - counter;
        component.set("v.startPage",start);
        component.set("v.endPage",end);
        component.set('v.QuestionnaireList', QuestionnaireList);
    }
})