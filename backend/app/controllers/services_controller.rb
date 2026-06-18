class ServicesController < ApplicationController

  def branches
    # Format data agar sesuai dengan yang diharapkan oleh Frontend (Next.js)
    formatted_branches = Branch.all.map do |branch|
      {
        _id: branch.id.to_s,
        name: branch.name,
        code: branch.id.to_s,
        address: {
          addressLine1: branch.address,
          city: "Medan"
        },
        phone: branch.phone
      }
    end

    render json: {
      success: true,
      data: {
        branches: formatted_branches
      }
    }, status: :ok
  end

  def by_branch
    services = Service.where(branch_id: params[:branch_id]).map do |s|
      {
        _id: s.id.to_s,
        name: s.name,
        code: s.id.to_s,
        displayName: s.name,
        description: s.description || '',
        turnaroundTime: { standard: 48, express: 24 }
      }
    end
    render json: { success: true, data: { services: services } }, status: :ok
  end

  def items_by_branch
    branch_services = Service.where(branch_id: params[:branch_id])
    response_items = {}
    
    branch_services.each do |s|
      price = s.price_per_kg || 7000
      response_items[s.id.to_s] = [
        { id: "#{s.id}_kg", name: "Berat Cucian (per KG)", basePrice: price, category: "normal" },
        { id: "#{s.id}_bed", name: "Sprei / Selimut", basePrice: price * 2, category: "large" }
      ]
    end

    render json: { success: true, data: response_items }, status: :ok
  end

  def calculate
    subtotal = 0
    params[:items].each do |item|
      price = 7000
      price = 14000 if item[:itemType].to_s.end_with?('_bed')
      subtotal += price * (item[:quantity].to_i || 1)
    end
    subtotal = (subtotal * 1.5).to_i if params[:isExpress]
    tax = (subtotal * 0.1).to_i
    total = subtotal + tax
    
    render json: { success: true, data: { subtotal: subtotal, tax: tax, orderTotal: { total: total } } }
  end

  def time_slots
    render json: { success: true, data: { timeSlots: ['09:00-11:00', '11:00-13:00', '13:00-15:00', '15:00-17:00'] } }
  end

  def availability
    render json: { success: true, data: { available: true } }
  end
end

