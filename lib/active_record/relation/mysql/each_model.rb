module ActiveRecord
  class Relation
    # In contrast to each or find_each, each_model does not return an array and must be used
    # in a block context and then it yields a model instance.
    #
    # ==== Example
    #   # Iterates over all MyModels of the type 'car' and returns them in the reverse
    #   # order of the field name:
    #   MyModel.where("type = 'car'").order("name desc").each_model{|mm| puts mm.name}
    #
    # ==== Discussion
    # The advantages are: each (and all other find methods) consume a lot of memory when you
    # have a huge result set, since they generate a huge array of model instances. Lazy 
    # loading only delays this problem to the moment, until the result_set is needed.
    #
    # find_each behaves exactly the same as each, but since you can limit the batch size,
    # you can reduce the memory usage, but at the cost of sending the same query multiple
    # times to the database, which can be time consuming. And you can only iterate in the
    # order of the primary key.
    #
    # each_model does not produce an array at all, so the memory consumption is by far the
    # lowest of all solutions, since only one model instance exists at the same time. It
    # should always be fast, since in contrast to batches it sends only one query to the
    # database. And for the same reason, you can return the result in every given order.
    # 
    # ==== Problems
    # Not every find method in ActiveRecord returns a Relation, so each_model can only
    # used when a Relation is returned. Then, there must be a reason, why ActiveRecord
    # does always return an array rather than yielding the models. So I guess, there
    # might be other problems as well.
    def each_model
      result_set = ActiveRecord::Base.connection.raw_connection.query(self.to_sql)
      result_set.each(:as => :hash, :cache_rows => false) do |row|
        yield self.klass.instantiate(row)
      end
    end
  end
end
