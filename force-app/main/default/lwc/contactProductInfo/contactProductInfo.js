import { LightningElement,api,wire,track } from 'lwc';
import {getRecord,getFieldValue} from 'lightning/uiRecordApi';
import CONTACT_ID_FIELD from '@salesforce/schema/Case.ContactId';
import fetchValues from '@salesforce/apex/FetchProductValueController.fetchValues';

const FIELDSET = [CONTACT_ID_FIELD];
const ERROR_MESSAGE = 'Error retrieving Customer Product Values.'
const NO_DATA_MESSAGE = 'Product Value could not be calculated due to incomplete data.'

export default class ContactProductInfo extends LightningElement {

    @api recordId; /*Fetch Record Id*/
    @api contactInfo;
    @api productValue;
    @api noData;

    /*Fields To Display*/
    @api contactId;

    @wire(getRecord,{recordId : '$recordId',fields : FIELDSET})
    fetchContactFields({error,data}){
        if(data){
           this.contactId = getFieldValue(data,CONTACT_ID_FIELD);    
        }
        else if(error){
           this.error = ERROR_MESSAGE;
        }
    }
    
    @wire(fetchValues,{'contactId' : '$contactId'})
    fetchRecord({error,data}){
        if(data){
            if(data.productValue){
                this.productValue = data.productValue;
            }
            else{
                this.noData = NO_DATA_MESSAGE;
            }
        }
        else if(error){
            this.error = ERROR_MESSAGE; 
        }
    }

   

}