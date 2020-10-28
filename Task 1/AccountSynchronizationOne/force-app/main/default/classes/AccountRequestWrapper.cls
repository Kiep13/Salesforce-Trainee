public with sharing class AccountRequestWrapper {
    public boolean allOrNone;
    public List<Account> records;

    public AccountRequestWrapper(boolean allOrNone,List<Account> records) {
        this.allOrNone = allOrNone;
        this.records = records;
    }
}
