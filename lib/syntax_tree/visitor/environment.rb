module SyntaxTree
  class Environment
    attr_reader :locals

    class Local
      attr_reader :type
      attr_reader :locations

      def initialize(type)
        @type = type
        @locations = []
      end

      def <<(location)
        @locations << location
      end
    end

    def initialize(parent = nil)
      @locals = {}
      @parent = parent
    end

    def register_local(identifier, type)
      name = identifier.value.delete_suffix(":")
      @locals[name] ||= Local.new(type)
      @locals[name] << identifier.location
    end

    def find_local(name)
      locations = @locals[name]
      return locations unless locations.empty?

      @parent&.find_local(name)
    end
  end
end
