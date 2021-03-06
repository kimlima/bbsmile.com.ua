CallbackDialog = require('./callback_dialog')
ContactDialog  = require('./contact_dialog')
require('./ga-events.coffee')

require('jquery.scrollto')
require('jquery-mask-plugin')
require('jquery.cookie')
require('lightgallery')

$ ->
  $('a[data-toggle=popover]').popover()
  $('a[data-toggle=popover]').click (e) ->
    e.preventDefault()
  $('.contacts .actions a[rel=popover]').click (e) ->
    $(@).toggleClass 'active'
    top = parseFloat($(@).next('.popover').css('top')) + 20
    left = parseFloat($(@).next('.popover').css('left')) - 7
    $(@).next('.popover').css('top',  "#{top}px")
                         .css('left', "#{left}px")
    e.preventDefault()

  $('#site-header .contacts .actions a.phone').click (e) ->
    if !$('#site-header').hasClass('jumbotron')
      $('.contacts .actions .popover').toggle()
    e.preventDefault()

  $('a[data-scroll]').click (e) ->
    offset = $(@).data('offset') ? -55
    $.scrollTo $(@).attr('href'), $(@).data('scroll'), offset: offset

  $('.landing-nav .nav a').click (e) ->
    offset = $(@).data('offset') ? -85
    $.scrollTo $(@).data('target'), 800, offset: offset
    ga 'send', 'Навигация', $(this).text()
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
    ga 'send', 'Навигация', 'К началу страницы'

  new ContactDialog('#send-message')
  new CallbackDialog('#send-callback')
  new CallbackDialog('#send-quick-order') if $("#send-quick-order").length

  $('.show-rest-products').click (e) ->
    $(@).parents('.products-list').find('.line.hide').removeClass('hide')
    $(@).hide()

  $('[data-toggle=offcanvas]').click (e) ->
    $('.product-filters').toggle(
      => $('span', this).text 'Показать фильтры'
      => $('span', this).text 'Скрыть фильтры'
    )
    $('i.fa', this).toggleClass 'fa-chevron-down fa-chevron-up'

  $('input[type="tel"]').mask '+38 (r00) 000-00-00',
    translation:
      r:
        pattern: /0/
        fallback: '0'

  $('input[name="order[payment_method]"]').click ->
    $('.payment-help').hide()
    $(".payment-help.#{$(this).val()}").fadeIn()

  $('#global-message button').click (e) ->
    $.cookie 'hide-global-message', 1, expires: 7
    $('#global-message').toggleClass 'hide'

  unless $.cookie('hide-global-message')
    $('#global-message').toggleClass 'hide'

  $('.lightgallery[data-gallery-id]').each ->
    $(this).lightGallery(
      selector: "a[data-gallery='##{$(this).data('gallery-id')}']"
      download: false
      html: true
      hideBarsDelay: 1e6 # set huge delay since no option to disable hiding
    )

  $('.footer .social').html '<a href="http://vk.com/babysmile_ua" target="_blank" rel="nofollow" title="Мы Вконтакте"><i class="fa fa-vk"></i> </a><a href="https://www.instagram.com/detskaja_odezhda_babysmile/" target="_blank" rel="nofollow" title="Instagram"><i class="fa fa-instagram"></i> </a><a href="http://www.facebook.com/babysmile.ua" target="_blank" rel="nofollow" title="Страница в Facebook"><i class="fa fa-facebook"></i> </a><a href="http://twitter.com/babysmileua" target="_blank" rel="nofollow" title="Читать наши твиты"><i class="fa fa-twitter"></i></a>'
