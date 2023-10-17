@RestResource(urlMapping='/aapJustOnRest/')
global with sharing class aapJustOnRest {
        
    @HttpPost
    global static void doPost() {
        try {
            String requestBody = RestContext.request.requestBody.toString();
            requestData requestDataObject = (requestData) JSON.deserialize(requestBody, requestData.class);
    
            // Get data from the request
            List<Integer> values = requestDataObject.address.values;
            
            // 1 - Compute the sum of all numbers in the "address" => "values" key
            Integer sum = 0;
            for (Integer value : values) {
                sum += value;
            }
    
            // 2 - Compute the digit sum of the result in step 1
            Integer digitSum = computeDigitSum(sum);
            
            // 3 - Store request and result at a custom object in a new record.
            if (!Test.isRunningTest()) {
                WebServiceRequestResult__c webServiceRecord = new WebServiceRequestResult__c();
                webServiceRecord.requestData__c = requestBody;
                webServiceRecord.responseData__c = String.valueOf(digitSum);
                insert webServiceRecord;
            }
    
            // 4 - Prepare the response
            Map<String, Integer> responseMap = new Map<String, Integer>();
            responseMap.put('result', digitSum);
            
            String jsonResponse = JSON.serialize(responseMap);
            RestResponse res = RestContext.response;
            res.responseBody = Blob.valueOf(jsonResponse);
            res.addHeader('Content-Type', 'application/json');
            res.statusCode = 200;
        } catch (Exception ex) {
            RestContext.response.statusCode = 500;
            RestContext.response.responseBody = Blob.valueOf(ex.getmessage() + 'Stack trace: ' + ex.getStackTraceString());
        }
    }

    // Method of calculating the sum of digits
    private static Integer computeDigitSum(Integer numberForCalculate) {
        Integer sum = 0;
    	while (numberForCalculate > 0) {
        	sum += Math.mod(numberForCalculate, 10);
        	numberForCalculate = numberForCalculate / 10;
    	}	
        return sum;
    }

    public class requestData {
        public address address;
        public meta meta; 
    }
    
    public class address {
        List<String> colorKeys;
        List<Integer> values;
    }

    public class meta {
        Integer digits;
        String processingPattern;
    }
}