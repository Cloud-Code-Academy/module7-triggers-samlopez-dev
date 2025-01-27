trigger OpportunityTrigger on Opportunity (before insert, before update, after delete) {
    
    if (Trigger.isBefore && Trigger.isUpdate) {
        for (Opportunity opp : Trigger.new){
            if (opp.Amount <= 5000) {
                opp.addError('Opportunity amount must be greater than 5000');
            }
        }
        
    }
    
    if (Trigger.isDelete) {
        
        Set<Id> accountIds = new Set<Id>();
        
        for (Opportunity opp : Trigger.old){
            accountIds.add(opp.AccountId);
        }
        
        Map<Id, Account> accountMap = new Map<Id,Account>([SELECT Industry FROM Account WHERE Id IN : accountIds]);
        
        for (Opportunity opp : Trigger.old) {
            Account relatedAccount = accountMap.get(opp.AccountId);
            if (opp.IsWon && relatedAccount.Industry == 'Banking') {
                opp.addError('Cannot delete closed opportunity for a banking account that is won');
            }
        }
    }
    
}