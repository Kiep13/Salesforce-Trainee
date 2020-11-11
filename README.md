# SalesforceTrainee

***

## Task 1

Need to realize Account synchronization between two SF orgs.

1. Synchronization works on Name, Number, Phone, Billing Address, Shipping Address fields changing
2. Synchronization should be like real time
3. Synchronization should work in two sides
4. 100% Test coverage

***

## Task 2

1. Create custom field on Account object with type checkbox
2. Detect changing this field, and if it is set to TRUE, need to generate a PDF file with Account information
3. PDF file must be related to the account
4. PDF should include:
    * Account info: Name, Phone, Billing and Shipping Addresses 
    * List of related Contacts: First Name, Last Name, Email, Phone and Address
    
***

## Task 2.1 (related to Task 2)

1. Create the button which will work with logic of generating PDF
2. Use LWC

***

## Task 3

1. Need to generate platform event on account updating 
2. On Account page should appear message about account changing
3. Message should include data about changes. For example: <br/>
 Account Name ExactTarget ->  Salesforce Marketing Cloud
