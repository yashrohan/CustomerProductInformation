@isTest
public class Test_FetchProductFromUUID {
    
  @TestSetup
  static void makeData(){
      Contact con = (Contact)TestDataFactory.createSObject('Contact',false);
      insert con;
      
      Case ca = (Case)TestDataFactory.createSObject('Case',false);
      ca.contactId = con.Id;
      insert ca;
  }
    
    @isTest 
    public static void testScenarioWithUUIDPresent() {
        List<Contact> conLst = [Select id from Contact limit 1];
        conLst[0].Product__c = 'Black';
        conLst[0].Home_Country__c = 'FR';
        conLst[0].uuid__c = '1234';
        update conLst;
        
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();             
        req.requestURI = '/services/apexrest/getProductValue/';
        req.httpMethod = 'POST';
        test.startTest();
        RestContext.request = req;
        RestContext.response= res;
        FetchProductFromUUID.ProductWrapper prodResponse = FetchProductFromUUID.returnStatus('1234');
        test.stopTest();
        
        /*Asserts*/
        for(FetchProductFromUUID.ProductValue prod : prodResponse.data){
          if(prod.type == 'Cost per Calendar Month'){
             system.assertEquals(prod.value,'€ 9,90'); 
          }
          else if(prod.type == 'ATM Fee in other currencies'){
             system.assertEquals(prod.value,'Free');  
          }
          else if(prod.type == 'Card Replacement Cost'){
              system.assertEquals(prod.value,'€ 6'); 
          }
        }
    }

    @isTest 
    public static void testScenarioWithoutUUIDPresent() {
        List<Contact> conLst = [Select id from Contact limit 1];
        conLst[0].Product__c = '';
        conLst[0].Home_Country__c = '';
        conLst[0].uuid__c = '1111';
        update conLst;
        
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();             
        req.requestURI = '/services/apexrest/getProductValue/';
        req.httpMethod = 'POST';
        test.startTest();
        RestContext.request = req;
        RestContext.response= res;
        FetchProductFromUUID.ProductWrapper prodResponse = FetchProductFromUUID.returnStatus('1234');
        test.stopTest();
        
        /*Asserts*/
        system.assertEquals(prodResponse.error.status,'400');
        system.assertEquals(prodResponse.data,new List<FetchProductFromUUID.ProductValue>());
    }
    
    
    
}