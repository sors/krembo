module KremboI18nizer
  class TranslatorController < ApplicationController
    def update
      key = params[:key]
      val = params[:value]
      keys = key.split('.')
      files =  Dir.entries("#{Rails.root.to_s}/config/locales").delete_if {|item| !item.end_with?('.yml')}
      source_file  = find_file(files,key)

      unless (source_file.nil?)
        update_file(source_file,key,val)
      end
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

    def update_file(file,key,val)
      yaml = YAML.load_file("#{Rails.root.to_s}/config/locales/#{file}")
      path = key.split('.').unshift('en')
      yaml.replace_path(path,val)
      file = File.open("#{Rails.root.to_s}/config/locales/#{file}", "w")
      file.write(yaml.to_yaml)
      file.close()
    end
  end
end

