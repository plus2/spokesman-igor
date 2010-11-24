require 'eg.helper'
require 'bunny'
require 'yajl'

eg 'send a message' do
  Bunny.run do |b|
    ex = b.exchange("plus2.messages", :type => :topic)

    msg = {:msg => "hello world"}

    ex.publish(Yajl::Encoder.encode(msg), :key => "campfire.General")
  end
end
