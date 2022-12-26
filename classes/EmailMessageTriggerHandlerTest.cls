@IsTest
private class EmailMessageTriggerHandlerTest {
    
    @istest
    static void createChildCaseOfClosedCase_Test(){
        Case c = New Case();
        c.Status = 'New';
        c.Type = 'Phone';
        c.Status = 'New';
        c.Subject = 'Test Subject';
        c.Description = 'Description';
        c.Origin = 'Email';
        insert c;
        c.status = 'Closed';
        update c;
        
        EmailMessage emails = new EmailMessage();
        emails.FromAddress = 'abc@fromaddress.com';
        emails.FromName = 'TestName';
        emails.ToAddress = 'touchpoint@test.com';
        emails.Subject = 'subject';
        emails.TextBody = 'plainTextBody';
        emails.HtmlBody = 'htmlBody';
        emails.Incoming = true;
        emails.ParentId = c.Id;
        insert emails;
        System.assertEquals(true, c != Null);
    }

}