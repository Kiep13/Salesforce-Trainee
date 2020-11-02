public with sharing class AccountTriggerHelper implements Queueable, Database.AllowsCallouts {

  private List<Id> ids;
  
  public AccountTriggerHelper(List<Id> ids) {
    this.ids = ids;
  }

  public void execute(QueueableContext context) {
    List<Account> accounts = [SELECT Id,  Generate_PDF__c FROM Account WHERE Id IN :ids];

    for (Account account : accounts) {
      account.Generate_PDF__c = false;
      this.savePdf(account.id);
    }

    update accounts;
  }

  public void savePdf(Id id) {

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
