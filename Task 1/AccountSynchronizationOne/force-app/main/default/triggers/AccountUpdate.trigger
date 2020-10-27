trigger AccountUpdate on Account (after update) {
  List<Id> needUpdateAccountIds = new List<Id>();

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
  }

  List<Account> needUpdateAccount = new List<Account>();

  for (Account account : [SELECT From_Api__c FROM Account WHERE Id IN :needUpdateAccountIds]) {
    account.From_Api__c = false;
    needUpdateAccount.add(account);
  }

  upsert needUpdateAccount;
}