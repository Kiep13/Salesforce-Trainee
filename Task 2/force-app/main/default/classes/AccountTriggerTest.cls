@IsTest
public with sharing class AccountTriggerTest {
  public static String TEST_ACCOUNT_NAME = 'Test Name';

  public static String INVALID_GENERATE_FIELD = 'Expected Generate_PDF__c field to be false';
  public static String IVALID_ATTACHMENTS_AMOUNT = 'Actual amount of attachments does not equal to expected';

  @TestSetup
  public static void makeData(){
    Account account = new Account(Name = TEST_ACCOUNT_NAME);
    insert account;
  }

  @IsTest
  public static void testGenerateFieldChanging() {
    Account account = [SELECT Id,  Generate_PDF__c FROM Account LIMIT 1];
    account.Generate_PDF__c = true;

    Test.startTest();
    update account;
    Test.stopTest();

    Account resultAccount = [SELECT Id,  Generate_PDF__c FROM Account WHERE Id = :account.Id];
    System.assertEquals(false, resultAccount.Generate_PDF__c, INVALID_GENERATE_FIELD);
  }

  @IsTest
  public static void testPdfGenerating() {
    Account account = [SELECT Id,  Generate_PDF__c FROM Account LIMIT 1];

    Test.startTest();
    AccountTriggerHelper.savePdf(account.Id);
    Test.stopTest(); 

    List<Attachment> attachments = [SELECT Id FROM Attachment WHERE ParentId = :account.id];
    
    System.assertEquals(1, attachments.size(), IVALID_ATTACHMENTS_AMOUNT);
  }
}
