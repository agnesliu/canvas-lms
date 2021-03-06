define [
  'i18n!editor'
  'jquery'
  'compiled/editor/EditorToggle'
], (I18n, $, EditorToggle) ->

  ##
  # Makes an EntryView's model message editable with TinyMCE
  #
  # ex:
  #
  #   editor = new EntryEditor(EntryView)
  #   editor.edit()    # turns the content into a TinyMCE editor box
  #   editor.display() # closes editor, saves model
  #
  class EntryEditor extends EditorToggle

    ##
    # @param {EntryView} view
    constructor: (@view) ->
      super @view.$('.message:first')
      @cancelButton = @createCancelButton()
      @done.addClass 'small-button'

    ##
    # Extends EditorToggle::display to save the model's message.
    #
    # @param {Bool} opts.cancel - doesn't submit
    # @api public
    display: (opts)->
      super
      @cancelButton.detach()
      if opts?.cancel isnt true
        @view.model.save
          messageNotification: I18n.t('saving', 'Saving...')
          message: @content
        ,
          success: @onSaveSuccess
          error: @onSaveError

    createCancelButton: ->
      $('<a/>')
        .html(I18n.t('cancel', 'Cancel'))
        .attr('href', 'javascript:')
        .addClass('cancel_button')
        .click => @display cancel: true

    edit: ->
      super
      @cancelButton.insertAfter @done

    ##
    # Overrides EditorToggle::getContent to get the content from the model
    # rather than the HTML of the element. This is because `enhanceUserContent`
    # in `instructure.js` manipulates the html and we need the raw html.
    #
    # @api private
    getContent: ->
      @view.model.get 'message'

    ##
    # Called when the model is successfully saved, provides user feedback
    #
    # @api private
    onSaveSuccess: =>
      @view.model.set 'messageNotification', ''

    ##
    # Called when the model fails to save, provides user feedback
    #
    # @api private
    onSaveError: =>
      @view.model.set
        messageNotification: I18n.t('save_failed', 'Failed to save, please try again later')
      @edit()

