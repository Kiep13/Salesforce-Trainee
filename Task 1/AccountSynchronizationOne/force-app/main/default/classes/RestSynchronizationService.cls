public with sharing class RestSynchronizationService {

  @future(callout = true)
  public static void sendInsertRequest(Id id) {
    Account account = RestSynchronizationService.getAccountById(id);
    Account newAccount = RestSynchronizationService.createAccountForRequest(account);
  
    Http http = new Http();
    HttpRequest request = new HttpRequest();  
    request.setEndpoint('callout:AnotherOrg/services/data/v49.0/sobjects/Account');  
    request.setMethod('POST');    
    request.setHeader('Content-Type', 'application/json;charset=UTF-8');
    request.setBody(JSON.serialize(newAccount)); 
    HttpResponse responce = http.send(request);
      
    String responseBody = responce.getBody();
    Map <String, Object> resultObject = (Map <String, Object>)JSON.deserializeUntyped(responseBody);
    String recordId = (String)resultObject.get('id');
    system.debug(recordId);
  
    System.debug(recordId);
  
    account.External_Id__c = recordId;
    upsert account;
  }

  @future(callout = true)
  public static void sendUpdateRequest(Id id) {
    Account account = RestSynchronizationService.getAccountById(id);
    Account accountForUpdate = RestSynchronizationService.createAccountForRequest(account);
    accountForUpdate.From_Api__c = true;
  
    Http http = new Http();
    HttpRequest request = new HttpRequest();  
    request.setEndpoint('callout:AnotherOrg/services/data/v49.0/sobjects/Account/' + account.External_Id__c);  
    request.setMethod('PATCH');    
    request.setHeader('Content-Type', 'application/json;charset=UTF-8');
    System.debug(JSON.serialize(accountForUpdate));
    request.setBody(JSON.serialize(accountForUpdate)); 
    HttpResponse responce = http.send(request);

    System.debug(responce);
  }

  @future(callout = true)
  public static void sendDeleteRequest(String externalId) {
    Account accountForUpdate = new Account(
      External_Id__c = null
    );
  
    Http http = new Http();
    HttpRequest request = new HttpRequest();  
    request.setEndpoint('callout:AnotherOrg/services/data/v49.0/sobjects/Account/' + externalId);  
    request.setMethod('PATCH');    
    request.setHeader('Content-Type', 'application/json;charset=UTF-8');
    System.debug(JSON.serialize(accountForUpdate));
    request.setBody(JSON.serialize(accountForUpdate)); 
    HttpResponse responce = http.send(request);

    System.debug(responce);
  }

  public static Account getAccountById(Id id) {
    Account account = [SELECT Name, AccountNumber, Phone, BillingStreet, 
                              BillingCity, BillingCountry, BillingState, 
                              BillingPostalCode, BillingLatitude, BillingLongitude, 
                              ShippingStreet, ShippingCity, ShippingCountry, 
                              ShippingState, ShippingPostalCode, ShippingLatitude, 
                              ShippingLongitude, External_Id__c
                              FROM Account WHERE Id = :id];
    return account;
  }

  public static Account createAccountForRequest(Account account) {
    Account newAccount = new Account(
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
  