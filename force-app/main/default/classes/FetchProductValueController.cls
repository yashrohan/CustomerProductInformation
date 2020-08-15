/**
     * description  : This Class is used to fetch the value of product based on different filter on Contacts
     * author       : Yash Rohan Singh
 */
public with sharing class FetchProductValueController {

    /*STATIC CONSTANTS*/
    public Static String CONTACT_OBJECT = 'Contact';
    public Static String PRODUCT_VALUE_API = 'Product_Value__c';
    public Static String SPECIAL_PACKAGE_API = 'Special_Package__c';
    public Static String PRODUCT_VALUE_MTDATA = 'Product_Value__mdt';
    public Static String AND_STRING = ' AND ';
    public Static String SELECT_STRING = ' Select ';
    public Static String FROM_STRING = ' From ';
    public Static String WHERE_STRING = ' Where ';

    /**
     * description  : This method fetches the value of product from Custom Metadata and 
     *                dynamically queries the contact records for filter values
     * params :       String product            : Contact's Product ,
     *                String country            : Contact's Country
     * return :       ProductInformationWrapper  : Wrapper consisting value of fields to display and value of 
     *                                             product
     */
    @AuraEnabled(cacheable = true)
    public static ProductInformationWrapper fetchValues(String contactId) {

        ProductInformationWrapper productInfo = new ProductInformationWrapper();
        List < String > metadataWhereClause = new List < String > ();
        List < String > contactWhereClause = new List < String > ();
        List < String > metadtaFromClause = new List < String > ();
        List < Product_Value__mdt > metadataRecord = new List < Product_Value__mdt > ();
        List < String > contactFieldsQuery = new List < String > ();
        List < Contact > contactRecord = new List < Contact > (); 

        try{
            if (String.isNotEmpty(contactId)) {
                /*Field Set for fetching list of fields to display*/
                for (Schema.FieldSetMember displayField: getFields()) {
                    contactFieldsQuery.add(displayField.getFieldPath());
                }
    
                /*Create Dynamic Query To Fetch Contact Record*/
                contactWhereClause.add('id =' + '\'' + contactId + '\'');
                contactRecord = (List < Contact > ) createDynamicQuery(contactFieldsQuery, CONTACT_OBJECT, contactWhereClause);
    
                /*Fetch Value of Contact Record and create dynamic where clause for metadata*/
                for (String fieldApi: contactFieldsQuery) {
                    metadataWhereClause.add(fieldApi + ' = ' + '\'' + contactRecord[0].get(fieldApi) + '\'');
                }
    
                /*Custom Metadata for fetching value based on the Dynamic Combination */
                metadtaFromClause.add(PRODUCT_VALUE_API);
                metadtaFromClause.add(SPECIAL_PACKAGE_API);
                metadataRecord = (List < Product_Value__mdt > ) createDynamicQuery(metadtaFromClause, PRODUCT_VALUE_MTDATA, metadataWhereClause);
    
                /*Assign Product Value*/
                if (!metadataRecord.isEmpty()) {
                    for (Product_Value__mdt productValue: metadataRecord) {
                        /* Displaying Product Value and Special Package */
                        ProductValueWrapper prod = new ProductValueWrapper();
                        prod.label = productValue.Special_Package__c;
                        prod.value = productValue.Product_Value__c;
                        productInfo.productValue.add(prod);
    
                    }
                }
            }
        }
        catch (Exception exp){
            /*Ideally there would be a exception logger*/
            system.debug('Line Number -->' + exp.getLineNumber() + 'Message --> ' + exp.getMessage());
            productInfo.exceptionMessage = exp.getMessage();
        }

        return productInfo;

    }

    /**
     * description  : This method is used to create dynamic query and execute them
     * params :       List < String > selectQuery : List of fields to be queried ,
     *                String fromQuery            : Object on which query will be done.
     *                List < String > whereQuery  : List of conditions to be but in where clause.
     * return :       List < SObject >  : List of sObject queried. 
     */
    public static List < SObject > createDynamicQuery(List < String > selectQuery, String fromQuery, List < String > whereQuery) {

        String whereClause = '';
        String selectClause = '';
        String dynamicQuery = '';
        List < SObject > lstRecrds = new List < SObject > ();

        if (!selectQuery.isEmpty()) {
            selectClause = String.join(selectQuery, ' , ');
        }

        if (!whereQuery.isEmpty()) {
            whereClause = String.join(whereQuery, AND_STRING);
        }

        dynamicQuery = SELECT_STRING + selectClause + FROM_STRING + fromQuery + WHERE_STRING + whereClause;
        lstRecrds = Database.query(dynamicQuery);
        return lstRecrds;
    }

    /**
     * description  : This method is used to fetch field from the fieldset
     * params :       none
     * return :       List < Schema.FieldSetMember >  : Schema.FieldSetMember will contain all 
     *                                                  the info about label , api name etc. 
     */
    public static List < Schema.FieldSetMember > getFields() {
        return SObjectType.Contact.FieldSets.Contact_Product_Info_Display.getFields();
    }


    /**
     * description  : Parent Wrapper which would contains product value information.
     *                More parameters can be added in future in this wrapper.
     */
    public class ProductInformationWrapper {

        @AuraEnabled
        public list < ProductValueWrapper > productValue;
        
        @AuraEnabled
        public String exceptionMessage = '';

        public ProductInformationWrapper() {
            productValue = new list < ProductValueWrapper > ();
        }
    }

    /**
     * description  : Child Wrapper for showing value of product.
     */
    public class ProductValueWrapper {
        @AuraEnabled
        public String label = '';
        @AuraEnabled
        public String value = '';
    }


}