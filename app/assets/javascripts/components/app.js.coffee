//= require ./cart

@app = new Vue(
  el: 'body'
  data:
    cartState:
      total: 0
      size: 0
      suborders: []
    cartModalId: "cartModal"
    currentOrder: {}
    pageTitle: ''
    flashMessage: ''
  created: ->
    @populateCartState(window.cartState)
  watch:
    'cartState.size': (size) -> @closeCart() unless size
  methods:
    openCart: -> @$.cartModal.open()
    closeCart: -> @$.cartModal.close()
    addCartItem: (item) ->
      item.quantity = 1
      $.post(
        '/cart'
        item
        (data) =>
          @populateCartState(data)
          @openCart()
        'json'
      )
    deleteCartItem: (index) ->
      $.post(
        '/cart'
        index: index, _method: 'delete'
        (data) =>
          @populateCartState(data)
        'json'
      )
    updateCartItem: (index, quantity) ->
      $.post(
        '/cart/update'
        index: index, quantity: quantity
        (data) => @populateCartState(data)
        'json'
      )
    populateCartState: (data) ->
      @cartState.total = data.total_with_currency
      @cartState.size = data.size
      @cartState.suborders = data.suborders
    emptyCart: ->
      @cartState.total = ''
      @cartState.size = 0
      @cartState.suborders = []
)
