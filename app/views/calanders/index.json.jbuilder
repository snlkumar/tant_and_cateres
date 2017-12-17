json.array!(@orders) do |order|
  json.extract! order, :id, :name
  json.start order.outdate
  json.end order.outdate
  json.url order_url(order)
end