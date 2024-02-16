({
    syncQuoteFromHelper: function (component) {
        // Perform the sync operation
        var action = component.get("c.createQuoteLineItem");
        action.setParams({
            quoteId: component.get("v.recordId"),
            markAsSyncing: true
        });
        action.setCallback(this, function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                // Update IsSyncing__c field on Quote_C__c
                this.updateIsSyncing(component, false);
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    title: "Success",
                    message: "Quote Line Items have been synced",
                    duration: "3000",
                    key: "info_alt",
                    type: "success",
                    mode: "pester"
                });
                toastEvent.fire();
            } else {
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    title: "Error",
                    message: "Error Occurred",
                    duration: "2000",
                    key: "info_alt",
                    type: "error",
                    mode: "pester"
                });
                toastEvent.fire();
            }

            // Close the modal and reload the page
            component.set("v.showModal", false);
            $A.get("e.force:closeQuickAction").fire();
            $A.get("e.force:refreshView").fire();
        });

        $A.enqueueAction(action);
    },

    updateIsSyncing: function (component, markAsSyncing) {
        // Update IsSyncing__c field on Quote_C__c
        var updateAction = component.get("c.updateIsSyncing");
        updateAction.setParams({
            quoteId: component.get("v.recordId"),
            markAsSyncing: markAsSyncing
        });
        $A.enqueueAction(updateAction);
    }
});