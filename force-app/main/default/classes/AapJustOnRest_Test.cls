@isTest
private class AapJustOnRest_Test {

    @isTest
    static void testWebServiceSuccess() {
        // Creating the correct JSON string of the test request
        String testRequest = '{"address":{"colorKeys":["A","G","Z"],"values":[74,117,115,116,79,110]},"meta":{"digits":33,"processingPattern":"d{5}+[a-z&$§]"}}';

        // Creating a mock request
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        req.requestURI = URL.getOrgDomainUrl().toExternalForm() + '/services/apexrest/aapJustOnRest/';
        req.addHeader('Content-Type', 'application/json');
        req.httpMethod = 'POST';        
        req.requestBody = Blob.valueOf(testRequest);
        RestContext.request = req;
        RestContext.response = res;
        
        // Calling the service
        Test.startTest();
        aapJustOnRest.doPost();
        Test.stopTest();
        
        // Checking the response status code
        System.assertEquals(200, res.statusCode);

        // Checking the response
        Map<String, Object> responseMap = (Map<String, Object>) JSON.deserializeUntyped(res.responseBody.toString());
        Integer result = (Integer) responseMap.get('result');
        System.assertNotEquals(null, result); 
        System.assert(result != 0);
        System.assert(result > 0);

    }
    
    @isTest
    static void testWebServiceError() {
        // Creating the wrong JSON string of the test request
        String testRequest = '{"city":{"Strassenbahn":[3,4,6],"values":["74","117"]},"meta":{"digits":33}}';

        // Creating a mock request
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        req.requestURI = URL.getOrgDomainUrl().toExternalForm() + '/services/apexrest/aapJustOnRest/';
        req.addHeader('Content-Type', 'application/json');
        req.httpMethod = 'POST';        
        req.requestBody = Blob.valueOf(testRequest);
        RestContext.request = req;
        RestContext.response = res;
        
        // Calling the service
        Test.startTest();
        aapJustOnRest.doPost();
        Test.stopTest();
        
        // Checking the response status code
        System.assertEquals(500, res.statusCode);
    }
}