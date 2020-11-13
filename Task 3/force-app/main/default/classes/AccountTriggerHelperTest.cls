@IsTest
public with sharing class AccountTriggerHelperTest {
    
    private static String ACCOUNT_NAME = 'Test name';

    private static String EXPECTED_EVENT_PUBLISH = 'Expected to get succes of event publish';
    private static String EXPECTED_RESULT_BE_NULL = 'Expected result to be null';
    private static String NOT_EXPECTED_EXCEPTIONS = 'Don\'t expecte to get exceptions';

    @IsTest
    static void detectFieldChangesTest() {
        Account account = new Account(Name = ACCOUNT_NAME);
        insert account;

        Account clone = account.clone(false, false, false, false);
        clone.Name = ACCOUNT_NAME + '1';

        Test.startTest();
        Database.SaveResult result = AccountTriggerHelper.detectFieldChanges(account, clone);
        Test.stopTest();

        System.assertEquals(true, result.isSuccess(), EXPECTED_EVENT_PUBLISH);
    }

    @IsTest
    static void detectFieldNoChangesTest() {
        Account account = new Account(Name = ACCOUNT_NAME);
        insert account;

        Test.startTest();
        Database.SaveResult result = AccountTriggerHelper.detectFieldChanges(account, account);
        Test.stopTest();

        System.assertEquals(null, result, EXPECTED_RESULT_BE_NULL);
    }

    @IsTest
    static void updateTest() {
        Account account = new Account(Name = ACCOUNT_NAME);
        insert account;

        try {
            account.Name = ACCOUNT_NAME + '1';
            update account;
        } catch (Exception e) {
            System.assert(false, NOT_EXPECTED_EXCEPTIONS);
        }

        System.assert(true);
    }
}
