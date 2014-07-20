class BaseContactImporterTranslator

  constructor: (listener) -> @_listener = listener

class HotmailContactImporterTranslator extends BaseContactImporterTranslator

  gotContactData: (contactData) ->
    @_listener.gotContact(contactData["FirstAndLastName"], contactData["WorkEmail"])

class GmailContactImporterTranslator extends BaseContactImporterTranslator

  gotContactData: (contactData) ->
    @_listener.gotContact(contactData["FullName"], contactData["Email1"])

class YahooContactImporterTranslator extends BaseContactImporterTranslator

  gotContactData: (contactData) ->
    @_listener.gotContact(contactData["PersonName"], contactData["PrimaryEmail"])

class ContactAdderListener

  constructor: (contactManger) ->
    @_contactManager = contactManger

  gotContact:(name, email) ->
    @_contactManager.addContact(name, email, false)

class Contact

  constructor: (name, email, selected) ->
    @_name = name
    @_email = email
    @_selected = selected

  select: -> @_selected = true

  getEmail: -> @_email

  getName: -> @_name

class ContactManager

  constructor: ->
    @_contacts = []

  getContactAtIndex: (index) ->
    @_contacts[index]

  addContact: (name, email, selected) ->
    contact = new Contact(name, email, selected)
    @_contacts.push(contact)

  selectedContacts: ->
    _.filter @_contacts, (x) -> x._selected == true

class ContactManagerReporter

  constructor: (contactManger) ->
    @_contactManager = contactManger

  emailsToSendTo: ->
    _.map(@_contactManager.selectedContacts(), (x) -> x.getEmail()).join(",")
