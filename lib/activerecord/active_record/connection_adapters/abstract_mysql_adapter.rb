module ActiveRecord # :nodoc:
  module ConnectionAdapters # :nodoc:
    class AbstractMysqlAdapter
      # 5.0.0 definitely supports it, possibly supported by earlier versions but
      # not sure
      def supports_advisory_locks?
        version >= '5.0.0'
      end

      def get_advisory_lock(lock_name, timeout = 0) # :nodoc:
        select_value("SELECT GET_LOCK('#{lock_name}', #{timeout});").to_s == '1'
      end

      def release_advisory_lock(lock_name) # :nodoc:
        select_value("SELECT RELEASE_LOCK('#{lock_name}')").to_s == '1'
      end
    end
  end
end
