({
    startSpinner: function (component) {
        // console.log('-- start --');

        component.set('v.loading', true);
    },
    stopSpinner: function (component) {
        // console.log('-- stop --');
        component.set('v.loading', false);
    },
})