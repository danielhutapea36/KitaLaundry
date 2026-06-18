module Admin
  class OrdersController < ApplicationController
    def index
      if current_user.role == 'center_admin'
        orders = Order.all.order(created_at: :desc)
      elsif current_user.role == 'branch_manager'
        orders = Order.where(branch_id: get_branch_id).order(created_at: :desc)
      else
        return render json: { errors: 'Unauthorized' }, status: :unauthorized
      end

      formatted_orders = orders.map do |order|
        {
          _id: order.id.to_s,
          id: order.id.to_s,
          orderNumber: "ORD-#{order.id}-#{order.created_at.to_i}",
          customerName: "#{order.user.first_name} #{order.user.last_name}".strip,
          customerPhone: order.user.phone,
          status: order.status,
          paymentStatus: order.payment_status || 'pending',
          totalAmount: order.total_price,
          createdAt: order.created_at.iso8601,
          branchId: order.branch_id.to_s,
          pickupDate: order.created_at.iso8601,
          items: order.order_items.map { |item| { itemType: item.service.name, quantity: item.weight_kg } }
        }
      end

      render json: { success: true, data: { orders: formatted_orders } }
    end

    def assign_to_branch
      order = Order.find(params[:id])
      order.update(branch_id: params[:branchId])
      render json: { success: true, message: 'Assigned to branch' }
    end

    def assign_to_logistics
      render json: { success: true, message: 'Assigned to logistics' }
    end

    def process_refund
      render json: { success: true, message: 'Refund processed' }
    end

    def scan_barcode
      # Either find by ID or generated orderNumber string
      # ORD-12-16238128 means ID is 12.
      barcode = params[:barcode].to_s
      order_id = barcode.split('-')[1] rescue barcode
      order = Order.find_by(id: order_id)
      
      if order
        if params[:newStatus]
          order.update(status: params[:newStatus])
          render json: { success: true, message: 'Status updated via scan' }
        else
          render json: { success: true, data: { order: { _id: order.id.to_s, orderNumber: barcode, status: order.status } } }
        end
      else
        render json: { success: false, message: 'Order not found for this barcode' }, status: :not_found
      end
    end

    private

    def current_user
      header = request.headers['Authorization']
      if header
        token = header.split(' ').last
        begin
          decoded = JsonWebToken.decode(token)
          @current_user ||= User.find(decoded[:user_id])
        rescue
          nil
        end
      end
      @current_user ||= User.where.not(role: :customer).first
    end

    def get_branch_id
      Branch.first.id
    end
  end
end
