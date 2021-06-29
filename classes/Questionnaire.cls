public without sharing class Questionnaire implements Comparable {
    @AuraEnabled public string objectname;
    @AuraEnabled public string fieldname;
    @AuraEnabled public string question;
    @AuraEnabled public decimal weightage;
    @AuraEnabled public decimal sortorder;

    public Questionnaire(String objectn, String fieldn, String quest, Decimal weight,Decimal sortn ){
        objectname=objectn;
        fieldname=fieldn;
        question=quest;
        weightage=weight;
        sortorder=sortn;
    }
    // Used in component: Questionnairecmp
    // used for pagination to show question with no value first and question which need updation later.
    public class Wrapper{
    @AuraEnabled
    public string pk {
        get;
        set;
    }
    @AuraEnabled
    public string fieldValue{
        get;
        set;
    }
    @AuraEnabled
    public string objectn{
        get;
        set;
    }
    @AuraEnabled 
    public string field{
        get;
        set;
    }
    @AuraEnabled 
    public string queId{
        get;
        set;
    }
    @AuraEnabled
    public Decimal soq{
        get;
        set;
    }
    @AuraEnabled
    public Integer listsize{
        get;
        set;
    } 
}
    // This method is used to do the sorting of questions using comparable interface.
    public Integer compareTo(Object objToCompare) {
        Questionnaire qe=(Questionnaire)objToCompare;
        if(sortorder==0) {
            return 0;
        } else {
            return 1;    
        }
   }

    // Used in component: Questionnairecmp
    // This method is used to do pagination of the questions.
    @AuraEnabled
    public static list<wrapper> getQue( String userId ) {
        Integer sortorder=1;
        List < ID > ids = new List < ID > ();
        list<wrapper> wplist = new list<wrapper>();
        Map < String, String > objecttofieldmap = new Map < String,String > ();
        Map<String, Integer> questionsort=new Map<String, Integer>();
        Map<ID, Integer> question=new Map<ID, Integer>();
        String cuserId = userinfo.getUserId();
        List<Questionnaire> que=new List<Questionnaire>();
        
        User user=[select id,contactid from User where id=:userId];
        if(!String.isEmpty(user.ContactId)) {
            ids.add(user.ContactId);    
            ids.add(userId);          
        }
        List < grz_ppt__Progress_Bar_Question__c > progress = [select id, name, grz_ppt__Question__c, grz_ppt__Object_Name__c,grz_ppt__Field_Api_Name__c,grz_ppt__Weightage__c  from grz_ppt__Progress_Bar_Question__c WITH SECURITY_ENFORCED];
        for (grz_ppt__Progress_Bar_Question__c p: progress) {
            if(objecttofieldmap.containskey(p.grz_ppt__Object_Name__c)){
            	objecttofieldmap.put(p.grz_ppt__Object_Name__c,objecttofieldmap.get(p.grz_ppt__Object_Name__c) + ',' + p.grz_ppt__Field_Api_Name__c);

            } else {
            	objecttofieldmap.put(p.grz_ppt__Object_Name__c,p.grz_ppt__Field_Api_Name__c );
            }
        }
        for (String keys: objecttofieldmap.keyset()){
            List<String> fieldname=new List<String>();
            String query ='select ' + objecttofieldmap.get(keys) + ' from ' + keys + ' ' + 'where' + ' ' + 'Id =' + ':' + 'cuserId' +' ' + 'OR' +' '+ 'Id'+ ' ' + 'IN' + ':'+ 'ids';
            String sbj = json.serialize(Database.query(String.escapeSingleQuotes(query)));
            
            fieldname=objecttofieldmap.get(keys).split(',');
            for(String s:fieldname) {
                if(!sbj.containsIgnorecase(s)) {
                    questionsort.put(s + keys,0);
                } else if(sbj.containsIgnorecase(s) && sbj.containsIgnorecase('/cap/profilephoto/005/T')) {
                    questionsort.put(s + keys,0);
                } else {
                    questionsort.put(s + keys,sortorder);
                }
            }
        }
        for(grz_ppt__Progress_Bar_Question__c p: progress) {
            que.add(new Questionnaire(p.grz_ppt__Object_Name__c,p.grz_ppt__Field_Api_Name__c,p.grz_ppt__Question__c,p.grz_ppt__Weightage__c,questionsort.get(p.grz_ppt__Field_Api_Name__c + p.grz_ppt__Object_Name__c)));
        }
        que.sort(); 
        for(Questionnaire q:que){
            wrapper wr = new wrapper();  
            wr.pk=q.question;
            wr.objectn=q.objectname;
            wr.field=q.fieldname;
            wr.soq=q.sortorder;
            wplist.add(wr);
        }
        return wplist;                        
    }

    // Used in component: CommunityProgressbar,Questionnairecmp,CommunityProgressQuestionnaire
    // This method calculates the percentange of question answered on the basis of their weightage 
    @AuraEnabled
    public static Decimal getcalculateactual(String userId) {
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

    // Used in component: Questionnairecmp
    // This method is used to return the filled value of the fields in the component.
    @AuraEnabled
    public static string returnrecords(string obj,string flds){
        list<Id> ids=new list<Id>();
        User user=[select id,contactid from User where id=:UserInfo.getUserId()];
        if(!String.isEmpty(user.ContactId)) {
            ids.add(user.ContactId);
            ids.add(user.Id);            
        }
        String fieldValue='';
        String objectName = obj;
        String fieldName = flds;
        list<sobject> obs = Database.query(String.escapeSingleQuotes('Select Id,' + flds + ' FROM '+obj+' WHERE ID IN:ids'));
        for(Sobject sobj: obs ) {
            fieldValue = String.valueOf(sobj.get(fieldName));
        }
        return fieldValue;
    }
	
    // Used in component: Questionnairecmp
    // This method is used to create badge.
   	@AuraEnabled
    public static string createBadges(Decimal Weightage){
        Map< String, WorkBadgeDefinition > mapOfWorkbadge = new Map< String, WorkBadgeDefinition > ();
        Decimal retVal = Questionnaire.getcalculateactual(UserInfo.getUserId());
        list< WorkBadge > wb = [SELECT Id FROM WorkBadge where RecipientId =: UserInfo.getUserId()];
            if(wb.size() > 0){
                if(Weightage != retVal){
                    delete wb;
                }
            }
        ID giverID;
        list< User >  ulist = [SELECT Id FROM User WHERE Profile.Name = 'System Administrator'];
        for(User u: ulist){
            if(u.Id != UserInfo.getUserId()){
                giverID=u.Id;
            }
        }
      	list< grz_ppt__Category__c > categories = [SELECT Id, OwnerId, grz_ppt__Badge_Name__c, grz_ppt__Minimum_Range__c, grz_ppt__Maximum_Range__c FROM grz_ppt__Category__c];
        list< WorkBadgeDefinition > workdlist = [SELECT Id, Name, NetworkId,CreatedDate, LastModifiedDate, Description, OwnerId FROM WorkBadgeDefinition order by LastModifiedDate asc];
        list< WorkBadge > wbs = [SELECT Id FROM WorkBadge where RecipientId =: UserInfo.getUserId()];
        for(WorkBadgeDefinition w:workdlist){
            if(mapOfWorkbadge.containsKey(w.Name) && string.valueOf(w.LastModifiedDate) > string.valueOf(mapOfWorkbadge.get(w.Name).LastModifiedDate)){
                mapOfWorkbadge.put(w.Name,w);
            } else {
                mapOfWorkbadge.put(w.Name,w);
            }
        }

        for(grz_ppt__Category__c cat:categories){
           for(WorkBadgeDefinition wd:mapOfWorkbadge.values()){
               if(cat.grz_ppt__Badge_Name__c == wd.Name && cat.grz_ppt__Minimum_Range__c <= retVal && cat.grz_ppt__Maximum_Range__c >= retVal && wbs.size() == 0){
                   WorkThanks thanks = new WorkThanks (
                    NetworkId =wd.NetworkId,
                    GiverId=giverID,
                    Message=Wd.Description
                );
                insert thanks;
                WorkBadge badge = new WorkBadge(
                    DefinitionId=wd.Id,
                    NetworkId =Wd.NetworkId,
                    RecipientId=UserInfo.getUserId(),
                    SourceId=thanks.id
                );
                insert badge;
               }
        	} 
        }
        return 'Success';
    }
    
    // Used in component: QuestionnaireFormComponent
    // this method used to show question in the component.
    
    @AuraEnabled
    public static list<wrapper> updateRecords(){
        Map<string,list<string> > fldMap = new Map<string,list<string> > ();
        Map<string,string> mapId = new Map<string,string> ();
        List<Questionnaire> que=new List<Questionnaire>();
        Map<string,string> fieldmap = new Map<string,string> ();
		list<wrapper> wplist = new list<wrapper>(); 
        list<string> conlist= new list<string> ();
        list<string> userlist= new list<string> ();
        sobject conobj;
        sobject userobj;
        String editableFields='';
        
        list<Id> ids=new list<Id>();
        User user=[select id,contactid from User where id=:UserInfo.getUserId()];
        if(!String.isEmpty(user.ContactId)) {
            ids.add(user.ContactId);
            ids.add(user.Id);            
        }
        Map<String, Schema.SObjectField> fields = Schema.getGlobalDescribe().get('grz_ppt__Progress_Bar_Question__c').getDescribe().fields.getMap();
        for(Schema.SObjectField fieldRef : fields.values()) {
            Schema.DescribeFieldResult fieldResult = fieldRef.getDescribe();
           if(fieldResult.isAccessible()) {
                if(fieldResult.custom && editableFields == ''){
                	editableFields = ', '+fieldResult.getname();
                } else if(fieldResult.custom && editableFields != ''){
                    editableFields = editableFields+', '+ fieldResult.getname();
                }
           }
        }
        string query = 'SELECT Id '+editableFields+' FROM grz_ppt__Progress_Bar_Question__c';
        list<grz_ppt__Progress_Bar_Question__c> pbq =  Database.query(query); 
        for(grz_ppt__Progress_Bar_Question__c p:pbq){
            que.add(new Questionnaire(p.grz_ppt__Object_Name__c,p.grz_ppt__Field_Api_Name__c,p.grz_ppt__Question__c,p.grz_ppt__Weightage__c,null));
            if(fldMap.containsKey(p.grz_ppt__Object_Name__c)){
                list<string> listValue = fldMap.get(p.grz_ppt__Object_Name__c);
                listValue.add(p.grz_ppt__Field_Api_Name__c);
                fldMap.put(p.grz_ppt__Object_Name__c,listValue);
            } else {
                list<string> listValue = new list<string> ();
                listValue.add(p.grz_ppt__Field_Api_Name__c);
                fldMap.put(p.grz_ppt__Object_Name__c,listValue);
            }
        }
        for(string keys:fldMap.keyset()){
            if(keys == 'Contact'){
                conlist=fldMap.get(keys);
            }
            if(keys == 'User'){
                userlist=fldMap.get(keys);
            }
        }
        string conString = string.join(conlist,',');
        string userString= string.join(userlist,',');
        if(!String.isBlank(conString)){
            String contactquerys ='select id, ' + conString + ' from ' + 'Contact' + ' ' + 'where'+' '+ 'Id'+ ' ' + 'IN' + ':'+ 'ids';
        	conobj = Database.query(contactquerys);
            for(string s:conlist){
                if(!fieldmap.containsKey(s) && !String.isBlank(String.valueOf(conobj.get(s)))){
                    fieldmap.put(s,String.valueOf(conobj.get(s)));
                    mapId.put(s,(String)conobj.id);
                }
            }
        }
        if(!String.isBlank(userString)){
            String userquerys ='select id, ' + userString + ' from ' + 'user' + ' ' + 'where'+' '+ 'Id'+ ' ' + 'IN' + ':'+ 'ids';
        	userobj = Database.query(userquerys);
            for(string s:userlist){
                if(!fieldmap.containsKey(s) && !String.isBlank(String.valueOf(userobj.get(s)))){
                    fieldmap.put(s,String.valueOf(userobj.get(s)));
                    mapId.put(s,(String)userobj.id);
                }
            }
        }
        for(Questionnaire q:que){
            wrapper wr = new wrapper();  
            wr.pk=q.question;
            wr.objectn=q.objectname;
            wr.field = q.fieldname;
            wr.fieldValue = fieldmap.get(q.fieldname);
            wr.queId = mapId.get(q.fieldname);
            wplist.add(wr);
        }
        return wplist;
    }
    // Used in component: QuestionnaireFormComponent
    // this method used to Update question in the component.

    @AuraEnabled
    public static string updateProfile(list<wrapper> values){
        list<string> conlist= new list<string> ();
        list<string> userlist= new list<string> ();
        Map<string,list<string> > fldMap = new Map<string,list<string> > ();
        List<Questionnaire> que=new List<Questionnaire>();
        Map<string,string> fieldmap = new Map<string,string> ();
        Map<string,string> mapId = new Map<string,string> ();
		list<wrapper> wplist = new list<wrapper>();
        list<Id> ids=new list<Id>();
        String editableFields='';
        sobject conobj;
        sobject userobj;
        string returnValue;
        User user = [SELECT Id,ContactId FROM User WHERE Id =:UserInfo.getUserId()];
        Map< Id, sObject > dataMap= new Map< Id, sObject >();
        Contact c = new Contact(id=user.ContactId);
        if(!String.isEmpty(user.ContactId)) {
            ids.add(user.ContactId);
            ids.add(user.Id);            
        }
        Map<String, Schema.SObjectField> fields = Schema.getGlobalDescribe().get('grz_ppt__Progress_Bar_Question__c').getDescribe().fields.getMap();
		for(Schema.SObjectField fieldRef : fields.values()) {
            Schema.DescribeFieldResult fieldResult = fieldRef.getDescribe();
            if(fieldResult.isAccessible()) {
                if(fieldResult.custom && editableFields == ''){
                	editableFields = ', '+fieldResult.getname();
                } else if(fieldResult.custom && editableFields != ''){
                    editableFields = editableFields+', '+ fieldResult.getname();
                }
            }
        }
        string query = 'SELECT Id '+editableFields+' FROM grz_ppt__Progress_Bar_Question__c';
        list<grz_ppt__Progress_Bar_Question__c> pbq =  Database.query(query); 
        for(grz_ppt__Progress_Bar_Question__c p:pbq){
            que.add(new Questionnaire(p.grz_ppt__Object_Name__c,p.grz_ppt__Field_Api_Name__c,p.grz_ppt__Question__c,p.grz_ppt__Weightage__c,null));
            if(fldMap.containsKey(p.grz_ppt__Object_Name__c)){
                list<string> listValue = fldMap.get(p.grz_ppt__Object_Name__c);
                listValue.add(p.grz_ppt__Field_Api_Name__c);
                fldMap.put(p.grz_ppt__Object_Name__c,listValue);
            } else {
                list<string> listValue = new list<string> ();
                listValue.add(p.grz_ppt__Field_Api_Name__c);
                fldMap.put(p.grz_ppt__Object_Name__c,listValue);
            }
        }
        for(string keys:fldMap.keyset()){
            if(keys == 'Contact'){
                conlist=fldMap.get(keys);
            }
            if(keys == 'User'){
                userlist=fldMap.get(keys);
            }
        }
        string conString = string.join(conlist,',');
        string userString= string.join(userlist,',');
        if(!String.isBlank(conString)){
            String contactquerys ='select id, ' + conString + ' from ' + 'Contact' + ' ' + 'where'+' '+ 'Id'+ ' ' + 'IN' + ':'+ 'ids';
        	conobj = Database.query(contactquerys);
            for(string s:conlist){
                if(!fieldmap.containsKey(s) && !String.isBlank(String.valueOf(conobj.get(s)))){
                    fieldmap.put(s,String.valueOf(conobj.get(s)));
                    mapId.put(s,(String)conobj.id);
                }
            }
        }
        if(!String.isBlank(userString)){
            String userquerys ='select id, ' + userString + ' from ' + 'user' + ' ' + 'where'+' '+ 'Id'+ ' ' + 'IN' + ':'+ 'ids';
        	userobj = Database.query(userquerys);
            for(string s:userlist){
                if(!fieldmap.containsKey(s) && !String.isBlank(String.valueOf(userobj.get(s)))){
                    fieldmap.put(s,String.valueOf(userobj.get(s)));
                    mapId.put(s,(String)userobj.id);
                }
            }
        }
        for(wrapper w:values){
            if(w.objectn == 'Contact' && w.fieldValue != fieldmap.get(w.field)){
                c.put(w.field,w.fieldValue);
                dataMap.put(c.Id,c);
                if(!String.isBlank(returnValue)){
                    returnValue = returnValue+' & '+w.objectn+' '+w.field;
                } else {
                    returnValue =w.objectn+' '+w.field;
                }
            }
            if(w.objectn == 'User' && w.fieldValue != fieldmap.get(w.field)){
                user.put(w.field,w.fieldValue);
                dataMap.put(user.Id,user);
                
                if(!String.isBlank(returnValue)){
                   	returnValue = returnValue+' & '+w.objectn+' '+w.field;
                } else {
                    returnValue =w.objectn+' '+w.field;
                }
            }
        }
        update dataMap.values();
        return returnValue;
    }
}