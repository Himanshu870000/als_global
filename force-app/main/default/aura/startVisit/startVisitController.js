({
    doInit : function(component, event, helper) { 
        debugger;
        var lat;
        var long;
        var userLocation = navigator.geolocation;
        if (userLocation) {
            userLocation.getCurrentPosition(function (position) {
                // lat = position.coords.latitude;
                // long = position.coords.longitude;
                component.set("v.currentLatitude",position.coords.latitude);
                component.set("v.currentLongitude",position.coords.longitude);
            });
        } 
        
        
        helper.getVisitRecord(component, event, helper);
        helper.getPastVisitRecord(component, event, helper);
        helper.getAccRelatedOppList(component, event, helper);
      //  helper.getRelatedInvoiceList(component, event, helper);
        helper.getRelatedCaseList(component, event, helper);
        helper.getRelatedActivityList(component, event, helper);
        
       
    },

    
    
    handleOppClick: function(component, event, helper){
        debugger;
        var url = $A.get("$Label.c.orgDefaultURL");
        var oppId = event.target.dataset.id; 
        var oppUrl = url + oppId;
        window.open(oppUrl, '_blank');
    },
    
    
    
    createTaskHanlde :  function(component, event, helper) {
        debugger;
        component.set("v.showCreateTask",true);
    },
    closeActivityCreate : function(component, event, helper) {
        debugger;
        component.set("v.showCreateTask",false);
    },
    closeBtn : function(component, event, helper) {
        debugger;
        component.set("v.showCreateTask",false);
        component.set("v.showCreateCallLogTask",false);
        component.set("v.showCreateCase",false);
        component.set("v.showOpportunityCreate",false);
    },
    onChangeHandlerStatus : function(component, event, helper) {
        debugger;
        var selPick = component.find('fieldStatus').get('v.value');
    },
    onChangeHandlerPriority : function(component, event, helper) {
        debugger;
        var selPick = component.find('fieldPrority').get('v.value');
    },
    onChangeHandlerCaseStatus : function(component, event, helper) {
        debugger;
        var selPick = component.find('fieldCaseStatus').get('v.value');
    },
    onChangeHandlerOppStage : function(component, event, helper) {
        debugger;
        var selPick = component.find('fieldOppStage').get('v.value');
    },
    createLogCallHanlde : function(component, event, helper) {
        debugger;
        component.set("v.showCreateCallLogTask",true);
    },
    closeCallLogCreate : function(component, event, helper) {
        debugger;
        component.set("v.showCreateCallLogTask",false);
    },
    createCaseHanlde : function(component, event, helper) {
        debugger;
        component.set("v.showCreateCase",true);
    },
    closeCaseHanlde : function(component, event, helper) {
        debugger;
        component.set("v.showCreateCase",false);
    },


    // createOpportunityHandle: function (component, event, helper) {
    //         var navService = component.find('navService');
    //         var pageReference = {
    //             type: 'standard__objectPage',
    //             attributes: {
    //                 objectApiName: 'Opportunity',
    //                 actionName: 'new'
    //             }
    //         };
    
    //         navService.navigate(pageReference);
    // },
        
        
        
    createTicket: function (component, event, helper) {
        var navService = component.find('navService');
        var pageReference = {
            type: 'standard__objectPage',
            attributes: {
                objectApiName: 'Case',
                actionName: 'new'
            },
            state: {
            }
        };
        
        var defaultFieldValues = {
            Visit__c:component.get("v.visitId")
        };
        
        pageReference.state.defaultFieldValues = component.find("pageRefUtils").encodeDefaultFieldValues(defaultFieldValues);
        component.set("v.pageReference", pageReference);

        navService.navigate(pageReference);
    },

          
    createTask: function (component, event, helper) {
        debugger;
        var navService = component.find('navService');
        var pageReference = {
            type: 'standard__objectPage',
            attributes: {
                objectApiName: 'Task',
                actionName: 'new'
            },
            state: {
            }
        };

        var defaultFieldValues = {
            Visit__c:component.get("v.visitId"),
            WhatId:component.get("v.accID")
        };

        pageReference.state.defaultFieldValues = component.find("pageRefUtils").encodeDefaultFieldValues(defaultFieldValues);
        component.set("v.pageReference", pageReference);

        navService.navigate(pageReference);
    },

    createTaskForMOM: function (component, event, helper) {
        debugger;
        component.set("v.ShowLogMOM",true);
    },

    closeModelPop : function (component, event, helper) {
        component.set("v.ShowLogMOM",false);
    },
    
    OnchageMomDescription :  function (component, event, helper) {
        debugger;
        var description = component.find('logDescription').get('v.value');
        if(description !=undefined){
            component.set("v.logMomDescription",description);
        }
        var subject = component.find('logSubject').get('v.value');
        if(subject !=undefined){
            component.set("v.logMomSubject",subject);
        }
        var stackEmail = component.find('logStackHolderEmail').get('v.value');
        if(stackEmail !=undefined){
            component.set("v.stackEmail",stackEmail);
        }
    },

    createMomActivity : function (component, event, helper) {
        debugger;
        var action = component.get("c.createMomActivityLog");
        action.setParams({
            description : component.get("v.logMomDescription"),
            visitId : component.get("v.visitId"),
            accId : component.get("v.accID"),
            subject :  component.get("v.logMomSubject"),
            salesUserId : component.get("v.auraUserId"),
            stackholderEmail : component.get("v.stackEmail")

        });
        action.setCallback(this,function(response){
          if(response.getState() === 'SUCCESS'){
            if(response.getReturnValue() === 'SUCCESS'){
                // var toastEvent = $A.get("e.force:showToast");
                // toastEvent.setParams({
                //     title : 'SUCCESS',
                //     message: 'Mom Activity Created Successfully',
                //     duration:' 5000',
                //     key: 'info_alt',
                //     type: 'success',
                //     mode: 'pester'
                // });
                // toastEvent.fire();
                alert('Mom Activity Created Successfully');
                component.set("v.ShowLogMOM",false);
            }
          }
        });
        $A.enqueueAction(action);
    },


    createLogCall: function (component, event, helper) {
        debugger;
        var navService = component.find('navService');
        var pageReference = {
            type: 'standard__objectPage',
            attributes: {
                objectApiName: 'Call_Logs__c',
                actionName: 'new'
            }
        };

        navService.navigate(pageReference);
    },

    openGoogleMaps: function (component, event, helper) {
        debugger;
        var currentLat = component.get("v.currentLatitude");
        var currentLong = component.get("v.currentLongitude");
    
        var userLocation = navigator.geolocation;
    
        if (userLocation) {
            userLocation.getCurrentPosition(
                function (position) {

                    var userLat = 12.917205;
                    var userLong = 77.606335;

                    // var userLat = position.coords.latitude;
                    // var userLong = position.coords.longitude;
    
                    if (userLat === currentLat && userLong === currentLong) {
                        // Handle the case where current location and user location are the same
                        alert("Current location and user location are the same. Please make sure location services are enabled.");
                    } else {
                        var mapsUrl = "https://www.google.com/maps/dir/?api=1&origin=" + currentLat + "," + currentLong + "&destination=" + userLat + "," + userLong + "&travelmode=driving";
                        window.open(mapsUrl, '_blank');
                    }
                },
                function (error) {
                    // Handle geolocation error
                    alert("Geolocation error: " + error.message);
                }
            );
        } else {
            alert("Geolocation is not supported in your browser or device.");
        }
    },

    closeOpportunityHandle : function(component, event, helper) {
        debugger;
        component.set("v.showOpportunityCreate",false);
    },
    saveTaskHandler : function(component, event, helper) {
        debugger;
        component.set('v.spinner', true);
        component.set("v.showCreateTask",false);
        var taskRecord = component.get('v.taskRec');
        var accId = component.get('v.accID');
        taskRecord.WhatId = accId;
        var action = component.get('c.saveTask');
        action.setParams({
            taskRec :  taskRecord
        });
        action.setCallback(this, function(response){
            if(response.getState() ==='SUCCESS'){
                component.set('v.spinner', false);
                //alert('record Saved Successfully');
                helper.getRelatedActivityList(component, event, helper);
                helper.showSuccess(component, event, helper);
                component.set("v.showCreateTask",false);
            }else{
                component.set('v.spinner', false);
                alert(JSON.stringify(response.getError()));
            }
            component.set('v.spinner', false);
        });
        $A.enqueueAction(action);
    },
    saveLogCall : function(component, event, helper) {
        debugger;
        component.set('v.spinner', true);
        component.set("v.showCreateCallLogTask",false);
        var today = new Date();
        var formattedDate = today.toISOString().slice(0, 10);
        var taskRecord = component.get('v.callRec');
        var accId = component.get('v.accID');
        taskRecord.WhatId = accId;
        taskRecord.Priority = 'Normal';
        taskRecord.ActivityDate = formattedDate;
        taskRecord.Status = 'Completed';
        var action = component.get('c.LogCall');
        action.setParams({
            taskRec :  taskRecord
        });
        action.setCallback(this, function(response){
            if(response.getState() ==='SUCCESS'){
                component.set('v.spinner', false);
                helper.getRelatedActivityList(component, event, helper);
                helper.showSuccess(component, event, helper);
                //alert('record Saved Successfully');
            }else{
                alert(JSON.stringify(response.getError()));
                component.set('v.spinner', false);
            }
            component.set('v.spinner', false);
        });
        $A.enqueueAction(action);
    },
    createOppHandle : function(component, event, helper) {
        debugger;
        component.set("v.showOpportunityCreate",false);
        component.set('v.spinner', true);
        var oppRecord = component.get('v.oppRec');
        if(oppRecord.Name == '' || oppRecord.Name == undefined || oppRecord.Name == null){
            helper.showErrorOpp(component, event, helper);
            component.set('v.spinner', false);
        }
        else if(oppRecord.StageName__c == '--None-' || oppRecord.StageName__c == undefined || oppRecord.StageName__c == null || oppRecord.StageName__c == ''){
            helper.showErrorOpp(component, event, helper);
            component.set('v.spinner', false);
        }
        else if(oppRecord.CloseDate__c == '' || oppRecord.CloseDate__c == undefined || oppRecord.CloseDate__c == null){
            helper.showErrorOpp(component, event, helper);
            component.set('v.spinner', false);
        }else{
            component.set('v.spinner', true);
            var accId = component.get('v.accID');
        oppRecord.AccountId = accId;
        var action = component.get('c.saveOpportunity');
        action.setParams({
            oppRec :  oppRecord
        });
        action.setCallback(this, function(response){
            if(response.getState() ==='SUCCESS'){
                component.set('v.spinner', false);
                //alert('record Saved Successfully');
                helper.showSuccess(component, event, helper);
                helper.getAccRelatedOppList(component, event, helper);
                
            }else{
                alert(JSON.stringify(response.getError()));
                component.set('v.spinner', false);
            }
            component.set('v.spinner', false);
        });
        $A.enqueueAction(action);
        } 
    },


    createOpportunityHandle: function (component, event, helper) {
        debugger;
        let Fields = ['AccountId__c','StageName__c','CloseDate__c','Name','Amount__c','Description__c'];
        component.set("v.SobjectApiName", 'Opportunity1__c');
        component.set("v.fields", Fields);
        component.set("v.ShowModal", true);
        
    },

    onCancel: function (component, event, helper) {
        component.set("v.ShowModal", false);

    },
    

    handleSuccess: function (component, event, helper) {
        debugger;
        var opportunityId = event.getParam("id");
        console.log('OpportunityId', opportunityId);
        var visitId = component.get("v.visitId");
        var action = component.get("c.createVisitActivity");
        action.setParams({
            opportunityId: opportunityId,
            visitId: visitId
        });

        action.setCallback(this, function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                component.set("v.ShowModal", false);

                console.log("Visit_Activity__c record created successfully.");

            } else {
                console.error("Error creating Visit_Activity__c record: " + response.getError()[0].message);
            }
        });

        $A.enqueueAction(action);
    },
    
    createCaseHandle : function(component, event, helper) {
        debugger;
        component.set('v.spinner', true);
        var caseRecord = component.get('v.caseRec');
        var accId = component.get('v.accID');
        caseRecord.AccountId = accId;
        caseRecord.Origin = 'Web';
        var action = component.get('c.saveCase');
        action.setParams({
            caseRec :  caseRecord
        });
        action.setCallback(this, function(response){
            if(response.getState() ==='SUCCESS'){
                component.set('v.spinner', false);
                helper.showSuccess(component, event, helper);
                //alert('record Saved Successfully');
                helper.getRelatedCaseList(component, event, helper);
            }else{
                alert(JSON.stringify(response.getError()));
                component.set('v.spinner', false);
            }
            component.set("v.showCreateCase",false);
            component.set('v.spinner', false);
        });
        $A.enqueueAction(action);
    },
    
    checkInHandler : function(component, event, helper) {
        debugger;
        var lat;
        var long;
        var userLocation = navigator.geolocation;
        if (userLocation) {
            userLocation.getCurrentPosition(function (position) {
                lat = position.coords.latitude;
                long = position.coords.longitude;
                if(lat !=undefined){
                    component.set("v.currentLatitudeNew",lat);
                }
                if(long !=undefined){
                    component.set("v.currentLongitudeNew",long);
                }
                if ((lat != null && lat != undefined && lat != '') && (long != null && long != undefined && long != '')) {
                    component.set('v.spinner', true);
                    helper.CheckInVisithelper(component,lat, long);
                    // component.set("v.currentLatitude", lat);
                    // component.set("v.currentLongitude", long);
                }
            });
        } 
        
    },
    
    checkOutHandler: function(component, event, helper) {
        debugger;
        var lat;
        var long;
      //  var userLocation = navigator.geolocation;
       // if (userLocation) {
          //  userLocation.getCurrentPosition(function (position) {
            var newLat = component.get("v.currentLatitude");
            var newLong = component.get("v.currentLongitude");
              //  lat =  12.9968411; //  position.coords.latitude;
              //  long = 77.6932811; // position.coords.longitude;
                if ((newLat != null && newLat != undefined && newLat != '') && (newLong != null && newLong != undefined && newLong != '')) {
                    component.set('v.spinner', true);
                    var action = component.get("c.checkMomActivityBeforeCheckOutVisit");
                    action.setParams({
                        visitId :  component.get('v.visitId')
                    });
                   action.setCallback(this,function(response){
                     if(response.getState() ==='SUCCESS'){
                        if(response.getReturnValue() == 'SUCCESS'){
                            helper.CheckOutVisithelper(component,newLat, newLong);
                        }else{
                       //  alert('Please submit MOM activity before checking out.');
                         var toastEvent = $A.get("e.force:showToast");
                         toastEvent.setParams({
                             title : 'ERROR',
                             message: 'Please submit MOM activity before checking out.',
                             duration:' 5000',
                             key: 'info_alt',
                             type: 'error',
                             mode: 'pester'
                         });
                         toastEvent.fire();
                         component.set('v.spinner', false);
                        }
                     }
                   });
                   $A.enqueueAction(action);
                    // component.set("v.currentLatitude", lat);
                    // component.set("v.currentLongitude", long);
                }
           // });
       // } 
        
    },
    /*handleComponentEvent:function(component, event, helper){
        debugger;
        alert('event fired');
        var visitId = event.getParam("visitId"); 
        var accId = event.getParam("accId"); 
        component.set("v.visitId", visitId);
        var visitRecId = component.get('v.visitId');
        var action = component.get('c.getSelectedVisitDetails');
        action.setParams({
            visitId :  visitRecId
        });
        action.setCallback(this, function(response){
            if(response.getState()==='SUCCESS'){
                var result = response.getReturnValue();
                component.set('v.visitRec', result);
                //component.set('v.accID', result.Account__c);
                var street = result.Account__r.BillingStreet;
                var city = result.Account__r.BillingCity;
                var state = result.Account__r.BillingState;
                var zipCode = result.Account__r.BillingPostalCode;
                var fullAddress = street + ', ' + city + ', ' + state+ '- ' + zipCode;
                component.set('v.accountAddress', fullAddress);
                window.setTimeout(
                    $A.getCallback(function() {
                       helper.callNavigation(component, event, helper,accId);
                    }),1000     
                );
            } 
            
        });
        $A.enqueueAction(action);
    },*/
    
    goBackOnePage : function(component, event, helper){
        debugger;
        //location.replace("https://sales-production--mfgcloud.sandbox.lightning.force.com/lightning/n/Field_Visit");
        //component.set('v.showTodaysTaskComponent',true);
        //component.set('v.showStartVisitComponent',false);
        
        var fieldVisitComponentEvent = component.getEvent("fieldVisitComponentEvent"); 
        
        fieldVisitComponentEvent.setParams({
            "showTodaysTaskComponent" : true,
            "showStartVisitComponent" : false
        }); 
        
        fieldVisitComponentEvent.fire(); 
    },
    handleLWCEvent: function(component, event, helper) {
        debugger;
       var userIdFromLWC = event.getParam('value');        
       // console.log(userIdFromLWC);
        component.set("v.auraUserId", userIdFromLWC);
    },
})