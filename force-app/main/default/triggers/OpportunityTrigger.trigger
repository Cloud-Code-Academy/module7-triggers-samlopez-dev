trigger OpportunityTrigger on Opportunity (before insert, before update) {
    
    if (Trigger.isBefore && Trigger.isUpdate) {
        for (Opportunity opp : Trigger.new){
            if (opp.Amount <= 5000) {
                opp.addError('Opportunity amount must be greater than 5000');
            }
        }
        
    }
    
}