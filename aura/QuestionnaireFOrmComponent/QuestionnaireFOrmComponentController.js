({
    doInit : function(component, event, helper) {
      	var action = component.get("c.updateRecords");
        action.setCallback(this, function(a) {
            console.log('getState :'+a.getState());
            if (a.getState() === 'SUCCESS') {
                var arrayfield = [];
                var arrayobjs = [];
                var result =a.getReturnValue();
                console.log('result :'+result);
                component.set("v.Questions" ,a.getReturnValue() ); 
                helper.docomputeProgress(component, event, helper);
            }  
        });
        $A.enqueueAction(action); 
    },
    getInput : function(component, event, helper) {
        var phoneRegexFormat = /^\d{5,11}$/;
		var urlRegexFormate = new RegExp('^[w]{3}.[a-zA-Z0-9]{2,}.[a-z]{2,3}$');
        var regExpEmailformat = /^(([^<>()\[\]\\.,;:\s@"]+(\.[^<>()\[\]\\.,;:\s@"]+)*)|(".+"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/;  
        var inputIsnull=true;
        var inputVal;
        var inputCmp = component.find("form");
        inputCmp.forEach(function(inputItem){
        inputVal = inputItem.get('v.value');
        var inputType = inputItem.get('v.type');
             if(inputVal =='' || inputVal == null || inputVal == undefined){
                inputItem.setCustomValidity('You can not blank this field');
            	inputItem.reportValidity();
                inputIsnull=false;
             } else if (inputType == 'Phone') {
            if (!inputVal.match(phoneRegexFormat)) {
                inputItem.setCustomValidity("Enter valid Number");
                inputItem.reportValidity();
                inputIsnull=false;
            } else {
                inputItem.setCustomValidity("");
                inputItem.reportValidity();
            }
		} else if (inputType == 'Website') {
			if (!inputVal.match(urlRegexFormate)) {
                inputItem.setCustomValidity("Enter valid Url");
                inputItem.reportValidity();
                inputIsnull=false;
			} else {
                inputItem.setCustomValidity("");
                inputItem.reportValidity();
            }
		} else if(inputType == 'Email'){
            if(!inputVal.match(regExpEmailformat)){
                var emailCmp = component.find("form");
                inputItem.setCustomValidity("Enter valid Email");
                inputItem.reportValidity();
                inputIsnull=false;
            } else {
                inputItem.setCustomValidity("");
                inputItem.reportValidity();
            }
        } else {
            inputItem.setCustomValidity("");
            inputItem.reportValidity();
        }
      });
      if(inputIsnull){
            var values = component.get("v.Questions");
            var action = component.get("c.updateProfile");
            action.setParams({
                "values" : values
            });
            action.setCallback(this, function(a) {
            if (a.getState() === 'SUCCESS') {
                var result =a.getReturnValue();
                helper.computeProgress(component, event, helper);
                helper.showToast(component, result);  
            }  
        });
        $A.enqueueAction(action); 
     }
    },
    getBackToHome : function(component, event, helper) {
        var urlString = window.location.href;
        var baseURL = urlString.substring(0, urlString.lastIndexOf("s/")+2);
        var urlEvent = $A.get("e.force:navigateToURL");
        urlEvent.setParams({ "url": baseURL+'profile/home' });   // Pass your community URL
        urlEvent.fire(); 
    },    
})