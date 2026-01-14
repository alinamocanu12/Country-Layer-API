public class CountryLayerSrv {
    /*
     @description: updates/inserts country records based on the API response
    */
    public static void updateCountries() {	
        Map<String, Country__c> countriesMap = new Map<String, Country__c> {}; 
        Map<String, CountryWrapper> countriesFromApiMap = new Map<String, CountryWrapper> {}; 
        List<CountryWrapper> countriesFromApi = getCountriesFromApi();
        List<Country__c> countriesToUpdate = new List<Country__c>{};
        List<Country__c> countriesToInsert = new List<Country__c>{};
        
        
        if (countriesFromApi == null)
            throw new CountryLayerSrvException('Could not retrieve countries from API');
        
        for (CountryWrapper c : countriesFromApi) {
            countriesFromApiMap.put(c.alpha2Code, c);
        }
        
        List<Country__c> countries = [SELECT Id, Name, Alpha2Code__c, Alpha3Code__c, Capital_City__c, Region__c, Regional_Blocs__c 
                                      FROM Country__c
                                      WHERE Alpha2Code__c IN :countriesFromApiMap.keyset()];
 
       for (Country__c c : countries) {
            countriesMap.put(c.Alpha2Code__c, c);
        }
        // loop through country records retrieved from the API
        // if a country with the current alpha2code exists in the org, update the record
        // otherwise create a new country record
        for (CountryWrapper c : countriesFromApi) {
            Set<String> regionalBlocs = new Set<String>{};
            if (c.regionalBlocs != null)
                for (CountryWrapper.RegionalBloc bloc : c.regionalBlocs) 
                    regionalBlocs.add(bloc.acronym);
                
            if (countriesMap.containsKey(c.alpha2Code)) {
                Country__c ctry = countriesMap.get(c.alpha2Code);

                if (ctry.Name != c.Name || ctry.Region__c != c.region || ctry.Alpha3Code__c != c.alpha3Code ||
                    ctry.Capital_City__c != c.capital || !toBlocSet(ctry.Regional_Blocs__c)?.equals(regionalBlocs)) {
                        
                    ctry.Name = c.Name;
                    ctry.Region__c = c.region;
                    ctry.Alpha3Code__c = c.alpha3Code;
                    ctry.Capital_City__c = c.capital;
                    ctry.Regional_Blocs__c = String.join(regionalBlocs, ';');
                    countriesToUpdate.add(ctry);
                }
                
            } else {
                Country__c newCountry = new Country__c(Name = c.Name, Region__c = c.region, Capital_City__c = c.capital, Alpha3Code__c = c.alpha3code, 
                                                       Alpha2Code__c = c.alpha2code, Regional_Blocs__c = String.join(regionalBlocs, ';'));
                countriesToInsert.add(newCountry);
            }

        }
        
        update countriesToUpdate;
        insert countriesToInsert;
    }
    
    /*
     @description: builds a set of sanitized strings based on the input string
    */
    public static Set<String> toBlocSet(String blocs) {
        Set<String> blocsSet = new Set<String>();
        if (String.isBlank(blocs)) return blocsSet;
    
        for (String part : blocs.split(';')) {
            String v = part == null ? '' : part.trim().toUpperCase();
            if (v != '') blocsSet.add(v);
        }
        
        return blocsSet;
    }
    
    /*
     @description: makes a GET request in order to retrieve the countries from the API
    */
    public static List<CountryWrapper> getCountriesFromApi() {
        List<CountryWrapper> responseWrapper;
        try {
            HttpClient client = new HttpClient();
            String response  = client.makeRequest();
            responseWrapper = CountryWrapper.parse(response);   
        } catch( Exception ex) {
            System.debug(ex.getMessage());
        }
        
        return responseWrapper;
    }
    
    public class CountryLayerSrvException extends Exception {}
}