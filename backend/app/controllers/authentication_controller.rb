class AuthenticationController < ApplicationController
  def login
    @user = User.find_by(email: params[:email])
    
    if @user&.authenticate(params[:password])
      token = JsonWebToken.encode(user_id: @user.id, role: @user.role)
      time = Time.now + 24.hours.to_i
      render json: {
        success: true,
        data: {
          token: token,
          exp: time.strftime("%m-%d-%Y %H:%M"),
          user: {
            _id: @user.id.to_s,
            id: @user.id.to_s,
            name: "#{@user.first_name} #{@user.last_name}".strip,
            email: @user.email,
            phone: @user.phone || '',
            role: @user.role,
            isActive: true
          }
        }
      }, status: :ok
    end
  end

  def profile
    header = request.headers['Authorization']
    header = header.split(' ').last if header
    begin
      decoded = JsonWebToken.decode(header)
      @user = User.find(decoded[:user_id])
      render json: {
        success: true,
        data: {
          user: {
            _id: @user.id.to_s,
            id: @user.id.to_s,
            name: "#{@user.first_name} #{@user.last_name}".strip,
            email: @user.email,
            phone: @user.phone || '',
            role: @user.role,
            isActive: true
          }
        }
      }, status: :ok
    rescue ActiveRecord::RecordNotFound, JWT::DecodeError
      render json: { errors: 'Unauthorized' }, status: :unauthorized
    end
  end
  def verify_email
    @user = User.find_by(verification_token: params[:token])

    if @user
      if @user.email_verified_at.present?
        render json: { success: false, message: 'Email already verified' }, status: :unprocessable_entity
      else
        @user.update(email_verified_at: Time.current, verification_token: nil)
        
        # Also return a token so the frontend can log them in immediately
        token = JsonWebToken.encode(user_id: @user.id, role: @user.role)
        time = Time.now + 24.hours.to_i
        
        render json: {
          success: true,
          data: {
            token: token,
            exp: time.strftime("%m-%d-%Y %H:%M"),
            user: {
              _id: @user.id.to_s,
              id: @user.id.to_s,
              name: "#{@user.first_name} #{@user.last_name}".strip,
              email: @user.email,
              phone: @user.phone || '',
              role: @user.role,
              isActive: true
            }
          }
        }, status: :ok
      end
    else
      render json: { success: false, message: 'Invalid verification token' }, status: :not_found
    end
  end

  def resend_verification
    @user = User.find_by(email: params[:email])
    
    if @user
      if @user.email_verified_at.present?
        render json: { success: false, message: 'Email already verified' }, status: :unprocessable_entity
      else
        @user.generate_verification_token
        @user.save
        UserMailer.with(user: @user).verification_email.deliver_later
        render json: { success: true, message: 'Verification email resent' }, status: :ok
      end
    else
      render json: { success: false, message: 'User not found' }, status: :not_found
    end
  end
end
