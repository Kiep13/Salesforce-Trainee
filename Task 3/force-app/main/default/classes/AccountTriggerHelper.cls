public with sharing class AccountTriggerHelper {
  public static void iterateAccounts(List<Account> newAccounts, Map<Id, Account> oldAccounts) {
    List<Account_Change__e> events = new List<Account_Change__e>();

    for(Account newAccount: newAccounts) {
      Account oldAccount = oldAccounts.get(newAccount.Id);
      List<FieldChanges> listFieldChanges = detectFieldChanges(newAccount, oldAccount);

      if(listFieldChanges.size() > 0) {
        events.add(createEvent(newAccount.Id, listFieldChanges));
      }
    }

    for(Account_Change__e event : events) {
      EventBus.publish(event);
    }
  }

  @TestVisible private static List<FieldChanges> detectFieldChanges(Account newAccount, Account oldAccount) {
    SobjectType objectType = Schema.getGlobalDescribe().get('Account');
    Map<String, Schema.SObjectField> fieldMap = objectType.getDescribe().fields.getMap();

    List<FieldChanges> listFieldChanges = new List<FieldChanges>();

    for(String field: fieldMap.keySet()) {
      if(newAccount.get(field) != oldAccount.get(field)) {
        listFieldChanges.add(new FieldChanges(field, oldAccount.get(field), newAccount.get(field)));
      }
    }

    return listFieldChanges;
  }

  @TestVisible private static Account_Change__e createEvent(String id, List<FieldChanges> listFieldChanges) {
    String message = UserInfo.getFirstName() + ' ' + UserInfo.getLastName() + ' changed data\n';

    for (FieldChanges fieldChanges : listFieldChanges) {
      message += fieldChanges.fieldName + ' : ' + fieldChanges.oldValue + ' -> ' + fieldChanges.newValue + ';\n';
    }

    Account_Change__e changesEvent = new Account_Change__e();
    changesEvent.Message__c = message;
    changesEvent.Id__c = id;

    return changesEvent;
  }
}
