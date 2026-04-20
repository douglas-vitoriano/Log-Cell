WickedPdf.configure do |config|
  config.exe_path = "/usr/bin/wkhtmltopdf"
  config.encoding = "UTF-8"
  config.margin   = { top: 10, bottom: 10, left: 10, right: 10 }
end
