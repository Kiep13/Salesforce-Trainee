public with sharing class RestSynchronizationService {

  @future(callout = true)
  public static void sendInsertRequest(Id id) {
    Account account = [SELECT Name, AccountNumber, Phone, BillingAddress, ShippingAddress FROM Account WHERE Id = :id];
    Account newAccount = new Account(
      Name = account.Name,
      AccountNumber = account.AccountNumber,
      Phone = account.Phone,
      External_Id__c = account.Id
    );
  
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
}
  