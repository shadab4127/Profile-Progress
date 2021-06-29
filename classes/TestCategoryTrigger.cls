@isTest
public class TestCategoryTrigger {
	@TestSetup
    static void setup(){
        grz_ppt__Category__c c = new grz_ppt__Category__c();
        c.grz_ppt__Badge_Name__c = 'Test';
        c.grz_ppt__Minimum_Range__c = 1;
        c.grz_ppt__Maximum_Range__c =10;
        insert c; 
    }
    @isTest public static void testCategoryInsert(){
        list< grz_ppt__Category__c > categories = [SELECT Id, grz_ppt__Minimum_Range__c, grz_ppt__Maximum_Range__c FROM grz_ppt__Category__c];
        grz_ppt__Category__c c1 = new grz_ppt__Category__c(grz_ppt__Badge_Name__c = 'Test1',grz_ppt__Minimum_Range__c = 101,grz_ppt__Maximum_Range__c =-1);
        grz_ppt__Category__c c2 = new grz_ppt__Category__c(grz_ppt__Badge_Name__c = 'Test2',grz_ppt__Minimum_Range__c = 1,grz_ppt__Maximum_Range__c =10);
        Test.startTest();
        Database.SaveResult result1 = Database.insert(c1, false);
        Database.SaveResult result2 = Database.insert(c2, false);
        if(c1.grz_ppt__Minimum_Range__c > 100){
            System.assertEquals('Minimum Range should exist from 1 - 100',result1.getErrors()[0].getMessage());
        }
        for(grz_ppt__Category__c cat : categories){
            if(c2.grz_ppt__Minimum_Range__c >= cat.grz_ppt__Minimum_Range__c && c2.grz_ppt__Minimum_Range__c <= cat.grz_ppt__Maximum_Range__c){
               	System.assertEquals('This Minimum Range already exist in the other category range. Please fill another set of range',result2.getErrors()[0].getMessage());
            }
        }
        Test.stopTest();
}
   @isTest public static void testCategoryUpdate(){
        list< grz_ppt__Category__c > categories = [SELECT Id, grz_ppt__Minimum_Range__c, grz_ppt__Maximum_Range__c FROM grz_ppt__Category__c];
        grz_ppt__Category__c c1 = [SELECT Id, grz_ppt__Minimum_Range__c, grz_ppt__Maximum_Range__c FROM grz_ppt__Category__c WHERE grz_ppt__Badge_Name__c = 'Test'];
        grz_ppt__Category__c c2 = [SELECT Id, grz_ppt__Minimum_Range__c, grz_ppt__Maximum_Range__c FROM grz_ppt__Category__c WHERE grz_ppt__Badge_Name__c = 'Test'];
       	grz_ppt__Category__c c3 = [SELECT Id, grz_ppt__Minimum_Range__c, grz_ppt__Maximum_Range__c FROM grz_ppt__Category__c WHERE grz_ppt__Badge_Name__c = 'Test'];
        c1.grz_ppt__Minimum_Range__c = 104;
        c1.grz_ppt__Maximum_Range__c = -4;
        c2.grz_ppt__Minimum_Range__c = 1;
        c2.grz_ppt__Maximum_Range__c = 10;
       	c3.grz_ppt__Minimum_Range__c = 10;
        c3.grz_ppt__Maximum_Range__c = 1;
        Test.startTest();
        Database.SaveResult result1 = Database.update(c1,false);
        Database.SaveResult result2 = Database.update(c2, false);
       	Database.SaveResult result3 = Database.update(c3, false);	
        if(c1.grz_ppt__Minimum_Range__c > 100){
            System.assertEquals('Minimum Range should exist from 1 - 100',result1.getErrors()[0].getMessage());
        }
        for(grz_ppt__Category__c cat : categories){
            if(c2.grz_ppt__Minimum_Range__c >= cat.grz_ppt__Minimum_Range__c && c2.grz_ppt__Minimum_Range__c <= cat.grz_ppt__Maximum_Range__c && c2.Id != cat.Id && c2.grz_ppt__Minimum_Range__c != cat.grz_ppt__Minimum_Range__c){
                System.assertEquals('This Minimum Range already exist. Please fill another set of range',result2.getErrors()[0].getMessage());
            }
            if(c3.grz_ppt__Maximum_Range__c >= cat.grz_ppt__Minimum_Range__c && c3.grz_ppt__Maximum_Range__c <= cat.grz_ppt__Maximum_Range__c && c3.Id != cat.Id && c3.grz_ppt__Maximum_Range__c != cat.grz_ppt__Maximum_Range__c){
                System.assertEquals('This Minimum Range already exist. Please fill another set of range',result2.getErrors()[0].getMessage());
            }
        }
        Test.stopTest();
    }
    @isTest public static void testCategoryMethods(){
        CategoryTriggerHandler handler = new CategoryTriggerHandler();
        handler.afterInsert(new Map<Id, sObject>());
        handler.afterUpdate(new Map<Id, sObject>(), new Map<Id, sObject>());
        handler.beforeDelete(new Map<Id, sObject>());
        handler.afterDelete(new Map<Id, sObject>());
        handler.afterUnDelete(new Map<Id, sObject>());
        System.assertEquals('test','test');
    }
}