module ActiveRecord # :nodoc:
  module ConnectionAdapters # :nodoc:
    class AbstractAdapter # :nodoc:
      # Does this adapter support application-enforced advisory locking?
      def supports_advisory_locks?
        false
      end

      # This is meant to be implemented by the adapters that support advisory
      # locks
      #
      # Return true if we got the lock, otherwise false
      def get_advisory_lock(lock_id) # :nodoc:
      end

      # This is meant to be implemented by the adapters that support advisory
      # locks.
      #
      # Return true if we released the lock, otherwise false
      def release_advisory_lock(lock_id) # :nodoc:
      end
    end
  end
end
