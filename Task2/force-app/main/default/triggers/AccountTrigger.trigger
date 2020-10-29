trigger AccountTrigger on Account (after update) {
  if (Trigger.isUpdate) {
    List<Id> needGeneratePdfIds = new List<Id>();

    for (Account account : Trigger.new) {
      if(account.Generate_PDF__c) {
        needGeneratePdfIds.add(account.Id);
      }
    }

    AccountTriggerHelper.generatePDFS(needGeneratePdfIds);
  }
}