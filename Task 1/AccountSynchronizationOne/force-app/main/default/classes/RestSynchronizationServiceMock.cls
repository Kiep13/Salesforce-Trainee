@IsTest
global class RestSynchronizationServiceMock implements HttpCalloutMock {
  global static String TEST_EXTERNAL_ID = '0019000001hE8apAAC';

  global HTTPResponse respond(HTTPRequest request) {
    HttpResponse response = new HttpResponse();
    response.setHeader('Content-Type', 'application/json');
    response.setBody('[{ "id" : "' + TEST_EXTERNAL_ID + '", "success" : true, "errors" : [ ] }]');
    response.setStatusCode(200);
    return response; 
  }
}
