require "active_support"
require "active_support/inflector"
require "where_is"

module Autoloader
  extend ActiveSupport::Concern

  included do
  end

  class_methods do
    def app_dir
      @app_dir ||= File.join(root, "app")
    end

    def init
      Dir.glob(File.join(App.app_dir, "{#{autoload_paths.join(',')}}", "**", "*.rb")).each do |f|
        relative_path = f.gsub("#{App.app_dir}/", "")
        parts = File.split(relative_path)
        parts[0] = parts[0].split("/")
        parts[0].shift
        parts[1] = File.basename(parts[1], ".rb")
        components = parts.flatten
        full_path = File.join(components)

        # puts "File: `#{full_path}`"

        if components.length > 1
          file = components.pop

          # puts "-- '#{file}'"

          m = define_consts(components.dup)
          # puts "---- Component count = #{components.length}"
          ns = components.length > 1 ? File.join(components).camelize : m.to_s
          # puts "---- Adding to module '#{ns}'"
          ns.constantize.autoload(file.camelize.to_sym, full_path)
          # puts "-- autoload :#{file.camelize}, '#{file}' (#{ns})"
        elsif components.length == 1
          name = components.first
          # puts "-- autoload :#{name.camelize}, '#{name}'"
          ::Object.autoload(name.camelize.to_sym, name)
        end
      end
    end

    def define_consts(components, base_module = ::Object)
      comp = components.shift.camelize
      m = module_exists?(comp, base_module) ? base_module.const_get(comp) : base_module.const_set(comp, ::Module.new)

      if components.length.zero?
        return m
      else
        define_consts(components, m)
      end
    end
    private :define_consts

    def module_exists?(name, base_module = ::Object)
      base_module.const_defined?(name) && base_module.const_get(name).instance_of?(::Module)
    end
    private :module_exists?

    # The root directory is the one with the 'Gemfile' in it.
    def root
      return @root unless @root.nil?

      loc = Where.is_class(self)
      dir = loc[0].first.split(File::SEPARATOR)
      dir.pop until File.exist?(File.join(dir, "Gemfile"))

      @root = File.join(dir)
    end
  end
end
