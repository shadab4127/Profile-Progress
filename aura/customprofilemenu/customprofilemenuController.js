({
    doInit: function (component, event, helper) {
        var opt =[];
      	var home =component.get('v.Home');
        var logout =component.get('v.logout');
        var MyProfileLabel =component.get('v.MyProfileLabel');
        var UserSetting =component.get('v.UserSetting');
        var MySetting =component.get('v.MySetting');
        var MyMessages =component.get('v.MyMessages');
        var WorkspacesLabel =component.get('v.WorkspacesLabel');
        opt.push(home);
        opt.push(MyProfileLabel);
        if(UserSetting){
            opt.push(MySetting);
        }
        if(MyMessages){
            opt.push('My Messages');
        }
        opt.push(WorkspacesLabel);
        opt.push(logout);
        component.set("v.options", opt);
        var ddDiv = component.find('ddId');
        $A.util.toggleClass(ddDiv,'slds-is-open');
        var action = component.get("c.fetchUser");
        action.setCallback(this, function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var storeResponse = response.getReturnValue();
                component.set("v.userInfo", storeResponse);
            }
        });
        $A.enqueueAction(action);
    },
    handleClick: function (component, event, helper) {
        var communityUrls = window.location.origin;
        console.log(communityUrls);
        var urlString = window.location.href;
 		var baseURL = urlString.substring(0, urlString.indexOf("/s"));
        var loginURL = urlString.substring(0, urlString.indexOf("/s")+2);
        var userId = $A.get("$SObjectType.CurrentUser.Id");
        var urlEvent = $A.get("e.force:navigateToURL");
        var selectlabel = event.currentTarget.id;
        if(selectlabel === 'Home') {
            urlEvent.setParams({ "url": '/' });
        } else if(selectlabel === 'My Profile') {
            urlEvent.setParams({ "url": '/profile/home' });
        } else if(selectlabel === 'Logout') {
            window.location.replace(baseURL+"/secur/logout.jsp?retUrl="+loginURL);
        } else if(selectlabel ==='My Settings'){
            urlEvent.setParams({ "url": '/settings/'+userId });
        } else if(selectlabel ==='My Messages'){
            urlEvent.setParams({ "url": '/messages/Home'});
        } else if(selectlabel ==='Experience Workspaces'){
            urlEvent.setParams({ "url": baseURL+'/communitySetup/cwApp.app#/c/home' });
        } else {
            return null;
        }
        urlEvent.fire();
    },
    toggleVisibility : function(component, event, helper) {
        var ddDiv = component.find('ddId');
        $A.util.toggleClass(ddDiv,'slds-is-open');
    },
    blurtoggleVisibility : function(component, event, helper) {
        window.setTimeout($A.getCallback(function() {
            var ddDiv = component.find('ddId');
            $A.util.removeClass(ddDiv,'slds-is-open');
        }),200)        
    },
})