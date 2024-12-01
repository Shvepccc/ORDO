#!/bin/bash

# cleanup() {
#     echo -e "\n  Process interrupted. The exit was successful."
#     exit 0
# }

# trap cleanup

config_file="install.conf"

validate_email() {
    [[ "$1" =~ ^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$ ]]
}

validate_phone() {
    if [[ "$1" =~ ^[0-9]{8,15}$ ]]; then
        return 0 
    else
        return 1
    fi
}

write_certificate() {
    local path="."
    local content="$1"
    local file="$path/certificate.txt"

    if [[ -f ./LICENSE ]]; then
        license_content=$(cat ./LICENSE)
        content="$content\n\n--- LICENSE ---\n$license_content"
    else
        echo "LICENSE file not found. Proceeding without it."
    fi
        echo -e "$content" > "$file"
}

write_config() {

    echo "[user]"
    echo "full_name=$full_name"
    echo "email=$email"
    echo "phone=$phone"

    echo ""
    echo "[paths]"
    echo "bin_path=$bin_path/ordo"
    echo "cert_path=$cert_path"
    echo "temp_path=$temp_path"
    echo "save_path=$save_path"
    echo "docs_path=$docs_path"

    echo ""
    echo "[license]"
    echo "license_type=MIT License"
    echo "install_date=$install_date"
} > "$config_file"


# MAIN ----------------------------------------
echo ""
echo " --- Welcome to the ORDO setup script! --- "
echo "Please enter some details:"

#Name
read -p "Enter your full name: " full_name

#Email
while true; do
    read -p "Enter your E-mail: " email
    if validate_email "$email"; then
        break
    else
        echo "Invalid E-mail. Please try again."
    fi
done

while true; do
    read -p "Enter your phone number. (8-15 numbers): " phone
    if validate_phone "$phone"; then
        break
    else
        echo "Invalid phone number. Please try again."
    fi
done

read -p "Enter path for the ORDO installation [default: /usr/lib]: " bin_path
bin_path=${bin_path:-/usr/lib}

read -p "Enter path for the certificate installation [default: /etc/ordo]: " cert_path
cert_path=${cert_path:-/etc/ordo}

read -p "Enter path for temporary files [default: /tmp/$USER/ordo]: " temp_path
temp_path=${temp_path:-/tmp/$USER/ordo}

read -p "Enter path for save files [default: ~/$USER/ordo/saves]: " save_path
save_path=${save_path:-~/ordo/saves}

read -p "Enter path for documentation [default: ~/$USER/ordo/docs]: " docs_path
docs_path=${docs_path:-~/ordo/docs}



install_date=$(date +"%Y-%m-%d")
certificate="Certificate of Free Use\n
User: $full_name
E-mail: $email
Phone: $phone
License: MIT License
Install Date: $install_date"

write_certificate "$certificate"
write_config

echo -e "\nSetup completed:"
echo -e "\033[32m ORDO will be installed in $bin_path"
echo -e " Certificate directory: $cert_path"
echo -e " Temporary files directory: $temp_path"
echo -e " Save files directory: $save_path"
echo -e " Documentation directory: $docs_path\033[0m\n"