#!/bin/bash

# Swap dosyasının boyutunu (GB cinsinden) belirleyin
SWAP_SIZE_GB=10
SWAP_FILE="/swapfile"

# Root yetkisi kontrolü
echo "Root yetkisi kontrol ediliyor..."
if [ "$EUID" -ne 0 ]; then
  echo "Lütfen bu scripti root kullanıcı olarak çalıştırın."
  exit 1
fi

# Swap dosyasını oluşturun
echo "Swap dosyası oluşturuluyor..."
if [ -f "$SWAP_FILE" ]; then
  echo "Swap dosyası zaten mevcut: $SWAP_FILE"
  exit 1
fi

dd if=/dev/zero of=$SWAP_FILE bs=1G count=$SWAP_SIZE_GB status=progress

# Dosya izinlerini ayarlayın
echo "Swap dosyasının izinleri ayarlanıyor..."
chmod 600 $SWAP_FILE

# Swap alanını oluşturun
echo "Swap alanı oluşturuluyor..."
mkswap $SWAP_FILE

# Swap alanını etkinleştirin
echo "Swap alanı etkinleştiriliyor..."
swapon $SWAP_FILE

# Swap dosyasını fstab dosyasına ekleyin
echo "Swap dosyası fstab dosyasına ekleniyor..."
echo "$SWAP_FILE none swap sw 0 0" >> /etc/fstab

# İşlem tamamlandı
echo "10 GB'lık swap alanı başarıyla oluşturuldu ve etkinleştirildi."