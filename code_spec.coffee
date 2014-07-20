describe "Contacts", ->

  contactManager = null

  contact = (id, selected) ->
    new Contact(id, selected)

  describe "import contacts", ->

    listener = null

    beforeEach ->
      contactManager = new ContactManager()
      listener = new ContactAdderListener(contactManager)

    it "should work from hotmail", ->
      translator = new HotmailContactImporterTranslator(listener)
      translator.gotContactData({FirstAndLastName:"John Jones", WorkEmail:"john@example.com"})
      expect(contactManager.getContactAtIndex(0).getEmail()).toEqual "john@example.com"

    it "should work from gmail", ->
      translator = new GmailContactImporterTranslator(listener)
      translator.gotContactData({FullName:"John Jones", Email1:"john@example.com"})
      expect(contactManager.getContactAtIndex(0).getEmail()).toEqual "john@example.com"

    it "should work from yahoo", ->
      translator = new YahooContactImporterTranslator(listener)
      translator.gotContactData({PersonName:"John Jones", PrimaryEmail:"john@example.com"})
      expect(contactManager.getContactAtIndex(0).getEmail()).toEqual "john@example.com"

  describe "ContactsManager (using idealized interface)", ->

    beforeEach ->
      contactManager = new ContactManager()
      contactManager.addContact(1, "adam@example.com", true)
      contactManager.addContact(2, "bertha@example.com", false)
      contactManager.addContact(3, "cat@example.com", true)

    it "should find selected contacts", ->
      expect(contactManager.selectedContacts().length).toEqual 2

  describe "reporter", ->

    it "should get a list of emails", ->
      reporter = new ContactManagerReporter(contactManager)
      emails = reporter.emailsToSendTo()
      expect(emails).toEqual "adam@example.com,cat@example.com"
