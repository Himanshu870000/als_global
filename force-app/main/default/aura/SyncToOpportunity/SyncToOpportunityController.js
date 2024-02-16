({
    doInit: function (component, event, helper) {
        // Fetch the other Quote Name and set it in the component attribute
        var action = component.get("c.getOtherQuoteName");
        action.setParams({
            quoteId: component.get("v.recordId")
        });
        action.setCallback(this, function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var otherQuoteName = response.getReturnValue();
                if (otherQuoteName) {
                    // If other quote exists, show the modal
                    component.set("v.otherQuoteName", otherQuoteName);
                    component.set("v.showModal", true);
                } else {
                    // If no other quote, proceed with syncing directly
                    helper.syncQuoteFromHelper(component);
                }
            } else {
                console.error('Error fetching other Quote Name: ' + response.getError()[0].message);
            }
        });
        $A.enqueueAction(action);
    },

    hideModel: function (component, event, helper) {
        // Close the modal and reload the page on Cancel
        component.set("v.showModal", false);
        $A.get("e.force:closeQuickAction").fire();
        $A.get("e.force:refreshView").fire();
    },

    syncQuote: function (component, event, helper) {
        // Perform the sync operation
        helper.syncQuoteFromHelper(component);
    }
});