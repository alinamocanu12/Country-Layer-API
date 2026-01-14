public with sharing class LeadTriggerHandler implements TriggerHandler {
    public void beforeInsert(List<Lead> newRecords) {
        updateCountryDetailsInsert(newRecords);
    }
    
    public void beforeUpdate(List<Lead> oldRecords, List<Lead> newRecords, Map<Id, SObject> oldRecordMap, Map<Id, SObject> newRecordMap) {
        updateCountryDetailsUpdate(newRecords, (Map<Id, Lead>)oldRecordMap);
    }
    
    public void beforeDelete(List<Lead> oldRecords, Map<Id, SObject> oldRecordMap) {
        
    }
    
    public void afterInsert(List<Lead> newRecords, Map<Id, SObject> newRecordMap) {
        
    }
    
    public void afterUpdate(List<Lead> oldRecords, List<Lead> newRecords, Map<Id, SObject> oldRecordMap, Map<Id, SObject> newRecordMap) {
        
    }
    
    public void afterDelete(List<Lead> oldRecords, Map<Id, SObject> oldRecordMap) {
        
    }
    
    public void afterUndelete(List<Lead> newRecords, Map<Id, SObject> newRecordMap) {
        
    }
    
    /*
     @description: populates Lead fields based on the related Country's field 
    */
    private void updateCountryDetailsInsert(List<Lead> newRecords) {
        Set<Id> countryIds = new Set<Id>{};
        for (Lead l : newRecords) {
           if (String.isNotBlank(l.Country__c))
               countryIds.add(l.Country__c);
               
        }
        
        Map<Id, Country__c> countriesMap = new Map<Id, Country__c>([SELECT Id, Capital_City__c, Region__c FROM Country__c WHERE Id IN :countryIds]);        
        for (Lead l : newRecords) {
            if (String.isBlank(l.Country__c))
                continue;
            
            Country__c country = countriesMap.get(l.Country__c);
            l.Region__c = country.Region__c;
            l.Capital_City__c = country.Capital_City__c;   
        }
    }
    
    /*
     @description: populates Lead fields based on the related Country's field 
    */
    private void updateCountryDetailsUpdate(List<Lead> newRecords, Map<Id, Lead> oldRecordMap) {
        Set<Id> countryIds = new Set<Id>{};
        for (Lead l : newRecords) {
           if (String.isNotBlank(l.Country__c))
               countryIds.add(l.Country__c);
               
        }
        
        Map<Id, Country__c> countriesMap = new Map<Id, Country__c>([SELECT Id, Capital_City__c, Region__c FROM Country__c WHERE Id IN :countryIds]);
        for (Lead l : newRecords) {
            if (l.Country__c == oldRecordMap.get(l.Id).Country__c)
                continue;
            
            if (String.isBlank(l.Country__c)){
               l.Region__c = '';
               l.Capital_City__c = '';  
            } else {
               Country__c country = countriesMap.get(l.Country__c);
               l.Region__c = country.Region__c;
               l.Capital_City__c = country.Capital_City__c;   
            }   
        }
    }
}