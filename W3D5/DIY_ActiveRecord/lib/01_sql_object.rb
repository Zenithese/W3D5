require 'byebug'

require_relative 'db_connection'
require 'active_support/inflector'
# NB: the attr_accessor we wrote in phase 0 is NOT used in the rest
# of this project. It was only a warm up.

class SQLObject
  # debugger
  def self.columns
    @columns ||= DBConnection.execute2(<<-SQL)
      SELECT
        *
      FROM
        #{table_name}
      SQL
    return @columns.first.map { |el| el.to_sym }
  end

  def self.finalize!

    columns.each do |column|
      self.define_method column do
        @attributes[column]
      end
      self.define_method "#{column}=" do |val|
        attributes[column] = val
      end
    end
  end

  def self.table_name=(table_name)
    @table_name = table_name
    

  end

  def self.table_name
    # debugger
    @table_name ||= "#{self}".tableize
  end

  def self.all
    results = DBConnection.execute(<<-SQL)
    SELECT
      *
    FROM
      #{self.table_name}
    SQL
    self.parse_all(results)
  end

  def self.parse_all(results)
    results.map do |hash|
      self.new(hash)
    end
  end

  def self.find(id)
    self.all.find { |obj| obj.id == id }
  end

  def initialize(params = {})
    params.each do |k, v|
      raise "unknown attribute '#{k}'" unless self.class.columns.include?(k.to_sym)

      self.send("#{k}=", v)
    end    
  end

  def attributes
    @attributes ||= {}
  end

  def attribute_values
    # ...
  end

  def insert
    # ...
  end

  def update
    # ...
  end

  def save
    # ...
  end
end
