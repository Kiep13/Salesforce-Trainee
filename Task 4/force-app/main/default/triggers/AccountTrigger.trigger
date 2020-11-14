trigger AccountTrigger on Account (after insert, after update) {
  AccountTriggerHelper helper = new AccountTriggerHelper();

  if(Trigger.isInsert) {
    helper.iterateInsertAccounts(Trigger.new);
  } else if(Trigger.isUpdate) {
    helper.iterateUpdateAccounts(Trigger.new, Trigger.oldMap);
  }
}