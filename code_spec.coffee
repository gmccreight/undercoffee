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
      contactManager.addContact("Adam", "adambear@example.com", true)
      contactManager.addContact("Bertha", "bertha@example.com", false)
      contactManager.addContact("Cat", "cat@example.com", true)

    describe "selection", ->

      it "should find selected contacts", ->
        expect(contactManager.selectedContacts().length).toEqual 2

    describe "searching", ->

      it "should display all contacts before searching", ->
        expect(contactManager.displayingContacts().length).toEqual 3

      it "should do case-insensitive search by either name and email", ->
        contactManager.search("Be")
        displayingContacts = contactManager.displayingContacts()
        expect(displayingContacts.length).toEqual 2
        expect(displayingContacts[0].getEmail()).toEqual "adambear@example.com"
        expect(displayingContacts[1].getName()).toEqual "Bertha"

      it "should re-display all contacts when going from a search to a blank search", ->
        contactManager.search("adam")
        displayingContacts = contactManager.displayingContacts()
        expect(displayingContacts.length).toEqual 1
        contactManager.search("")
        expect(contactManager.displayingContacts().length).toEqual 3

      it "should display all contacts again after clearing search", ->
        contactManager.search("adam")
        displayingContacts = contactManager.displayingContacts()
        expect(displayingContacts.length).toEqual 1
        contactManager.clearSearch()
        expect(contactManager.displayingContacts().length).toEqual 3

  describe "reporter", ->

    it "should get a list of emails", ->
      reporter = new ContactManagerReporter(contactManager)
      emails = reporter.emailsToSendTo()
      expect(emails).toEqual "adambear@example.com,cat@example.com"
