trigger AccountTrigger on Account (before insert, after insert) {
    
    if (Trigger.isBefore && Trigger.isInsert) {
        for (Account acc : Trigger.new) {
            if (acc.Type == null) {
                acc.Type = 'Prospect';
            }
        }
    }
    
    if (Trigger.isBefore && Trigger.isInsert) {
        for (Account acc : Trigger.new) {
            if (acc.ShippingStreet == null || acc.ShippingCity == null || acc.ShippingState == null || acc.ShippingPostalCode == null || acc.ShippingCountry == null) {
                continue;
            } else {
                acc.BillingStreet = acc.ShippingStreet;
                acc.BillingCity = acc.ShippingCity;
                acc.BillingState = acc.ShippingState;
                acc.BillingPostalCode = acc.ShippingPostalCode;
                acc.BillingCountry = acc.ShippingCountry;
            }
        }
    }
    
    
}