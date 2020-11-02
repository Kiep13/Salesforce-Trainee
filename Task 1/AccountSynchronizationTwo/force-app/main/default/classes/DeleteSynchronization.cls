public with sharing class DeleteSynchronization implements Queueable, Database.AllowsCallouts {
  private List<String> ids;
  
  public DeleteSynchronization(List<String> ids) {
    this.ids = ids;
  }
  
  public void execute(QueueableContext context) {
    String endPoint = 'callout:AnotherOrg/services/data/v49.0/composite/sobjects?ids=';
  
    for(String id: ids) {
      endPoint = endpoint + id + ',';
    }
  
    endPoint = endPoint.removeEnd(',');
  
    Http http = new Http();
    HttpRequest request = new HttpRequest();
    request.setEndpoint(endPoint);
    request.setMethod('DELETE');
  
    HTTPResponse response = http.send(request);
  }
}
  