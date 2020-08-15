@isTest(seeAllData = false)
public with sharing class Test_FetchProductValueController {
    
  @TestSetup
  static void makeData(){
      
      Contact con = (Contact)TestDataFactory.createSObject('Contact',false);
      con.Product__c = 'Black';
      con.Home_Country__c = 'FR';
      insert con;
      
      Case ca = (Case)TestDataFactory.createSObject('Case',false);
      ca.contactId = con.Id;
      insert ca;
      
  }

  @isTest
  public static void ifContactHasValues(){
    Case ca = [Select id,contactId from Case limit 1];
    test.startTest();
    FetchProductValueController.ProductInformationWrapper returnWrap =  FetchProductValueController.fetchValues(ca.contactId);
    test.stopTest();
    
      /*Verify the details*/
      for(FetchProductValueController.ProductValueWrapper prod : returnWrap.productValue){
          if(prod.label == 'Cost per Calendar Month'){
             system.assertEquals(prod.value,'€ 9,90'); 
          }
          else if(prod.label == 'ATM Fee in other currencies'){
             system.assertEquals(prod.value,'Free');  
          }
          else if(prod.label == 'Card Replacement Cost'){
              system.assertEquals(prod.value,'€ 6'); 
          }
      }
  }
    
  @isTest
  public static void ifContactHasNoProduct(){
    Contact con = [Select id,product__c from Contact limit 1];
    con.product__c = '';
    update con;
    test.startTest();
    FetchProductValueController.ProductInformationWrapper returnWrap =  FetchProductValueController.fetchValues(con.Id);
    test.stopTest();
      /*Verify the Details*/
      system.assertEquals(returnWrap.productValue,new List<FetchProductValueController.ProductValueWrapper>());
  }
    
  @isTest
  public static void checkIfException(){
    Case caa = [Select id from Case limit 1];
     test.startTest();
     FetchProductValueController.ProductInformationWrapper returnWrap =  FetchProductValueController.fetchValues(caa.Id);
    test.stopTest();
       /*Verify the Details*/
      system.assertEquals(returnWrap.productValue,new List<FetchProductValueController.ProductValueWrapper>());
      
  }

}