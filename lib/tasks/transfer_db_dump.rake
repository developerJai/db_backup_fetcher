# lib/tasks/transfer_db_dump.rake

namespace :db do
  desc "Transfer MySQL dump from server to localhost"
  task transfer_dump: :environment do
    require 'net/ssh'
    puts "Transfer MySQL dump"

    # SSH connection details
    server_address = ENV['SERVER_HOST']
    username = ENV['SERVER_USER']
    pem_file_path = File.join(Rails.root, 'config', 'credentials', ENV['SERVER_PEMFILE'])  # Path to your PEM file

    filename = "#{ENV['SERVER_DATABASE_NAME']}_#{Date.today.strftime("%d-%m-%Y")}.sql"
    # Local destination for the MySQL dump file
    local_file_path = File.join(Rails.root, 'tmp', filename)

    # Check if local dump file exists and delete if it does
    File.delete(local_file_path) if File.exist?(local_file_path)

    puts "Initiating server login via ssh..."
    Net::SSH.start(server_address, username, keys: [pem_file_path]) do |ssh|
      # Execute commands via SSH
      puts "Server loggedin successfully"

      dump_file_path = filename

      delete_command = "rm -f #{dump_file_path}"
      ssh.exec!(delete_command)

      puts "Taking dump from MySQL server..."
      mysqldump_command = "mysqldump -u #{ENV['SERVER_DATABASE_USER']} -p'#{ENV['SERVER_DATABASE_PASS']}' #{ENV['SERVER_DATABASE_NAME']} > #{dump_file_path}"

      # Execute the mysqldump command via SSH
      ssh.exec!(mysqldump_command)


      puts "Initiating downloading dump to local..."
      # Download file from server to local
      ssh.scp.download!(dump_file_path, local_file_path)

      puts "MySQL dump downloaded to #{local_file_path}"
    end
  end
end
