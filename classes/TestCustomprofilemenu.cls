@isTest
public class TestCustomprofilemenu {
    @isTest static void fetchUser() {
        Test.startTest();
        customprofilemenu.fetchUser();
        string actual = customprofilemenu.fetchUrl();
        Test.stopTest();
        Organization org = [SELECT InstanceName FROM Organization];
        String expected= 'https://' + org.InstanceName + '.salesforce.com/';
        System.assertEquals(expected, actual);
    }
    
}