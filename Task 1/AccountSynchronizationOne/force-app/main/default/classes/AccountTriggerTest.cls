@IsTest
public with sharing class AccountTriggerTest {
    private static String TEST_ACCOUNT_NAME = 'Test';
    private static String TEST_EXTERNAL_ID = '0019000001hE8apAAC';

    private static String ERROR_WRONG_EXTERNAL_ID = 'Actual external id does not equal to expectected';
    private static String ERROR_EXPECTED_EMPTY_LIST = 'Actual accounts list size does not equal to exptected';
    private static String ERROR_INVALID_NAME = 'Actual account name does not equal to exptected';

    @TestSetup
    public static void makeData(){
        Account account = new Account(Name = TEST_ACCOUNT_NAME);

        Test.setMock(HttpCalloutMock.class, new RestSynchronizationServiceMock()); 

        Test.startTest();
        insert account;
        Test.stopTest();
    }

    @IsTest
    public static void insertWithNoExternalIdTest() {
      Account account = new Account(Name = TEST_ACCOUNT_NAME);
        
      Test.setMock(HttpCalloutMock.class, new RestSynchronizationServiceMock()); 

      Test.startTest();
      insert account;
      Test.stopTest();

      Account resultAccount = [SELECT External_Id__c FROM Account WHERE Id = :account.Id];

      System.assertEquals(TEST_EXTERNAL_ID, resultAccount.External_Id__c,ERROR_WRONG_EXTERNAL_ID);
    }

    @IsTest
    public static void updateName() {
      Account account = [SELECT Name FROM Account LIMIT 1];
      account.Name = TEST_ACCOUNT_NAME + '1';
      
      Test.setMock(HttpCalloutMock.class, new RestSynchronizationServiceMock()); 

      Test.startTest();
      upsert account;
      Test.stopTest();

      Account resultAccount = [SELECT Name FROM Account WHERE Id = :account.Id];
      System.assertEquals(account.Name, resultAccount.Name, ERROR_INVALID_NAME);
    }

    @IsTest
    public static void deleteAccount() {
      Account account = [SELECT Name FROM Account LIMIT 1];
      
      Test.setMock(HttpCalloutMock.class, new RestSynchronizationServiceMock()); 

      Test.startTest();
      delete account;
      Test.stopTest();

      List<Account> accounts = [SELECT Name FROM Account];
      System.assertEquals(0, accounts.size(), ERROR_EXPECTED_EMPTY_LIST);
    }
}
