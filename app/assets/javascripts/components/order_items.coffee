@OrderItems = React.createClass
  getInitialState: ->
    items: @props.items
    itemId: 0
    orderId: @props.order.id
    quantity: 0
    searchedItems: []

  saveItem: (e)->   
    if e.key == 'Enter'
      if @state.quantity== 0 
        alert "invalid"
      else
        OrderApi.request('/order_items', 'POST', {item_id: @state.itemId, id: 1}, @saveSuccess)

  saveSuccess: (result) ->
    if result.status
      @setState
        items: result.items

  loadItems: (e)->
    input = e.target.value
    OrderApi.request('/items/search_items', 'GET', {input}, @showItems)

  showItems: (result) ->
    @setState
      searchedItems: result.items

  getQuantity: (e) ->
    @setState
      quantity: e.target.value

  setItem: (item, e)->
    @setState
      name: item.name,
      searchedItems: [],
      itemId: item.id

  render: ->
    <div className="col-md-10 col-md-offset-1 panel-default">
      <div className="panel panel-primary">
        <div className="panel-heading">items for order</div>
        <div className="panel-body">
          <form className="form-horizontal center">
            <div className="control-group">
              <div className="col-md-6">
                <input type="text" name="name" placeholder= "Item Name" className="form-control" value={@state.name} onChange={@loadItems} />
                <div>
	                <ul ref="playerslist">
	                  {
	                    @state.searchedItems.map (((item, index) ->
	                      <li key={index} onClick ={@setItem.bind(this, item ) } > {item.name}
	                      </li>
	                    ).bind(this))
	                  }                      
	                </ul>
	              </div>
              </div>
            </div>
            <div className="control-group">   
              <div className="col-md-6">
                <input type="text" name="quantity" placeholder= "Quantity" className="form-control" onChange={@getQuantity} onKeyPress={@saveItem} />
              </div>
            </div>
          </form>
        </div>
        <div className="panel">
          <div className="panel-body">
            <table className="table table-striped">
              <thead>
                <tr>
                  <th>Name</th>
                  <th>Quantity</th>
                  <th>Charge</th>
                  <th>Status</th>
                </tr>
              </thead>
              <tbody>
                { 
                  debugger
                  @state.items.map((x, i) ->                    
                    <tr>
                      <td>xxx</td>
                      <td>{x.name}</td>
                      <td>10</td>
                      <td>Out</td>
                    </tr>
                  )
                }
              </tbody>
            </table>
          </div>
        </div>
      </div>  
    </div>