public with sharing class RestSynchronizationService {

  @future(callout = true)
  public static void sendInsertRequest(List<Id> ids) {
    List<Account> accounts = RestSynchronizationService.getAccountsByIds(ids);
    List<Account> newAccounts = new List<Account>();

    for(Account account: accounts) {
      Account newAccount = RestSynchronizationService.createAccountForRequest(account);
      newAccounts.add(newAccount);
    }
    
    AccountRequestWrapper wrapper = new AccountRequestWrapper(false, newAccounts);
  
    Http http = new Http();
    HttpRequest request = new HttpRequest();  
    request.setEndpoint('callout:AnotherOrg/services/data/v49.0/composite/sobjects');  
    request.setMethod('POST');    
    request.setHeader('Content-Type', 'application/json;charset=UTF-8');
    request.setBody(JSON.serialize(wrapper)); 
    HttpResponse responce = http.send(request);
      
    String responseBody = responce.getBody();
    List<AccountInsertResponse> resultObjects = (
      List<AccountInsertResponse>)JSON.deserialize(responseBody, List<AccountInsertResponse>.class);

    System.debug(resultObjects);

    for(Integer i = 0; i < resultObjects.size(); i++) {
      String recordId = (String)resultObjects[i].id;
      System.debug(recordId);
      accounts[i].External_Id__c = recordId;
    }

    upsert accounts;
  }

  @future(callout = true)
  public static void sendUpdateRequest(List<Id> ids) {

    List<Account> accounts = RestSynchronizationService.getAccountsByIds(ids);
    List<Account> accountsForUpdate = new List<Account>();

    for (Account account : accounts) {
      Account accountForUpdate = RestSynchronizationService.createAccountForRequest(account);
      accountForUpdate.From_Api__c = true;
      accountsForUpdate.add(accountForUpdate);
    }
    
    AccountRequestWrapper wrapper = new AccountRequestWrapper(false, accountsForUpdate);
  
    Http http = new Http();
    HttpRequest request = new HttpRequest();  
    request.setEndpoint('callout:AnotherOrg/services/data/v49.0/composite/sobjects');  
    request.setMethod('PATCH');    
    request.setHeader('Content-Type', 'application/json;charset=UTF-8');
    System.debug(JSON.serialize(wrapper));
    request.setBody(JSON.serialize(wrapper)); 
    HttpResponse responce = http.send(request);
  }

  @future(callout = true)
  public static void sendDeleteRequest(List<String> externalIds) {

    List<Account> accountsForUpdate = new List<Account>();
    for (String id : externalIds) {
      Account accountForUpdate = new Account(
        Id = id,
        External_Id__c = null
      );
      accountsForUpdate.add(accountForUpdate);
    }

    AccountRequestWrapper wrapper = new AccountRequestWrapper(false, accountsForUpdate);
  
    Http http = new Http();
    HttpRequest request = new HttpRequest();  
    request.setEndpoint('callout:AnotherOrg/services/data/v49.0/composite/sobjects');  
    request.setMethod('PATCH');    
    request.setHeader('Content-Type', 'application/json;charset=UTF-8');
    request.setBody(JSON.serialize(wrapper)); 
    HttpResponse responce = http.send(request);
  }

  private static List<Account> getAccountsByIds(List<Id> ids) {
    return [SELECT Name, AccountNumber, Phone, BillingStreet, 
                              BillingCity, BillingCountry, BillingState, 
                              BillingPostalCode, BillingLatitude, BillingLongitude, 
                              ShippingStreet, ShippingCity, ShippingCountry, 
                              ShippingState, ShippingPostalCode, ShippingLatitude, 
                              ShippingLongitude, External_Id__c
                              FROM Account WHERE Id = :ids];
  }

  private static Account createAccountForRequest(Account account) {
    Account newAccount = new Account(
      Id = account.External_Id__c,
      Name = account.Name,
      AccountNumber = account.AccountNumber,
      Phone = account.Phone,
      External_Id__c = account.Id,
      BillingStreet = account.BillingStreet,
      BillingCity = account.BillingCity,
      BillingCountry = account.BillingCountry,
      BillingState = account.BillingState,
      BillingPostalCode = account.BillingPostalCode,
      BillingLatitude = account.BillingLatitude,
      BillingLongitude = account.BillingLongitude,
      ShippingStreet = account.ShippingStreet,
      ShippingCity = account.ShippingCity,
      ShippingCountry = account.ShippingCountry,
      ShippingState = account.ShippingState,
      ShippingPostalCode = account.ShippingPostalCode,
      ShippingLatitude = account.ShippingLatitude,
      ShippingLongitude = account.ShippingLongitude
    );
    return newAccount;
  }
}
  