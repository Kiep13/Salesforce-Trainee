public with sharing class AccountTriggerHelper {

  @future(callout=true)
  public static void generatePdfs(List<Id> ids) {
    List<Account> accounts = [SELECT Id,  Generate_PDF__c FROM Account WHERE Id IN :ids];

    for (Account account : accounts) {
      account.Generate_PDF__c = false;
      savePdf(account.id);
    }

    update accounts;
  }

  public static void savePdf(Id id) {

    Pagereference pdf = Page.AccountPage;
    pdf.getParameters().put('id', id);

    Attachment attach = new Attachment();
    
    Blob body;
    
    try {
        body = pdf.getContentAsPDF(); 
    } catch (VisualforceException e) {
     	body = Blob.valueOf('Test body');
    }

    System.debug(body);

    attach.Body = body;
    Datetime dt = Datetime.now();
    attach.Name = '' + dt.format('d.M.Y h:mm a') + '.pdf';
    attach.IsPrivate = false;
    attach.ParentId = id;

    insert attach;
  }
}
