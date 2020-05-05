#!/bin/bash

# Utils functions

function echo...() {
	spin[0]="."
	spin[1]=".."
	spin[2]=".."

	echo -n "$1${spin[0]}"

	for i in "${spin[@]}"
	do
		echo -ne "\b$i"
		sleep 0.5
	done
}

# Install ibus-unikey
function install_ibus_unikey() {
	echo... "Bắt đầu cài đặt ibus-unikey"
	sudo apt install ibus ibus-unikey
}

# Install ibus-teni
function install_ibus_teni() {

	local ppa=teni-ime/ibus-teni

	if ! grep -q "^deb .*$ppa" /etc/apt/sources.list /etc/apt/sources.list.d/*; then
		echo... "Thêm nguồn cài đặt ibus-teni tại ppa:$ppa"
		echo
		sudo add-apt-repository ppa:$ppa
		sudo apt-get update
	fi

	echo... "Bắt đầu cài đặt ibus-teni"
	sudo apt-get install ibus ibus-teni
}

# Install ibus-bamboo
function install_ibus_bamboo() {

	local ppa=bamboo-engine/ibus-bamboo

	if ! grep -q "^deb .*$ppa" /etc/apt/sources.list /etc/apt/sources.list.d/*; then
		echo... "Thêm nguồn cài đặt ibus-bamboo tại ppa:$ppa"
		echo
		sudo add-apt-repository ppa:$ppa
		sudo apt-get update
	fi

	echo... "Bắt đầu cài đặt ibus-bamboo"
	sudo apt-get install ibus ibus-bamboo
}

function check_for_conflict_software() {
	conflict_software_list=(fcitx)
	echo... "Kiểm tra phần mềm xung đột"

	for software in ${conflict_software_list[@]}; do
		dpkg -l | grep -i $software | head -1 | if [[ "$(cut -d ' ' -f 1)" == "ii" ]]; then
			echo
			echo... "Tôi phát hiện ra bạn có cài $software"
			echo
			echo... "Tôi sẽ gỡ bõ bộ gõ này trước để tránh xung đột"
			sudo apt purge $software*
		else
			echo "Không phát hiện ra ứng dụng hỗ trợ gõ dấu tiếng Việt khác."
		fi
	done
}

# Main program start:

read -p "Bấm Ctrl-C để thoát bất cứ lúc nào. Bấm [ENTER] để qua bước tiếp theo."

echo "Vui lòng chọn bộ gõ tiếng Việt:"

select ime in ibus-unikey ibus-teni ibus-bamboo
do
	case $ime in
	ibus-unikey|ibus-teni|ibus-bamboo)
		break
		;;
	*)
		echo "Vui lòng nhập từ 1-3"
		;;
	esac
done

echo... "Bạn chọn $ime"
echo

check_for_conflict_software

echo

case $ime in
	ibus-unikey)
		install_ibus_unikey
		;;
	ibus-teni)
		install_ibus_teni
		;;
	ibus-bamboo)
		install_ibus_bamboo
		;;
esac

echo
echo... "Chạy lệnh 'im-config -n ibus' để chuyển bộ gõ mặc định về iBus"
im-config -n ibus

echo
echo... "Khởi động iBus nếu chưa chạy"
echo
ibus restart
echo
echo... "Bật giao diện cấu hình iBus."
echo

case $ime in
	ibus-unikey)
		echo... "Bạn hãy thêm Vietnamese > Unikey tại tab Input Method / Phương thức nhập"
		;;
	ibus-teni)
		echo... "Bạn hãy thêm Vietnamese > Teni tại tab Input Method / Phương thức nhập"
		;;
	ibus-bamboo)
		echo... "Bạn hãy thêm Vietnamese > Bamboo tại tab Input Method / Phương thức nhập"
		;;
esac

ibus-setup

echo
echo
echo "Cài đặt hoàn tất."
