require "activerecord-reset-pk-sequence/version"

module ActiveRecord
  module ConnectionAdapters
    class AbstractAdapter
      def reset_pk_sequence!(table_name)
        model = table_name.classify.constantize
        case adapter_name
        when 'SQLite'
          new_max = model.maximum(model.primary_key) || 0
          update_seq_sql = "UPDATE sqlite_sequence SET seq = #{new_max} WHERE name = '#{table_name}';"
          execute(update_seq_sql)
        when 'Mysql', 'Mysql2'
          new_max = model.maximum(model.primary_key) + 1 || 1
          update_seq_sql = "ALTER TABLE `#{table_name}` AUTO_INCREMENT = #{new_max};"
          execute(update_seq_sql)
        when 'PostgreSQL'
          reset_pk_sequence!(table_name)
        else 
          raise "Task not implemented for this DB adapter"
        end 
      end
    end
  end
end

