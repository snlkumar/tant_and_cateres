@Order = React.createClass
  getInitialState: ->
    orders: @props.orders
    name: ""
    mobile: ""
    address: ""
    date: ""
    items: []
    errorMessages: []

  componentDidMount: () ->
    $('#demo1-1').datetimepicker
      controlType: 'select'
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
            <ul className="error-list">
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
          <form>
            <div className="form-group required col-md-6">
              <label className="control-label">Name: </label> 
              <input type="text" name="name" placeholder= "Name" className="form-control" onChange={@getName} />
            </div>
            <div className="form-group required col-md-6">                 
              <label className="control-label">Mobile: </label> 
              <input type="text" name="phone" placeholder= "Mobile" className="form-control" onChange={@getMobile} />
            </div>
            <div className="form-group required col-md-6">              
              <label className="control-label">Address: </label> 
              <input type="text" name="address" placeholder= "Address" className="form-control" onChange={@getAddress} />
            </div>
            <div className="form-group has-feedback col-md-6 required">              
              <label className="control-label">Order Date: </label>
              <input ref="startdate" id="demo1-1" className="form-control" />
              <i className="fa fa-calendar form-control-feedback"></i>              
            </div>
            <div className="form-group col-md-6">
              <a title="Save" href="#" className="btn btn-default btn-primary" onClick={@saveOrder}>Save</a>
            </div>
            <hr/>            
          </form>
        </div>        
      </div>  
    </div>