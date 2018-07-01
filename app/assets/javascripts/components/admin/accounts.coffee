@Accounts = React.createClass
  getInitialState: ->
    accounts: @props.accounts

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
          </div>
        </div>
      </div>
    </div>
