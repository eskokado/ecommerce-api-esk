json.coupons do
  json.array! @coupons do |coupon|
    json.id coupon.id
    json.name coupon.name
    json.code coupon.code
    json.status coupon.status
    json.discount_value coupon.discount_value
    json.max_use coupon.max_use
    json.due_date coupon.due_date
  end
end
