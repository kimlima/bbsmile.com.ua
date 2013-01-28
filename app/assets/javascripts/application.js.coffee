#= require jquery
#= require twitter/bootstrap

do ($ = jQuery) ->
  $ ->
    $('a[rel=popover]').popover().click (e) ->
      e.preventDefault()
    $('.contacts .actions a[rel=popover]').click (e) ->
      $(@).toggleClass 'active'
      top = parseFloat($(@).next('.popover').css('top')) + 20
      $(@).next('.popover').css 'top', "#{top}px"
      e.preventDefault()