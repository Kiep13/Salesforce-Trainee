trigger AccountTrigger on Account (after insert, after update, before delete) {
  if (Trigger.isInsert) {
    for(Account account : Trigger.New) {
      if(account.External_Id__c == null) {
        RestSynchronizationService.sendInsertRequest(account.id);
      }
    }
  } else if (Trigger.isUpdate) {
    List<Id> needUpdateAccountIds = new List<Id>();
    List<Id> needDeleteAccountIds = new List<Id>();

    for (Account account : Trigger.new) {
      Account oldAccount = Trigger.oldMap.get(account.Id);
  
      if((account.Name != oldAccount.Name ||
         account.AccountNumber != oldAccount.AccountNumber ||
         account.Phone != oldAccount.Phone || 
         account.BillingAddress != oldAccount.BillingAddress ||
         account.ShippingAddress != account.ShippingAddress) && !account.From_Api__c) {
  
         System.debug(2);
         RestSynchronizationService.sendUpdateRequest(account.id);
      } 
  
      if(account.From_Api__c) {
        System.debug(3);
        needUpdateAccountIds.add(account.Id);
      }

      if(account.External_Id__c == null) {
        System.debug('will delete');
        needDeleteAccountIds.add(account.Id);
      }
    }
  
    List<Account> needUpdateAccount = new List<Account>();
  
    for (Account account : [SELECT From_Api__c FROM Account WHERE Id IN :needUpdateAccountIds]) {
      account.From_Api__c = false;
      needUpdateAccount.add(account);
    }
  
    upsert needUpdateAccount;

    List<Account> needDeleteAccounts = [SELECT Name FROM Account WHERE Id IN :needDeleteAccountIds];

    delete needDeleteAccounts;
  } else if(Trigger.isDelete) {
    for(Account account: Trigger.old) {
      if(account.External_Id__c != null) {
        RestSynchronizationService.sendDeleteRequest(account.External_Id__c);
      }
    }
  }
}