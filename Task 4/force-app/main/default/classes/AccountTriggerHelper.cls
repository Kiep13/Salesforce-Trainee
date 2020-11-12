public with sharing class AccountTriggerHelper {
  public static void iterateInsertAccounts(List<Account> accounts) {
    List<AccountShare> newRules = new List<AccountShare>();

    for(Account account: accounts) {
      newRules.add(createSharingRules(account));
    }

    insert newRules;
  } 

  public static void iterateUpdateAccounts(List<Account> accounts, Map<Id, Account> oldVersion) {
    List<AccountShare> oldRules = new List<AccountShare>();
    List<AccountShare> newRules = new List<AccountShare>();

    for(Account account: accounts) {
      Account oldAccount = oldVersion.get(account.Id);
        if(account.For_Team__c != oldAccount.For_Team__c) {
          oldRules.addAll(deleteSharingRules(account.Id));
          newRules.add(createSharingRules(account));
        }
      }

    if(oldRules.size() > 0) {
      delete oldRules;
    }

    insert newRules;
  }

  private static List<AccountShare> deleteSharingRules(Id accountId) {
    try {
      return [SELECT Id FROM AccountShare WHERE AccountId = : accountId AND RowCause = 'Manual'];
    } catch(System.DmlException exc) {
      return new List<AccountShare>();
    }
  }   

  private static AccountShare createSharingRules(Account account) {
    AccountShare accountSharRule = new AccountShare();
    accountSharRule.AccountId= account.Id;

    Group userGroup = [SELECT Id FROM Group WHERE Name = :account.For_Team__c];
    accountSharRule.UserOrGroupId = userGroup.Id;

    accountSharRule.AccountAccessLevel = 'Edit';
    accountSharRule.OpportunityAccessLevel = 'Edit';
    accountSharRule.CaseAccessLevel = 'Edit';
    accountSharRule.RowCause = Schema.AccountShare.RowCause.Manual;

    return accountSharRule;
  }
}
