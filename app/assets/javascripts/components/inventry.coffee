@Inventry = React.createClass
  getInitialState: ->
    items: @props.items,
    nextPage: @props.next_page,
    currentPage: @props.current_page,
    prevPage: @props.previous_page,
    name: '',
    quantity: 0,
    charge: 0,
    productId: 0,
    errors: []

  componentDidMount: ->
    console.log('mounted')


  editItem: (item) ->
    @setState
      name: item.name
      quantity: item.quantity
      charge: item.charge
      productId: item.id

  deleteItem: (id) -> 
    alert id

  searchByName: (e) ->
    OrderApi.request("/orders/search", 'GET', {q: e.target.value}, @saveSuccess)

  getName: (e) ->
    @setState
      name: e.target.value

  getQuantity: (e) ->
    @setState
      quantity: e.target.value

  getCharge: (e) ->
    @setState
      charge: e.target.value

  addItemToInventry: ->
    data = {item: {name: @state.name, quantity: @state.quantity, charge: @state.charge}}
    if @state.productId > 0      
      OrderApi.request('/items/'+@state.productId, 'PUT', data, @saveSuccess, @errorToSave)
    else
      OrderApi.request('/items', 'POST', data, @saveSuccess, @errorToSave)
    
  errorToSave: (e) ->
    @setState
      errors: e.responseJSON.error


  saveSuccess: (response)-> 
    toastr.success(response.message, {positionClass: "toast-top-center"})
    @setState
      items: response.items
      nextPage: response.next_page
      currentPage: response.current_page
      prevPage: response.previous_page
    @clearForm()

  getPaginationData: (page) ->    
    OrderApi.request("/items", 'GET', {page: page}, @paginationDataLoaded)

  paginationDataLoaded: (response) ->
    @setState
      items: response.items
      nextPage: response.next_page
      currentPage: response.current_page
      prevPage: response.previous_page


  clearForm: ->
    @setState
      name: '',
      quantity: 0,
      charge: 0,
      productId: 0,
      errors: []
    $('#myModal').modal('hide');

  render: ->
    <div className="col-md-12 panel-default edit-list">
      <div className="panel panel-primary">
        <div className="panel-heading">
          <div className="panel-title pull-left">
            Inventry
          </div>
          <div className="panel-title pull-right">
            <button className="btn btn-primary panel-button btn-sm" data-toggle="modal" data-target="#myModal"> <i aria-hidden="true" className="fa fa-plus-circle"></i> Add Item</button>
          </div>
          <div className="clearfix"></div>
        </div>        
        <div className="panel">
          <div className="panel-body">
            <form className="form-horizontal center">              
              <div className="form-group">
                <div className="col-md-3">
                  <input type="text" name="search" placeholder= "Search item by name" className="form-control" onChange={@searchByName} />
                </div>                
              </div>
              <hr/>            
            </form>
            <table className="table table-striped">
              <thead>
                <tr>
                  <th></th>
                  <th>Name</th>
                  <th>Quantity</th>
                  <th>Left</th>
                  <th>Charge (item/day)</th>
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
                      <td>{item.left}</td>
                      <td>{item.charge}</td>
                      <td className="action">
                        <a href="#" onClick={@editItem.bind(this, item)} data-backdrop="static" data-keyboard="false" data-toggle="modal" data-target="#myModal">
                          <i className="fa fa-pencil-square-o" style={{'fontSize': '25px'}}></i>
                        </a>

                          
                        <a href="javascript.void(0);" onClick={@deleteItem.bind(this, item.id)}>
                          <i className="fa fa-trash" style={{'fontSize': '25px';}}></i>
                        </a>
                      </td>
                    </tr>
                  ).bind(this))
                }
              </tbody>              
            </table>            
            {
              if (@state.prevPage || @state.nextPage)                                        
                <Confirmbox nextPage={@state.nextPage} prevPage={@state.prevPage} currentPage={@state.currentPage} parentCall={@getPaginationData}/>
            }
            
            
          </div>
        </div>
      </div>

      <div className="modal fade" id="myModal" tabIndex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
        <div className="vertical-alignment-helper">
          <div className="modal-dialog vertical-align-center">
              <div className="modal-content">
                <div className="modal-header">                  
                  <h4 className="modal-title" id="myModalLabel">Item Detail</h4>
                </div>
                  <div className="modal-body">
                    <div>
                      <ul className="error-list">
                        {
                          @state.errors.map(((error, i) ->
                            <li>{error}</li>
                          ).bind(this))
                        }
                      </ul>
                    </div>
                    <form >
                      <div>
                        <label for="email">Name:</label>
                        <input type="text" name="search" placeholder= "Name or Mobile" className="form-control" value={@state.name} onChange={@getName} />                        
                      </div>
                      <div>
                        <label for="pwd">Quantity:</label>
                        <input type="number" name="quantity" placeholder= "Quantity" value={@state.quantity} className="form-control" onChange={@getQuantity} />
                      </div>
                      <div>
                        <label>Charge/Day</label>
                        <input type="number" name="charge" placeholder= "Charge/Day" value={@state.charge} className="form-control" onChange={@getCharge} />
                      </div>
                    </form>
                  </div>
                  <div className="modal-footer">
                    <button type="button" className="btn btn-default"  onClick={@clearForm}>Close</button>
                    <button type="button" className="btn btn-primary" onClick={@addItemToInventry}>Save Item</button>
                  </div>                
              </div>
          </div>
        </div>
      </div>      
    </div>