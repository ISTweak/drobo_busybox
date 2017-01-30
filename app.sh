CFLAGS="${CFLAGS:-} -ffunction-sections -fdata-sections"
LDFLAGS="-L${DEST}/lib -L${DEPS}/lib -Wl,--gc-sections"

### PCRE ###
_build_pcre() {
local VERSION="8.40"
local FOLDER="pcre-${VERSION}"
local FILE="${FOLDER}.tar.bz2"
local URL="ftp://ftp.csx.cam.ac.uk/pub/software/programming/pcre/${FILE}"

_download_bz2 "${FILE}" "${URL}" "${FOLDER}"
pushd "target/${FOLDER}"
./configure --host="${HOST}" --prefix="${DEPS}" --disable-shared --enable-static --disable-cpp --enable-utf --enable-unicode-properties
make
make install
popd
}


### BUSYBOX ###
_build_busybox() {
local VERSION="1.26.2"
local FOLDER="busybox-${VERSION}"
local FILE="${FOLDER}.tar.bz2"
local URL="http://busybox.net/downloads/${FILE}"

_download_bz2 "${FILE}" "${URL}" "${FOLDER}"
cp -vf "src/${FOLDER}-config" "target/${FOLDER}/.config"
pushd "target/${FOLDER}"
make LDLIBS="pcre crypt m"
make install LDLIBS="pcre m"
popd
}

_build_rootfs() {
mv -vf "${DEST}/usr/sbin/adduser" "${DEST}/bin/adduser"
mv -vf "${DEST}/usr/sbin/addgroup" "${DEST}/bin/addgroup"
mv -vf "${DEST}/usr/sbin/deluser" "${DEST}/bin/deluser"
mv -vf "${DEST}/usr/sbin/delgroup" "${DEST}/bin/delgroup"
mv -vf "${DEST}/sbin/ip" "${DEST}/bin/ip"
mv -vf "${DEST}/sbin/ipaddr" "${DEST}/bin/ipaddr"
mv -vf "${DEST}/sbin/iplink" "${DEST}/bin/iplink"
mv -vf "${DEST}/sbin/iproute" "${DEST}/bin/iproute"
mv -vf "${DEST}/sbin/iprule" "${DEST}/bin/iprule"
mv -vf "${DEST}/sbin/iptunnel" "${DEST}/bin/iptunnel"
mv -vf "${DEST}/usr/sbin/arping" "${DEST}/usr/bin/arping"
mv -vf "${DEST}/usr/sbin/chat" "${DEST}/usr/bin/chat"
mv -vf "${DEST}/usr/sbin/ether-wake" "${DEST}/usr/bin/ether-wake"
mv -vf "${DEST}/bin/kbd_mode" "${DEST}/usr/bin/kbd_mode"
mv -vf "${DEST}/usr/sbin/killall5" "${DEST}/usr/bin/killall5"
mv -vf "${DEST}/usr/sbin/readahead" "${DEST}/usr/bin/readahead"
mv -vf "${DEST}/usr/sbin/rtcwake" "${DEST}/usr/bin/rtcwake"
mv -vf "${DEST}/usr/sbin/tftpd" "${DEST}/usr/bin/tftpd"

}

_build() {
  _build_pcre
  _build_busybox
  _package
}
