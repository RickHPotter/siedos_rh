# i decided to 'create' my own breadcrumb --stolen from boring ruby
class Breadcrumb
  attr_reader :name, :path

  def initialize(name, path)
    @name = name
    @path = path
  end

  def link?
    @path.present?
  end

end

