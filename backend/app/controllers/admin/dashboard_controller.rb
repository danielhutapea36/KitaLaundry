module Admin
  class DashboardController < ApplicationController
    def stats
      if current_user.role == 'center_admin'
        orders = Order.all
        customers_count = User.where(role: :customer).count
      elsif current_user.role == 'branch_manager'
        orders = Order.where(branch_id: get_branch_id)
        # For simple demonstration, customer count is global or from orders
        customers_count = orders.select(:user_id).distinct.count
      else
        return render json: { errors: 'Unauthorized' }, status: :unauthorized
      end

      active_orders = orders.where(status: [:pending, :processing, :ready_for_delivery]).count
      completed_orders = orders.where(status: :completed).count
      total_revenue = orders.where(payment_status: :paid).sum(:total_price)
      
      # Mocking revenue trend for chart (just for display purposes)
      revenue_trend = [
        { name: 'Mon', revenue: (total_revenue * 0.1).to_i },
        { name: 'Tue', revenue: (total_revenue * 0.15).to_i },
        { name: 'Wed', revenue: (total_revenue * 0.2).to_i },
        { name: 'Thu', revenue: (total_revenue * 0.1).to_i },
        { name: 'Fri', revenue: (total_revenue * 0.25).to_i },
        { name: 'Sat', revenue: (total_revenue * 0.15).to_i },
        { name: 'Sun', revenue: (total_revenue * 0.05).to_i }
      ]

      render json: {
        success: true,
        data: {
          stats: {
            totalRevenue: total_revenue,
            activeOrders: active_orders,
            totalCustomers: customers_count,
            completedOrders: completed_orders
          },
          revenueTrend: revenue_trend
        }
      }
    end

    private

    def current_user
      @current_user ||= User.find_by(email: params[:email]) || User.where.not(role: :customer).first
    end

    def get_branch_id
      # Simple heuristic: map last name to branch if manager, or pass branch_id in params.
      # Usually this would be current_user.branch_id
      Branch.first.id
    end
  end
end
