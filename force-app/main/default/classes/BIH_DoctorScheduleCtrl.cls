public with sharing class BIH_DoctorScheduleCtrl {
    public Map<String,List<BIH_PicklistOption>> PickListValue {get;set;}
    public List<BIH_PicklistOption> SpecialtyPickList {get;set;}
    public List<BIH_PicklistOption> Specialty2PickList {get;set;}
    public Datetime dT {get;set;}
    public string dTString {get;set;}


    // public static integer sizeOfObj {get;set;}
    // public static integer numbersOfPage {get;set;}
    // public static integer currentPage {get;set;}
    
    
    public class WrapperList{
        public List<List<String>> timeslotList {get;set;}
        public Map<String,Doctor__c> doctorList {get;set;}
        public integer sizeOfObj {get;set;}
        public integer numbersOfPage {get;set;}
        public integer currentPage {get;set;}
    }
    public BIH_DoctorScheduleCtrl() {

        PickListValue = BIH_EditChildCaseFormCtrl.getPickListValuesIntoList(new List<String>{
            'Specialty_Doctor__c','Specialty_Doctor2__c'});
        SpecialtyPickList = PickListValue.get('Specialty_Doctor__c');
        Specialty2PickList=PickListValue.get('Specialty_Doctor2__c');
        dT = date.today();
        dTString = dT.format('yyyy-MM-dd');
        // System.debug('dTString : '+dTString);
        // System.debug('PickListValue : '+PickListValue.get('Specialty_Doctor__c'));
        // System.debug('SpecialtyPickList : '+SpecialtyPickList);
    }

    @RemoteAction
    public static WrapperList getListDoctorBySearching(string specialty,string specialty2,string startDate, integer pageNo,integer sizeObj){
        
        WrapperList wrap = new WrapperList();
        String isAvaliablePrivateNote = '';
        String querySpecial2 = '';
        Integer offset = 0;

        /* ----- check FLS ---- */
        Schema.DescribeFieldResult drField = Doctor__c.Doctor_Private_Note__c.getDescribe();
        // System.debug('drField.isAccessible() : '+drField.isAccessible());
        if(drField.isAccessible()){
            isAvaliablePrivateNote = ',Doctor_Private_Note__c';
        }
        /* check specialty2 for add query string  */
        if(specialty2 != ''){
            querySpecial2 = ' OR Specialty2__c =\''+specialty2+'\'';
        }

         /* offset for query  */
        if(sizeObj != null ){
            offset = (pageNo-1) * 15;
        }

        List<List<String>> tmpAllSlot = new List<List<String>>();
        System.debug('specialty : '+specialty+' | specialty2 : '+ specialty2+' | startDate : '+startDate);
        String sQuery = 'SELECT Id, Name, MD_Code__c, Doctor_First_Name__c, Doctor_Last_Name__c, Specialty__c, Specialty2__c'+isAvaliablePrivateNote+' FROM Doctor__c'+
                        ' WHERE (Specialty__c = \''+specialty+'\''+querySpecial2+') AND Active__c = true'+
                        ' ORDER BY Doctor_First_Name__c';

        List<Doctor__c> listDoctorAll = Database.query(sQuery);
        // System.debug('listDoctor : '+listDoctorAll);
        System.debug('listDoctor : '+listDoctorAll.size());
        wrap.sizeOfObj = listDoctorAll.size();
        wrap.currentPage = pageNo;
        // System.debug('sizeOfObj : '+sizeOfObj);
        // numbersOfPage = Integer.ValueOf((Decimal.ValueOf(sizeOfObj).setscale(2)/15).round(System.RoundingMode.UP));
        Map<String,Doctor__c> docMap = new Map<String,Doctor__c>();
        List<Doctor__c> listDoctor = new List<Doctor__c>();
        Integer countDoc  = 0;
         /* get doctor following the  pageNo */
        for(Doctor__c d :listDoctorAll){
            if(countDoc < offset+15 && countDoc >= offset){
                listDoctor.add(d);
                docMap.put(d.MD_Code__c,d);
            }
            countDoc++;
        }
        wrap.doctorList = docMap;
        Datetime tmpStartDate = Datetime.valueOfGmt(startDate+' 00:00:00');
        Datetime tmpEndDate = Datetime.valueOfGmt(startDate+' 23:59:59');
        for(Doctor__c doc : listDoctor){
            Boolean flatCheckFirstArrayIsAvaliable = true;
            List<BIH_DoctorScheduleService.TimeSlot> tmpSlot = BIH_DoctorScheduleService.getDoctorSchedule(doc.MD_Code__c,tmpStartDate,tmpEndDate);
            System.debug('timeslot API : '+tmpSlot.size());
            if(tmpSlot.size() > 0){
                for(BIH_DoctorScheduleService.TimeSlot ts : tmpSlot){
                    List<String> tmptimeslot =  new  List<String>();
                    tmptimeslot.add(doc.Doctor_First_Name__c+' '+doc.Doctor_Last_Name__c); //[0]
                    if(Boolean.ValueOf(ts.isAvailable)){
                        tmptimeslot.add(ts.code);//[1]
                        tmptimeslot.add(ts.startTime);//[2]
                        tmptimeslot.add(ts.endTime);//[3]
                        tmptimeslot.add(ts.locationCode);//[4]
                        tmptimeslot.add(ts.location);//[5]
                        /* SECTION DOCTOR INFORMATION */ 
                        tmptimeslot.add(doc.MD_Code__c);//[6]
                         /* SECTION DOCTOR INFORMATION */
                        tmpAllSlot.add(tmptimeslot);
                    }else{
                        if(flatCheckFirstArrayIsAvaliable){
                            flatCheckFirstArrayIsAvaliable = false;
                            tmpAllSlot.add(tmptimeslot);
                        }
                    }
                }
            }else{
                List<String> tmoemptyslot =  new  List<String>();
                tmoemptyslot.add(doc.Doctor_First_Name__c+' '+doc.Doctor_Last_Name__c);
                tmpAllSlot.add(tmoemptyslot);
            }
            // tmptimeslot.add();
            // System.debug('tmptimeslot : '+tmptimeslot);
        }
        System.debug('tmpAllSlot : '+tmpAllSlot.size());
        wrap.timeslotList = tmpAllSlot;
         System.debug('time_slot_front : '+wrap.timeslotList.size());
        System.debug('time_slot_front : '+wrap.timeslotList);
        return wrap;

    }

}