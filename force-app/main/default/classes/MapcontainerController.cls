public class MapcontainerController {
    
    @AuraEnabled
    public static Account getAccountDetails(String recordId){
        Map<String,String> MapOfAccountIdCurrnetLatLong = new Map<String,String>();
        try{
            if(String.isNotBlank(recordId))
                return [SELECT Id,Name, BillingStreet, BillingCity, BillingState, BillingPostalCode,BillingCountry FROM Account WHERE Id=:recordId];
        }catch(Exception e){
            System.debug('The Error ::'+e.getMessage() +' AND Error Line No :'+e.getLineNumber());
        }
        return null;
    }
    
    @auraEnabled
    Public static String GoogleMapReverseGeocodeCallout(String lat, String lng){
        system.debug('lat =====> ' + lat+' && lng =====> ' + lng);
        String CompleteAddress = '';
        try{
            string key =System.label.GoogleApiKey;  //'AIzaSyB4SPqkO0ZQbxT-EU4l886H9Y3ipf1NMW0';
            Http httpProtocol = new Http();
            HttpRequest request = new HttpRequest();
            String endpoint = 'https://maps.googleapis.com/maps/api/geocode/json?latlng='+lat+',' +lng +'&key='+ key;
            request.setEndPoint(endpoint);
            request.setMethod('GET');
            HttpResponse response = httpProtocol.send(request);
            if(response.getStatusCode() == 200 || response.getStatusCode() == 201){
                Map<String, object> GooglemapResponseMap = (Map<String, Object>)JSON.deserializeUntyped(response.getBody());
                List<Object> Addresslist = (List<Object>)GooglemapResponseMap.get('results');
                integer j=0;
                for(integer i=0; i<Addresslist.size(); i++){
                    System.debug('Addresslist[i] =====>> '+Addresslist[i]);
                    if(i==0){
                        Map<String, Object> addressmap = (map<String, Object>)Addresslist[i];
                        CompleteAddress = String.valueof(addressmap.get('formatted_address'));
                        System.debug('CompleteAddress =====>> '+CompleteAddress);
                    }
                }
            }
        }
        catch(Exception e){
            System.debug('The Error ::'+e.getMessage() +' AND Error Line No :'+e.getLineNumber());
        }
        System.debug('CompleteAddress =====>> '+CompleteAddress); 
        return CompleteAddress;
    }
    
}