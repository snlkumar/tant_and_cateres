@Orders = React.createClass
  getInitialState: ->
    orders: @props.orders
    itemId: 0
    orderId: 0
    quantity: ""
    searchedItems: []
    startDate: moment(new Date()).format('YYYY-MM-DD')
    endDate: moment(new Date()).format('YYYY-MM-DD')

  setStartDate: (selected) ->    
    @setState
      startDate: moment(selected).format('YYYY-MM-DD')

  setEndDate: (selected) ->
    @setState
      endDate: moment(selected).format('YYYY-MM-DD')

  completeOrder: (order, e)->
    OrderApi.request("/orders/#{order}/complete", 'GET', {}, @saveSuccess)

  orderDispatched: (order, e) ->
    OrderApi.request("/orders/#{order}/order_dispatched", 'PUT', {}, @saveSuccess)

  saveSuccess: (result) ->
    if result.status
      @setState
        orders: result.orders

  searchOrder: ->
    OrderApi.request("/orders/search", 'GET', {from: @state.startDate, to: @state.endDate}, @saveSuccess)

  searchByName: (e) ->
    OrderApi.request("/orders/search", 'GET', {q: e.target.value}, @saveSuccess)

  render: ->
    <div className="col-md-12 panel-default edit-list">
      <div className="panel panel-primary">
        <div className="panel-heading">Orders</div>        
        <div className="panel">
          <div className="panel-body">
            <form className="form-horizontal center">
              <div className="control-group">
                <div className="col-md-3">
                  <DatePicker addClass="input-field align-center form-control" placeholder="Start Date" showSelected={@state.endDate} onSelect={@setStartDate} calendar='false'/>                  
                </div>
              </div>
              <div className="control-group">   
                <div className="col-md-3">
                  <DatePicker addClass="input-field align-center form-control" placeholder="End Date" showSelected={@state.endDate} onSelect={@setEndDate} calendar='false'/>
                </div>
              </div>
              <div className="form-group">
                <div className="col-md-3">
                  <input type="text" name="search" placeholder= "Name or Mobile" className="form-control" onChange={@searchByName} />
                </div>
                <div className="col-md-3">
                  <a title="Save" href="#" className="btn btn-default btn-primary" onClick={@searchOrder}>Search</a>
                </div>
              </div>
              <hr/>            
            </form>
            <table className="table table-striped">
              <thead>
                <tr>
                  <th></th>
                  <th>Name</th>
                  <th>Address</th>
                  <th>Mobile</th>
                  <th>Status</th>
                  <th>Amount</th>
                  <th>Date</th>
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
                      <td>{order.outdate}</td>
                      <td>
                        {
                          if (order.status == "Initial" || order.status == "Partialy Dispatched")
                            <a href="#" onClick={@orderDispatched.bind(this, order.id)}>Dispatch</a>
                          else if (order.status == "Dispatched" || order.status == "Partialy Completed")
                            <a href="#" onClick={@completeOrder.bind(this, order.id)}>Complete</a>
                          

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