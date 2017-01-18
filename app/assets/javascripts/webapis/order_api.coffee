@OrderApi = @OrderApi || {}
@OrderApi.request = (url, method, inputData, onSuccess) ->	
	return $.ajax
    type: method
    dataType: 'json'
    url: url
    data: inputData
    success: onSuccess