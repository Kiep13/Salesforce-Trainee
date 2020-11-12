@IsTest
public with sharing class AccountTriggerHelperTest {
    
    private static String ACCOUNT_NAME = 'Test name';

    private static String INVALID_EVENTS_AMOUNTS = 'Actual amount of events doesn\'t equal to actual';

    @TestSetup
    static void makeData(){
        Account account = new Account(Name = ACCOUNT_NAME);
        insert account;
    }

    @IsTest
    static void updateTest() {
        Account account = [SELECT Name FROM Account];
        account.Name = ACCOUNT_NAME + '1';

        Test.startTest();
        update account;
        Test.stopTest();

        List<EventBusSubscriber> events = [SELECT Name, Position, Retries, LastError 
                                           FROM EventBusSubscriber 
                                           WHERE Topic='Account_Change__e' AND Type='ApexTrigger'];
        System.assertEquals(1, events.size(), INVALID_EVENTS_AMOUNTS);
    }
}
