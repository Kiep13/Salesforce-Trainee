public with sharing class AccountTriggerHelper {

  private Map<String, Group> groupMap = new Map<String, Group>();

  public AccountTriggerHelper() {
    prepareGroupMap();
  }

  public void iterateInsertAccounts(List<Account> accounts) {
    List<AccountShare> newRules = new List<AccountShare>();
    
    for(Account account: accounts) {
      newRules.add(createSharingRules(account));
    }

    insert newRules;
  } 

  private void prepareGroupMap() {
    List<Group> groups = [SELECT Id, Name FROM Group];

    for(Group userGroup : groups) {
      groupMap.put(userGroup.Name, userGroup);
    }
  }

  public void iterateUpdateAccounts(List<Account> accounts, Map<Id, Account> oldVersion) {
    List<AccountShare> newRules = new List<AccountShare>();

    List<Id> ids = new List<Id>();

    for(Account account: accounts) {
      Account oldAccount = oldVersion.get(account.Id);
        if(account.For_Team__c != oldAccount.For_Team__c || account.OwnerId != oldAccount.OwnerId) {
          ids.add(account.Id);
          newRules.add(createSharingRules(account));
        }
      }

    try {
      List<AccountShare> oldRules  = [SELECT Id FROM AccountShare WHERE AccountId IN :ids AND RowCause = 'Manual'];
      delete oldRules;
    } catch(System.DmlException exc) {}

    insert newRules;
  }  

  private AccountShare createSharingRules(Account account) {
    AccountShare accountSharRule = new AccountShare();
    accountSharRule.AccountId= account.Id;

    Group userGroup = groupMap.get(account.For_Team__c);
    accountSharRule.UserOrGroupId = userGroup.Id;

    accountSharRule.AccountAccessLevel = 'Edit';
    accountSharRule.OpportunityAccessLevel = 'Edit';
    accountSharRule.CaseAccessLevel = 'Edit';
    accountSharRule.RowCause = Schema.AccountShare.RowCause.Manual;

    return accountSharRule;
  }
}
