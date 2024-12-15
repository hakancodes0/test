#!/bin/bash
# Swap dosyas1n1n boyutunu (GB cinsinden) belirleyin
SWAP_SIZE_GB=10
SWAP_FILE="/swapfile"
# Root yetkisi kontrolü
echo "Root yetkisi kontrol ediliyor..."
if [ "$EUID" -ne 0 ]; then
  echo "Lütfen bu scripti root kullan1c1 olarak çal1_t1r1n."
  exit 1
fi
# Swap dosyas1n1n varl11n1 kontrol et
if [ -f "$SWAP_FILE" ]; then
  echo "Swap dosyas1 zaten mevcut: $SWAP_FILE"
  exit 1
fi
# Swap dosyas1n1 olu_turun
echo "Swap dosyas1 olu_turuluyor..."
dd if=/dev/zero of=$SWAP_FILE bs=1M count=$((SWAP_SIZE_GB * 1024)) status=progress
# Dosya izinlerini ayarlay1n
echo "Swap dosyas1n1n izinleri ayarlan1yor..."
chmod 600 $SWAP_FILE
# Swap alan1n1 olu_turun
echo "Swap alan1 olu_turuluyor..."
mkswap $SWAP_FILE
# Swap alan1n1 etkinle_tirin
echo "Swap alan1 etkinle_tiriliyor..."
swapon $SWAP_FILE
# Swap dosyas1n1 /etc/fstab dosyas1na ekleyin (kal1c1 hale getirmek için)
echo "Swap dosyas1 /etc/fstab dosyas1na ekleniyor..."
echo "$SWAP_FILE none swap sw 0 0" >> /etc/fstab
# 0_lem tamamland1
echo "Swap dosyas1 ba_ar1yla olu_turuldu, etkinle_tirildi ve fstab dosyas1na kal1c1 olarak eklendi."
# Swap durumunu kontrol et
swapon --show
