@isTest
public class TestProfileModalController{
    @TestSetup static void setup(){
        Id profileId = [SELECT Id FROM Profile WHERE Name ='Customer Community Plus User'].Id;
        Account a = TestUtility.createAccount('Test Account');
        insert a;
        Contact c = TestUtility.createContact(a.Id);
        insert c;
        User u = TestUtility.createCommunityUser(c.Id,profileId,'test@user.com','User');
        insert u;
    }
    @isTest public static void testUpdateRecord(){
        User u =[SELECT Id FROM User WHERE Username = 'test@user.com'];
        Account ac=[SELECT Id, website FROM Account WHERE Name ='Test Account'];
        ac.website = 'www.google.com';
        Update ac;
        Test.startTest();
        System.runAs(u){
            ProfileModalController.updateProfile('Account', 'Website');
            ProfileModalController.updateRecord('Account', 'Website',ac.Website);
        }
        Test.stopTest();
        System.assertEquals( 'www.google.com' , [SELECT Id, website FROM Account WHERE Id =:ac.Id].website);
    }
}