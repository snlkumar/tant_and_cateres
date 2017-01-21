class ItemsController < ApplicationController
	before_action :authenticate_user!
	before_action :item, except: [:index, :create, :search_items]
	def index
		@items = Item.all
	end

	def search_items
		items = Item.search_by(params[:input])
		render json: {items: items}
	end

	def new		
	end

	def edit
	end

	def create
		params[:item][:left] = params[:item][:quantity]
		@item = Item.new params[:item].permit!
		if @item.save
			flash[:notice] = "Updated successfuly."
		    redirect_to items_path
		else
			render 'new'
		end
	end

	def update
		if @item.update_attributes(params[:item].permit!)
			flash[:notice] = "Updated successfuly."
			redirect_to items_path
		else
			render 'edit'
		end
	end

	def destroy
		if @item.destroy
			flash[:notice] = "deleted successfuly"
		else
			flash[:notice] = "error"			
		end
			redirect_to items_path
	end

	private
	def item
		@item ||= params[:id] ? Item.find(params[:id]) : Item.new 
	end

end
