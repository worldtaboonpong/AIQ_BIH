public class BIH_CreateQuickChildCase {
    @AuraEnabled
    public static User getUserProfile() {
        return [SELECT id, User_Team__c, Profile.Name, ProfileId FROM User WHERE id = :UserInfo.getUserId()];
    }

    @AuraEnabled
    public static Case createQuickCase(String recordId) {
        Case caseObj = new Case();
        Case cas = [
            SELECT 
            Id, 
            Subject, 
            AccountId, 
            Verified_Patient__c, 
            Patient__c, 
            Hospital_Number_HN__c, 
            Full_Name__c, 
            Gender__c, 
            Nationality__c, 
            Date_of_Birth__c, 
            SuppliedEmail, 
            Case_Category_Level1__c, 
            Case_Category_Level2__c, 
            Case_Category_Level3__c, 
            Caller_Name__c, 
            Contact_Number__c, 
            Contact_Center_Channel__c, 
            Service_Detail__c, 
            Building__c, 
            Doctor_Name__c, 
            Patient_s_Room_Department__c, 
            IV_Team_Name__c, 
            Symptoms_Diseases__c, 
            Contact_Center_Source__c, 
            Contact_Center_Attendee__c, 
            Department__c, 
            Specialty_Doctor__c, 
            Doctor__c, 
            Interpreter_Language__c, 
            Type_of_SMS__c, 
            Medical_Procedure__c, 
            Contact_Center_Other_Source__c, 
            Contact_Center_Follower__c, 
            Postpone_Date__c, 
            Not_App_Reason__c, 
            App_Date__c, 
            App_Date_Liaison__c, 
            App_Time_Status__c, 
            App_Time__c, 
            Add_field_Info_1__c, 
            Add_field_Info_2__c, 
            Add_field_Info_3__c, 
            Add_field_Info_4__c, 
            Add_field_Info_5__c, 
            Add_field_Info_6__c, 
            Add_field_Info_7__c, 
            Add_field_Info_8__c, 
            Add_field_Info_9__c, 
            Add_field_Info_10__c, 
            Add_field_Info_11__c, 
            Add_field_Info_12__c, 
            Add_field_Info_13__c, 
            Dynamic_Group__c, 
            Messagebird_Q_Clinic__c, 
            Case_From_MB__c, 
            MessageBird_Link__c, 
            MessageBird_Agent__c, 
            MessageBird_Ticket_ID__c, 
            Origin, 
            Channel__c, 
            RecordTypeId
            FROM 
            Case 
            WHERE 
            Id = :recordId
        ];

        caseObj.ParentId = cas.Id;
        caseObj.Subject = cas.Subject;
        caseObj.AccountId = cas.AccountId;
        caseObj.Patient__c = cas.Patient__c;
        caseObj.Verified_Patient__c = cas.Verified_Patient__c;
        caseObj.Hospital_Number_HN__c = cas.Hospital_Number_HN__c;
        caseObj.Full_Name__c= cas.Full_Name__c;
        caseObj.Gender__c = cas.Gender__c;
        caseObj.Nationality__c = cas.Nationality__c;
        caseObj.Date_of_Birth__c = cas.Date_of_Birth__c;
        caseObj.SuppliedEmail = cas.SuppliedEmail;
        caseObj.Case_Category_Level1__c = cas.Case_Category_Level1__c;
        caseObj.Case_Category_Level2__c = cas.Case_Category_Level2__c;
        caseObj.Case_Category_Level3__c = cas.Case_Category_Level3__c;
        caseObj.Caller_Name__c =cas.Caller_Name__c;
        caseObj.Contact_Number__c = cas.Contact_Number__c;
        caseObj.Contact_Center_Channel__c = cas.Contact_Center_Channel__c;
        caseObj.Service_Detail__c = cas.Service_Detail__c;
        caseObj.Building__c = cas.Building__c;
        caseObj.Doctor_Name__c = cas.Doctor_Name__c;
        caseObj.Patient_s_Room_Department__c = cas.Patient_s_Room_Department__c;
        caseObj.IV_Team_Name__c = cas.IV_Team_Name__c;
        caseObj.Symptoms_Diseases__c= cas.Symptoms_Diseases__c;
        caseObj.Contact_Center_Source__c= cas.Contact_Center_Source__c;
        caseObj.Contact_Center_Attendee__c= cas.Contact_Center_Attendee__c;
        caseObj.Department__c= cas.Department__c;
        caseObj.Specialty_Doctor__c= cas.Specialty_Doctor__c;
        caseObj.Doctor__c= cas.Doctor__c;
        caseObj.Interpreter_Language__c= cas.Interpreter_Language__c;
        caseObj.Type_of_SMS__c= cas.Type_of_SMS__c;
        caseObj.Medical_Procedure__c= cas.Medical_Procedure__c;
        caseObj.Contact_Center_Other_Source__c= cas.Contact_Center_Other_Source__c;
        caseObj.Contact_Center_Follower__c= cas.Contact_Center_Follower__c;
        caseObj.Postpone_Date__c= cas.Postpone_Date__c;
        caseObj.Not_App_Reason__c= cas.Not_App_Reason__c;
        caseObj.App_Date__c= cas.App_Date__c;
        caseObj.App_Date_Liaison__c= cas.App_Date_Liaison__c;
        caseObj.App_Time_Status__c= cas.App_Time_Status__c;
        caseObj.App_Time__c= cas.App_Time__c;
        caseObj.Add_field_Info_1__c= cas.Add_field_Info_1__c;
        caseObj.Add_field_Info_2__c= cas.Add_field_Info_2__c;
        caseObj.Add_field_Info_3__c= cas.Add_field_Info_3__c;
        caseObj.Add_field_Info_4__c= cas.Add_field_Info_4__c;
        caseObj.Add_field_Info_5__c= cas.Add_field_Info_5__c;
        caseObj.Add_field_Info_6__c= cas.Add_field_Info_6__c;
        caseObj.Add_field_Info_7__c= cas.Add_field_Info_7__c;
        caseObj.Add_field_Info_8__c= cas.Add_field_Info_8__c;
        caseObj.Add_field_Info_9__c= cas.Add_field_Info_9__c;
        caseObj.Add_field_Info_10__c= cas.Add_field_Info_10__c;
        caseObj.Add_field_Info_11__c= cas.Add_field_Info_11__c;
        caseObj.Add_field_Info_12__c= cas.Add_field_Info_12__c;
        caseObj.Add_field_Info_13__c= cas.Add_field_Info_13__c;
        caseObj.Dynamic_Group__c= cas.Dynamic_Group__c;
        caseObj.Messagebird_Q_Clinic__c= cas.Messagebird_Q_Clinic__c;
        caseObj.Case_From_MB__c= cas.Case_From_MB__c;
        caseObj.MessageBird_Link__c= cas.MessageBird_Link__c;
        caseObj.MessageBird_Agent__c= cas.MessageBird_Agent__c;
        caseObj.MessageBird_Ticket_ID__c= cas.MessageBird_Ticket_ID__c;

        caseObj.Status = 'New';
        caseObj.Priority = 'High';
        caseObj.Origin = cas.Origin;
        caseObj.Channel__c = cas.Channel__c;
        caseObj.Is_Quick_Case_Create__c = true;
        caseObj.RecordTypeId = cas.RecordTypeId;

        insert caseObj;
        return caseObj;
    }
}