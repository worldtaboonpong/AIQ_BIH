({
    onInit : function(component, event, helper) {
        google.charts.load('current', { 'packages': ['timeline'] });
        google.charts.setOnLoadCallback(helper.drawChart);
        
    }
    
})