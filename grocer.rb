require "pry"

def consolidate_cart(scart)
  consolidated = {}
  scart.each do |item|
    item.each do |name, price_details|
      if !consolidated.keys.include?(name)
        consolidated[name] = price_details
        consolidated[name][:count] = 1
      else
        consolidated[name][:count] += 1
      end
    end
  end
  consolidated
end

def apply_coupons (cart, coupons)
  discounts_applied ={}
  coupons.each do |coupon|
    cart.each do  |grocery, details|
      if coupon[:item] == grocery && coupon[:num] <= cart[grocery][:count]
        if !discounts_applied.keys.include?("#{grocery} W/COUPON")
          discounts_applied["#{grocery} W/COUPON"] = { price: coupon[:cost], count: 1 }
        else
          discounts_applied["#{grocery} W/COUPON"][:count] += 1
        end
        discounts_applied["#{grocery} W/COUPON"][:clearance] = cart[grocery][:clearance]
        if cart[grocery][:count] >= coupon[:num]
          cart[grocery][:count] = cart[grocery][:count] - coupon[:num]
        end
      end
    end
  end
  discounts_applied.each do |key, value|
    cart[key] = value
  end
  cart
end

def apply_clearance(cart)
  cart.each do |item, details|
    if cart[item][:clearance] == true
      cart[item][:price] = cart[item][:price] - (cart[item][:price] * 0.20 )
    end
  end
  cart
end

def checkout(cart,coupons)
  total = 0
  updated_cart = consolidate_cart(cart)
  updated_cart = apply_coupons(updated_cart, coupons)
  updated_cart = apply_clearance(updated_cart)
  updated_cart.each do |item, details|
    total = total + (updated_cart[item][:count] * updated_cart[item][:price])
  end
  if total > 100
    total = total * 0.9
  end
  total
end
