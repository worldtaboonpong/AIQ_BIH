public with sharing class BatchEmailService {
    public static void SendEmailForDeleteCTIBatch(Datetime startTime,Datetime finishTime,AsyncApexJob job,Integer recordsProcessed,String bodyText) {
        if (job.CreatedBy.Email != null && job.CreatedBy.Email != ''){
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            String[] toAddresses = new String[] {job.CreatedBy.Email};
            mail.setToAddresses(toAddresses);
            mail.setSenderDisplayName('BIH Support');
            // mail.setReplyTo('info.contacttest@gmail.com');
            mail.setBccSender(false);
            mail.setUseSignature(false);
            if (job.Status == 'Completed'){
                mail.setSubject('Delete Contact CTI Completed : ' + Datetime.now().format('dd MMM YYYY hh:mm'));
                mail.setPlainTextBody('Your Batch Id: ' + job.Id +' was Success.' + 'Start Date/Time: '
                + startTime.format('dd MMM YYYY hh:mm:ss')
                + 'Finish Date/Time: '+finishTime.format('dd MMM YYYY hh:mm:ss')
                + 'Quantity of Contacts has been delete :'+recordsProcessed);

                mail.setHtmlBody('Your Batch Id :<b> ' + job.Id +' </b>was <b>'+job.Status+ '</b>.<p>'
                + 'Start Date/Time : <b>'+startTime.format('dd MMM YYYY hh:mm:ss') +'</b><p>'
                + 'Finish Date/Time : <b>'+finishTime.format('dd MMM YYYY hh:mm:ss')+'</b><p>'
                + 'Data : <b>'+bodyText+'</b><p>'
                + 'Quantity of Contacts has been delete : <b>'+recordsProcessed+'</b><p>');
                Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
            }else {
                mail.setSubject('Delete Contact CTI '+ job.Status +'  : ' + Datetime.now().format('dd MMM YYYY hh:mm'));
                mail.setPlainTextBody('Your Batch Id: ' + job.Id +' was Success.' + 'Start Date/Time: '
                + startTime.format('dd MMM YYYY hh:mm:ss')
                + 'Finish Date/Time: '+finishTime.format('dd MMM YYYY hh:mm:ss')
                + 'Quantity of Contacts has been delete :'+recordsProcessed);

                mail.setHtmlBody('Your Batch Id :<b> ' + job.Id +' </b>was <b>'+job.Status+ '</b>.<p>'
                + 'Start Date/Time : <b>'+startTime.format('dd MMM YYYY hh:mm:ss') +'</b><p>'
                + 'Finish Date/Time : <b>'+finishTime.format('dd MMM YYYY hh:mm:ss')+'</b><p>'
                + 'Data : <b>'+bodyText+'</b><p>'
                // + 'Quantity of Contacts has been delete : <b>'+recordsProcessed+'</b><p>'
                );
                Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
            }
        }
    }

    public static void SendEmailForDeleteCTIBatch(Datetime startTime,Datetime finishTime,AsyncApexJob job,Integer recordsProcessed,String SuccessPhone, String FailPhone) {
        if (job.CreatedBy.Email != null && job.CreatedBy.Email != ''){
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            String[] toAddresses = new String[] {job.CreatedBy.Email};
            mail.setToAddresses(toAddresses);
            mail.setSenderDisplayName('BIH Support');
            // mail.setReplyTo('info.contacttest@gmail.com');
            mail.setBccSender(false);
            mail.setUseSignature(false);
            if (job.Status == 'Completed'){
                mail.setSubject('Delete Contact CTI Completed : ' + Datetime.now().format('dd MMM YYYY hh:mm'));
                mail.setPlainTextBody('Your Batch Id: ' + job.Id +' was Success.' + 'Start Date/Time: '
                + startTime.format('dd MMM YYYY hh:mm:ss')
                + 'Finish Date/Time: '+finishTime.format('dd MMM YYYY hh:mm:ss')
                + 'Quantity of Contacts has been delete :'+recordsProcessed);

                mail.setHtmlBody('Your Batch Id :<b> ' + job.Id +' </b>was <b>'+job.Status+ '</b>.<p>'
                + 'Start Date/Time : <b>'+startTime.format('dd MMM YYYY hh:mm:ss') +'</b><p>'
                + 'Finish Date/Time : <b>'+finishTime.format('dd MMM YYYY hh:mm:ss')+'</b><p>'
                + 'Success : <b>'+SuccessPhone+'</b><p>'
                + 'Fail : <b>'+FailPhone+'</b><p>'
                + 'Quantity of Contacts has been delete : <b>'+recordsProcessed+'</b><p>');
                Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
            }else {
                mail.setSubject('Delete Contact CTI '+ job.Status +'  : ' + Datetime.now().format('dd MMM YYYY hh:mm'));
                mail.setPlainTextBody('Your Batch Id: ' + job.Id +' was Success.' + 'Start Date/Time: '
                + startTime.format('dd MMM YYYY hh:mm:ss')
                + 'Finish Date/Time: '+finishTime.format('dd MMM YYYY hh:mm:ss')
                + 'Quantity of Contacts has been delete :'+recordsProcessed);

                mail.setHtmlBody('Your Batch Id :<b> ' + job.Id +' </b>was <b>'+job.Status+ '</b>.<p>'
                + 'Start Date/Time : <b>'+startTime.format('dd MMM YYYY hh:mm:ss') +'</b><p>'
                + 'Finish Date/Time : <b>'+finishTime.format('dd MMM YYYY hh:mm:ss')+'</b><p>'
                + 'Success : <b>'+SuccessPhone+'</b><p>'
                + 'Fail : <b>'+FailPhone+'</b><p>'
                // + 'Quantity of Contacts has been delete : <b>'+recordsProcessed+'</b><p>'
                );
                Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
            }
        }
    }
}