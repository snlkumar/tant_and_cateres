class ItemsController < ApplicationController
	before_action :authenticate_user!
	before_action :item, except: [:index, :create, :search_items]
	def index		
		@items = Item.paginate(page: params[:page] || 1, per_page: 10).order('updated_at DESC')
		if request.xhr?
			render json: {items: @items, next_page: @items.next_page, current_page: @items.current_page, previous_page: @items.previous_page}
		end
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
			items = get_items
		  render json: {message: 'Product Added successfuly.', items: items, next_page: items.next_page, current_page: items.current_page, previous_page: items.previous_page}
		else
			render json: {error: @item.errors.full_messages}
		end
	end

	def update
		respond_to do |format|
			if @item.update_attributes(params[:item].permit!)				
				items = get_items
				format.json { render json: {message: 'Product Updated successfuly.', items: items, next_page: items.next_page, current_page: items.current_page, previous_page: items.previous_page} }
			else		  
			  format.json { render json: {error: @item.errors.full_messages }	, status: :unprocessable_entity}
			end
		end
	end

	def destroy
		respond_to do |format|
			if @item.destroy
				items = get_items
				format.json { render json: {message: 'Product Deleted successfuly.', items: items, next_page: items.next_page, current_page: items.current_page, previous_page: items.previous_page} }
			else
				format.json { render json: {error: @item.errors.full_messages }	, status: :unprocessable_entity}
			end
		end
	end

	private
	def item
		@item ||= params[:id] ? Item.find(params[:id]) : Item.new 
	end

	def get_items
		Item.paginate(page: params[:page] || 1, per_page: 10).order('updated_at DESC')
	end

end
