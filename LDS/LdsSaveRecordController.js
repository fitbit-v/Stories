({
    handleSaveRecord: function(component, event, helper) {
        component.find("recordEditor").saveRecord($A.getCallback(function(saveResult) {
            if (saveResult.state === "SUCCESS" || saveResult.state === "DRAFT") {
                console.log("Save completed successfully.");
            } else if (saveResult.state === "INCOMPLETE") {
                console.log("User is offline, device doesn't support drafts.");
            } else if (saveResult.state === "ERROR") {
                console.log('Problem saving record, error: ' + 
                           JSON.stringify(saveResult.error));
            } else {
                console.log('Unknown problem, state: ' + 
                saveResult.state + ', error: ' + 
                JSON.stringify(saveResult.error));
            }
        }));}
})

/**
 * @param predicate - `find` calls predicate once for each element of the array, in ascending order,
 *  until it finds one where predicate returns true.  If such an element is found, find immediately returns 
 * that element value.  Otherwise, find returns undefined.
 * @param thisArg - if provided, it will be used as the this value for each invocation of predicate.  
 * If it is not provided, undefined is used instead.
 */