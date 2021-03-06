if typeof require is 'function'
  $ = require '../vendor/jquery'
  _ = require 'underscore-plus'
else
  {$, _} = window

$.fn.scrollBottom = (newValue) ->
  if newValue?
    @scrollTop(newValue - @height())
  else
    @scrollTop() + @height()

$.fn.scrollDown = ->
  @scrollTop(@scrollTop() + $(window).height() / 20)

$.fn.scrollUp = ->
  @scrollTop(@scrollTop() - $(window).height() / 20)

$.fn.scrollToTop = ->
  @scrollTop(0)

$.fn.scrollToBottom = ->
  @scrollTop(@prop('scrollHeight'))

$.fn.scrollRight = (newValue) ->
  if newValue?
    @scrollLeft(newValue - @width())
  else
    @scrollLeft() + @width()

$.fn.pageUp = ->
  @scrollTop(@scrollTop() - @height())

$.fn.pageDown = ->
  @scrollTop(@scrollTop() + @height())

$.fn.isOnDom = ->
  @closest(document.body).length is 1

$.fn.isVisible = ->
  !@isHidden()

$.fn.isHidden = ->
  # We used to check @is(':hidden'). But this is much faster than the
  # offsetWidth/offsetHeight check + all the pseudo selector mess in jquery.
  style = this[0].style

  if style.display == 'none' or not @isOnDom()
    true
  else if style.display
    false
  else
    getComputedStyle(this[0]).display == 'none'

$.fn.isDisabled = ->
  !!@attr('disabled')

$.fn.enable = ->
  @removeAttr('disabled')

$.fn.disable = ->
  @attr('disabled', 'disabled')

$.fn.insertAt = (index, element) ->
  target = @children(":eq(#{index})")
  if target.length
    $(element).insertBefore(target)
  else
    @append(element)

$.fn.removeAt = (index) ->
  @children(":eq(#{index})").remove()

$.fn.indexOf = (child) ->
  @children().toArray().indexOf($(child)[0])

$.fn.containsElement = (element) ->
  (element[0].compareDocumentPosition(this[0]) & 8) == 8

$.fn.preempt = (eventName, handler) ->
  @on eventName, (e, args...) ->
    if handler(e, args...) == false then e.stopImmediatePropagation()

  eventNameWithoutNamespace = eventName.split('.')[0]
  handlers = @handlers()[eventNameWithoutNamespace] ? []
  handlers.unshift(handlers.pop())

# Public: Get the event handlers registered on an element
#   * eventName: The optional event name to get all handlers for.
#
# Returns an object of event name keys to handler array values if an
# event name isn't specified or an array of event handlers if an event name is
# specified. This method never returns null or undefined.
$.fn.handlers = (eventName) ->
  handlers = if @length then $._data(@[0], 'events') ? {} else {}
  handlers = handlers[eventName] ? [] if arguments.length is 1
  handlers

$.fn.hasParent = ->
  @parent()[0]?

$.fn.hasFocus = ->
  @is(':focus') or @is(':has(:focus)')

$.fn.flashError = ->
  @addClass 'error'
  removeErrorClass = => @removeClass 'error'
  window.setTimeout(removeErrorClass, 300)

$.fn.trueHeight = ->
  this[0].getBoundingClientRect().height

$.fn.trueWidth = ->
  this[0].getBoundingClientRect().width

$.fn.document = (eventName, docString) ->
  eventDescriptions = {}
  eventDescriptions[eventName] = docString
  @data('documentation', {}) unless @data('documentation')
  _.extend(@data('documentation'), eventDescriptions)

$.fn.events = ->
  documentation = @data('documentation') ? {}
  events = {}

  for eventName of @handlers()
    events[eventName] = documentation[eventName] ? null

  if @hasParent()
    _.extend(@parent().events(), events)
  else
    events

$.fn.command = (eventName, selector, options, handler) ->
  if not options?
    handler  = selector
    selector = null
  else if not handler?
    handler = options
    options = null

  if selector? and typeof(selector) is 'object'
    options  = selector
    selector = null

  @document(eventName, _.humanizeEventName(eventName, options?['doc']))
  @on(eventName, selector, options?['data'], handler)

$.fn.iconSize = (size) ->
  @width(size).height(size).css('font-size', size)

$.fn.intValue = ->
  parseInt(@text())

$.Event.prototype.abortKeyBinding = ->
$.Event.prototype.currentTargetView = -> $(this.currentTarget).view()
$.Event.prototype.targetView = -> $(this.target).view()

if module?
  module.exports = $
else
  this.$ = $
