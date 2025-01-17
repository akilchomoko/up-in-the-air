class PotentialDestinationsController < ApplicationController
  def index
    skip_authorization
    @trip = Trip.find(params[:trip_id])
    @trip_participant = TripParticipant.find(params[:trip_participant_id])

    budget = params["budget"] || 999_999
    time = params["time"] || 999_999

    puts params
    puts budget
    puts time

    @trip_estimates = TripEstimate.where("high_cost < '#{budget}'").limit(20)
    p @trip_estimates

    # @trip_estimates = TripEstimate.where("high_cost < #{budget} AND flight_mins < #{time} AND valid_from <= '#{odate}' AND valid_until >= '#{odate}'").limit(20)

    # if params[:budget].present?
    #   @trip_estimates = TripEstimate.where("high_cost < #{params["budget"]}").limit(20)
    # else
    #   @trip_estimates = TripEstimate.limit(20)
    # end

    @cards = cards_with_love

    p @cards

    @potential_destination = policy_scope(PotentialDestination)
  end

  def create
    skip_authorization
    pd = PotentialDestination.new
    pd.city = TripEstimate.find(params[:est]).destination_city
    pd.trip_participant = TripParticipant.find(params[:trip_participant_id])
    pd.status = 'selected'
    pd.save
    redirect_to trip_trip_participant_potential_destinations_path(params[:trip_id], params[:trip_participant_id])
  end

  def destroy
    skip_authorization
    PotentialDestination.find(params[:id]).destroy
    redirect_to trip_trip_participant_potential_destinations_path(params[:trip_id], params[:trip_participant_id])
  end

  def update
    skip_authorization
    trip_participant = TripParticipant.find(params[:trip_participant_id])
    pds = PotentialDestination.where(trip_participant: trip_participant, status: 'selected')
    pds.each do |pd|
      pd.status = 'submitted'
      pd.save
    end
    redirect_to trip_trip_participant_potential_destinations_path(params[:trip_id], params[:trip_participant_id])
  end

  private

  def cards_with_love
    cards = []
    @trip_estimates.each do |te|
      card = {}
      card[:te] = te
      card[:pd] = PotentialDestination.find_by(city: te.destination_city, trip_participant: @trip_participant)
      cards << card
    end
    cards
  end
end
