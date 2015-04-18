json.responders do
  json.array!(@responders) do |responder|
    json.partial! 'responder', responder: responder
  end
end