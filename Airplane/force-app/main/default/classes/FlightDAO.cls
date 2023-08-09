public class FlightDAO {
    public Flight__c getFlightById(String id) {
        return [Select Id,Departure_Airport__r.Name,Arrival_Airport__r.Name,Distance__c From Flight__c WHERE id =:id Limit 1];
    }

}