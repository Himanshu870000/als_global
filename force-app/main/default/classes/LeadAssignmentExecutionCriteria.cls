public without sharing class LeadAssignmentExecutionCriteria {
    public static boolean handleAfterUpdate = true;
    
    public static void validateEntryCriteria(list<Lead__c> newLeadList){
        //Getting the Validated Leads : 
        List<Lead__c> leadListToBeProcessed = newLeadList;
        Set<Lead__c> assignedLead = new Set<Lead__c>();
        if(leadListToBeProcessed != Null){ 
            system.debug('leadListToBeProcessed ==> '+leadListToBeProcessed.size());
        }
        
        Boolean IsLeadAssigned = False;
        list<Lead__c> newLeadListTemp 												= new list<Lead__c>();
        list<Lead__c> DefaultQueueList 												= new list<Lead__c>();
        list<String> matchedCriterias 											= new list<String>();
        map<string,list<Lead__c>> mapofExecutionIdByListLead 						= new map<String,List<Lead__c>>();
        map<String,integer> mapofExeIdByEntryCount								= new map<string,Integer>();
        map<String,String> mapofExeIdByEvaluaationExp 							= new map<string,String>();
        map<String,List<String>> mapByallFields 		            	        = new map<String,List<String>>();
        map<String,List<String>> mapofFieldsWithPossibleValues 			        = new map<String,List<String>>();
        map<String,map<String,Map<String,String>>> matchingTypeFieldByCriteria = new map<String,map<String,Map<String,String>>>();
        map<string,map<string,List<String>>> multipleCriteriasForFields 	    = new map<string,map<string,List<String>>>();
        map<string,map<string,List<Decimal>>> allotedFieldbySequenceList	= new map<string, map<string,List<Decimal>>>();
        map<String,List<Lead__c>> mapofRMGroupNameByLeadList 						= new map<String,List<Lead__c>>();
        map<string,map<string,String>> expectedValuebyCriteria 					= new map<string,map<string,String>>();
        map<String,String> leadIdByMatchedCriterias 							= new map<String,String>();
        map<string,map<string,Decimal>> allotedFieldbySequence 					= new map<string,map<string,Decimal>>();
        map<string,String> criteriaNameById 									= new Map<String,String>();
        
        map<String,map<string,list<String>>> fieldByMatchingType 				= new map<String,map<string,list<String>>>();
        
        map<String,map<string,String>> fieldByFieldType 						= new map<String,map<string,String>>();
        map<string,String> leadValueForFields 									= new Map<String,String>();
        map<String,List<Lead__c>> mapofCriteriaIdByLeadList 						= new map<String,List<Lead__c>>();
        //Older
        map<String,List<Lead>> mapofFbGroupNameByLeadList = new map<String,List<Lead>>();
        map<string,Decimal> allotedMarksbySequence = new Map<String,Decimal>();
        set<String> newLeadsSet = new set<String>();
        
        if(leadListToBeProcessed != null){
            for(Lead__c leadRec:leadListToBeProcessed){
                newLeadListTemp.add(leadRec);
                newLeadsSet.add(leadRec.Id);
            }
        }
        
        List<Execution_Criteria__c> AvailableCriterias = [SELECT Enabled__c,Evaluation_Expression_For_Execution__c,Id,Name ,(SELECT Execution_Criteria__c,serial__c,Field_Name__c,Field_Type__c,Matching_Type__c,Matching_Value__c,Related_Object__c,Scorecard_Execution_Criteria_Name__c,Sequence__c FROM Execution_Criteria_Entry__r WHERE Execution_Criteria__c != null ORDER BY Sequence__c ASC)FROM Execution_Criteria__c where Enabled__c = true];
        for(Execution_Criteria__c scr:AvailableCriterias){
            map<string,string> fieldNameByMatching                                  = new Map<String,string>();
            map<string,List<Decimal>> allotedFieldbySequenceListMap 				= new Map<String,List<Decimal>>();
            map<string,Decimal> allotedFieldbySequenceMap 							= new Map<String,Decimal>();
            map<string,List<String>> fieldByMatchingTypeMap                        = new map<string,List<String>>();
            map<string,String>fieldByFieldTypeMap                                 = new map<string,String>();
            map<String,Map<String,String>> matchingTypeAndValuesByField 			= new map<String,Map<String,String>>();
            List<String> allFields 													= new List<String>();  
        
            for(Execution_Criteria_Entry__c exe:scr.Execution_Criteria_Entry__R){
                if(mapofFieldsWithPossibleValues.containsKey(exe.Field_Name__c)){
                    mapofFieldsWithPossibleValues.get(exe.Field_Name__c).add(exe.Matching_Value__c);
                }else{ 
                    mapofFieldsWithPossibleValues.put(exe.Field_Name__c,new list<string>{exe.Matching_Value__c});
                }
                
                if(fieldByMatchingTypeMap.containsKey(exe.Field_Name__c)){
                    fieldByMatchingTypeMap.get(exe.Field_Name__c).add(exe.Matching_Type__c);
                }else{ 
                    fieldByMatchingTypeMap.put(exe.Field_Name__c,new list<string>{exe.Matching_Type__c});
                }
                
                if(matchingTypeAndValuesByField.containsKey(exe.Field_Name__c)){
                    matchingTypeAndValuesByField.get(exe.Field_Name__c).put(exe.Matching_Type__c,exe.Matching_Value__c);
                }else{ 
                    map<string,String> matchingTypeAndValues = new  map<string,String>();
                    matchingTypeAndValues.put(exe.Matching_Type__c,exe.Matching_Value__c);
                    matchingTypeAndValuesByField.put(exe.Field_Name__c,matchingTypeAndValues);
                }
                
                if(allotedFieldbySequenceMap.containsKey(exe.Field_Name__c)){
                    allotedFieldbySequenceListMap.get(exe.Field_Name__c).add(exe.Sequence__c);
                }else{ 
                    allotedFieldbySequenceListMap.put(exe.Field_Name__c,new list<Decimal>{exe.Sequence__c});
                }
                allotedFieldbySequenceMap.put(exe.Field_Name__c,exe.Sequence__c);
                fieldNameByMatching.put(exe.Field_Name__c,exe.Matching_Value__c);
                fieldByFieldTypeMap.put(exe.Field_Name__c,exe.Field_Type__c);
                allFields.add(exe.Field_Name__c);
            }
            
            fieldByMatchingType.put(scr.Name,fieldByMatchingTypeMap);
            fieldByFieldType.put(scr.Name,fieldByFieldTypeMap);
            mapByallFields.put(scr.Name,allFields);
            allotedFieldbySequence.put(scr.Name,allotedFieldbySequenceMap);
            allotedFieldbySequenceList.put(scr.Name,allotedFieldbySequenceListMap);
            matchingTypeFieldByCriteria.put(scr.Name,matchingTypeAndValuesByField);
            mapofExeIdByEntryCount.put(scr.Id,scr.Execution_Criteria_Entry__r.size());
            mapofExeIdByEvaluaationExp.put(scr.Name,scr.Evaluation_Expression_For_Execution__c);
            expectedValuebyCriteria.put(scr.Name,fieldNameByMatching);
            multipleCriteriasForFields.put(scr.Name,mapofFieldsWithPossibleValues);
            criteriaNameById.put(scr.Name,scr.Id);
            
        }
        system.debug('allotedFieldbySequenceList ==> '+allotedFieldbySequenceList);
        system.debug('allotedFieldbySequence ===> '+allotedFieldbySequence);
        system.debug('mapofFieldsWithPossibleValues ==> '+mapofFieldsWithPossibleValues);
        system.debug('expectedValuebyCriteria ==> '+expectedValuebyCriteria);
        system.debug('newLeadListTemp ==> '+newLeadListTemp);
        system.debug('mapByallFields ==> '+mapByallFields);
        system.debug('criteriaNameById ==> '+criteriaNameById);
        system.debug('multipleCriteriasForFields ==> '+multipleCriteriasForFields);
        system.debug('matchingTypeFieldByCriteria ==> '+matchingTypeFieldByCriteria);
        
        String logicalValues = '';
        
        for(Lead__c ld:newLeadListTemp){
            boolean leadTemp = false;
            List<String> matchedCriteriasName = new List<String>();
            for(String criteriaName : expectedValuebyCriteria.keyset()){
                system.debug('criteriaName ==> '+criteriaName);
                String Booleanvalues = mapofExeIdByEvaluaationExp.get(criteriaName);
                system.debug('Booleanvalues ==> '+Booleanvalues);
                integer matchedValues = 0;
                Decimal recursionValue = 0;
                
                system.debug('expectedValuebyCriteria.get(criteriaName).Keyset() ==> '+expectedValuebyCriteria.get(criteriaName).Keyset());
                for(String field:mapByallFields.get(criteriaName))  {
                    
                    recursionValue = allotedFieldbySequence.get(criteriaName).get(field);
                    system.debug('recursionValue ==> '+recursionValue);
                    system.debug('matchingTypeFieldByCriteria ==> '+matchingTypeFieldByCriteria);
                    system.debug('matchingTypeFieldByCriteria.get(criteriaName).get(field).size() ==> '+matchingTypeFieldByCriteria.get(criteriaName).get(field).size());
                    if(matchingTypeFieldByCriteria.get(criteriaName).get(field).size() <= 1){
                        system.debug('allotedFieldbySequence.get(field) ==> '+allotedFieldbySequence.get(criteriaName).get(field));
                        system.debug('fieldByFieldType.get(field)'+fieldByFieldType.get(criteriaName).get(field));
                        if(fieldByFieldType.get(criteriaName).get(field) == 'Number'){
                            system.debug('fieldByMatchingType.get(field) ==> '+fieldByMatchingType.get(field));
                            system.debug('field ==> '+field);
                            for(String str : fieldByMatchingType.get(criteriaName).get(field)){
                                system.debug('field ==> '+field +' && str == >'+str+' && recursionValue == >'+recursionValue);
                                if(str == '<' || str == '<='){
                                    if(Integer.valueOf(expectedValuebyCriteria.get(criteriaName).get(field)) >= Integer.valueOf(ld.get(field))){
                                        matchedValues++;
                                        Booleanvalues = Booleanvalues.replace(string.valueOf(recursionValue),'True');
                                        matchedCriteriasName.add(getLabelNameOfField(field)+' '+str+' '+expectedValuebyCriteria.get(criteriaName).get(field));
                                    }else{
                                        Booleanvalues = Booleanvalues.replace(string.valueOf(recursionValue),'False');
                                    } 
                                }else if(str == '>' || str == '>='){
                                    if(Integer.valueOf(expectedValuebyCriteria.get(criteriaName).get(field)) <= Integer.valueOf(ld.get(field))){
                                        matchedValues++;
                                        Booleanvalues = Booleanvalues.replace(string.valueOf(recursionValue),'True');
                                        matchedCriteriasName.add(getLabelNameOfField(field)+' '+str+' '+expectedValuebyCriteria.get(criteriaName).get(field));
                                    }else{
                                        Booleanvalues = Booleanvalues.replace(string.valueOf(recursionValue),'False');
                                    }
                                }else{
                                    if(Integer.valueOf(expectedValuebyCriteria.get(criteriaName).get(field)) == Integer.valueOf(ld.get(field))){
                                        matchedValues++;
                                        Booleanvalues = Booleanvalues.replace(string.valueOf(recursionValue),'True');
                                        matchedCriteriasName.add(getLabelNameOfField(field)+' '+str+' '+expectedValuebyCriteria.get(criteriaName).get(field));
                                    }else{
                                        Booleanvalues = Booleanvalues.replace(string.valueOf(recursionValue),'False');
                                    }
                                }
                            }
                        }
                        else if(fieldByFieldType.get(criteriaName).get(field) == 'Checkbox'){
                            if(ld.get(field) == Boolean.valueOf(expectedValuebyCriteria.get(criteriaName).get(field))){
                                matchedValues++;
                                Booleanvalues = Booleanvalues.replace(string.valueOf(recursionValue),'True');
                                matchedCriteriasName.add(getLabelNameOfField(field)+' '+'== '+expectedValuebyCriteria.get(criteriaName).get(field));
                            }else{
                                Booleanvalues = Booleanvalues.replace(string.valueOf(recursionValue),'False');
                            }
                        }
                        else{
                            for(String str : fieldByMatchingType.get(criteriaName).get(field)){
                                if(str == '=='){
                                    if(expectedValuebyCriteria.get(criteriaName).get(field).contains(',')){
                                        List<String> commaSeparatedValues = expectedValuebyCriteria.get(criteriaName).get(field).split(',');
                                        for(String Str1:commaSeparatedValues){
                                            if(Str1 == String.valueOf(ld.get(field))){
                                                matchedValues++;
                                                Booleanvalues = Booleanvalues.replace(string.valueOf(recursionValue),'True');
                                                matchedCriteriasName.add(getLabelNameOfField(field)+' '+str+' '+expectedValuebyCriteria.get(criteriaName).get(field));
                                            } 
                                        }
                                    }else{
                                        
                                        if(expectedValuebyCriteria.get(criteriaName).get(field) == String.valueOf(ld.get(field))){
                                            matchedValues++;
                                            Booleanvalues = Booleanvalues.replace(string.valueOf(recursionValue),'True');
                                            matchedCriteriasName.add(getLabelNameOfField(field)+' '+str+' '+expectedValuebyCriteria.get(criteriaName).get(field));
                                        }else{
                                            Booleanvalues = Booleanvalues.replace(string.valueOf(recursionValue),'False');
                                        }   
                                    }    
                                }else if(str == '!='){
                                    if(expectedValuebyCriteria.get(criteriaName).get(field) == 'null'){
                                        
                                        if(ld.get(field) == null){
                                            Booleanvalues = Booleanvalues.replace(string.valueOf(recursionValue),'False');
                                        }else{
                                            if(expectedValuebyCriteria.get(criteriaName).get(field) != ld.get(field)){
                                                matchedValues++;
                                                Booleanvalues = Booleanvalues.replace(string.valueOf(recursionValue),'True');
                                                matchedCriteriasName.add(getLabelNameOfField(field)+' '+str+' '+expectedValuebyCriteria.get(criteriaName).get(field));
                                            }else{
                                                Booleanvalues = Booleanvalues.replace(string.valueOf(recursionValue),'False');
                                            }    
                                        }
                                    }else{
                                        if(expectedValuebyCriteria.get(criteriaName).get(field) != String.valueOf(ld.get(field))){
                                            matchedValues++;
                                            Booleanvalues = Booleanvalues.replace(string.valueOf(recursionValue),'True');
                                            matchedCriteriasName.add(getLabelNameOfField(field)+' '+str+' '+expectedValuebyCriteria.get(criteriaName).get(field));
                                        }else{
                                            Booleanvalues = Booleanvalues.replace(string.valueOf(recursionValue),'False');
                                        }     
                                    }
                                }else if(str == 'CONTAINS'){
                                    system.debug('Coming Here ==>');
                                    if(String.valueOf(ld.get(field)) != null){
                                        if(String.valueOf(expectedValuebyCriteria.get(criteriaName).get(field)).contains(String.valueOf(ld.get(field)))){
                                            matchedValues++;
                                            Booleanvalues = Booleanvalues.replace(string.valueOf(recursionValue),'True');
                                            matchedCriteriasName.add(getLabelNameOfField(field)+' '+str+' '+expectedValuebyCriteria.get(criteriaName).get(field));
                                        }else{
                                            Booleanvalues = Booleanvalues.replace(string.valueOf(recursionValue),'False');
                                        }   
                                    }else{
                                        Booleanvalues = Booleanvalues.replace(string.valueOf(recursionValue),'False');
                                    }
                                    
                                }
                                else if(str == 'DOES NOT CONTAIN'){
                                    if(!expectedValuebyCriteria.get(criteriaName).get(field).contains(String.valueOf(ld.get(field)))){
                                        matchedValues++;
                                        Booleanvalues = Booleanvalues.replace(string.valueOf(recursionValue),'True');
                                        matchedCriteriasName.add(getLabelNameOfField(field)+' '+str+' '+expectedValuebyCriteria.get(criteriaName).get(field));
                                    }
                                    else{
                                        Booleanvalues = Booleanvalues.replace(string.valueOf(recursionValue),'False');
                                    }
                                }
                            }
                            
                        }
                        
                    }
                    else{
                        integer start = 0;
                        system.debug('Sequence In the Else ==> '+matchingTypeFieldByCriteria.get(criteriaName).get(field));
                        system.debug('multipleCriteriasForFields ==> '+allotedFieldbySequenceList.get(criteriaName).get(field)[start]);
                        system.debug('field 1 ==> '+field+' &&  === >'+matchingTypeFieldByCriteria.get(criteriaName).get(field)); 
                        system.debug('start == >'+start);
                        
                        for(String str : matchingTypeFieldByCriteria.get(criteriaName).get(field).keyset()){
                            if(fieldByFieldType.get(criteriaName).get(field) == 'Number'){
                                if(str == '<' || str == '<='){
                                    if(Integer.valueOf(matchingTypeFieldByCriteria.get(criteriaName).get(field).get(str)) >= Integer.valueOf(ld.get(field))){
                                        matchedValues++;
                                        Booleanvalues = Booleanvalues.replace(string.valueOf(allotedFieldbySequenceList.get(criteriaName).get(field)[start]),'True');
                                        matchedCriteriasName.add(getLabelNameOfField(field)+' '+str+' '+expectedValuebyCriteria.get(criteriaName).get(field));
                                    }else{
                                        Booleanvalues = Booleanvalues.replace(string.valueOf(allotedFieldbySequenceList.get(criteriaName).get(field)[start]),'False');
                                    } 
                                }else if(str == '>' || str == '>='){
                                    if(Integer.valueOf(matchingTypeFieldByCriteria.get(criteriaName).get(field).get(str)) <= Integer.valueOf(ld.get(field))){
                                        matchedValues++;
                                        Booleanvalues = Booleanvalues.replace(string.valueOf(allotedFieldbySequenceList.get(criteriaName).get(field)[start]),'True');
                                        matchedCriteriasName.add(getLabelNameOfField(field)+' '+str+' '+expectedValuebyCriteria.get(criteriaName).get(field));
                                    }else{
                                        Booleanvalues = Booleanvalues.replace(string.valueOf(allotedFieldbySequenceList.get(criteriaName).get(field)[start]),'False');
                                    }
                                }else{
                                    if(Integer.valueOf(expectedValuebyCriteria.get(criteriaName).get(field)) == Integer.valueOf(ld.get(field))){
                                        matchedValues++;
                                        Booleanvalues = Booleanvalues.replace(string.valueOf(recursionValue),'True');
                                        matchedCriteriasName.add(getLabelNameOfField(field)+' '+str+' '+expectedValuebyCriteria.get(criteriaName).get(field));
                                    }else{
                                        Booleanvalues = Booleanvalues.replace(string.valueOf(recursionValue),'False');
                                    }
                                }
                            }
                            else if(fieldByFieldType.get(criteriaName).get(field) == 'Checkbox'){
                                
                                if(ld.get(field) == Boolean.valueOf(matchingTypeFieldByCriteria.get(criteriaName).get(field).get(str))){
                                    matchedValues++;
                                    Booleanvalues = Booleanvalues.replace(string.valueOf(allotedFieldbySequenceList.get(criteriaName).get(field)[start]),'True');
                                    
                                }else{
                                    Booleanvalues = Booleanvalues.replace(string.valueOf(allotedFieldbySequenceList.get(criteriaName).get(field)[start]),'false');
                                }
                            }
                            else{
                                if(str == '=='){
                                    if(matchingTypeFieldByCriteria.get(criteriaName).get(field).get(str).contains(',')){
                                        List<String> commaSeparatedValues = expectedValuebyCriteria.get(criteriaName).get(field).split(',');
                                        for(String Str1:commaSeparatedValues){
                                            if(Str1 == String.valueOf(ld.get(field))){
                                                matchedValues++;
                                                Booleanvalues = Booleanvalues.replace(string.valueOf(allotedFieldbySequenceList.get(criteriaName).get(field)[start]),'True');
                                                matchedCriteriasName.add(getLabelNameOfField(field)+' '+str+' '+expectedValuebyCriteria.get(criteriaName).get(field));
                                            } else{
                                                Booleanvalues = Booleanvalues.replace(string.valueOf(allotedFieldbySequenceList.get(criteriaName).get(field)[start]),'False');
                                                
                                            }
                                        }
                                    }else{
                                        if(matchingTypeFieldByCriteria.get(criteriaName).get(field).get(str) == String.valueOf(ld.get(field))){
                                            matchedValues++;
                                            Booleanvalues = Booleanvalues.replace(string.valueOf(allotedFieldbySequenceList.get(criteriaName).get(field)[start]),'True');
                                            matchedCriteriasName.add(getLabelNameOfField(field)+' '+str+' '+expectedValuebyCriteria.get(criteriaName).get(field));
                                        }else{
                                            Booleanvalues = Booleanvalues.replace(string.valueOf(allotedFieldbySequenceList.get(criteriaName).get(field)[start]),'False');
                                            
                                        }   
                                    }    
                                }
                                else if(str == '!='){
                                    if(matchingTypeFieldByCriteria.get(criteriaName).get(field).get(str) == 'null'){
                                        if(ld.get(field) == null){
                                            Booleanvalues = Booleanvalues.replace(string.valueOf(allotedFieldbySequenceList.get(criteriaName).get(field)[start]),'False');
                                            
                                        }else{
                                            if(matchingTypeFieldByCriteria.get(criteriaName).get(field).get(str) != ld.get(field)){
                                                matchedValues++;
                                                Booleanvalues = Booleanvalues.replace(string.valueOf(allotedFieldbySequenceList.get(criteriaName).get(field)[start]),'True');
                                                matchedCriteriasName.add(getLabelNameOfField(field)+' '+str+' '+expectedValuebyCriteria.get(criteriaName).get(field));
                                            }else{
                                                Booleanvalues = Booleanvalues.replace(string.valueOf(allotedFieldbySequenceList.get(criteriaName).get(field)[start]),'False');
                                            }    
                                        }
                                    }else{
                                        if(matchingTypeFieldByCriteria.get(criteriaName).get(field).get(str) != String.valueOf(ld.get(field))){
                                            matchedValues++;
                                            Booleanvalues = Booleanvalues.replace(string.valueOf(allotedFieldbySequenceList.get(criteriaName).get(field)[start]),'True');
                                            matchedCriteriasName.add(getLabelNameOfField(field)+' '+str+' '+expectedValuebyCriteria.get(criteriaName).get(field));
                                        }else{
                                            Booleanvalues = Booleanvalues.replace(string.valueOf(allotedFieldbySequenceList.get(criteriaName).get(field)[start]),'False');
                                        }     
                                    }
                                }
                                else if(str == 'CONTAINS'){
                                    system.debug('Coming Here 2 === >');
                                    if(String.valueOf(ld.get(field)) != null){
                                        if(String.valueOf(matchingTypeFieldByCriteria.get(criteriaName).get(field).get(str)).contains(String.valueOf(ld.get(field)))){
                                            matchedValues++;
                                            Booleanvalues = Booleanvalues.replace(string.valueOf(allotedFieldbySequenceList.get(criteriaName).get(field)[start]),'True');
                                            matchedCriteriasName.add(getLabelNameOfField(field)+' '+str+' '+expectedValuebyCriteria.get(criteriaName).get(field));
                                        }else{
                                            Booleanvalues = Booleanvalues.replace(string.valueOf(allotedFieldbySequenceList.get(criteriaName).get(field)[start]),'False');
                                        }   
                                    }else{
                                        Booleanvalues = Booleanvalues.replace(string.valueOf(recursionValue),'False');
                                    }

                                }
                                else if(str == 'DOES NOT CONTAIN'){
                                    if(!matchingTypeFieldByCriteria.get(criteriaName).get(field).get(str).contains(String.valueOf(ld.get(field)))){
                                        matchedValues++;
                                        Booleanvalues = Booleanvalues.replace(string.valueOf(allotedFieldbySequenceList.get(criteriaName).get(field)[start]),'True');
                                        matchedCriteriasName.add(getLabelNameOfField(field)+' '+str+' '+expectedValuebyCriteria.get(criteriaName).get(field));
                                    }
                                    else{
                                        Booleanvalues = Booleanvalues.replace(string.valueOf(allotedFieldbySequenceList.get(criteriaName).get(field)[start]),'False');
                                    }
                                }
                            }
                            system.debug('Booleanvalues 2 == >'+Booleanvalues);
                            start++;
                        }
                    }
                }
                system.debug('Booleanvalues 21 == >'+Booleanvalues);
                if(Booleanvalues == 'false'){
                    leadTemp = False;
                }else if(Booleanvalues == 'true'){
                    leadTemp = True;
                }else{
                    leadTemp = BooleanExpressionCalculation.evaluateExpression(Booleanvalues);    
                }
                
                system.debug('leadTemp ==> '+leadTemp);
                system.debug('Number of Matched Criterias === >'+matchedValues +' && The Matched Criterias are ==> :'+matchedCriteriasName);
                system.debug('matchedValues 12 == >'+matchedValues);
                
                if(leadTemp == true){
                    assignedLead.add(ld);
                    matchedCriterias.add(criteriaName);
                    
                }
            }
            if(assignedLead.contains(ld)){
                system.debug('assignedLead === >'+assignedLead);   
            }else{
                DefaultQueueList.add(ld);    
            }
            if(matchedCriterias.size() > 0){
                system.debug('matchedCriterias  == > '+matchedCriterias);
                mapofExecutionIdByListLead.put(criteriaNameById.get(matchedCriterias[0]),new list<Lead__c>(assignedLead));    
            }
            
        }
        
        system.debug('DefaultQueueList-Size ==> '+DefaultQueueList.size()+'&&  List ==> '+DefaultQueueList);
        map<String,List<Lead__c>> mapofGlobalGroupNameByLeadList = new map<String,List<Lead__c>>();
       
        system.debug('mapofExecutionIdByListLead 2.1 == >'+mapofExecutionIdByListLead);
        system.debug('mapofGlobalGroupNameByLeadList 2.2 == >'+mapofGlobalGroupNameByLeadList);
        getGroupNameByLeads(mapofExecutionIdByListLead,mapofGlobalGroupNameByLeadList);
    }
    
    public static void getGroupNameByLeads(map<string,list<Lead__c>> mapofExecutionIdByLeadList,map<String,List<Lead__c>> mapofGlobalGroupNameByLeadList){
        system.debug('mapofExecutionIdByLeadList 1.4 == >'+mapofExecutionIdByLeadList);
        system.debug('mapofFBGroupNameByLeadList 1.5 == >'+mapofGlobalGroupNameByLeadList);
        
        list<Assignment_Group__c> agList = [SELECT id,name,Lead_Assigning_Criteria__c from assignment_group__c where Lead_Assigning_Criteria__c in: mapofExecutionIdByLeadList.keySet()];
        System.debug('agList 112 == >'+agList);
        map<string,list<Lead__c>> mapOfGroupNameByListLead = new map<string,list<Lead__c>>();
        
        if(!agList.isEmpty()){
            for(assignment_group__c assGroup : agList){
                mapOfGroupNameByListLead.put(assGroup.name, mapofExecutionIdByLeadList.get(assGroup.Lead_Assigning_Criteria__c));
            }
            list<String> leadIdList = new list<String>();
            map<string,list<String>> mapofGroupnameByLeadIdList = new map<String,list<String>>();
            for(String mapKey : mapOfGroupNameByListLead.keySet()){
                for(Lead__c ld : mapOfGroupNameByListLead.get(mapKey)){
                    if(mapofGroupnameByLeadIdList.containsKey(mapKey)){
                        mapofGroupnameByLeadIdList.get(mapKey).add(ld.Id);
                    }else{
                        mapofGroupnameByLeadIdList.put(mapKey,new list<String>{ld.Id});
                    }
                }
                Set<string> tempId = new Set<String>(mapofGroupnameByLeadIdList.get(mapKey));
                RoundRobinLeadAssignment.assignLeadsToBDS(mapKey,tempId);
            }
        }
        //this is else Part.....
        if(!mapofGlobalGroupNameByLeadList.isEmpty()){
            set<String> tempId = new set<String>();
            for(string mapKey : mapofGlobalGroupNameByLeadList.keySet()){
                for(Lead__c ld : mapofGlobalGroupNameByLeadList.get(mapKey)){
                    tempId.add(ld.id);
                }
                RoundRobinLeadAssignment.assignLeadsToBDS(mapKey,tempId);
            }
        }
    }
    
    public static void assignDefaultQueue(list<Lead__c> newLeadList){
        try{
            List<Lead__c>  LeadsToBeUpdated= new List<Lead__c>();
            List<Lead__c> UpdatedLeads = [Select id,Name,OwnerID from Lead__c where ID IN:newLeadList];
            string queueId = [SELECT Id, Type FROM Group WHERE Type = 'Queue' AND Name = 'Lead Default Queue' limit 1].Id;
            for(Lead__c ld : UpdatedLeads) {
                ld.ownerId = queueId;
                LeadsToBeUpdated.add(ld);
            }
            update LeadsToBeUpdated;
        }catch(exception ex ){
            system.debug('Error==>'+ex.getMessage());
            system.debug('Error==>@@'+ex.getLineNumber());
        }
    }
    
    public static string getLabelNameOfField(string apiName){
        String type='Lead__c';
        Map<String, Schema.SObjectType> schemaMap = Schema.getGlobalDescribe();
        Schema.SObjectType leadSchema = schemaMap.get(type);
        Map<String, Schema.SObjectField> fieldMap = leadSchema.getDescribe().fields.getMap();
        return fieldMap.get(apiName).getDescribe().getLabel();
    }
    
  
}