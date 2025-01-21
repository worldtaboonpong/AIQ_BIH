({
	sortData: function (cmp, fieldName, sortDirection) {
		var data = cmp.get("v.data");
		var reverse = sortDirection !== 'asc';
		data.sort(this.sortBy(fieldName, reverse))
		cmp.set("v.data", data);
	},
	sortBy: function (field, reverse, primer) {
		var key = primer ?
			function (x) { return primer(x[field]) } :
			function (x) { return x[field] };
		reverse = !reverse ? 1 : -1;
		return function (a, b) {
			return a = key(a), b = key(b), reverse * ((a > b) - (b > a));
		}
	},
	sortDataMap: function (cmp, fieldName, sortDirection) {
		var data = cmp.get("v.dataMapDate");
		var reverse = sortDirection !== 'asc';
		data.sort(this.sortBy(fieldName, reverse))
		cmp.set("v.dataMapDate", data);
	},
	sortDataDateTImeMap: function (cmp, fieldName, sortDirection) {
		var data = cmp;
		var reverse = sortDirection !== 'asc';
		data.sort(this.sortBy(fieldName, reverse))
		return data;
	},
	startSpinner: function (component) {
		component.set('v.loading', true);
	},
	stopSpinner: function (component) {
		component.set('v.loading', false);
	},
})