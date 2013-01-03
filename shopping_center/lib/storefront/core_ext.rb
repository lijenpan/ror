String.class_eval do
  def to_class
    self.classify.constantize
  end
end
