def consolidate_cart(cart)
  cart.each_with_object({}) do |item, result|
    #each_with_object passes objects to build up a collection (array/hash)
    #identifies two parameters.  Item = object parameter.  result = accumulator parameter.
    #so the result is the "hash" that's being built up based on each item.
    #so now you've got {Avocado=>{}, Avocado=>{}, Kale=>{}}
    item.each do |type, attributes|
      #iterator will look at each initial item/attributes
      #:price = type | 3.0 = attribute
      if result[type]
        #looks at result has created with each_with_object and looks at first value
        #=={Avocado, Avocado, Kale}
        attributes[:count] += 1
        #for each match of result[type] add +1 to the attributes[:count] hash
        #==Avocado / attributes[:count]=1
        #==Avocado / attributes[:count]=2
        #==Kale / attributes[:count]=1
      else
        attributes[:count] = 1
        #if there is no valid result[type], then just add :count 1
        result[type] = attributes
        #return all other hash keys
      end
    end
  end
end

def apply_coupons(cart, coupons)
  coupons.each do |coupon|
    #iterate across the coupons for each item in the hash
    #:item=>"AVOCADO", :num=> 2, :cost=>5.0
    name = coupon[:item]
    #sets name variable equal to the :item value
    #name = "AVOCADO"
    if cart[name] && cart[name][:count] >= coupon[:num]
      #if name value and :count value is greater than :num value from coupon hash
      if cart["#{name} W/COUPON"]
        #nested if.
        cart["#{name} W/COUPON"][:count] += 1
      else
        cart["#{name} W/COUPON"] = {:count => 1, :price => coupon[:cost]}
        cart["#{name} W/COUPON"][:clearance] = cart[name][:clearance]
      end
      cart[name][:count] -= coupon[:num]
    end
  end
  cart
  #why does this work?  Doesn't the .each avoid changing the original array?
end

def apply_clearance(cart)
  cart.each do |name, properties|
    if properties[:clearance]
      #if there's a :clearance value
      updated_price = properties[:price] * 0.80
      #create new price variable and set it to :price=>value * 0.80
      properties[:price] = updated_price.round(2)
      #replace the :price value to the updated price with rounding
    end
  end
  cart
end

def checkout(cart, coupons)
  consolidated_cart = consolidate_cart(cart)
  couponed_cart = apply_coupons(consolidated_cart, coupons)
  final_cart = apply_clearance(couponed_cart)
  total = 0
  final_cart.each do |name, properties|
    total += properties[:price] * properties[:count]
  end
  total = total * 0.9 if total > 100
  total
end
