module InvoiceHelpers
  Item = Struct.new(:description, :unit, :quantity, :unit_price, :discount)

  def format_items(items)
    list, count, i = [], items['description'].length, 1

    while i <= count
      d, u, q = items['description'][i.to_s], items['unit'][i.to_s], items['quantity'][i.to_s]
      up, dis = items['unit_price'][i.to_s], items['discount'][i.to_s]
      list << Item.new(d, u, q, up, dis)
      i += 1
    end

    list
  end

  def calculate_total(list)
    total = 0
    list.each { |item| total += (item.quantity.to_d * item.unit_price.to_d) - item.discount.to_d }
    total
  end

  def calculate_payments(invoice)
    payments, sum = Payment.where(invoice: invoice), 0
    payments.each { |payment| sum += payment.amount }
    sum
  end

  def vat_price(invoice)
    invoice.total + invoice.total * 20/100
  end
end
