@isTest
public class TestDataFactory {
    
    public static SObject createSObject(String sObjectName,Boolean isInsert){
        
        Map<String,String> requiredValueMap = new Map<String,String>();
        
        if(sObjectName == 'Contact'){
            requiredValueMap.put('LastName','Singh');
        }
        else if(sObjectName == 'Case'){
            requiredValueMap.put('Status','New');
            requiredValueMap.put('origin','Phone');
        }
        
        return createSObject(sObjectName,requiredValueMap,isInsert);
    }
    
     public static SObject createSObject(String sObjectName,Map<String,String> requiredValues,Boolean isInsert){
         
         sObject ret ;
         
         if(sObjectName == 'Case'){
             Case ca = new Case();
             ret = (sObject)ca;
         }
         else if(sObjectName == 'Contact'){
             Contact con = new Contact();
             ret = (sObject)con;
         }
         
         for(String apiName : requiredValues.keySet()){
             ret.put(apiName,requiredValues.get(apiName)); 
         }
         
         if(isInsert){
             insert ret;
         }
        
        return ret;
    }
    
    

}