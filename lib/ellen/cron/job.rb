require "active_support/core_ext/hash/keys"
require "chrono"
require "json"

module Ellen
  module Cron
    class Job
      attr_reader :attributes, :thread

      def initialize(attributes)
        @attributes = attributes.stringify_keys
      end

      def to_json
        to_hash.to_json
      end

      def start(robot)
        @thread = Thread.new do
          Chrono::Trigger.new(schedule) do
            robot.say(body)
          end.run
        end
      end

      def stop
        thread.kill
      end

      def description
        %<%5s: "%s" %s> % [id, schedule, body]
      end

      def id
        attributes["id"]
      end

      def schedule
        attributes["schedule"]
      end

      def body
        attributes["body"]
      end

      private

      def to_hash
        attributes.to_json
      end
    end
  end
end
