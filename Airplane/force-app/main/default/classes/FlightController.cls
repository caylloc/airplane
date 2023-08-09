public class FlightController {

    public static FlightHelper helper = new FlightHelper();
    public static FlightDAO flightDAO = new FlightDAO();
    public static AirportDAO airportDAO = new AirportDAO();
    
    public class FlightException extends Exception {}
    @AuraEnabled(cacheable=true)
    public static Airport__c getAirportById(String id) {
        return airportDAO.getAirportById(id);
    }
    
    @AuraEnabled
    public static Flight__c saveFlight(Flight__c flight) {
        validateFlight(flight);
        Airport__c departureAirport = getAirportById(flight.Departure_Airport__c);
        Airport__c arrivalAirport = getAirportById(flight.Arrival_Airport__c);
        return createFlight(flight, departureAirport, arrivalAirport);
    }

    private static Flight__c createFlight(Flight__c flight ,Airport__c departureAirport, Airport__c arrivalAirport){
        Decimal distance = helper.calculateDistance(
            departureAirport.Latitude__c, departureAirport.Longitude__c,
            arrivalAirport.Latitude__c, arrivalAirport.Longitude__c
        );
        
        flight.Distance__c = distance / 1000; 
        
        insert flight;
        return flightDAO.getFlightById(flight.id);
    }
    private static void validateFlight (Flight__c flight ){
        if (flight.Departure_Airport__c == null || flight.Arrival_Airport__c == null) {
            throw new FlightException('Para calcular é preciso preencher os campos de aeroportos.');
        }
        if (flight.Departure_Airport__c == flight.Arrival_Airport__c) {
            throw new FlightException('Impossível calcular a rota para aeroportos iguais.');
        }
    }   
}