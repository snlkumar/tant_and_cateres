@Order = React.createClass
  getInitialState: ->
    orders: @props.orders
    name: ""
    mobile: ""
    address: ""
    date: moment(new Date()).format('YYYY-MM-DD')
    items: []
    errorMessages: []

  componentDidMount: () ->
    $('#demo1-1').datetimepicker
      oneLine: true
      dateFormat: 'dd M yy'
      timeFormat: 'hh:mm tt'
      minDate: new Date
      onSelect: @setDate

  getName: (e)->
    @setState
      name: e.target.value

  getMobile: (e)->
    @setState
      mobile: e.target.value

  getAddress: (e)->
    @setState
      address: e.target.value

  setDate: (datetimeText, datepickerInstance) ->    
    @setState
      date: moment(datetimeText).format("YYYY-MM-DD HH:mm:ss")

  saveOrder: ->
    data = {name: @state.name, phone: @state.mobile, address: @state.address, outdate: @state.date, status: 'Initial'}
    OrderApi.request('/orders', 'POST', {order: data}, @saveSuccess)

  saveSuccess: (result)->
    if result.valid
      window.location.href = "/orders/#{result.id}/items"
    else
      @setState
        errorMessages: result.message


  render: ->
    <div className="col-md-12 panel-default edit-list">
      <div>
        {
          if @state.errorMessages.length > 0
            <ul id="flash_error">
              {
                @state.errorMessages.map((msg, i) ->
                  <li key={i} >{msg}</li>
                )
              }
            </ul>
        }
      </div>
      <div className="panel panel-primary">
        <div className="panel-heading">New Order</div>
        <div className="panel-body">
          <form className="form-horizontal center">
            <div className="control-group">
              <div className="col-md-3">
                 <label>Name: </label> 
                <input type="text" name="name" placeholder= "Name" className="form-control" onChange={@getName} />
              </div>
            </div>
            <div className="control-group">   
              <div className="col-md-2">
                 <label>Mobile: </label> 
                <input type="text" name="phone" placeholder= "Mobile" className="form-control" onChange={@getMobile} />
              </div>
            </div>
            <div className="control-group">   
              <div className="col-md-3">
                 <label>Address: </label> 
                <input type="text" name="address" placeholder= "Address" className="form-control" onChange={@getAddress} />
              </div>
            </div>
            <div className="control-group has-feedback">   
              <div className="col-md-3">
                <label>Order Date: </label>
                <input ref="startdate" id="demo1-1" className="form-control" />
                <i className="fa fa-calendar form-control-feedback"></i>
              </div>
            </div>
            <div className="form-group ">              
              <div className="col-md-2">
                <a title="Save" href="#" className="btn btn-default btn-primary" onClick={@saveOrder}>Save</a>
              </div>
            </div>
            <hr/>            
          </form>
        </div>        
      </div>  
    </div>