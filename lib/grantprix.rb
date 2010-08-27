$:.unshift(File.dirname(__FILE__)) unless
  $:.include?(File.dirname(__FILE__)) || $:.include?(File.expand_path(File.dirname(__FILE__)))

module Grantprix

  def self.grant ( *privileges )
    Grantprix::Builder.new( *privileges )
  end
  
  class NotAllowed < StandardError; end

  class Builder
  
    DATABASE_OBJECTS = [ 'TABLE', 'DATABASE', 'FUNCTION', 'LANGUAGE', 'SCHEMA', 'TABLESPACE' ].freeze

    def initialize( *privileges )
      # @options = Hash.new( &(lambda { |hsh,key| hsh[key] = Array.new }) )
      
      @grant, @on, @to, @with = [], [], [], []
      @database_object = nil

      grant( *privileges )
    end
    
    # grant( :select )
    # grant( 'all privileges' )
    # grant( :select, :insert, :update )
    def grant( *args )
      @grant += args.map(&:to_s).map(&:upcase)
      
      self
    end

    # on( 'table_name' )  # default
    # on( :table, 'table_name' )
    # on( :database, 'database_name' )
    def on ( *args )
      args = args.map(&:to_s)
      
      unless DATABASE_OBJECTS.include?( args.first.upcase )
        return on( :table, *args )
      end
      
      database_object = args.shift.upcase
      if @database_object && @database_object != database_object
        raise NotAllowed, 'Changing the database object is not allowed'
      else
        @database_object = database_object
      end
      
      @on += args
      
      self
    end

    # to( 'username' )
    # to( :group, 'groupname' )
    # to( :public )
    def to ( *args )
      @to += if args.first == :group
        ["GROUP #{args.last}"]
      elsif args.first == :public
        ["PUBLIC"]
      else
        args
      end

      self
    end

    # with( :grant_option )
    # with( :admin_option )
    def with ( option )
      @with << option.to_s.gsub( '_', ' ' ).upcase

      self
    end
    
    def to_s
      # [ 'grant', 'on', 'to', 'with' ].inject( Array.new ) do |ary, p|
      #   var = instance_variable_get("@#{p}")
      #   ary << "#{p.upcase} #{var.join(', ')}" unless var.empty?
      #   ary
      # end.join( ' ' )
      rtn = []
      rtn << "GRANT #{@grant.join(', ')}" unless @grant.empty?
      rtn << "ON #{@database_object} #{@on.join(', ')}" unless @on.empty?
      rtn << "TO #{@to.join(', ')}" unless @to.empty?
      rtn << "WITH #{@with.join(', ')}" unless @with.empty?
      
      rtn.join( ' ' )
    end

  end

end

if defined?( ActiveRecord::Migration )
  ActiveRecord::Migration.send :include, Grantprix
end
