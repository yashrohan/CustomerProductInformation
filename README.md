Use Case 1 Design Doc:-


Logic :- The logic followed here is below:-

1. Fetch the contactId from LWC component.
2. Fetch all the fields of Contact which needs to be filtered from FieldSet so that in future no one has to update the code for adding new filter.
3. Fetch all the Product Value records from Custom Metadata and apply the filters based on the current Contact.
4. Create a Wrapper for showcasing the Product Values and exception (if any).  

Generic Methodology for adding/updating filters and product in Simple Steps

In case user needs to add product Below steps needed to be followed :-

 1. Add particular product to Product Picklist in Contact Object.
 2. Add particular product to Product Picklist in Product Value Metadata.
 3. Create metadata record with respective values of Product and Country.

In case user needs to add new Filter based on some other Contact field Below steps needed to be followed :-

 1. Add the particular field to Contact Product Info Fieldset.
 2. Create new field in metadata with api name same as the api name of the Contact Field used.
 3. Update the existing metadata record with respective values of the new field filter .

Use Case 2 Design Doc:-

Logic :- Fetch The Type and Value based on the UUID provided , if UUID is not mapped the user would get a error coded.

Url Mapping :- /services/apexrest/getProductValue/

Error Codes :-

200 :- Ok
400 :- UUID not found
401 :- Exception in Apex

Sample Request Format :-

{
   "uuid" : "" 
}

Sample Response Format :- 

{
    "data" : [
           { "type" : "" , "value" : ""}
	],
	"error" : {
	   "status" : "",
	   "message" : ""
	}

}




Code Library Use Case 1 :-

Apex Class 

1. FetchProductValueController
2. Test_FetchProductValueController;
3. TestDataFactory

Custom Field

1. Contact.Product__c
2. Contact.Home_Country__C

FlexiPage

1. Case FlexiPage

LWC

1. contactProductInfo

Custom Metadata and Record

1. Product_Value

Fieldset

1. Contact_Product_Info_Display

Profile Permission

1. System Admin

Code Library Use Case 2 :-

Apex Class 

1. FetchProductFromUUID
2. Test_FetchProductFromUUID;
3. TestDataFactory


