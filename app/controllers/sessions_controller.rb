class SessionsController < ApplicationController
	def new
	end

	def create
		user = User.find_by_email(params[:sessions][:email])
		if user && user.authenticate(params[:sessions][:password])
			sign_in user
			redirect_to user
		else
			flash.now[:error] = "Invalid email/passowrd combination"
			render 'new'
		end
	end

	def destroy
		sign_out
		redirect_to root_path
	end
end
