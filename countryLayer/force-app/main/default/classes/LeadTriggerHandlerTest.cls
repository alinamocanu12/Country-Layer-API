@IsTest
public class LeadTriggerHandlerTest {
    
    @TestSetup
    private static void makeTestData() {
        Country__c c1 = new Country__c(Name = 'Italy', Region__c = 'Europe', Capital_City__c = 'Rome');
        Country__c c2 = new Country__c(Name = 'France', Region__c = 'Europe', Capital_City__c = 'Paris');
        List<Country__c> countries = new List<Country__c> {c1, c2};
        insert countries;
        Lead l = new Lead(LastName = 'Johnson', Company = 'Acme Inc.', Country__c = c1.Id);
        insert l;
    }
    
    @IsTest
    private static void updateCountryDetailsInsertTest() {
        Country__c c = [SELECT Id FROM Country__c WHERE Name = 'France' LIMIT 1];
        Lead l = new Lead(LastName = 'Smith', Company = 'Acme Inc.', Country__c = c.Id);
        insert l;
        
        l = [SELECT Id, Capital_City__c FROM Lead WHERE LastName = 'Smith' LIMIT 1];
        Assert.isTrue(l.Capital_City__c == 'Paris');
    }
    
    @IsTest
    private static void updateCountryDetailsInsertnEGATIVETest() {
        Lead l = new Lead(LastName = 'Smith', Company = 'Acme Inc.');
        insert l;
        
        l = [SELECT Id, Capital_City__c FROM Lead WHERE LastName = 'Smith' LIMIT 1];
        Assert.isNull(l.Capital_City__c);
    }
    
    @IsTest
    private static void updateCountryDetailsUpdateTest() {
        Lead l = [SELECT Id, Capital_City__c FROM Lead WHERE LastName = 'Johnson' LIMIT 1];
        Country__c c = [SELECT Id, Capital_City__c FROM Country__c WHERE Name = 'France' LIMIT 1];
        Assert.isTrue(l.Capital_City__c == 'Rome');
        
        l.Country__c = c.Id;
        update l; 
        l = [SELECT Id, Capital_City__c FROM Lead WHERE LastName = 'Johnson' LIMIT 1];
        Assert.isTrue(l.Capital_City__c == 'Paris');
    }
    
    @IsTest
    private static void updateCountryDetailsUpdateNegativeTest() {
        Lead l = [SELECT Id, Capital_City__c FROM Lead WHERE LastName = 'Johnson' LIMIT 1];
        Assert.isTrue(l.Capital_City__c == 'Rome');
        
        l.email = 'johnson.william@acme.com';
        update l;
        l = [SELECT Id, Capital_City__c FROM Lead WHERE LastName = 'Johnson' LIMIT 1];
        Assert.isTrue(l.Capital_City__c == 'Rome');
        
        l.Country__c = null;
        update l;
        l = [SELECT Id, Capital_City__c FROM Lead WHERE LastName = 'Johnson' LIMIT 1];
        Assert.isNull(l.Capital_City__c);
    }
}