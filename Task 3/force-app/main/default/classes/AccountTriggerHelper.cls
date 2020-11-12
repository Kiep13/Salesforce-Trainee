public with sharing class AccountTriggerHelper {
  public static void iterateAccounts(List<Account> newAccounts, Map<Id, Account> oldAccounts) {
    for(Account newAccount: newAccounts) {
      Account oldAccount = oldAccounts.get(newAccount.Id);
      detectFieldChanges(newAccount, oldAccount);
    }
  }

  private static void detectFieldChanges(Account newAccount, Account oldAccount) {
    SobjectType objectType = Schema.getGlobalDescribe().get('Account');
    Map<String, Schema.SObjectField> fieldMap = objectType.getDescribe().fields.getMap();

    List<FieldChanges> listFieldChanges = new List<FieldChanges>();

    for(String field: fieldMap.keySet()) {
      if(newAccount.get(field) != oldAccount.get(field)) {
        listFieldChanges.add(new FieldChanges(field, oldAccount.get(field), newAccount.get(field)));
      }
    }

    if(listFieldChanges.size() > 0) {
      sendEvent(listFieldChanges);
    }
  }

  private static void sendEvent(List<FieldChanges> listFieldChanges) {
    String message = UserInfo.getFirstName() + ' ' + UserInfo.getLastName() + ' changed data\n';

    for (FieldChanges fieldChanges : listFieldChanges) {
      message += fieldChanges.fieldName + ' : ' + fieldChanges.oldValue + ' -> ' + fieldChanges.newValue + ';\n';
    }

    Account_Change__e changesEvent = new Account_Change__e(Message__c = message);
    Database.SaveResult sr = EventBus.publish(changesEvent);

    if (sr.isSuccess()) {
      System.debug('Successfully published event.');
    } 
  }
}
