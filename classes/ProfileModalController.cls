public without sharing class ProfileModalController {
    
    //used in component: ProfileTrackerModal
    // this method shows the datatype of the field in which value needs to be stored
    @AuraEnabled
    public static string updateProfile(string obj,string flds){
        String objectName = obj;
        String fieldName = flds;
        SObjectType r = ((SObject)(Type.forName('Schema.'+objectName).newInstance())).getSObjectType();
        DescribeSObjectResult d = r.getDescribe();
        String types = string.valueof(d.fields.getMap().get(fieldName).getDescribe().getType());
        return types; 
    }

    //used in component: ProfileTrackerModal
    // this method updates the value in the field of contact,account and user
    @AuraEnabled
    public static string updateRecord(string obj,string flds,string inputValues){
        list<Id> ids=new list<Id>();
        User user=[select id,contactid,accountid from User where id=:UserInfo.getUserId()];
        if(!String.isEmpty(user.ContactId)) {
            ids.add(user.ContactId);
            ids.add(user.Id);            
        } 
        SObjectType r = ((SObject)(Type.forName('Schema.'+obj).newInstance())).getSObjectType();
	    DescribeSObjectResult d = r.getDescribe();
        String types = string.valueof(d.fields.getMap().get(flds).getDescribe().getType());
        list<sobject> obs = Database.query(String.escapeSingleQuotes('Select Id,' + flds + ' FROM '+obj+' WHERE ID IN:ids'));
     
        for(sobject ob:obs){
            ob.put(flds,inputValues);
            update ob;
        }
        return obj+' '+flds;
    }
    
}