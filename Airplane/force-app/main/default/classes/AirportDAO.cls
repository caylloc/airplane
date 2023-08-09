public with sharing class AirportDAO {
    public Airport__c getAirportById(String id) {
        return [SELECT Id, Name, Latitude__c, Longitude__c FROM Airport__c WHERE id=:id LIMIT 1];
    }
}