Padfoot::App.controllers :stripe do
  before do # guarantees @event is a legitimate Stripe event
    event_json = JSON.parse(request.body.read, symbolize_names: true)
    begin
      @event = Stripe::Event.retrieve(event_json[:id]) # callback
    rescue StandardError => e # rescues 404 error from Stripe - or missing id
      logger.warn "Stripe says: #{e}"
      halt 200
    end
  end

  post :events, map: 'stripe_events', csrf_protection: false, provides: :json do
    logger.info "Stripe event: #{@event.type}"
    if @event.type == 'customer.subscription.created'
      logger.info @event.data.object.status # should be 'active'
      @user = DB[:users].first(stripe_cust_id: @event.data.object.customer)
      # @user.update(subscription: true)
      logger.info @user
    end
    return 200
  end
end
