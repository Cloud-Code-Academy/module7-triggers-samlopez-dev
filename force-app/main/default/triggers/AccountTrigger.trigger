trigger AccountTrigger on Account (before insert, after insert) {
    
    if (Trigger.isBefore) {
        if (Trigger.isInsert) {
            for (Account acc : Trigger.new) {
                if (acc.Type == null) {
                    acc.Type = 'Prospect';
                }
            }
        }
    }
    
}