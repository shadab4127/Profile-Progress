({
	doInit: function (component, event, helper) {
		var obj = component.get("v.objects");
		var fld = component.get("v.fields");
		var action = component.get("c.updateProfile");
		var question = component.get("v.Question");
		component.set("v.ques",question.pk);
		action.setParams({
			"obj": obj,
			"flds": fld,
		});
		action.setCallback(this, function (res) {
			var state = res.getState();
			if (state == "SUCCESS") {
				var result = res.getReturnValue();
                if(result == "URL"){
                    component.set("v.isType", "urltext");
                } else {
                    component.set("v.isType", result);
                }
			}
		});
		$A.enqueueAction(action);
	},
	doClose: function (component, event, helper) {
		component.set("v.istruthy", false);
	},
	saveRecord: function (component, event, helper) { 
		var phoneRegexFormat = /^\d{5,11}$/;
		var urlRegexFormate = new RegExp('^[w]{3}.[a-zA-Z0-9]{2,}.[a-z]{2,3}$');
        var regExpEmailformat = /^(([^<>()\[\]\\.,;:\s@"]+(\.[^<>()\[\]\\.,;:\s@"]+)*)|(".+"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{3}))$/;  
        var inputValues = '';
        var inputType = component.get("v.isType");
		var obj = component.get("v.objects");
		var fld = component.get("v.fields");
        var inputs = component.get('v.fieldvalue1');
        if(inputs == undefined || inputs == '' || inputs == null){
            var inputCmp = component.find("form1");
            inputCmp.setCustomValidity('You can not blank this field');
            inputCmp.reportValidity();
        } else if (inputType == 'PHONE') {
            if (!inputs.match(phoneRegexFormat)) {
                var phoneCmp = component.find("form1");
                phoneCmp.setCustomValidity("Enter valid Number");
                phoneCmp.reportValidity();
            } else {
                inputValues = inputs;
            }
		} else if (inputType == 'urltext') {
			if (!inputs.match(urlRegexFormate)) {
                var urlCmp = component.find("form1");
                urlCmp.setCustomValidity("Enter valid Url");
                urlCmp.reportValidity();
			} else {
                inputValues = inputs;
            }
		} else if(inputType == 'EMAIL'){
            if(!inputs.match(regExpEmailformat)){
                var emailCmp = component.find("form1");
                emailCmp.setCustomValidity("Enter valid Email");
                emailCmp.reportValidity();
            } else {
                inputValues = inputs;
            }
        } else {
                inputValues = inputs;
        }
        if(inputValues !='' && inputValues != null && inputValues != undefined) {
            var action = component.get("c.updateRecord");
            action.setParams({
                "obj": obj,
                "flds": fld,
                "inputValues": inputValues,
            });
            action.setCallback(this, function (res) {
                var state = res.getState();
                if (state == "SUCCESS") {
                    var result = res.getReturnValue();
                    helper.showToast(component, result);
                    helper.callParentMethod(component, event, helper);
                    var action = component.get('c.doClose');
                    $A.enqueueAction(action);
                }
            });
            $A.enqueueAction(action);
        }
	},
})