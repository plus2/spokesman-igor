module Spokesman
  class Campfire
    autoload :Api, "spokesman/campfire/api"

    def initialize(igor)
      @igor = igor
    end

    def call(env)
      if env['igor.queue'] == 'spokesman.campfire'
        handle_message(env)
      else
        @igor.call(env)
      end

      nil
    end

    def handle_message(env)
      Api.setup( env.campfire.subdomain, env.campfire.token )

      room_name = env['igor.amqp.header'].routing_key[/campfire\.(.*)$/,1]

      payload = env['igor.payload']
      msg = payload['msg']

      if app = payload['app']
        msg = "[#{app}] #{msg}"
      end

      room(room_name).message(msg)
    end

    def rooms
      @rooms ||= Api.rooms
    end

    def room(name)
      name = name.downcase
      Api.room( rooms.find {|r| r.tapp['name'].downcase == name}['id'] )
    end
  end
end
