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

    List<Id> needDeleteAccountIds = new List<Id>();
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

      if(account.External_Id__c == null) {
        needDeleteAccountIds.add(account.Id);
      }
    }

    if(needUpdateRequestIds.size() > 0) {
      RestSynchronizationService.sendPutRequest(needUpdateRequestIds);
    }

    AccountWorker.deleteMarkedAccounts(needDeleteAccountIds);
  }

  public static void processDelete() {

  }
  
  public static void deleteMarkedAccounts(List<Id> ids) {
    if(ids.size() > 0) {
      List<Account> needDeleteAccounts = [SELECT Name FROM Account WHERE Id IN :ids];

      delete needDeleteAccounts;
    }
  }
}
