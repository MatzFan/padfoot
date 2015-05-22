Padfoot::App.controllers :stripe do

  post :events, map: '/events', csrf_protection: false, provides: [:json] do
    event_json = JSON.parse(request.body.read)
    event = Stripe::Event.retrieve(event_json["id"])
    logger.info event
    status 200
  end

end
