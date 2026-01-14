public class HttpClient {

    public String makeRequest() {
        Http h = new Http();

        HttpRequest req = new HttpRequest();
        Integration_Config__mdt config = Integration_Config__mdt.getInstance('Country_Layer');
        req.setEndpoint('callout:Country_Layer_API/all?access_key=' + EncodingUtil.urlEncode(config.API_Key__c, 'UTF-8'));
        req.setMethod('GET');

        HttpResponse res = h.send(req);
        return res.getBody();
    }
}