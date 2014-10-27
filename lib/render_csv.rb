module RenderCsv
  class RenderCsvRailtie < ::Rails::Railtie
    config.after_initialize do
      require 'render_csv/csv_renderable'
      require 'action_controller/metal/renderers'

      ActionController.add_renderer :csv do |csv, options|
        filename = options[:filename] || options[:template]
        if Rails.version.to_i == 3
          csv.extend RenderCsv::CsvRenderable
        else
          csv.extend RenderCsv::CsvRenderable unless csv.respond_to?(:to_csv)
        end
        data = csv.to_csv(options)
        send_data data, type: Mime::CSV, disposition: "attachment; filename=#{filename}.csv"
      end
    end
  end
end
