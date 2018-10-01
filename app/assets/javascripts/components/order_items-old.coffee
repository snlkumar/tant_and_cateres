@OrderItems = React.createClass
  getInitialState: ->
    items: @props.items
    itemId: 0
    orderId: @props.order.id
    quantity: ""
    value: 10
    errors: []
    showDelete: true
    itemName: ''
    editId: 0
    rowEdit: 0
    error: ''
    oldQuantity: 0

  componentDidMount: ->
    $('#tags').autocomplete(
      source: '/items/search_items'
      select: ((event, ui) ->
        @setState
          itemId: ui.item.id
        false
      ).bind this
      focus: (( event, ui ) ->
        @setState
          itemName: ui.item.name
        false
      ).bind this
    ).autocomplete('instance')._renderItem = (ul, item) ->
      $('<li>').append('<div>' + item.name +  '</div>').appendTo ul   

  saveItem: (e)->   
    if e.key == 'Enter'
      if @state.quantity== 0 
        alert "invalid"
      else
        OrderApi.request('/order_items', 'POST', {item_id: @state.itemId, quantity: @state.quantity, id: @state.orderId, status: 'Initial'}, @saveSuccess)

  saveSuccess: (result) ->
    if result.status
      @setState
        items: result.items,
        quantity: '',
        itemId: '',
        itemName: ''
        errors: []
    else
      @setState
        errors: result.errors

  loadItems: (e)->
    @setState
      itemName: e.target.value

  getQuantity: (e) ->
    @setState
      quantity: e.target.value  

  inItem: (item, otype, e)->    
    OrderApi.request('/order_items/mark_complete', 'GET', {id: item, status: otype}, @saveSuccess)

  deleteItem: (item, e) ->
    OrderApi.request("/order_items/#{item}", 'DELETE', {id: item}, @saveSuccess)

  showDelete: (item, e) ->
    idate = Date.parse(item.created_at)
    if moment(idate).add(5, 'm') > moment(Date.now()) then "show" else "hide"

  changeQuantity: (item, e)->
    quantity = document.getElementById "editItem"+item
    OrderApi.request("/order_items/#{item}/change_quantity", 'PUT', {quantity: quantity.textContent}, @quantityChanged)

  quantityChanged: (response) ->
    if response.status
      @setState
        editId: 'ok'
        error: ''
    else
      @setState
        error: response.errors[0]

  makeEditable: (item, e) ->
    @setState
      editId: item.id
      oldQuantity: item.quantity

  resetRow: (itemId, e) ->
    id = document.getElementById "editItem"+itemId
    id.textContent = @state.oldQuantity
    @setState
      editId: 'no'
      error: ''
      
      

  render: ->
    <div className="col-md-12 panel-default edit-list">
      <div>
        <ul className="error-list">
          {
            @state.errors.map((msg, i) ->
              <li>{msg}</li>
            )
          }
        </ul>
      </div>
      <div className="panel panel-primary">
        <div className="panel-heading">items for order</div>
        {
          if (@props.order.status != 'Completed')
            <div className="panel-body">
              <form className="form-horizontal center">
                <div className="control-group">                  
                  <div className="col-md-4">
                    <label>Product Name</label>
                    <input id="tags" type="text" name="name" placeholder= "Product" autoComplete="off" className="form-control" value={@state.itemName} onChange={@loadItems}/>
                  </div>
                </div>
                <div className="control-group">   
                  <div className="col-md-4">
                    <label>Quantity</label>
                    <input type="number" min="1" name="quantity" placeholder= "Enter quantity and hit enter key" className="form-control" onChange={@getQuantity} value={@state.quantity} onKeyPress={@saveItem} />
                  </div>
                </div>
              </form>
            </div>
        
        }
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
                  <th>Action {@props.order.status}</th>
                </tr>
              </thead>
              <tbody>
                {                   
                  @state.items.map(((item, i) ->
                    <tr key={i}>
                      <td>{i+1}</td>
                      <td>{item.name}</td>
                      {
                        if (@props.order.status != 'Completed')
                          <td>
                            <span contentEditable="true" onClick={@makeEditable.bind(this, item)} className="editable-input" id="editItem#{item.id}" >
                              {item.quantity}
                            </span>
                            {
                              
                              if @state.editId != @state.rowEdit && @state.editId == item.id
                                <div className="edit-row-action">
                                  <a href="javascript:void(0)" onClick={@changeQuantity.bind(this, item.id)}>
                                    <i className="fa fa-check"></i>
                                  </a>
                                  <a href="javascript:void(0)" onClick={@resetRow.bind(this, item.id)}>
                                    <i style={{color: 'red'}} className="fa fa-close" ></i>
                                  </a>
                                  <span className="has-error"> {@state.error}</span>
                                </div>
                            }
                          </td>
                        else
                          item.quantity

                      }
                      <td>{item.daily_charge}</td>
                      <td>{item.days}</td>
                      <td>{item.charge}</td>
                      <td>{item.status}</td>
                      <td>
                        {
                          if item.status == "Initial"
                            <div>
                              <span><a href="#" onClick={@inItem.bind(this, item.id, 'O')}>Out</a> | <a href="#" onClick={@deleteItem.bind(this, item.id)}>Delete</a></span>
                            </div>

                          else if item.status == 'Out'
                            <div>
                              <span>
                                <a href="#" onClick={@inItem.bind(this, item.id, 'C')}>In</a>
                              </span>
                              <span className={@showDelete(item)}><a href="#" onClick={@deleteItem.bind(this, item.id)}>Delete</a></span>    
                            </div>
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