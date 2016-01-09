module ActiveRecord
  class ConcurrentMigrationError < MigrationError #:nodoc:
    DEFAULT_MESSAGE = "Cannot run migrations because another migration process is currently running.".freeze

    def initialize(message = DEFAULT_MESSAGE)
      super
    end
  end

  class Migrator#:nodoc:
    def run
      if use_advisory_lock?
        with_advisory_lock { run_without_lock }
      else
        run_without_lock
      end
    end

    def use_advisory_lock?
      Base.connection.supports_advisory_locks?
    end

    def run_without_lock
      migration = migrations.detect { |m| m.version == @target_version }
      raise UnknownMigrationVersionError.new(@target_version) if migration.nil?
      unless (up? && migrated.include?(migration.version.to_i)) || (down? && !migrated.include?(migration.version.to_i))
        begin
          execute_migration_in_transaction(migration, @direction)
        rescue => e
          canceled_msg = use_transaction?(migration) ? ", this migration was canceled" : ""
          raise StandardError, "An error has occurred#{canceled_msg}:\n\n#{e}", e.backtrace
        end
      end
    end

    def with_advisory_lock
      lock_id = generate_migrator_advisory_lock_id
      got_lock = Base.connection.get_advisory_lock(lock_id)
      raise ConcurrentMigrationError unless got_lock
      load_migrated # reload schema_migrations to be sure it wasn't changed by another process before we got the lock
      yield
    ensure
      Base.connection.release_advisory_lock(lock_id) if got_lock
    end

    MIGRATOR_SALT = 2053462845
    def generate_migrator_advisory_lock_id
      db_name_hash = Zlib.crc32(Base.connection.current_database)
      MIGRATOR_SALT * db_name_hash
    end

    def migrated
      @migrated_versions || load_migrated
    end

    def load_migrated
      @migrated_versions = Set.new(self.class.get_all_versions)
    end
  end
end
