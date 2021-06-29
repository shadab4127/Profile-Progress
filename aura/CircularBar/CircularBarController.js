({
    questionsDetails : function(component, event, helper) {
        var urlString = window.location.href;
        var baseURL = urlString.substring(0, urlString.lastIndexOf("s/")+2);
        console.log('urlString :'+baseURL);
        var urlEvent = $A.get("e.force:navigateToURL");
        urlEvent.setParams({ "url": baseURL+"progress-bar-questions" });   // Pass your community URL
        urlEvent.fire(); 
    }
})