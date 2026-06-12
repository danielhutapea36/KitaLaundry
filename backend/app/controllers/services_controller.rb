class ServicesController < ApplicationController
  # Memungkinkan akses publik tanpa token untuk melihat daftar cabang
  skip_before_action :authenticate_request, only: [:branches]

  def branches
    # Format data agar sesuai dengan yang diharapkan oleh Frontend (Next.js)
    formatted_branches = Branch.active.map do |branch|
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
end
