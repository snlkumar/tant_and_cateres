@OrderItems = React.createClass
  getInitialState: ->
    items: @props.items
    itemId: 0
    orderId: @props.order.id
    quantity: ""
    errors: []
    searchedItems: []

  saveItem: (e)->   
    if e.key == 'Enter'
      if @state.quantity== 0 
        alert "invalid"
      else
        OrderApi.request('/order_items', 'POST', {item_id: @state.itemId, quantity: @state.quantity, id: @state.orderId}, @saveSuccess)

  saveSuccess: (result) ->
    if result.status
      @setState
        items: result.items,
        quantity: '',
        itemId: '',
        name: ''
        errors: []
    else
      @setState
        errors: result.errors



  loadItems: (e)->
    @setState
      name: e.target.value
    if e.target.value != ''
      OrderApi.request('/items/search_items', 'GET', {input: e.target.value}, @showItems)
    else
      @setState({ searchedItems: [] })

  showItems: (result) ->
    @setState
      searchedItems: result.items

  getQuantity: (e) ->
    @setState
      quantity: e.target.value

  selectItem: (item, e)->
    @setState
      name: item.name,
      searchedItems: [],
      itemId: item.id

  inItem: (item, e)->
    OrderApi.request('/order_items/mark_complete', 'GET', {id: item}, @saveSuccess)

  deleteItem: (item, e) ->
    OrderApi.request("/order_items/#{item}", 'DELETE', {id: item}, @saveSuccess)

  render: ->
    <div className="col-md-12 panel-default edit-list">
      <div>
        <ul>
          {
            @state.errors.map((msg, i) ->
              <li>{msg}</li>
            )
          }
        </ul>
      </div>
      <div className="panel panel-primary">
        <div className="panel-heading">items for order</div>
        <div className="panel-body">
          <form className="form-horizontal center">
            <div className="control-group">
              <div className="col-md-6">
                <input type="text" name="name" placeholder= "Item Name" className="form-control" value={@state.name} onChange={@loadItems} />
                <div>
	                <ul ref="playerslist" className="ui-autocomplete">
	                  {
	                    @state.searchedItems.map (((item, index) ->
	                      <li key={index} onClick ={@selectItem.bind(this, item ) } > {item.name}
	                      </li>
	                    ).bind(this))
	                  }                      
	                </ul>
	              </div>
              </div>
            </div>
            <div className="control-group">   
              <div className="col-md-6">
                <input type="text" name="quantity" placeholder= "Quantity" className="form-control" onChange={@getQuantity} value={@state.quantity} onKeyPress={@saveItem} />
              </div>
            </div>
          </form>
        </div>
        <div className="panel">
          <div className="panel-body">
            <table className="table table-striped">
              <thead>
                <tr>
                  <th></th>
                  <th>Name</th>
                  <th>Quantity</th>
                  <th>Charge/Day</th>
                  <th>Day(s)</th>
                  <th>Total Amount</th>
                  <th>Status</th>
                  <th>Action</th>
                </tr>
              </thead>
              <tbody>
                {                   
                  @state.items.map(((item, i) ->
                    <tr key={i}>
                      <td>{i+1}</td>
                      <td>{item.name}</td>
                      <td>{item.quantity}</td>
                      <td>{item.daily_charge}</td>
                      <td>{item.days}</td>
                      <td>{item.charge}</td>
                      <td>{item.status}</td>
                      <td>
                        <a href="#" onClick={@inItem.bind(this, item.id)}>In</a> | 
                        {
                          if item.status == 'Out'
                            <a href="#" onClick={@deleteItem.bind(this, item.id)}>Delete</a>
                          else
                            <s>Delete</s>
                        }
                      </td>
                    </tr>
                  ).bind(this))
                }
              </tbody>
            </table>
          </div>
        </div>
      </div>  
    </div>