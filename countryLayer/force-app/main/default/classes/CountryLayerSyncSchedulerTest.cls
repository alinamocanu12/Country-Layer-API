@IsTest
public class CountryLayerSyncSchedulerTest implements HttpCalloutMock {

    @IsTest
    private static void makeTestData() {
        Country__c c1 = new Country__c(Name = 'Italy', Alpha2Code__c = 'IT', Alpha3Code__c = 'ITA', Region__c = 'Europe', Capital_City__c = 'Rome');
        Country__c c2 = new Country__c(Name = 'France', Alpha2Code__c = 'FR', Alpha3Code__c = 'FRA', Region__c = 'Europe', Capital_City__c = 'Paris');
        Country__c c3 = new Country__c(Name = 'Spain', Alpha2Code__c = 'ES', Alpha3Code__c = 'ESP', Region__c = 'Europe', Capital_City__c = 'Madrid',
                                      Regional_Blocs__c = 'SAARC;ASEAN;Mercosur');
        
        insert new List<Country__c> {c1, c2, c3};
    }
    
    @IsTest
    private static void scheduleCountryLayerSrvUpdateTest() {
        makeTestData();
        Test.setMock(HttpCalloutMock.class, new CountryLayerSyncSchedulerTest());
        Test.startTest();
        CountryLayerSyncScheduler srv = new CountryLayerSyncScheduler();
        String jobId = System.schedule('Country Layer Srv', '0 0 12 * * ?', new CountryLayerSyncScheduler());
        System.enqueueJob(new CountryLayerSyncQueueable());
        Test.stopTest();
        Country__c c = [SELECT Id, Regional_Blocs__c FROM Country__c WHERE Name = 'Spain' LIMIT 1];
        Assert.isTrue(c.Regional_Blocs__c == 'EU');
    }
        
    @IsTest
    private static void scheduleCountryLayerSrvCreateTest() {
        Test.setMock(HttpCalloutMock.class, new CountryLayerSyncSchedulerTest());
        Test.startTest();
        CountryLayerSyncScheduler srv = new CountryLayerSyncScheduler();
        String jobId = System.schedule('Country Layer Srv', '0 0 12 * * ?', new CountryLayerSyncScheduler());
        System.enqueueJob(new CountryLayerSyncQueueable());
        Test.stopTest();
        List<Country__c> countries = [SELECT Id, Regional_Blocs__c FROM Country__c];
        Assert.isFalse(countries.isEmpty());
    }
    
    public HttpResponse respond(HttpRequest request) {
        CountryWrapper.RegionalBloc regionalBloc = new CountryWrapper.RegionalBloc();
        regionalBloc.name = 'European Union';
        regionalBloc.acronym = 'EU';
        
        CountryWrapper countryResp = new CountryWrapper();
        countryResp.name = 'Spain';
        countryResp.alpha2Code = 'ES';
        countryResp.alpha3Code = 'ESP';
        countryResp.capital = 'Madrid';
        countryResp.region = 'Europe';
        countryResp.regionalBlocs = new List<CountryWrapper.RegionalBloc> {regionalBloc};
            
        HttpResponse response = new HttpResponse();
        response.setHeader('Content-Type', 'application/json');
        response.setBody(JSON.serialize(new List<CountryWrapper>{ countryResp }));
        response.setStatusCode(200);
        return response;
    }
}