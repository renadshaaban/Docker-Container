require "bunny"

class Api::V1::BugsController < ApplicationController
	protect_from_forgery with: :null_session

	def create
		conn = Bunny.new(:host => "172.18.0.1",  :user => "admin", :password => "password")
		conn.start
		ch   = conn.create_channel
		q  = ch.queue("bug.post", :auto_delete => true)
		x  = ch.default_exchange
		result=Bug.post(q)
		input = { priority: params[:priority], status: params[:status],application_token: params[:application_token],
		comment: params[:comment], device: params[:device], os: params[:os], memory: params[:memory],
		storage: params[:storage]}.to_s
		x.publish(input, :routing_key => q.name) 
		sleep 1.0
		conn.close
		render :json => {message: "Bug has been saved correctly"}, status: 200
	end

	def show	
		unless Bug.exists?(:number => params[:number], :application_token => params[:application_token])
			render :json => {result:"NOK" , message: "No bug with this cardentials"}, status: 422
		else
			bug = Bug.find_by(params[:bug_id],params[:application_token])
			render json: bug, status: 200
		end
	end

	def search
		if params[:query].present?
			@bugs=Bug.search(params[:query]).records
		else
			@bugs = Bug.all
		end
		render json: @bugs, status: 200
	end
end
