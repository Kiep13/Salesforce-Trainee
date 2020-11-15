@IsTest
public with sharing class AccountTriggerHelperTest {
    
    private static String ACCOUNT_NAME = 'Test name';

    private static String EXPECTED_CHANGE = 'Actual amount of field changes doesn\'t equal to expected';
    private static String EXPECTED_NO_CHANGES = 'Actual amount of field changes doesn\'t equal to expected';
    private static String INVALID_MESSAGE = 'Actual message does\'t equal to expected';
    private static String NOT_EXPECTED_EXCEPTIONS = 'Don\'t expecte to get exceptions';
    

    @IsTest
    static void detectFieldChangesTest() {
        Account account = new Account(Name = ACCOUNT_NAME);
        insert account;

        Account clone = account.clone(false, false, false, false);
        clone.Name = ACCOUNT_NAME + '1';

        Test.startTest();
        List<FieldChanges> listFieldChanges = AccountTriggerHelper.detectFieldChanges(account, clone);
        Test.stopTest();

        System.assertEquals(true, listFieldChanges.size() > 1, EXPECTED_CHANGE);
    }

    @IsTest
    static void detectFieldNoChangesTest() {
        Account account = new Account(Name = ACCOUNT_NAME);
        insert account;

        Test.startTest();
        List<FieldChanges> listFieldChanges = AccountTriggerHelper.detectFieldChanges(account, account);
        Test.stopTest();

        System.assertEquals(0, listFieldChanges.size(), EXPECTED_NO_CHANGES);
    }

    @IsTest
    static void createEventTest() {
        Account account = new Account(Name = ACCOUNT_NAME);
        insert account;

        Account clone = account.clone(false, false, false, false);
        clone.Name = ACCOUNT_NAME + '1';

        List<FieldChanges> listChanges = new List<FieldChanges>();
        FieldChanges fieldChange = new FieldChanges(
            'Name',
            account.get('Name'),
            clone.get('Name')
        );

        listChanges.add(fieldChange);

        Test.startTest();
        Account_Change__e event = AccountTriggerHelper.createEvent(account.Id, listChanges);
        Test.stopTest();

        String message = UserInfo.getFirstName() + ' ' + UserInfo.getLastName() + ' changed data\n';
        message += fieldChange.fieldName + ' : ' + fieldChange.oldValue + ' -> ' + fieldChange.newValue + ';\n';

        System.assertEquals(account.Id, event.Id__c, EXPECTED_NO_CHANGES);
        System.assertEquals(message, event.Message__c, INVALID_MESSAGE);
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
