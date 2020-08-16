@RestResource(urlMapping ='/getProductValue/*')
global class FetchProductFromUUID {
    
    /**
     * description  : This method returns the response based on UUID
     * params :       String uuid
     * return :       ProductWrapper  : Wrapper consisting value of Products 
     *                                  and Error codes
     */
    @HTTPpost
    global static ProductWrapper returnStatus(String uuid){
        FetchProductValueController.ProductInformationWrapper fetchInfo = new FetchProductValueController.ProductInformationWrapper();
        ProductWrapper productWrap = new ProductWrapper();
        List<Contact> con = new List<Contact>();
        ErrorWrapper err = new ErrorWrapper();
        
        con = [Select id from Contact where uuid__c =: uuid Limit 1];
        
        /*Check if Contact is mapped to UUID*/
        if(!con.isEmpty()){
            fetchInfo = FetchProductValueController.fetchValues(con[0].Id);
            
            if(String.isEmpty(fetchInfo.exceptionMessage)){
                /*Create return wrapper*/
                for(FetchProductValueController.ProductValueWrapper prod :  fetchInfo.productValue){
                    ProductValue prodValue = new ProductValue();
                    prodValue.type = prod.label;
                    prodValue.value = prod.value;
                    productWrap.data.add(prodValue);
                }
                
                /*Success*/
                err.status = '200';
                err.message = 'Product Value Successfully Requested';
                productWrap.error = err;
            }
            else{
                /*Error Adding exception in response*/
                err.status = '401';
                err.message = fetchInfo.exceptionMessage;
                productWrap.error = err;
            }
        }
        else{
            /*In case UUID is not mapped to contact*/
            err.status = '400';
            err.message = 'UUID not found';
            productWrap.error = err;
        }
        
        return productWrap;
    } 
    
    global Class ParameterInfoWrapper{
        global String uuid;
    }
    
    global Class ProductWrapper{
        public List<ProductValue> data;
        public ErrorWrapper error;
        global ProductWrapper(){
            data = new List<ProductValue>();
            error = new ErrorWrapper();
        }
    }
    
    global class ProductValue {
        public String type;
        public String value;
        global ProductValue(){
            type = '';
            value = '';
        }
    }
    
    global class ErrorWrapper {
        public String status;
        public String message;
        global ErrorWrapper(){
            status = '';
            message = '';
        }
    }
    
}