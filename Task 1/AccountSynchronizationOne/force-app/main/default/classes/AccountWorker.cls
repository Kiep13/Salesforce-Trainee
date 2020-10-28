public with sharing class AccountWorker {
  public static void updateFromApiFlags(List<Id> ids) {
    if(ids.size() > 0) {
      List<Account> needUpdateAccount = new List<Account>();
  
      for (Account account : [SELECT From_Api__c FROM Account WHERE Id IN :ids]) {
        account.From_Api__c = false;
        needUpdateAccount.add(account);
      }
      
      upsert needUpdateAccount;
    }  
  }

  public static void deleteMarkedAccounts(List<Id> ids) {
    if(ids.size() > 0) {
      List<Account> needDeleteAccounts = [SELECT Name FROM Account WHERE Id IN :ids];

      delete needDeleteAccounts;
    }
  }
}
