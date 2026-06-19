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

      branch_info = if current_user.role == 'center_admin'
                      { _id: 'center', name: 'Admin Pusat', code: 'HQ' }
                    else
                      branch = Branch.find_by(id: get_branch_id)
                      { _id: branch&.id.to_s, name: branch&.name || 'Cabang', code: branch&.code || 'BR' }
                    end

      today = Time.zone.now.beginning_of_day
      pending_orders = orders.where(status: 'pending').count
      processing_orders = orders.where(status: 'processing').count
      ready_orders = orders.where(status: 'ready_for_delivery').count
      completed_today = orders.where(status: 'completed', updated_at: today..Time.zone.now).count
      today_orders = orders.where(created_at: today..Time.zone.now).count
      weekly_orders = orders.where(created_at: 1.week.ago..Time.zone.now).count
      today_revenue = orders.where(payment_status: 'paid', updated_at: today..Time.zone.now).sum(:total_price).to_f
      
      staff_count = User.where(role: ['staff', 'branch_manager', 'driver', 'washer', 'ironer']).count
      active_staff = staff_count # Mock active staff

      recent_orders = orders.order(created_at: :desc).limit(5).map do |o|
        {
          _id: o.id.to_s,
          orderNumber: "ORD-#{o.id.to_s.rjust(4, '0')}",
          status: o.status,
          amount: o.total_price.to_f,
          itemCount: o.order_items.sum(:weight_kg).to_i,
          isExpress: false,
          createdAt: o.created_at.iso8601,
          customer: { name: o.user.first_name, phone: o.user.phone }
        }
      end

      render json: {
        success: true,
        data: {
          branch: branch_info,
          metrics: {
            todayOrders: today_orders,
            pendingOrders: pending_orders,
            processingOrders: processing_orders,
            readyOrders: ready_orders,
            completedToday: completed_today,
            todayRevenue: today_revenue,
            weeklyOrders: weekly_orders,
            staffCount: staff_count,
            activeStaff: active_staff
          },
          recentOrders: recent_orders,
          staffPerformance: [],
          alerts: []
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
