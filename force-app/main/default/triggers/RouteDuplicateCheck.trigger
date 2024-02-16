trigger RouteDuplicateCheck on Route__c (before insert) {
    Set<String> predefinedAreas = new Set<String>();
    for (Route__c route : Trigger.new) {
        predefinedAreas.add(route.Predefined_Area__c);
    }
    
    Map<String, List<Route__c>> predefinedAreaToRoutes = new Map<String, List<Route__c>>();
    List<Predefine_Route__mdt> predefinedAreaRecords = [SELECT Predefine_Area__c,Sales_User__c FROM Predefine_Route__mdt];
    
    for (Route__c existingRoute : [SELECT Id, Predefined_Area__c, Sales_User__c FROM Route__c WHERE Predefined_Area__c IN :predefinedAreas AND Sales_User__c = :UserInfo.getUserId()]) {
        if (!predefinedAreaToRoutes.containsKey(existingRoute.Predefined_Area__c)) {
            predefinedAreaToRoutes.put(existingRoute.Predefined_Area__c, new List<Route__c>());
        }
        predefinedAreaToRoutes.get(existingRoute.Predefined_Area__c).add(existingRoute);
    }
    
    for (Route__c newRoute : Trigger.new) {
        if (predefinedAreaToRoutes.containsKey(newRoute.Predefined_Area__c)) {
            for (Route__c existingRoute : predefinedAreaToRoutes.get(newRoute.Predefined_Area__c)) {
                if (existingRoute.Id != newRoute.Id) { 
                    newRoute.addError('A route with the same Predefined Area already exists for this sales user.');
                }
            }
        }
    }
}