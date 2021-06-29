trigger Category on grz_ppt__Category__c(before Insert,before Update) {
    TriggerDispatcher.run(new CategoryTriggerHandler());
}