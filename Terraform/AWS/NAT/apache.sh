#!/bin/bash

# Exit on any error
set -e

# Update the package list
echo "Updating package list..."
sudo apt-get update -y

# Install Apache
echo "Installing Apache..."
sudo apt-get install -y apache2

# Start Apache and enable it to run on boot
echo "Starting Apache and enabling it on boot..."
sudo systemctl start apache2
sudo systemctl enable apache2

# Create a subfolder called 'test' in /var/www/html
echo "Creating a subfolder 'test' in /var/www/html..."
sudo mkdir -p /var/www/html/test

# Create a simple HTML file in the 'test' folder
echo "Creating a simple HTML page in the 'test' subfolder..."
sudo bash -c 'cat > /var/www/html/test/index.html <<EOF
<!DOCTYPE html>
<html>
<head>
    <title>Test Page</title>
</head>
<body>
    <h1>Apache Test Page</h1>
    <p>This is a test page served by Apache from the /test subfolder.</p>
</body>
</html>
EOF'

# Set appropriate permissions
echo "Setting permissions for /var/www/html/test..."
sudo chown -R www-data:www-data /var/www/html/test
sudo chmod -R 755 /var/www/html/test

# Restart Apache to ensure everything is applied correctly
echo "Restarting Apache..."
sudo systemctl restart apache2

# Output success message
echo "Apache has been installed and a test HTML page has been created in the /test subfolder."
