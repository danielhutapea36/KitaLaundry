class OrdersController < ApplicationController
  def create
    ActiveRecord::Base.transaction do
      pickup_address = current_user.addresses.find_by(id: params[:pickupAddressId]) || current_user.addresses.first || current_user.addresses.create!(full_address: 'Dummy Address, Medan')
      delivery_address = current_user.addresses.find_by(id: params[:deliveryAddressId]) || pickup_address

      @order = Order.new(
        user: current_user,
        branch_id: params[:branchId] || Branch.first.id,
        pickup_address_id: pickup_address.id,
        delivery_address_id: delivery_address.id,
        notes: params[:specialInstructions],
        payment_method: params[:paymentMethod] || 'cod'
      )
      
      subtotal = 0
      if params[:items].present?
        params[:items].each do |item|
          price = 7000
          price = 14000 if item[:itemType].to_s.end_with?('_bed')
          subtotal += price * (item[:quantity].to_i || 1)
        end
      end
      
      subtotal = (subtotal * 1.5).to_i if params[:isExpress]
      tax = (subtotal * 0.1).to_i
      @order.total_price = subtotal + tax
      @order.payment_status = (@order.payment_method == 'online' ? :unpaid : :pending)

      service = Service.find_by(branch_id: @order.branch_id) || Service.first
      @order.order_items.build(service: service, weight_kg: 1)

      if @order.save!
        if @order.payment_method == 'online'
          invoice_url = create_xendit_invoice(@order)
          @order.update!(invoice_url: invoice_url, status: :pending)
        end
        
        render json: { success: true, data: { order: @order, invoice_url: @order.invoice_url } }, status: :created
      else
        render json: { success: false, errors: @order.errors.full_messages }, status: :unprocessable_entity
      end
    end
  rescue => e
    render json: { success: false, error: e.message }, status: :internal_server_error
  end

  def index
    orders = current_user.orders.order(created_at: :desc)
    
    formatted_orders = orders.map do |order|
      {
        _id: order.id.to_s,
        id: order.id.to_s,
        orderNumber: "ORD-#{order.id}-#{order.created_at.to_i}",
        status: order.status,
        createdAt: order.created_at.iso8601,
        paymentMethod: order.payment_method == 'online' ? 'online' : 'cod',
        paymentStatus: order.payment_status || 'pending',
        pricing: {
          subtotal: order.total_price,
          total: order.total_price
        },
        pickupDate: order.created_at.iso8601,
        items: order.order_items.map { |item| { itemType: item.service.name, quantity: item.weight_kg } }
      }
    end

    render json: { success: true, data: { orders: formatted_orders } }
  end

  def show
    order = Order.find(params[:id])
    
    formatted_order = {
      _id: order.id.to_s,
      id: order.id.to_s,
      orderNumber: "ORD-#{order.id}-#{order.created_at.to_i}",
      status: order.status,
      createdAt: order.created_at.iso8601,
      paymentMethod: order.payment_method == 'online' ? 'online' : 'cod',
      paymentStatus: order.payment_status || 'pending',
      pricing: {
        subtotal: order.total_price,
        expressCharge: 0,
        deliveryCharge: 0,
        discount: 0,
        tax: 0,
        total: order.total_price
      },
      pickupDate: order.created_at.iso8601,
      pickupTimeSlot: "09:00-11:00",
      isExpress: false,
      items: order.order_items.map { |item| { itemType: "Service", quantity: item.weight_kg } },
      statusHistory: [
        { status: 'placed', date: order.created_at.iso8601 }
      ]
    }
    
    render json: { success: true, data: { order: formatted_order } }
  rescue ActiveRecord::RecordNotFound
    render json: { success: false, message: 'Order not found' }, status: :not_found
  end

  def tracking
    order = Order.find(params[:id])
    
    tracking_data = [
      { status: 'placed', date: order.created_at.iso8601 }
    ]
    
    # Enum for status: pending(0), processing(1), ready_for_delivery(2), completed(3), cancelled(4)
    # This is a simple approximation
    if order.status_before_type_cast >= 1 && order.status != 'cancelled'
      tracking_data << { status: 'in_process', date: (order.created_at + 1.hour).iso8601 }
    end
    
    if order.status_before_type_cast >= 2 && order.status != 'cancelled'
      tracking_data << { status: 'ready', date: order.updated_at.iso8601 }
    end

    render json: { success: true, data: { tracking: tracking_data } }
  end

  def cancel
    order = Order.find(params[:id])
    if order.status == 'pending'
      order.update(status: :cancelled)
      render json: { success: true, message: 'Order cancelled' }
    else
      render json: { success: false, message: 'Order cannot be cancelled' }, status: :unprocessable_entity
    end
  end

  def rate
    render json: { success: true, message: 'Rating submitted' }
  end

  def reorder
    render json: { success: true, message: 'Reordered' }
  end

  private

  def current_user
    @current_user ||= User.first || User.create!(email: 'demo@example.com', first_name: 'Demo', phone: '123456789', role: :customer, password_digest: 'dummy')
  end

  def create_xendit_invoice(order)
    require 'net/http'
    require 'uri'
    require 'json'

    uri = URI.parse("https://api.xendit.co/v2/invoices")
    request = Net::HTTP::Post.new(uri)
    request.basic_auth(ENV['XENDIT_API_KEY'], "")
    request.content_type = "application/json"
    
    # Need to pass an external_id, amount, payer_email, description
    request.body = JSON.dump({
      "external_id" => "ORD-#{order.id}-#{Time.now.to_i}",
      "amount" => order.total_price.to_i,
      "payer_email" => order.user.email,
      "description" => "Payment for Laundry Order ##{order.id}",
      "success_redirect_url" => "http://localhost:3002/customer/orders/#{order.id}?success=true"
    })

    req_options = {
      use_ssl: uri.scheme == "https",
    }

    response = Net::HTTP.start(uri.hostname, uri.port, req_options) do |http|
      http.request(request)
    end
    
    result = JSON.parse(response.body)
    
    if response.code.to_i >= 200 && response.code.to_i < 300
      order.update(xendit_invoice_id: result['id'])
      return result['invoice_url']
    else
      raise "Xendit API Error: #{result['message']}"
    end
  end
end
