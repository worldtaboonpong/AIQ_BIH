({
    doInit: function(cmp) {
        // Set the attribute value. 
        // You could also fire an event here instead.
        cmp.set('v.loaded', !cmp.get('v.loaded'));
    },
    
    showBookingScreen: function(cmp) {
        cmp.set('v.loaded', !cmp.get('v.loaded'));
        cmp.set("v.Hideappsearch", false);
        cmp.set("v.Hideappbook", true);
        cmp.set('v.loaded', !cmp.get('v.loaded'));
    },
    hideBookingScreen: function(cmp) {
        cmp.set('v.loaded', !cmp.get('v.loaded'));
        cmp.set("v.Hideappbook", false);
        cmp.set("v.Hideappsearch", true);
        cmp.set('v.loaded', !cmp.get('v.loaded'));
        
    }
    
})