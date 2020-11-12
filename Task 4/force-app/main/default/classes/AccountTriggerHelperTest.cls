
@IsTest
public with sharing class AccountTriggerHelperTest {
    
    private static String ACCOUNT_NAME = 'Test name';

    private static String INVALID_RULES_AMOUNT = 'Actual amount of rules does\'t equal to expected';
    private static String INVALID_GROUP = 'Actual group name doesn\'t equal to expected';

    @IsTest
    public static void testInsertAccount() {
        Account account = new Account(Name = ACCOUNT_NAME);
        account.For_Team__c = 'Team 1';

        Test.startTest();
        insert account;
        Test.stopTest();

        List<AccountShare> rules = [SELECT Id, UserOrGroupId FROM AccountShare WHERE AccountId = : account.Id AND RowCause = 'Manual'];
        System.assertEquals(1, rules.size(), INVALID_RULES_AMOUNT);

        Group userGroup = [SELECT Id, Name FROM Group WHERE Id = :rules[0].UserOrGroupId];
        System.assertEquals(account.For_Team__c, userGroup.Name, INVALID_RULES_AMOUNT);
    }  
    
    @IsTest
    public static void testUpdateAccount() {
        Account account = new Account(Name = ACCOUNT_NAME);
        account.For_Team__c = 'Team 1';

        Test.startTest();
        insert account;

        account.For_Team__c = 'Team 2';
        update account;
        Test.stopTest();

        List<AccountShare> rules = [SELECT Id, UserOrGroupId FROM AccountShare WHERE AccountId = : account.Id AND RowCause = 'Manual'];
        System.assertEquals(1, rules.size(), INVALID_RULES_AMOUNT);

        Group userGroup = [SELECT Id, Name FROM Group WHERE Id = :rules[0].UserOrGroupId];
        System.assertEquals(account.For_Team__c, userGroup.Name, INVALID_RULES_AMOUNT);
    }
}
