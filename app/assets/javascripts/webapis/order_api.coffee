@OrderApi = @OrderApi || {}
@OrderApi.request = (url, method, inputData, onSuccess, onError) ->	
	return $.ajax
    type: method
    dataType: 'json'
    url: url
    data: inputData
    success: onSuccess
    error: onError

@OrderApi.getItemJson = (url) ->
    return $.ajax
    type: 'GET'
    dataType: 'json'
    url: url