@isTest
public class DownloadAllFilesTest {
    @isTest
    public static void DownloadAllFilesTest() {        
        Test.startTest();
        Case cse=new Case();
        insert cse;
        
        Task ta = new Task();
        ta.WhatId=cse.id;
        insert ta;

        EmailMessage em = new EmailMessage();
        em.parentId=cse.id;
        insert em;
        
        Work_Duration__c wd = new Work_Duration__c();
        wd.Case__c = cse.id;
        insert wd;
        /*
        Attachment attach=new Attachment();   	
    	attach.Name='Unit Test Attachment';
    	Blob bodyBlob=Blob.valueOf('Unit Test Attachment Body');
    	attach.body=bodyBlob;
        attach.parentId=cse.id;
        insert attach;
        */
        
        ContentVersion content = new ContentVersion();
        content.Title = 'HeaderPic1';
        content.PathOnClient= '/'+content.Title+'.jpg';
        Blob bodyBlob=Blob.valueOf('Unit Test ContentVersion Body');
        content.VersionData=bodyBlob;
        content.origin='H';
        insert content;

        ContentDocumentLink contentlink = new ContentDocumentLink();
        contentlink.LinkedEntityId = cse.id;
        contentlink.contentdocumentid=[SELECT contentdocumentid FROM ContentVersion WHERE id = :content.id].contentdocumentid;
        contentlink.ShareType = 'I';
        contentlink.Visibility = 'AllUsers';
        insert contentlink;

        ContentVersion content1 = new ContentVersion();
        content1.Title = 'HeaderPic2';
        content1.PathOnClient= '/'+content1.Title+'.jpg';
        Blob bodyBlob1=Blob.valueOf('Unit Test ContentVersion Body1');
        content1.VersionData=bodyBlob1;
        content1.origin='H';
        insert content1;

        ContentDocumentLink contentlink1 = new ContentDocumentLink();
        contentlink1.LinkedEntityId = em.id;
        contentlink1.contentdocumentid=[SELECT contentdocumentid FROM ContentVersion WHERE id = :content1.id].contentdocumentid;
        contentlink1.ShareType = 'V';
        contentlink1.Visibility = 'AllUsers';
        insert contentlink1;

        ContentVersion content2 = new ContentVersion();
        content2.Title = 'HeaderPic3';
        content2.PathOnClient= '/'+content1.Title+'.jpg';
        Blob bodyBlob2=Blob.valueOf('Unit Test ContentVersion Body2');
        content2.VersionData=bodyBlob2;
        content2.origin='H';
        insert content2;

        ContentDocumentLink contentlink2 = new ContentDocumentLink();
        contentlink2.LinkedEntityId = ta.id;
        contentlink2.contentdocumentid=[SELECT contentdocumentid FROM ContentVersion WHERE id = :content2.id].contentdocumentid;
        contentlink2.ShareType = 'V';
        contentlink2.Visibility = 'AllUsers';
        insert contentlink2;
        
        ContentVersion content3 = new ContentVersion();
        content3.Title = 'HeaderPic4';
        content3.PathOnClient= '/'+content1.Title+'.jpg';
        Blob bodyBlob3=Blob.valueOf('Unit Test ContentVersion Body3');
        content3.VersionData=bodyBlob3;
        content3.origin='H';
        insert content3;

        ContentDocumentLink contentlink3 = new ContentDocumentLink();
        contentlink3.LinkedEntityId = wd.id;
        contentlink3.contentdocumentid=[SELECT contentdocumentid FROM ContentVersion WHERE id = :content3.id].contentdocumentid;
        contentlink3.ShareType = 'V';
        contentlink3.Visibility = 'AllUsers';
        insert contentlink3;
		
    	
    	//List<Attachment> attachments=[select id, name from Attachment where parent.id=:cse.id];
    	//System.assertEquals(1, attachments.size());
        
        //DownloadAllFiles obj_dlAF = new DownloadAllFiles();
        //obj_dlAF.generateDownloadAllFiles(cse.id);

        DownloadAllFiles.generateDownloadAllFiles(cse.id);
        
        
        
		Test.stopTest();
        
    }
}