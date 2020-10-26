trigger AccountInsert on Account (after insert) {
  for(Account account : Trigger.New) {
    System.debug(account.External_Id__c);
    if(account.External_Id__c == null) {
      System.debug('two insert request one');
      RestSynchronizationService.sendInsertRequest(account.id);
    }
  }
}