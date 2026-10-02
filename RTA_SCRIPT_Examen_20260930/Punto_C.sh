#!/bin/bash
# Punto C: usuarios, grupos y permisos

# Grupos secundarios
sudo groupadd -f p1c2_2024_gAlumno
sudo groupadd -f p1c2_2024_gProfesores

# Usuarios (clave = nombre del usuario, cargada como hash SHA-512)
for u in A1 A2 A3; do
  id "p1c2_2024_$u" &>/dev/null || sudo useradd -m -s /bin/bash \
    -G p1c2_2024_gAlumno -p "$(openssl passwd -6 "p1c2_2024_$u")" "p1c2_2024_$u"
done
id p1c2_2024_P1 &>/dev/null || sudo useradd -m -s /bin/bash \
  -G p1c2_2024_gProfesores -p "$(openssl passwd -6 p1c2_2024_P1)" p1c2_2024_P1

# Dueño y grupo
sudo chown -R p1c2_2024_A1:p1c2_2024_A1 /Examenes-UTN/alumno_1
sudo chown -R p1c2_2024_A2:p1c2_2024_A2 /Examenes-UTN/alumno_2
sudo chown -R p1c2_2024_A3:p1c2_2024_A3 /Examenes-UTN/alumno_3
sudo chown -R p1c2_2024_P1:p1c2_2024_gProfesores /Examenes-UTN/profesores

# Permisos
sudo chmod -R 750 /Examenes-UTN/alumno_1
sudo chmod -R 700 /Examenes-UTN/alumno_2
sudo chmod -R 700 /Examenes-UTN/alumno_3
sudo chmod -R 775 /Examenes-UTN/profesores

# validar.txt con la salida de whoami de cada usuario
sudo su -c "whoami > /Examenes-UTN/alumno_1/validar.txt" p1c2_2024_A1
sudo su -c "whoami > /Examenes-UTN/alumno_2/validar.txt" p1c2_2024_A2
sudo su -c "whoami > /Examenes-UTN/alumno_3/validar.txt" p1c2_2024_A3
sudo su -c "whoami > /Examenes-UTN/profesores/validar.txt" p1c2_2024_P1
