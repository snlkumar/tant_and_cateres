@Orders = React.createClass
  getInitialState: ->
    orders: @props.orders
    itemId: 0
    orderId: 0
    quantity: ""
    searchedItems: []

  completeOrder: (order, e)->
    OrderApi.request("/orders/#{order}/complete", 'GET', {}, @saveSuccess)

  saveSuccess: (result) ->
    if result.status
      @setState
        orders: result.orders

  render: ->
    <div className="col-md-12 panel-default edit-list">
      <div className="panel panel-primary">
        <div className="panel-heading">Orders</div>        
        <div className="panel">
          <div className="panel-body">
            <table className="table table-striped">
              <thead>
                <tr>
                  <th></th>
                  <th>Name</th>
                  <th>Address</th>
                  <th>Mobile</th>
                  <th>Status</th>
                  <th>Amount</th>
                  <th>Action</th>
                </tr>
              </thead>
              <tbody>
                {                   
                  @state.orders.map(((order, i) ->
                    <tr key={i}>
                      <td>{i+1}</td>
                      <td><a href="orders/#{order.id}/items">{order.name}</a></td>
                      <td>{order.address}</td>
                      <td>{order.phone}</td>
                      <td>{order.status}</td>
                      <td>{order.amount}</td>
                      <td><a href="#" onClick={@completeOrder.bind(this, order.id)}>In</a></td>
                    </tr>
                  ).bind(this))
                }
              </tbody>
            </table>
          </div>
        </div>
      </div>  
    </div>