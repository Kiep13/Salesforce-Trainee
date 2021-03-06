public with sharing class PutSynchronization implements Queueable, Database.AllowsCallouts {

  private List<Id> ids;
  
  public PutSynchronization(List<Id> ids) {
    this.ids = ids;
  }

  public void execute(QueueableContext context) {
    List<Account> accounts = this.getAccountsByIds(ids);
    List<Account> accountsForRequest = new List<Account>();

    for (Account account : accounts) {
      Account accountForRequest = this.createAccountForRequest(account);
      accountsForRequest.add(accountForRequest);
    }

    AccountRequestWrapper wrapper = new AccountRequestWrapper(false, accountsForRequest);

    Http http = new Http();
    HttpRequest request = new HttpRequest();  
    request.setEndpoint('callout:AnotherOrg/services/data/v49.0/composite/sobjects/Account/External_Id__c/?_HttpMethod=PATCH');  
    request.setMethod('POST');    
    request.setHeader('Content-Type', 'application/json;charset=UTF-8');
    request.setBody(JSON.serialize(wrapper)); 
    HttpResponse responce = http.send(request);
      
    String responseBody = responce.getBody();
    List<AccountInsertResponse> resultObjects = (
      List<AccountInsertResponse>)JSON.deserialize(responseBody, List<AccountInsertResponse>.class);

    for(Integer i = 0; i < resultObjects.size(); i++) {
      String recordId = (String)resultObjects[i].id;
      System.debug(recordId);
      accounts[i].External_Id__c = recordId;
    }

    update accounts;
  }

  private List<Account> getAccountsByIds(List<Id> ids) {
    return [SELECT Name, AccountNumber, Phone, BillingStreet, 
                              BillingCity, BillingCountry, BillingState, 
                              BillingPostalCode, BillingLatitude, BillingLongitude, 
                              ShippingStreet, ShippingCity, ShippingCountry, 
                              ShippingState, ShippingPostalCode, ShippingLatitude, 
                              ShippingLongitude, External_Id__c
                              FROM Account WHERE Id = :ids];
  }

  private Account createAccountForRequest(Account account) {
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
