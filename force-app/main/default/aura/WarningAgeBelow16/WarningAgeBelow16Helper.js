({
    isAgeBelow16: function(component) {
        var caseRecord = component.get("v.simpleRecord");
        if (caseRecord && caseRecord.Age_Formula__c <= 16) {
            component.set("v.showWarning", true);
        }
    }
})