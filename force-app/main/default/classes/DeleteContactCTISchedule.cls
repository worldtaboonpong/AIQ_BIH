global class DeleteContactCTISchedule implements Schedulable {
    
    global void execute(SchedulableContext sc) {
        String days = BIH_Constants.DELETE_CTI_CONTACT_DAYS;
        String query = 'SELECT ID,MobilePhone,Phone,AccountId,Firstname,createddate FROM Contact WHERE Phone != null and CreatedDate = LAST_N_DAYS:'+days;
        DeleteContactCTIBatch memberPurge = new DeleteContactCTIBatch(query);
        //Id BatchProcessId = Database.ExecuteBatch(memberPurge); 
        Id BatchProcessId = System.enqueueJob(memberPurge);
    }
}