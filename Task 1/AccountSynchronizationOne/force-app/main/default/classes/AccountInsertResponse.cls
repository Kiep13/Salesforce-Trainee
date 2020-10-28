public with sharing class AccountInsertResponse {
  public String id;
  public Boolean success;

  public AccountInsertResponse(String id, Boolean success) {
    this.id = id;
    this.success = success;
  }
}
