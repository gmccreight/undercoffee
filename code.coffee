class Contact

  constructor: (id, email, selected) ->
    @_id = id
    @_email = email
    @_selected = selected

class Code

  constructor: ->
    @_contacts = []

  addContact: (id, email, selected) ->
    contact = new Contact(id, email, selected)
    @_contacts.push(contact)

  selectedContacts: ->
    _.filter @_contacts, (x) -> x._selected == true
