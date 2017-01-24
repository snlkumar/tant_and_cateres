@Order = React.createClass
  getInitialState: ->
    orders: @props.orders
    name: ""
    mobile: ""
    address: ""
    items: []

  getName: (e)->
    @setState
      name: e.target.value

  getMobile: (e)->
    @setState
      mobile: e.target.value

  getAddress: (e)->
    @setState
      address: e.target.value

  saveOrder: ->
    data = {name: 'xx', phone: 1234567890}
    OrderApi.request('/orders', 'POST', {order: data}, @saveSuccess)

  saveSuccess: (result)->
    window.location.href = "/orders/#{result.id}/items"


  render: ->
    <div className="col-md-12 panel-default edit-list">
      <div className="panel panel-primary">
        <div className="panel-heading">New Order</div>
        <div className="panel-body">
          <form className="form-horizontal center">
            <div className="control-group">
              <div className="col-md-3">
                <input type="text" name="name" placeholder= "Name" className="form-control" onChange={@getName} />
              </div>
            </div>
            <div className="control-group">   
              <div className="col-md-3">
                <input type="text" name="phone" placeholder= "Mobile" className="form-control" onChange={@getMobile} />
              </div>
            </div>
            <div className="form-group">
              <div className="col-md-3">
                <input type="text" name="address" placeholder= "Address" className="form-control" onChange={@getAddress} />
              </div>
              <div className="col-md-3">
                <a title="Save" href="#" className="btn btn-default btn-primary" onClick={@saveOrder}>Save</a>
              </div>
            </div>
            <hr/>            
          </form>
        </div>        
      </div>  
    </div>