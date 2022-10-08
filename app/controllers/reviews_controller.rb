class ReviewsController < ApplicationController
  rescue_from ActiveRecord::RecordNotFound, with: :render_not_found_response

  def index
    # allow us to get the index of all reviews for a certain dog house
    if params [:dog_house_id]
      dog_house = DogHouse.find(params[:dog_house_id])
      reviews = dog_house.reviews  
    else
      # allow access to the index of all reviews
      reviews = Review.all
    end 
    render json: reviews, include: :dog_house
  end

  def show
    review = Review.find(params[:id])
    render json: review, include: :dog_house
  end

  def create
    review = Review.create(review_params)
    render json: review, status: :created
  end

  private

  def render_not_found_response
    render json: { error: "Review not found" }, status: :not_found
  end

  def review_params
    params.permit(:username, :comment, :rating)
  end

end
