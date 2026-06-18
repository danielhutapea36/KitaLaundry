module Admin
  class UsersController < ApplicationController
    before_action :set_user, only: [:show, :update, :destroy]

    def index
      # Support filtering by role
      if params[:role].present?
        @users = User.where(role: params[:role]).order(created_at: :desc)
      else
        @users = User.order(created_at: :desc)
      end
      
      render json: {
        success: true,
        data: {
          users: @users.map { |u| format_user(u) }
        }
      }
    end

    def show
      render json: {
        success: true,
        data: {
          user: format_user(@user)
        }
      }
    end

    def create
      @user = User.new(user_params)
      
      # For admin-created users, we can auto-verify them or let them verify
      @user.email_verified_at = Time.current

      if @user.save
        render json: {
          success: true,
          message: 'User created successfully',
          data: {
            user: format_user(@user)
          }
        }, status: :created
      else
        render json: { success: false, errors: @user.errors.full_messages }, status: :unprocessable_entity
      end
    end

    def update
      # Prevent updating password through this endpoint if empty
      update_params = user_params
      update_params.delete(:password) if update_params[:password].blank?
      update_params.delete(:password_confirmation) if update_params[:password_confirmation].blank?

      if @user.update(update_params)
        render json: {
          success: true,
          message: 'User updated successfully',
          data: {
            user: format_user(@user)
          }
        }
      else
        render json: { success: false, errors: @user.errors.full_messages }, status: :unprocessable_entity
      end
    end

    def destroy
      if @user.destroy
        render json: { success: true, message: 'User deleted successfully' }
      else
        render json: { success: false, errors: @user.errors.full_messages }, status: :unprocessable_entity
      end
    end

    private

    def set_user
      @user = User.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      render json: { success: false, message: 'User not found' }, status: :not_found
    end

    def user_params
      # Frontend sends 'name', handle it
      if params[:name].present?
        names = params[:name].split(' ', 2)
        params[:first_name] = names[0]
        params[:last_name] = names[1] || ''
      end
      
      params.permit(:email, :password, :password_confirmation, :first_name, :last_name, :phone, :role)
    end

    def format_user(user)
      {
        _id: user.id.to_s,
        id: user.id.to_s,
        name: "#{user.first_name} #{user.last_name}".strip,
        email: user.email,
        phone: user.phone || '',
        role: user.role,
        isActive: true,
        createdAt: user.created_at
      }
    end
  end
end
