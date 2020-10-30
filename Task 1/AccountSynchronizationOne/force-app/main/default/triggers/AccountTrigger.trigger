trigger AccountTrigger on Account (after insert, after update, before delete) {
  if (Trigger.isInsert) {
    AccountWorker.proccessInsert(Trigger.new);
  } else if (Trigger.isUpdate) {
    AccountWorker.proccessUpdate(Trigger.new, Trigger.oldMap);
  } else if(Trigger.isDelete) {
    AccountWorker.processDelete(Trigger.old);
  }
}