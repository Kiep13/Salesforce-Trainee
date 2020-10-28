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
        account.BillingStreet != oldAccount.BillingStreet ||
        account.BillingCity != oldAccount.BillingCity ||
        account.BillingCountry  != oldAccount.BillingCountry ||
        account.BillingState != oldAccount.BillingState ||
        account.BillingPostalCode != oldAccount.BillingPostalCode ||
        account.BillingLatitude != oldAccount.BillingLatitude ||
        account.BillingLongitude != oldAccount.BillingLatitude ||
        account.ShippingStreet != oldAccount.ShippingStreet ||
        account.ShippingCity != oldAccount.ShippingCity || 
        account.ShippingCountry != account.ShippingCountry ||
        account.ShippingState != oldAccount.ShippingState ||
        account.ShippingPostalCode != oldAccount.ShippingPostalCode ||
        account.ShippingLatitude != oldAccount.ShippingLatitude ||
        account.ShippingLongitude != oldAccount.ShippingLongitude
      ) && !account.From_Api__c) {
  
         RestSynchronizationService.sendUpdateRequest(account.id);
      } 
  
      if(account.From_Api__c) {
        needUpdateAccountIds.add(account.Id);
      }

      if(account.External_Id__c == null) {
        needDeleteAccountIds.add(account.Id);
      }
    }

    AccountWorker.updateFromApiFlags(needUpdateAccountIds);

    AccountWorker.deleteMarkedAccounts(needDeleteAccountIds);
  } else if(Trigger.isDelete) {
    for(Account account: Trigger.old) {
      if(account.External_Id__c != null) {
        RestSynchronizationService.sendDeleteRequest(account.External_Id__c);
      }
    }
  }
}