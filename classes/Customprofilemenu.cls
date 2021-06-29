public without sharing class Customprofilemenu {
    @AuraEnabled 
    public static user fetchUser(){
        User u = [select id,FirstName from User where id =: userInfo.getUserId()];
        return u;
    }
    @AuraEnabled 
    public static string fetchUrl(){
        Organization org = [SELECT InstanceName FROM Organization];
        return 'https://' + org.InstanceName + '.salesforce.com/';
    }
    
}