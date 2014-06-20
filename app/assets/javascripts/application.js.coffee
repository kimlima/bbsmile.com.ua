//= require jquery
//= require jquery_ujs
//= require underscore
//= require twitter/bootstrap
//= require jquery.scrollTo/jquery.scrollTo
//= require search-box
//= require order-from-grid
//= require category
//= require promotions
//= require ga-events
//= require contact_dialog
//= require callback_dialog
//= require blueimp-gallery/js/blueimp-gallery
//= require bootstrap-image-gallery/js/bootstrap-image-gallery
//= require jquery.mask
//= require jquery.cookie

$ ->
  $('a[rel=popover]').popover()
  $('a[rel=popover]').click (e) ->
    e.preventDefault()
  $('.contacts .actions a[rel=popover]').click (e) ->
    $(@).toggleClass 'active'
    top = parseFloat($(@).next('.popover').css('top')) + 20
    left = parseFloat($(@).next('.popover').css('left')) - 7
    $(@).next('.popover').css('top',  "#{top}px")
                         .css('left', "#{left}px")
    e.preventDefault()

  $('a[data-scroll]').click (e) ->
    $.scrollTo $(@).attr('href'), $(@).data('scroll'), offset: -55

  $('.landing-nav .nav a').click (e) ->
    offset = $(@).data('offset')
    offset = -85 unless offset?
    $.scrollTo $(@).data('target'), 800, offset: offset
    _gaq.push ['_trackEvent', 'Навигация', $(this).text()]
    e.preventDefault()

  toggleGoTop = ->
    if $(@).scrollTop() > 200
      $('a.go-top').fadeIn 200
    else
      $('a.go-top').fadeOut 200
  toggleGoTop()
  $(window).scroll toggleGoTop

  $('a.go-top').click (e) ->
    e.preventDefault()
    $('html, body').animate scrollTop: 0, 300
    _gaq.push ['_trackEvent', 'Навигация', 'К началу страницы', 0, true]

  new ContactDialog('#send-message')
  new CallbackDialog('#send-callback')

  $('input[type="tel"]').mask '(000) 000-00-00'

  $('#global-message button').click (e) ->
    $.cookie 'hide-global-message-21-06', 1

  unless $.cookie('hide-global-message-21-06')
    $('#global-message').toggleClass 'hide'


  $('.gallery-links').each ->
    links = $('a[data-gallery]', @)
    links.click (e) ->
      gallery = $(@).data 'gallery'
      options =
        index: @
        event: e
        container: gallery
        onslide: (index, slide) ->
          $('.next, .prev', slide).removeAttr 'disabled'
          $(gallery).trigger 'slide', [index, slide, links]
        onslideend: (index, slide) ->
          $('.next', slide).attr 'disabled', 'disabled' if index == links.length - 1
          $('.prev', slide).attr 'disabled', 'disabled' if index == 0
        onopen: =>
          $(gallery).trigger 'display', [@]
      blueimp.Gallery links, options
