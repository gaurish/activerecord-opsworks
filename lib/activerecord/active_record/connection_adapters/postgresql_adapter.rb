module ActiveRecord # :nodoc:
  module ConnectionAdapters # :nodoc:
    class PostgresqlAdapter
      def supports_advisory_locks?
        true
      end

      def get_advisory_lock(lock_id) # :nodoc:
        unless lock_id.is_a?(Integer) && lock_id.bit_length <= 63
          raise(ArgumentError, "Postgres requires advisory lock ids to be a signed 64 bit integer")
        end
        select_value("SELECT pg_try_advisory_lock(#{lock_id});")
      end

      def release_advisory_lock(lock_id) # :nodoc:
        unless lock_id.is_a?(Integer) && lock_id.bit_length <= 63
          raise(ArgumentError, "Postgres requires advisory lock ids to be a signed 64 bit integer")
        end
        select_value("SELECT pg_advisory_unlock(#{lock_id})")
      end
    end
  end
end
