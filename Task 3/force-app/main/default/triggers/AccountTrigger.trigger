trigger AccountTrigger on Account (after update) {
  if(Trigger.isUpdate) {
    AccountTriggerHelper.iterateAccounts(Trigger.new, Trigger.oldMap);
  }
}