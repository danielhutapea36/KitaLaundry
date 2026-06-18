class AddressesController < ApplicationController
  before_action :set_address, only: [:update, :destroy, :set_default]

  def index
    @addresses = @current_user.addresses.order(is_default: :desc, created_at: :desc)
    render json: {
      success: true,
      data: {
        addresses: @addresses.map { |a| format_address(a) }
      }
    }
  end

  def create
    @address = @current_user.addresses.build(address_params)
    
    # If this is the first address, make it default
    if @current_user.addresses.count == 0
      @address.is_default = true
    end

    if @address.save
      render json: {
        success: true,
        data: {
          address: format_address(@address)
        }
      }, status: :created
    else
      render json: { success: false, errors: @address.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def update
    if @address.update(address_params)
      render json: {
        success: true,
        data: {
          address: format_address(@address)
        }
      }
    else
      render json: { success: false, errors: @address.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def destroy
    if @address.destroy
      render json: { success: true, message: 'Address deleted successfully' }
    else
      render json: { success: false, errors: @address.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def set_default
    Address.transaction do
      @current_user.addresses.update_all(is_default: false)
      @address.update!(is_default: true)
    end
    render json: {
      success: true,
      data: {
        address: format_address(@address)
      }
    }
  rescue StandardError => e
    render json: { success: false, message: e.message }, status: :unprocessable_entity
  end

  private

  def set_address
    @address = @current_user.addresses.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    render json: { success: false, message: 'Address not found' }, status: :not_found
  end

  def address_params
    params.permit(:address_type, :address_line_1, :address_line_2, :city, :state, :pincode, :landmark, :phone, :is_default)
  end

  def format_address(address)
    {
      _id: address.id.to_s,
      id: address.id.to_s,
      type: address.address_type || 'home',
      addressLine1: address.address_line_1,
      addressLine2: address.address_line_2,
      city: address.city,
      state: address.state,
      pincode: address.pincode,
      landmark: address.landmark,
      phone: address.phone,
      isDefault: address.is_default || false
    }
  end
end
