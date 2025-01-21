import { LightningElement,api,wire } from 'lwc';
import getBigObjectFieldDisplay from "@salesforce/apex.BigObjectRelatedListController.getBigObjectFieldDisplay";
import getBigObjectRecords from "@salesforce/apex.BigObjectRelatedListController.getBigObjectRecords";


export default class BigObjectRelatedList extends LightningElement {
	@api bigObjectAPI;
    @api parentFieldApi;
    @api parentId;

	columns = [];
    records = [];
    isLoading = true;
    error;

	connectedCallback() {
        this.loadBigObjectFieldDisplay();
    }

    loadBigObjectFieldDisplay() {
        getBigObjectFieldDisplay({ bigObjectApi: this.bigObjectApi })
            .then((columns) => {
                this.columns = columns;
                this.loadBigObjectRecords();
            })
            .catch((error) => {
                this.error = error;
                this.isLoading = false;
            });
    }

	loadBigObjectRecords() {
		const fieldApiNames = this.columns.map(column => column.fieldApiName);
        getBigObjectRecords({
            bigObjectApi: this.bigObjectApi,
            parentFieldApi: this.parentFieldApi,
            parentId: this.parentId,
			fields : fieldApiNames
        })
            .then((records) => {
                this.records = records.map(record => {
                    const formattedRecord = {};
					const valueList = [];
                    this.columns.forEach(col => {
                        let value = record[col.fieldApiName] || '';
						valueList.push(value);
                    });
					formattedRecord.fieldValues = valueList;
                    formattedRecord.Id = record.Id;
                    return formattedRecord;
                });
				if (this.records.length == 0){
					this.error = 'There is no record to display'
				}
                this.isLoading = false;
            })
            .catch((error) => {
                this.error = error;
                this.isLoading = false;
            });
    }

}