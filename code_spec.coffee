describe "Code", ->

  code = null

  contact = (id, selected) ->
    new Contact(id, selected)

  beforeEach ->
    code = new Code()
    code.addContact(1, "adam@example.com", true)
    code.addContact(2, "bertha@example.com", false)
    code.addContact(3, "cat@example.com", true)

  it "should find selected contacts", ->
    expect(code.selectedContacts().length).toEqual 2

  it "should get a list of emails", ->
    emails = _.map(code.selectedContacts(), (x) -> x._email).join(",")
    expect(emails).toEqual "adam@example.com,cat@example.com"
