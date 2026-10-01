#!/bin/bash
# Punto B: particionado (10 partes iguales), ext4 y montaje persistente
DISCO=/dev/sdb
DESTINOS=(
  /Examenes-UTN/alumno_1/parcial_1
  /Examenes-UTN/alumno_1/parcial_2
  /Examenes-UTN/alumno_1/parcial_3
  /Examenes-UTN/alumno_2/parcial_1
  /Examenes-UTN/alumno_2/parcial_2
  /Examenes-UTN/alumno_2/parcial_3
  /Examenes-UTN/alumno_3/parcial_1
  /Examenes-UTN/alumno_3/parcial_2
  /Examenes-UTN/alumno_3/parcial_3
  /Examenes-UTN/profesores
)

# Tabla GPT (MBR solo permite 4 primarias) y 10 particiones del 10%
sudo parted -s "$DISCO" mklabel gpt
for i in {0..9}; do
  sudo parted -s "$DISCO" mkpart primary ext4 "$((i*10))%" "$(((i+1)*10))%"
done
sudo partprobe "$DISCO"
sudo udevadm settle

# Formato ext4 y entrada persistente en /etc/fstab (por UUID)
for i in {1..10}; do
  sudo mkfs.ext4 -F "${DISCO}${i}"
  UUID=$(sudo blkid -s UUID -o value "${DISCO}${i}")
  echo "UUID=$UUID ${DESTINOS[$((i-1))]} ext4 defaults 0 0" | sudo tee -a /etc/fstab
done

sudo systemctl daemon-reload
sudo mount -a
