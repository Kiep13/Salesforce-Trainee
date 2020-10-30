public with sharing class AccountWorker {
  public static void proccessInsert(List<Account> accounts) {
    List<Id> needInsertRequestIds = new List<Id>();

    for(Account account : accounts) {
      if(account.External_Id__c == null) {
        needInsertRequestIds.add(account.id);
      }
    }

    if(needInsertRequestIds.size() > 0) {
      RestSynchronizationService.sendPutRequest(needInsertRequestIds);
    }
  }

  public static void proccessUpdate(List<Account> newAccounts, Map<Id, Account> oldAccounts) {
    Boolean isFromApi = String.valueOf(System.URL.getCurrentRequestUrl().getPath()).contains('composite');

    String[] compareFields = new String[]{
      'Name', 'AccountNumber', 'Phone', 'BillingStreet',
      'BillingCity', 'BillingCountry', 'BillingState', 'BillingPostalCode',
      'BillingLatitude', 'BillingLongitude', 'ShippingStreet', 'ShippingCity', 
      'ShippingCountry', 'ShippingState', 'ShippingPostalCode', 'ShippingLatitude', 
      'ShippingLongitude'
      };

    List<Id> needUpdateRequestIds = new List<Id>();

    for (Account account : newAccounts) {
      Account oldAccount = oldAccounts.get(account.Id);
  
      Boolean isHaveChanges = false;
      
      if(!isFromApi) {
        for(String field : compareFields) {
          if((String)account.get(field) != (String)oldAccount.get(field)) {
            isHaveChanges = true;
          }
        }
  
        if(isHaveChanges) {
          needUpdateRequestIds.add(account.id);
        }
      }
    }

    if(needUpdateRequestIds.size() > 0) {
      RestSynchronizationService.sendPutRequest(needUpdateRequestIds);
    }
  }

  public static void processDelete(List<Account> accounts) {
    Boolean isFromApi = String.valueOf(System.URL.getCurrentRequestUrl().getPath()).contains('composite');

    if(!isFromApi) {
      List<String> needDeleteRequestIds = new List<String>();

      for(Account account: accounts) {
        needDeleteRequestIds.add(account.External_Id__c);
      }
  
      RestSynchronizationService.sendDeleteRequest(needDeleteRequestIds);
    }
  }
}
