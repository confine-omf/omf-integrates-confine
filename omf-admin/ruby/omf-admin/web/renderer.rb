require 'markaby'

module OMF
  module Admin
    module Web

      class MabRenderer
        #@@partial_dir = '../repository/views'
        @@partial_dir = "#{File.dirname(__FILE__)}/tab"

        def self.render(name, assigns = {}, helpers = nil)
          if helpers.nil?
            helpers = OMF::Admin::Web.helpersClass
          end
          builder = Markaby::Builder.new(assigns, helpers)
          Thread.current[:MabRenderer] = {
            :builder => builder, :content => name, :opts => assigns
          }
          return unless content = read_content('shared/application')

          #MObject.debug :renderer, "Rendering #{name}"
          return builder.capture_string(content)
        end
        
        def self.render_content()
          p = Thread.current[:MabRenderer][:content]
          return unless content = read_content(p)          
          builder = Thread.current[:MabRenderer][:builder]
          #MObject.debug :renderer, "Rendering #{p}"
          return builder.capture_string(content)
        end
        
        def self.render_partial(path)
          comp, name = path.split('/')
          if name.nil?
            p = "layout/_#{comp}"
          else
            p = "#{comp}/_#{name}"
          end
          return unless content = read_content(p)          
          builder = Thread.current[:MabRenderer][:builder]
          #MObject.debug :renderer, "Rendering #{path}"
          return builder.capture_string(content)
        end
        
        def self.read_content(name)
          view_dir = Thread.current[:MabRenderer][:opts][:view_dir]
          #fname = "#{@@partial_dir}/#{name}.mab"
          fname = "#{view_dir}/#{name}.mab"
          unless File.readable?(fname)
            fname = nil
            view_dirs = Thread.current[:MabRenderer][:opts][:common_view_dir]
            view_dirs.each do |view_dir|
              fname = "#{view_dir}/#{name}.mab"
              if File.readable?(fname)
                break
              end
            end
          end
          unless fname
            MObject.error(:mab_renderer, "Can't find mab file for '#{name}' in '#{fname}'.")
            raise "FFFF #{Thread.current[:MabRenderer][:opts].inspect}"
            return nil
          end
          return File.new(fname).read
        end
      end
    end
  end
end


# Extend Markaby's builder with a capture from string
#
module Markaby
  class Builder
    def capture_string(str)
      @streams.push(builder.target = [])
      @builder.level += 1
      #puts ">>>> #{str}"
      str = instance_eval(str)
      str = @streams.last.join if @streams.last.any?
      @streams.pop
      @builder.level -= 1
      builder.target = @streams.last
      str
    end
  end
end


if __FILE__ == $0
  require 'omf_ext/helpers'
  include OMF::Admin::Web
  puts MabRenderer.render('application', {:params => {}, :flash => {}}, ViewHelper)
end
