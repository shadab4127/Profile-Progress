public class TestUtility {
    public static User createUser(String roleId, String profId,String username, String lastName){
        User tempUser = prepareUser(roleId, profId, username, lastName);
        return tempUser;
    }
    private static User prepareUser(String roleId, String profId,String username, String lastName){
        User tempUser = new User(
        	FirstName = 'Test',
            LastName = lastName,
            Email = 'test@gmail.com',
            Username=username,
            EmailEncodingKey = 'ISO-8859-1',
            Alias = 'fstlst',
            Title = 'Test Engineer',
            TimeZoneSidKey = 'America/Los_Angeles',
            LocaleSidKey = 'en_US',
            LanguageLocaleKey = 'en_US',
            ProfileId = profId
        );
        if(String.isBlank(roleId)==false){
            tempUser.UserRoleId = roleId;
        }
        return tempUser;
    }
    public static User createCommunityUser(String contactId, String profId,String username, String lastName){
        User tempUser = prepareUser('', profId, username, lastName);
        tempUser.ContactId = contactId;
        return tempUser;
        
    }
    public static Account createAccount(String Name){
        Account a = new Account(Name = Name, Website='www.test.com');
        return a;
    }
    public static Contact createContact(String AccountId){
        Contact c = new Contact(FirstName = 'Abc', LastName = 'Test',Email='test@gmail.com', AccountId = AccountId );
        return c;
    }
    public static grz_ppt__Category__c createCategory(){
        grz_ppt__Category__c cat = new grz_ppt__Category__c(grz_ppt__Badge_Name__c = 'Test Badge',grz_ppt__Minimum_Range__c=60, grz_ppt__Maximum_Range__c = 80);
        return cat;
    }
    @future
    public static void getPermissions(string userId){
        PermissionSet perset =[SELECT Id, ProfileId, Name FROM PermissionSet WHERE Name ='PPT_Community_User_Access'];
        PermissionSetAssignment psa = new PermissionSetAssignment();
        psa.AssigneeId = userId;
        psa.PermissionSetId = perset.Id;
        insert psa;
    } 
}