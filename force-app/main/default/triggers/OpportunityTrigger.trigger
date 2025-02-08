trigger OpportunityTrigger on Opportunity (before insert, before update, before delete) {
    
    Set<Id> accountIds = new Set<Id>();
    
    if (Trigger.isBefore) {
        
        if (Trigger.isUpdate) {
            for (Opportunity opp : Trigger.new) {
                accountIds.add(opp.AccountId);
            }
            
            Map<Id, Contact> contactsMap = new Map<Id, Contact>();
            for (Contact con : [SELECT Id, AccountId, Title, FirstName FROM Contact WHERE AccountId IN :accountIds AND Title = 'CEO' ORDER BY FirstName]) {
                contactsMap.put(con.AccountId, con);
            }
            for (Opportunity opp : Trigger.new) {
                Contact relatedContact = contactsMap.get(opp.AccountId);
                if (relatedContact != null) {
                    opp.Primary_Contact__c = relatedContact.Id;
                }
                if (opp.Amount <= 5000) {
                    opp.addError('Opportunity amount must be greater than 5000');
                }
            }
        }
        
        else if (Trigger.isDelete) {
            for (Opportunity opp : Trigger.old) {
                accountIds.add(opp.AccountId);
            }
            
            Map<Id, Account> accountMap = new Map<Id, Account>([SELECT Industry FROM Account WHERE Id IN :accountIds]);
            for (Opportunity opp : Trigger.old) {
                Account relatedAccount = accountMap.get(opp.AccountId);
                if (relatedAccount != null && opp.StageName == 'Closed Won' && relatedAccount.Industry == 'Banking') {
                    opp.addError('Cannot delete closed opportunity for a banking account that is won');
                }
            }
        }
    }
}