trigger AccountInsert on Account (after insert) {
  for(Account account : Trigger.New) {
    if(account.External_Id__c == null) {
      RestSynchronizationService.sendInsertRequest(account.id);
    }
  }
}