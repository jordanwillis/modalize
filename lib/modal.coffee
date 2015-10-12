DEBUG = false


###
#     Template.materializeModalContainer
###
Template.materializeModalContainer.helpers
  modalOptions: ->
    Template.currentData().get()


###
#     Template.materializeModal
###
Template.materializeModal.onCreated ->
  console.log("Template.materializeModal.onCreated", @data) if DEBUG


Template.materializeModal.onRendered ->
  console.log("Template.materializeModal.onRendered", @data.title)  if DEBUG

  #
  # (1) Update the jQuery handle of the modal instance with the latest
  #     modal DOM element.
  #
  Materialize.modalize.$modal = $ @find '#materializeModal'

  #
  # (2) Compute modal animation duration.
  #     Fullscreen modals should appear instantly.
  #     Otherwise, 300ms transition.
  #
  if @data.fullscreen then inDuration = 0 else 300

  #
  # (3) Call Materialize's openModal() method to make
  #     the modal content appear.
  #
  # Set a callback to handle destroying the materializeModal template
  # if the user "completes" the modal, for instance by clicking
  # the background.
  #
  Materialize.modalize.$modal.openModal
    in_duration: inDuration
    ready: ->
      console.log("materializeModal: ready") if DEBUG
    complete: ->
      console.log("materializeModal: complete") if DEBUG
      Materialize.modalize.close false


Template.materializeModal.onDestroyed ->
  console.log("Template.materializeModal.onDestroyed") if DEBUG


Template.materializeModal.helpers

  #
  # bodyTemplate: The name of the template that should be rendered
  #               in the modal's body area.
  #
  bodyTemplate: ->
    @bodyTemplate or null

  #
  # icon: Return a Material icon code for the Modal.
  #
  icon: ->
    if @icon
      @icon
    else
      console.log("icon: type", @type) if DEBUG
      switch @type
        when 'alert'
          'warning'
        when 'error'
          'error'

  #
  # modalFooter:
  #
  modalFooter: ->
    @footerTemplate or 'materializeModalFooter'

#
# Extend data context helpers (title, footer, etc.) into the modal
# body wrapper.
#
Template.materializeModalBody.inheritsHelpersFrom "materializeModal"

Template.materializeModal.events
  "click #closeButton": (e, tmpl) ->
    e.preventDefault()
    console.log('closeButton') if DEBUG
    Materialize.modalize.close(false)

  "submit form#materializeModalForm, click button#submitButton": (e, tmpl) ->
    e.preventDefault()
    form = tmpl?.$('form#materializeModalForm')
    console.log('submit event:', e, "form:", form) if DEBUG
    Materialize.modalize.close true,
      event: e
      form: form
    false # this prevents the page from refreshing on form submission!


Template.materializeModalForm.helpers
  #
  # isForm: Only true when the modal is a form.
  #
  isForm: ->
    @type in [ 'form', 'prompt' ]
