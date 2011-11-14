module KremboI18nizer
  class TranslatorController < ApplicationController
    def update
      key = params[:key]
      val = params[:value]
      keys = key.split('.')
      files =  Dir.entries("#{Rails.root.to_s}/config/locales").delete_if {|item| !item.end_with?('.yml')}
      source_file  = find_file(files,key)

      if (source_file.nil?) then
        source_file = "i18nizer.#{I18n.locale.to_s}.yml"
        append_file(source_file,key,val)
      else
        update_file(source_file,key,val)
      end
      I18n.reload!
      render :json=>{:key=>key,:val=>val,:source_file=>source_file}
    end

    def find_file(files,key)
      locale = I18n.locale.to_s || 'en'
      path = key.split('.').unshift(locale)
      files.each do |file|
        yaml = YAML.load_file("#{Rails.root.to_s}/config/locales/#{file}")
        return file unless yaml.find_path(path).nil?
      end
      return nil
    end

    def append_file(file,key,val)
      file_path = "#{Rails.root.to_s}/config/locales/#{file}"
      if (File.exists?(file_path)) then
        yaml = YAML.load_file(file_path)
      else
        reload_i18n=true
        yaml ={}
      end
      locale = I18n.locale.to_s || 'en'
      path = key.split('.').unshift(locale)
      yaml.append_path(path,val)
      file = File.open("#{Rails.root.to_s}/config/locales/#{file}", "w")
      file.write(yaml.to_yaml)
      file.close()
      if (reload_i18n)
        I18n.load_path << file_path
        I18n::Railtie.reloader.paths.concat I18n.load_path
        I18n::Railtie.reloader.execute_if_updated
      end
    end

    def update_file(file,key,val)
      yaml = YAML.load_file("#{Rails.root.to_s}/config/locales/#{file}")
      locale = I18n.locale.to_s || 'en'
      path = key.split('.').unshift(locale)
      yaml.replace_path(path,val)
      file = File.open("#{Rails.root.to_s}/config/locales/#{file}", "w")
      file.write(yaml.to_yaml)
      file.close()
    end
  end
end

