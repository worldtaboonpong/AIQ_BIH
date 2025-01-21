public with sharing class ConfirmController {
  public Case c { get; set; }

  public ConfirmController() {
    c = [SELECT Id, Confirm__c FROM Case WHERE Id = :ApexPages.currentPage().getParameters().get('caseId')];
  }

  public PageReference confirm() {
    c.Confirm__c = true;
    update c;
    return new PageReference('/confirm');
  }
}