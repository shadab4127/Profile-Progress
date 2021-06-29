@isTest public class TestSumofWeightage {
    @isTest public static void testinsertWeightage(){
        Decimal sum=0;
        grz_ppt__Progress_Bar_Question__c p = new grz_ppt__Progress_Bar_Question__c();
        p.grz_ppt__Field_Api_Name__c = 'Email';
        p.grz_ppt__Object_Name__c = 'Contact';
        p.grz_ppt__Question__c = 'Enter Email';
        p.grz_ppt__Weightage__c = 120;
        Database.SaveResult result = Database.insert(p, false);
        List<grz_ppt__Progress_Bar_Question__c> pb=[select id,grz_ppt__Weightage__c from grz_ppt__Progress_Bar_Question__c LIMIT 50000];
        for(grz_ppt__Progress_Bar_Question__c prog:pb){
            sum=sum+prog.grz_ppt__Weightage__c;
        }
        if(sum > 100){
            System.assertEquals('The total sum of weightage of all questions should not be greater than 100.',result.getErrors()[0].getMessage());
        }
    }
    @isTest public static void testUpdateWeightage(){
        Decimal sum=0;
        grz_ppt__Progress_Bar_Question__c p = new grz_ppt__Progress_Bar_Question__c();
        p.grz_ppt__Field_Api_Name__c = 'Email';
        p.grz_ppt__Object_Name__c = 'Contact';
        p.grz_ppt__Question__c = 'Enter Email';
        p.grz_ppt__Weightage__c = 70;
        Database.SaveResult insertResult = Database.insert(p, false);
        p.grz_ppt__Weightage__c=40;
        Database.SaveResult updateResult = Database.update(p, false);
        List<grz_ppt__Progress_Bar_Question__c> pb=[select id,grz_ppt__Weightage__c from grz_ppt__Progress_Bar_Question__c LIMIT 50000];
        for(grz_ppt__Progress_Bar_Question__c prog:pb){
            sum=sum+prog.grz_ppt__Weightage__c;
        }
        if(sum > 100){
            System.assertEquals('The total sum of weightage of all questions should not be greater than 100.',updateResult.getErrors()[0].getMessage());
        }
    }
}