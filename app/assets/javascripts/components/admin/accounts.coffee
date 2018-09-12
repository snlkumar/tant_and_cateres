@Accounts = React.createClass
  getInitialState: ->
    accounts: @props.accounts
    availableTags: [
      "ActionScript",
      "AppleScript",
      "Asp",
      "BASIC",
      "C",
      "C++",
      "Clojure",
      "COBOL",
      "ColdFusion",
      "Erlang",
      "Fortran",
      "Groovy",
      "Haskell",
      "Java",
      "JavaScript",
      "Lisp",
      "Perl",
      "PHP",
      "Python",
      "Ruby",
      "Scala",
      "Scheme"
    ]

  componentDidMount: ->
    $('#tags').autocomplete(
      source: 'dashboards/demo'
      select: (event, ui) ->
        console.log ui.item.name+''+ui.item.id
        false
    ).autocomplete('instance')._renderItem = (ul, item) ->
      $('<li>').append('<div>' + item.name +  '</div>').appendTo ul

  render: ->
    <div className="col-md-12 panel-default edit-list">
      <div className="panel panel-primary">
        <div className="panel-heading">Accounts</div>        
        <div className="panel">
          <div className="panel-body">
            <table className="table table-striped">
              <thead>
                <tr>
                  <th></th>
                  <th>Email</th>
                  <th>Subdomain</th>
                </tr>
              </thead>
              <tbody>
                {                   
                  @state.accounts.map(((account, i) ->
                    <tr key={i}>
                      <td>{i+1}</td>
                      <td>{account.email}</td>
                      <td>{account.domain}</td>
                    </tr>
                  ).bind(this))
                }
              </tbody>
            </table>
            <div className="ui-widget">
              <label for="tags">Tags: </label>
              <input id="tags" />
            </div>
          </div>
        </div>
      </div>
    </div>
