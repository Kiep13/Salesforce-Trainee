trigger AccountTrigger on Account (after insert, after update, before delete) {
  if (Trigger.isInsert) {
    AccountWorker.proccessInsert(Trigger.new);
  } else if (Trigger.isUpdate) {
    AccountWorker.proccessUpdate(Trigger.new, Trigger.oldMap);
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