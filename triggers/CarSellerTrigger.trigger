trigger CarSellerTrigger on Pricebook__c (before insert, before update) {
    //if the record was created
    if (Trigger.isInsert) {
        for (Pricebook__c pb : Trigger.new) {
            //and if Holder field was set, set status to 'sold'
            if (pb.Holder__c != null) {
                pb.Status__c = 'Sold';

                Car__c carToUpdate = [SELECT id, Holder__c FROM Car__c WHERE Model__c = :pb.Model__c LIMIT 1];
                carToUpdate.Holder__c = pb.Holder__c;
                update carToUpdate;
            }
        }
    }

    //if record wass updated
    if (Trigger.isUpdate) {
        for (Pricebook__c pbOld : Trigger.old) {
            for (Pricebook__c pbNew : Trigger.new) {
                //and if Holder was still null after insert, set status to 'sold'
                if (pbOld.Holder__c == null && pbNew.Holder__c != null) {
                    pbNew.Status__c = 'Sold';

                    Car__c carToUpdate = [SELECT id, Holder__c FROM Car__c WHERE Model__c = :pbNew.Model__c LIMIT 1];
                    carToUpdate.Holder__c = pbNew.Holder__c;
                    update carToUpdate;
                }
                //else Holder was set and then changed, set status to 'Previously used'
                else if (pbOld.Holder__c != pbNew.Holder__c) {
                    pbNew.Status__c = 'Previously used';

                    Car__c carToUpdate = [SELECT id, Holder__c FROM Car__c WHERE Model__c = :pbNew.Model__c LIMIT 1];
                    carToUpdate.Holder__c = pbNew.Holder__c;
                    update carToUpdate;
                }
            }
        }
    }
}
