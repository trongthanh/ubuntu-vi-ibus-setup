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

	sudo apt install ibus ibus-unikey
}

# Install ibus-teni
function install_ibus_teni() {

	echo "To install ibus-teni"
}

# Install ibus-teni
function install_ibus_bamboo() {

	echo "To install ibus-bamboo"
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

read -p "Tôi phát hiện ra bạn có cài unikey/teni/bamboo"
read -p "Tôi sẽ gỡ bõ bộ gõ này trước để tránh xung đột"

echo... "Bắt đầu cài đặt"
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
read -p "Tiếp theo tôi sẽ kích hoạt cửa sổ im-config để chuyển bộ gõ mặc định về iBus"
read -p "Bạn hãy chọn OK|YES hai lần sau đó click chọn vào tùy chọn ibus"

im-config
