@Pagination = React.createClass
  getInitialState: ->    
    nextPage: @props.nextPage,
    currentPage: @props.currentPage,
    prevPage: @props.prevPage,

  componentWillReceiveProps: (nextProps) ->  
    @setState    
      nextPage: nextProps.nextPage,
      currentPage: nextProps.currentPage,
      prevPage: nextProps.prevPage,

  callParentWithPage: (page, e) ->
    e.preventDefault()
    @props.parentCall(page)

  render: ->
    <div className="text-center">
      <ul className="pagination">
        {
          if (@state.prevPage)
            <li><a href="#" onClick={@callParentWithPage.bind(this, @state.prevPage)}>{@state.prevPage}</a></li>
        }                    
        <li className="active"><a href="#">{@state.currentPage}</a></li>
        {
          if (@state.nextPage)
            <li><a href="#" onClick={@callParentWithPage.bind(this, @state.nextPage)}>{@state.nextPage}</a></li>
        }
        
      </ul>
    </div>