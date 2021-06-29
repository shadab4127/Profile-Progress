public without sharing class Header {
    //used in component: Header
    // this method used to show the percentage in the customprofilemenu component
    @AuraEnabled
    public static Decimal updatePercentage(String userId) {
        Decimal totalVal = 0;
        Decimal actualVal = 0;
        Integer retVal = 0;
        String percentagevalue;
        List < ID > ids = new List < ID > ();
        Map < String, List < String >> objecttofieldsmap = new Map < String, List < String >> ();
        User user=[select id,contactid from User where id=:userId];
        if(!String.isEmpty(user.ContactId)) {
            ids.add(user.ContactId);
            ids.add(userId);            
        }
        List < grz_ppt__Progress_Bar_Question__c > pq = [select id, grz_ppt__Weightage__c, grz_ppt__Object_Name__c, grz_ppt__Field_Api_Name__c from grz_ppt__Progress_Bar_Question__c WITH SECURITY_ENFORCED];
        for (grz_ppt__Progress_Bar_Question__c p: pq) {
            totalVal=totalVal+p.grz_ppt__Weightage__c;
        }
        List < grz_ppt__Progress_Bar_Question__c > pb = [select id, grz_ppt__Weightage__c, grz_ppt__Object_Name__c, grz_ppt__Field_Api_Name__c from grz_ppt__Progress_Bar_Question__c WITH SECURITY_ENFORCED];
        for (grz_ppt__Progress_Bar_Question__c p: pb) {
            if(objecttofieldsmap.containskey(p.grz_ppt__Object_Name__c)) {
                List < String > field = objecttofieldsmap.get(p.grz_ppt__Object_Name__c);
                field.add(p.grz_ppt__Field_Api_Name__c+';;'+p.grz_ppt__Weightage__c);
                objecttofieldsmap.put(p.grz_ppt__Object_Name__c, field);
            }
            else {
                List < String > field = new List < String > ();
                field.add(p.grz_ppt__Field_Api_Name__c+';;'+p.grz_ppt__Weightage__c);
                objecttofieldsmap.put(p.grz_ppt__Object_Name__c, field);
            }
        }
        for (String keys: objecttofieldsmap.keyset()) {
            for (String ss: objecttofieldsmap.get(keys)) {
                String field= ss.substringBefore(';;');
                String weightage=ss.substringAfter(';;');
                Map < String, List < sObject >> stringtoSobjectsmap = new Map < String, List < sObject >> ();
                String querystring = 'select ' + field + ' from ' + keys + ' ' + 'where' + ' ' + 'Id' + ' ' + 'IN' + ':' + 'ids';
                List < Sobject > res = Database.query(String.escapeSingleQuotes(querystring ));
                stringtoSobjectsmap.put(keys, res);
                String soBjectTypeString = String.valueOf(res[0].getSObjectType());
                Type type = Type.forName('Map<String,' + soBjectTypeString + '>');
                Map < String, Sobject > sobjectMap = (Map < String, Sobject > ) type.newInstance();
                for (SObject currentSObject: res) {
                    sobjectMap.put(String.valueOf(currentSObject.get(field)), currentSObject);
                    String fieldvalue = String.valueOf(currentSObject.get(field));
                    if (!String.isBlank(fieldvalue)) {
                        if (!fieldvalue.contains('/profilephoto/005/T') || fieldvalue.contains(field)) {
                            actualVal = actualVal + decimal.valueOf(Weightage);
                        }
                        else {
                            actualVal=actualval;
                        }
                    }
                }
                if(totalVal == 0){
                    retVal = Integer.valueOf(actualVal );                   
                }else if (actualVal > 0){
                    retVal = Integer.valueOf( ( actualVal / totalVal ) * 100 );  
                } 
            }
        }
        return retVal;
    }  

}