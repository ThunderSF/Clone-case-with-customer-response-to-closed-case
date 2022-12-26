public without sharing class EmailMessageTriggerHandler {

    public static void createChildCaseOfClosedCase(List<EmailMessage> listEmailMessages){
        //String queueName = [Select id from group where type = 'Queue' AND Name = 'Support'].Id; Set queue name here
        Map<Id, EmailMessage> emIds = new Map<Id, EmailMessage>();
        List<Case> casesToCreate = new List<Case>();
        for (EmailMessage em : listEmailMessages){
            if(em.Incoming){
                emIds.put(em.ParentId, em);
            }
        }
        if(emIds.size()>0){
            List<Case> caseList = [Select id, Origin, Status, Priority, ParentId, ContactId, AccountId, 
								   Type, Reason, Subject ,Description,EntitlementId,ContactEmail,
                                   SuppliedEmail
                                   from Case Where id In : emIds.keySet()
                                   AND Status = 'Closed'];
            if(caseList.size()>0){
                
                for(Case c : caseList){				
				   Case newCase = new Case();
				   newCase.Status = 'New';
				   newCase.Description = c.Description;
				   newCase.Origin =  'Email';
				   newCase.ParentId = c.id;
				   newCase.ContactId = c.ContactId;
				   newCase.EntitlementId = c.EntitlementId;
				   newCase.AccountId = c.AccountId;
				   newCase.OwnerId = UserInfo.getUserId();  // Use queueName if want to transfer ownership to queue
				   newCase.Subject = c.Subject;
				   casesToCreate.add(newCase);
                }
                if(casesToCreate.size()>0){
                    Database.SaveResult[] srList = Database.insert(casesToCreate, false);
					System.debug(srList);
                }
            }
        }
    }
    
}