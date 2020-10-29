trigger AccountTrigger on Account (after insert, after update, before delete) {
  if (Trigger.isInsert) {
    List<Id> needInsertRequestIds = new List<Id>();

    for(Account account : Trigger.New) {
      if(account.External_Id__c == null) {
        needInsertRequestIds.add(account.id);
      }
    }

    if(needInsertRequestIds.size() > 0) {
      RestSynchronizationService.sendInsertRequest(needInsertRequestIds);
    }
  } else if (Trigger.isUpdate) {
    String[] compareFields = new String[]{
      'Name', 'AccountNumber', 'Phone', 'BillingStreet',
      'BillingCity', 'BillingCountry', 'BillingState', 'BillingPostalCode',
      'BillingLatitude', 'BillingLongitude', 'ShippingStreet', 'ShippingCity', 
      'ShippingCountry', 'ShippingState', 'ShippingPostalCode', 'ShippingLatitude', 
      'ShippingLongitude'
    };

    List<Id> needUpdateAccountIds = new List<Id>();
    List<Id> needDeleteAccountIds = new List<Id>();
    List<Id> needUpdateRequestIds = new List<Id>();

    for (Account account : Trigger.new) {
      Account oldAccount = Trigger.oldMap.get(account.Id);
  
      Boolean isHaveChanges = false;
      
      if(!account.From_Api__c) {
        for(String field : compareFields) {
          if((String)account.get(field) != (String)oldAccount.get(field)) {
            isHaveChanges = true;
          }
        }
  
        if(isHaveChanges) {
          needUpdateRequestIds.add(account.id);
        }
      }
  
      if(account.From_Api__c) {
        needUpdateAccountIds.add(account.Id);
      }

      if(account.External_Id__c == null) {
        needDeleteAccountIds.add(account.Id);
      }
    }

    if(needUpdateRequestIds.size() > 0) {
      RestSynchronizationService.sendUpdateRequest(needUpdateRequestIds);
    }
    
    AccountWorker.updateFromApiFlags(needUpdateAccountIds);

    AccountWorker.deleteMarkedAccounts(needDeleteAccountIds);
    
  } else if(Trigger.isDelete) {
    List<String> needDeleteRequestIds = new List<String>();

    for(Account account: Trigger.old) {
      if(account.External_Id__c != null) {
        needDeleteRequestIds.add(account.External_Id__c);
      }
    }

    if(needDeleteRequestIds.size() > 0) {
      RestSynchronizationService.sendDeleteRequest(needDeleteRequestIds);
    }
  }
}