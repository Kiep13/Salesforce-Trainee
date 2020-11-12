trigger AccountTrigger on Account (after insert, after update) {
  if(Trigger.isInsert) {
    AccountTriggerHelper.iterateInsertAccounts(Trigger.new);
  } else if(Trigger.isUpdate) {
    AccountTriggerHelper.iterateUpdateAccounts(Trigger.new, Trigger.oldMap);
  }
}