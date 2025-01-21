public class AppointmentQuickCtrl 
{
    @AuraEnabled
    public static List<Account> getPersonAccountRecord(Id mRecordId)
    {
        List<Account> mPersonAccountList = [SELECT Id,Name FROM Account WHERE Id =: mRecordId];
        return mPersonAccountList;
    }
}